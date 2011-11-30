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