require 'thread'
# ThreadPool is a simple class using Thread and Queue Ruby 2.0 as of writing
# to assign processes to a queue of a size specified which allows for 
# processing across multiple threads.

# There are 3 operations:
# - '.new(size)' this creates a new ThreadPool of a given size. (Too few 
# few doesn't allow for much concurrent process while to many will degrade
# performance by getting ruby stuck switching between the different threads.
# - '#assign(*args, &job)' Pretty self explanitory here, method that assigns
# a block of code to a process, allows you to pass in arguments if needed.
# - '#shutdown' In the code we have a try block to handle program flow, this# sends out the exit flag to shutdown all the processes. Clean exits :D

class ThreadPool
  def initialize(size)
    @size = size # Important for the clean exits, have to know the size
                 # if we want to pass out the proper amount of exit flags.
    @processes = Queue.new # What more can I say:
    # http://www.ruby-doc.org/stdlib-2.0/libdoc/thread/rdoc/Queue.html
    
    @pool = Array.new(@size) do |i|
      Thread.new do
        Thread.current[:id] = i
        # Here is that clean exit stuff I was going on about earlier. Flow
        # Control catch and we use the #shutdown method to throw the flag.
        # One bit of niftyness I suppose is that instead of instant bailing
        # we want to make sure all the processes finish up. You could just
        # use Thread.kill if you wished to say screw it to the processes.
        catch(:exit) do
          loop do
            process, args = @processes.pop # have a look at line 44. Should 
                                           # explain what is happening here.
                                           # Making a Proc from the block,
                                           # and filling up args.
            process.call(*args) # Invokes the block, setting its params to 
                                # the arguments given.
          end
        end
      end
    end
  end

  def assign(*args, &block)
    @processes << [block, args] # Self explanitory sends the block and args
                                # to the Queue for processing when a thread
                                # is available.
  end

  def shutdown
    # Throws :exit to each thread to insure clean exit.
    @size.times do
      assign {throw :exit}
    end
    
    # When all working theads have exited, join all the available threads 
    # so that all the threads aren't just killed by the main thread exiting.
    @pool.map(&:join)
  end
end
