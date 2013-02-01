require 'rake'

desc "Setup Heroku gem and such"
task :heroku_setup do
  puts "Installing Heroku gem and dependencies"
  `gem install heroku`
end

desc "Create Heroku app for Brightswipe"
task :heroku_create, :name do |t, args|
  puts "Creating new Heroku app for Brightswipe"
  `heroku apps:create #{args[:name]}`
end

desc "Push content to Heroku"
task :update, :message do |t, args|
#  puts "Cleaning for Heroku"
#  Rake::Task['clean'].invoke

  puts 'Adding content'
  `git add $(git rev-parse --show-toplevel)`
  puts 'Committing with message'
  `git commit -m "#{args[:message] || 'update'}"`
  puts 'Pushing to Heroku'
  `git push heroku master`
end
