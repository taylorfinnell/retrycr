module Retrycr
  # :nodoc:
  class Retrier(T)
    def retry(tries : Int32, wait : Proc(Int32, Int32) | Int32 = 1,
              callback : Proc(Exception, _) = ->(ex : Exception) {},
              finally : Proc(Int32, Exception, _) = ->(retries : Int32, ex : Exception) {})
      retries = 0

      loop do
        begin
          return yield retries
        rescue ex : T
          if retries == tries
            finally.call(retries, ex)
            raise ex
          end

          if wait.is_a?(Proc)
            sleep(wait.call(retries))
          else
            sleep(wait)
          end

          callback.call(ex)

          retries += 1
        end
      end
    end
  end
end
