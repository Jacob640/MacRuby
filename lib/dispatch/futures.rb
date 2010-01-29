module Dispatch
  # Wrapper around Dispatch::Group used to implement lazy Futures 
  class Future
    # Create a future that asynchronously dispatches the block 
    # to a concurrent queue of the specified (optional) +priority+
    def initialize(priority=nil, &block)
      @value = nil
      @group = Dispatch.fork(priority) { @value = block.call }
    end

    # Waits for the computation to finish, then returns the value
    # Duck-typed to lambda.call(void)
    # If a block is passed, invoke that asynchronously with the final value
    def call(&callback)
      if not block_given?
        @group.wait
        return @value
      end
      @group.notify { callback.call(@value) }
    end
  end
end
