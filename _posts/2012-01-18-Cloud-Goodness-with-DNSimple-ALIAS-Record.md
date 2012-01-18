---
layout: posts
title: Cloud Goodness With the DNSimple ALIAS Record
---

This is the third in a [series](/2011/11/29/Run-Your-Jekyll-Site-On-Heroku.html) of [posts](/2011/12/04/Jekyll-on-Heroku-Part-2.html) about setting up this Jekyll-backed blog on Heroku.

Cloud computing and second-level domains a.k.a. root domains (example.com) don't play nicely together. This is because of [RFC 1034](http://www.ietf.org/rfc/rfc1034.txt) section 3.6.2: "If a CNAME RR is present at a node, no other data should be present; this ensures that the data for a canonical name and its aliases cannot be different." Since root domains tend to have several types of records -- "other data" -- like NS or MX records, you can't use a CNAME for them. That means you're left with A records, which must specify IP addresses. Hence the rub with cloud computing, which tries to abstract away servers and IP addresses.

Heroku deals with root domains by providing [3 public IP addresses](http://devcenter.heroku.com/articles/custom-domains#dns_setup) for routing web requests. For SSL, the extremely cloud-unfriendly [IP-based SSL add-on](http://addons.heroku.com/ssl) is used, which provisions a dedicated server instance to serve your certificate. While these solutions work, they're not really optimal. For example, if Heroku ever changes those IP addresses, as would be necessary in the case of a large-scale DDoS attack, or a datacenter failure, your root domain would no longer resolve. The IP-based SSL add-on has these same downsides, plus its a scaling bottleneck and costs $100/mo. Bummer.

DNSimple has introduced a really clever mechanism for dealing with this problem, the [ALIAS record](http://blog.dnsimple.com/introducing-the-alias-record/). An ALIAS record is set up much like a CNAME, but it resolves the name it points to and returns its IP addresses as if you had set up A records for them. This provides the flexibility of a CNAME without violating the RFC. You can see it working for this site using the `host` command:

    [~/code/blog] host mwmanning.com
    mwmanning.com has address 107.20.209.232
    mwmanning.com has address 107.22.180.220
    mwmanning.com has address 107.20.154.48
    mwmanning.com has address 107.22.181.229
    mwmanning.com has address 107.22.173.156
    mwmanning.com has address 50.17.208.142
    mwmanning.com has address 107.22.180.255
    mwmanning.com has address 107.22.178.183

Besides the routing flexibility afforded by using an ALIAS record, you can take advantage of [Heroku's new HTTP stack](http://devcenter.heroku.com/articles/http-routing#the_herokuappcom_http_stack), which is only available at \[appname\].herokuapp.com, and not at the 3 IPs mentioned previously. You can also use an ALIAS record to provide SSL at your root domain without using the IP-SSL add-on. If you use the Endpoint SSL add-on (available in the Beta program), you can actually have SSL at your root domain for free!
