# :nodoc:
class Retrycr(T)
  VERSION = "0.1.0"

  def retry(tries : Int32, wait : Proc(Int32, Int32) | Int32 = 1,
            callback : Proc(Exception, _) = ->(e : Exception) {},
            finally : Proc(Int32, _) = ->(e : Int32) {},
            &block)
    retries = 0

    loop do
      begin
        return yield retries
      rescue ex : T
        raise ex if retries == tries

        if wait.is_a?(Proc)
          sleep(wait.call(retries))
        else
          sleep(wait)
        end

        callback.call(ex)

        retries += 1
      ensure
        finally.call(retries)
      end
    end
  end
end

macro retryable(on = Exception, **args, &block)
  Retrycr({{on}}).new.retry {{**args}} {{block}}
end
