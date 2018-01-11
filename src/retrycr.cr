require "./retrycr/*"

macro retryable(on = Exception, **args, &block)
  Retrycr::Retrier({{on}}).new.retry {{**args}} {{block}}
end
