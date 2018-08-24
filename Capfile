# # Load DSL and Setup Up Stages
# require 'capistrano/setup'
# require 'capistrano/deploy'
#
#
# require 'capistrano/rails'
# require 'capistrano/bundler'
# # require 'capistrano/rvm'
# require 'capistrano/puma'
# require 'rvm1/capistrano3'
# require 'capistrano/rbenv'
#
# install_plugin Capistrano::Puma
# set :rbenv_ruby, '2.4.1'
# set :rbenv_path, :user
#
# # Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
# Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

# Load DSL and Setup Up Stages
require 'capistrano/setup'
require 'capistrano/deploy'

require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rvm'
require 'capistrano/puma'

install_plugin Capistrano::Puma
# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }