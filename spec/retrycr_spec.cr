require "./spec_helper"

class MyExcepion < Exception
end

describe Retrycr do
  it "returns the block value" do
    ret = retryable(tries: 3, wait: 0) do |retries|
      1
    end

    ret.should eq(1)
  end

  it "keeps a counter" do
    tries = 0

    assert_retried do
      retryable(tries: 3, wait: 0) do |retries|
        tries = retries
        raise Exception.new
      end
    end

    tries.should eq(3)
  end

  it "can use a proc for wait time" do
    assert_retried do
      retryable(tries: 3, wait: ->(n : Int32) { 0 }) do |retries|
        raise Exception.new
      end
    end
  end

  it "can call a callback on retry" do
    cb_called = 0
    proc = ->(ex : Exception) { cb_called += 1 }

    assert_retried do
      retryable(tries: 3, wait: 0, callback: proc) do |retries|
        raise Exception.new
      end
    end

    cb_called.should eq(3)
  end

  it "can have a callback for final operation" do
    finally = 0
    proc = ->(tries : Int32) { finally = tries }

    assert_retried do
      retryable(tries: 3, wait: 0, finally: proc) do |retries|
        raise Exception.new
      end
    end

    finally.should eq(3)
  end

  it "wont raise unless 'on' exception is raised" do
    tries = 0

    assert_retried do
      retryable(on: ArgumentError, tries: 3, wait: 0) do |retries|
        raise Exception.new
      end
    end

    tries.should eq(0)
  end

  it "can specify union" do
    tries = 0

    assert_retried do
      retryable(on: ArgumentError | Exception, tries: 3, wait: 0) do |retries|
        tries = retries
        raise ArgumentError.new if retries < 2
        raise Exception.new
      end
    end

    tries.should eq(3)
  end
end
