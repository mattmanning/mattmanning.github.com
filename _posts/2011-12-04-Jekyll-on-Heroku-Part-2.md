---
layout: posts
title: "Jekyll on Heroku Part 2: Rack 'Em"
---

This is a follow up to my previous post, [Run Your Jekyll Site On Heroku](/2011/11/29/Run-Your-Jekyll-Site-On-Heroku.html).

Ditching rack-jekyll
--------------------

The previous post we got going as a Rack app using rack-jekyll. While rack-jekyll is a good project, it does some checking that isn't really necessary since we're precompiling the site and don't need to build anything at runtime.

I first tried replacing rack-jekyll with Rack::Static, but it only works with explicit filenames. For example, with rack static the URL [http://mwmanning.com/index.html]() would work fine, but [http://mwmanning.com]() would return a 404. Luckily I found [this blog post by Chris Continanza](http://chriscontinanza.com/2011/06/15/Jekyll-to-heroku.html) which clued me in to Rack::TryStatic, which is part of [rack-contrib](https://github.com/rack/rack-contrib).

Making this switch is pretty easy. Just remove the rack-jekyll gem and add the rack-contrib gem, so your Gemfile looks like this:

    source :rubygems

    gem 'jekyll'
    gem 'rack-contrib'
    gem 'RedCloth'
    gem 'thin'

Then change your config.ru file to use Rack::TryStatic. The result should look something like this:

    require 'rack/contrib/try_static'

    use Rack::TryStatic,
        :root => "_site",
        :urls => %w[/],
        :try => ['.html', 'index.html', '/index.html']

    run lambda { [404, {'Content-Type' => 'text/html'}, ['Not Found']]}

Rewriting URLs
--------------

One of the reasons I really wanted Rack was for rewriting URLs. That's something the Jekyll server can't do. My old blog was a Wordpress site hosted by A Small Orange, and its URL scheme was slightly different. I had a few links and some Google results pointing to my old URLs, and I didn't want to throw all of that away, so I turned to [Rack::Rewrite](https://github.com/jtrupiano/rack-rewrite). With Rack:Rewrite you get a little DSL that lets you specify routes that are either rewritten or issue redirects. Regular expressions are available for route matching, which suited my needs perfectly for supporting the old blog URL scheme.

Since I don't plan to go back to the old scheme from the Wordpress blog, I dedided to use 301 - Moved Permanently redirects. 

I added the gem to my Gemfile:

    source :rubygems

    gem 'jekyll'
    gem 'rack-contrib'
    gem 'rack-rewrite'
    gem 'RedCloth'
    gem 'thin'

and set up the appropriate redirects in my config.ru:

    require 'rack/contrib/try_static'
    require 'rack/rewrite'

    # Support links to old Wordpress site
    use Rack::Rewrite do
      r301 '/2010/11/29/ec2-micro-instance-as-a-remote-bittorrent-client/', '/2010/11/29/EC2-Micro-Instance-as-a-Remote-Bittorrent-Client.html'
      r301 '/2009/01/13/timemachine-ubuntu-nas/', '/2009/01/13/TimeMachine-Ubuntu-NAS.html'
      r301 '/projects/jack-o-led/', '/projects/jack-o-LED.html'
      r301 %r{/projects/(\S+)/}, '/projects/$1.html'
    end

    use Rack::TryStatic,
        :root => "_site",
        :urls => %w[/],
        :try => ['.html', 'index.html', '/index.html']

    run lambda { [404, {'Content-Type' => 'text/html'}, ['Not Found']]}

Caching
-------

The final piece I wanted for my Rack app was caching. Older Heroku stacks (Aspen and Bamboo, which only support Ruby apps) use [Varnish](https://www.varnish-cache.org/) and [nginx](http://nginx.org/) in front of the app server and can be blazing fast. The Cedar stack does not, because they [conflict with some advanced HTTP features it supports](http://devcenter.heroku.com/articles/http-routing#the_herokuappcom_http_stack).

Luckily, Heroku offers a [hosted memcache add-on](http://addons.heroku.com/memcache) which can be used with the Rack::Cache middleware. The free version of the add-on gives you 5MB of memory, which is pretty good for my purposes since my whole app (gems included) is only a little over 7MB. To get this working I first added the add-on with this command:

    heroku addons:add memcache:5mb

Next, I needed a couple of gems, dalli and rack-cache. With those installed my Gemfile looked like this:

    source :rubygems

    gem 'dalli'
    gem 'jekyll'
    gem 'rack-cache'
    gem 'rack-contrib'
    gem 'rack-rewrite'
    gem 'RedCloth'
    gem 'thin'

The last bit was to set up Rack::Cache in the config.ru file.

    require 'dalli'
    require 'rack/cache'
    require 'rack/contrib/try_static'
    require 'rack/rewrite'

    $cache = Dalli::Client.new
    use Rack::Cache,
      :verbose => true,
      :metastore => $cache,
      :entitystore => $cache

    # Support links to old Wordpress site
    use Rack::Rewrite do
      r301 '/2010/11/29/ec2-micro-instance-as-a-remote-bittorrent-client/', '/2010/11/29/EC2-Micro-Instance-as-a-Remote-Bittorrent-Client.html'
      r301 '/2009/01/13/timemachine-ubuntu-nas/', '/2009/01/13/TimeMachine-Ubuntu-NAS.html'
      r301 '/projects/jack-o-led/', '/projects/jack-o-LED.html'
      r301 %r{/projects/(\S+)/}, '/projects/$1.html'
    end

    use Rack::TryStatic,
        :root => "_site",
        :urls => %w[/],
        :try => ['.html', 'index.html', '/index.html']

    run lambda { [404, {'Content-Type' => 'text/html'}, ['Not Found']]}

I set this up without really thinking too much about it. Caching Is Good™, right? Well I decided to do a quick test with ApacheBench to see what kind of average response times I got. (If you're having trouble with ApacheBench on OS X Lion, [here's how to fix it](https://gist.github.com/1430691)). First I wanted to get a baseline number without caching, so I removed that part from config.ru and ran this test on one dyno.

    [~/code/blog] ab -n 1000 -c 5 http://www.mwmanning.com/2010/11/29/EC2-Micro-Instance-as-a-Remote-Bittorrent-Client.html
    This is ApacheBench, Version 2.3 <$Revision: 1178079 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking www.mwmanning.com (be patient)
    Completed 100 requests
    Completed 200 requests
    Completed 300 requests
    Completed 400 requests
    Completed 500 requests
    Completed 600 requests
    Completed 700 requests
    Completed 800 requests
    Completed 900 requests
    Completed 1000 requests
    Finished 1000 requests


    Server Software:        thin
    Server Hostname:        www.mwmanning.com
    Server Port:            80

    Document Path:          /2010/11/29/EC2-Micro-Instance-as-a-Remote-Bittorrent-Client.html
    Document Length:        11274 bytes

    Concurrency Level:      5
    Time taken for tests:   42.249 seconds
    Complete requests:      1000
    Failed requests:        0
    Write errors:           0
    Total transferred:      11451000 bytes
    HTML transferred:       11274000 bytes
    Requests per second:    23.67 [#/sec] (mean)
    Time per request:       211.247 [ms] (mean)
    Time per request:       42.249 [ms] (mean, across all concurrent requests)
    Transfer rate:          264.68 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:       29   43  12.6     39     117
    Processing:    75  168 127.0    140    1870
    Waiting:       32   59  27.4     53     422
    Total:        109  211 127.5    184    1913

    Percentage of the requests served within a certain time (ms)
      50%    184
      66%    199
      75%    209
      80%    218
      90%    255
      95%    310
      98%    582
      99%    853
     100%   1913 (longest request)

Not bad. The average response time was about 211ms, with 2/3 of requests taking less than 200ms. Next I turned caching back on and ran the same test.

    [~/code/blog] ab -n 1000 -c 5 http://www.mwmanning.com/2010/11/29/EC2-Micro-Instance-as-a-Remote-Bittorrent-Client.html
    This is ApacheBench, Version 2.3 <$Revision: 1178079 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking www.mwmanning.com (be patient)
    Completed 100 requests
    Completed 200 requests
    Completed 300 requests
    Completed 400 requests
    Completed 500 requests
    Completed 600 requests
    Completed 700 requests
    Completed 800 requests
    Completed 900 requests
    Completed 1000 requests
    Finished 1000 requests


    Server Software:        thin
    Server Hostname:        www.mwmanning.com
    Server Port:            80

    Document Path:          /2010/11/29/EC2-Micro-Instance-as-a-Remote-Bittorrent-Client.html
    Document Length:        11274 bytes

    Concurrency Level:      5
    Time taken for tests:   49.630 seconds
    Complete requests:      1000
    Failed requests:        0
    Write errors:           0
    Total transferred:      11593000 bytes
    HTML transferred:       11274000 bytes
    Requests per second:    20.15 [#/sec] (mean)
    Time per request:       248.152 [ms] (mean)
    Time per request:       49.630 [ms] (mean, across all concurrent requests)
    Transfer rate:          228.11 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:       28   43  60.9     35    1142
    Processing:    76  205 262.7    142    3830
    Waiting:       41   77 140.4     59    2418
    Total:        110  248 285.4    183    3932

    Percentage of the requests served within a certain time (ms)
      50%    183
      66%    199
      75%    214
      80%    228
      90%    392
      95%    548
      98%    970
      99%   1279
     100%   3932 (longest request)

What's this? Not only were the caching results not any better, the averages were slightly *worse*. This was a bit of a facepalm moment. The main purpose of caching is to prevent calculations or database transactions being made by the web app backend, but in this case the web app backend is doing very little other than serving static files off of disk. Plus the Memcached instance being used here is network-attached, so there's some unavoidable latency in that connection. In this case serving files off of disk is faster than serving out of memory over a network connection, so I disabled caching. Hooray for the scientific method!
