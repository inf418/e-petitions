Before("@departments") do
  ['Cabinet Office', 'Treasury'].each do |department_name|
    FactoryGirl.create(:department, :name => department_name)
  end
end

# for search testing
# see http://opensoul.org/blog/archives/2010/04/07/cucumber-and-sunspot/
$original_sunspot_session = Sunspot.session

Before("~@search") do
  Sunspot.session = Sunspot::Rails::StubSessionProxy.new($original_sunspot_session)
end

Before("@search") do
  unless $sunspot
    $sunspot = Sunspot::Rails::Server.new
    pid = fork do
      STDERR.reopen('/dev/null')
      STDOUT.reopen('/dev/null')
      $sunspot.run
    end
    # shut down the Solr server
    at_exit { Process.kill('TERM', pid) }

    # wait for solr to start
    require 'sunspot_server_util'
    SunspotServerUtil.wait_for_sunspot_to_start($sunspot.port)
  end
  Sunspot.session = $original_sunspot_session
  Sunspot.remove_all!
end