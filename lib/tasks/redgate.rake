namespace :redgate do
  desc "Starts the pulling worker process"
  task :pull => :environment do
    if Puller.instance.pulls.empty?
      puts "No pull sources have being configured for any gate."
      puts "Terminating pulling worker process."
    else
      puts "Pulling resources from the following sources: #{Puller.instance.pulls.collect {|p| p.uri}.join(',')}"
      # event handler
      puts "Resource pulled."
    end
  end
end
