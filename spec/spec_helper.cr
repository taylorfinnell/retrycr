require "spec"
require "../src/retrycr"

def assert_retried
  expect_raises Exception do
    yield
  end
end
