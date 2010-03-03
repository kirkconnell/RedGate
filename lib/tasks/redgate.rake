namespace :redgate do
  desc "Starts the pulling worker process"
  task :pull => :environment do
    if Puller.instance.pulls.empty?
      puts "No pull sources have being configured for any gate."
      puts "Terminating pulling worker process."
    else
      puts "Pulling resources from the following sources: #{Puller.instance.pulls.collect {|p| p.uri}.join(',')}"
      Puller.start do |source, counter| 
        puts "#{counter} #{counter > 1 ? "resource".pluralize : "resource"} pulled from #{source}."
      end
    end
  end
end
