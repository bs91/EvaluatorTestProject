# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Evaluator::Application.initialize!

# Create Thread Pool
module Evaluator
  class Application < Rails::Application
    require 'thread_pool'
    THREAD_POOL = ThreadPool.new
  end
end
