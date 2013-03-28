require 'thread'
# ThreadPool is a simple class using Thread and Queue Ruby 2.0 as of writing
# to assign processes to a queue of a size specified which allows for
# processing across multiple threads.
 
# There are 3 operations:
# - '.new' this creates a new ThreadPool
# - '#assign(*args, &job)' Pretty self explanitory here, method that assigns
# a block of code to a process, allows you to pass in arguments if needed.
# - '#execute' This executes the queue with a newly created thread.
 
class ThreadPool
  def initialize()
    @processes = Queue.new # What more can I say:
    # http://www.ruby-doc.org/stdlib-2.0/libdoc/thread/rdoc/Queue.html
  
  end
 
  def assign(*args, &block)
    @processes << [block, args] # Self explanitory sends the block and args
                                # to the Queue for processing when a thread
                                # is available.
    execute
  end
 
  def execute
    Thread.abort_on_exception = true
    @pool =  Thread.new {
      Thread.current[:id] = Thread.current
      loop do
        process, args = @processes.pop # Making a Proc from the block,
                                       # and filling up args.

        process.call(*args) # Invokes the block, setting its params to
                            # the arguments given.
      end
    }
  end
end
