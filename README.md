# retrycr
[![Build Status](https://travis-ci.org/taylorfinnell/retrycr.svg?branch=master)](https://travis-ci.org/taylorfinnell/retrycr)

Retry blocks of Crystal code.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  retrycr:
    github: taylorfinnell/retrycr
```

## Usage

```crystal
require "retrycr"
```

Retry all exceptions.

```crystal
retryable(tries: 1, wait: 1) do
  # my code
end
```

You may specify which `Exception` classes trigger a retry.
```crystal
retryable(on: ArgumentError | Base64::Error, tries: 1, wait: 1) do
  # my code
end
```

The *wait* parameter can either be an `Int32` or a `Proc`.
```crystal
retryable(tries: 1, wait: ->(x : Int32) { 2**x }) do
  # my code
end
```

The number of retries that have happened is yielded to the block.
```crystal
retryable(tries: 1, wait: 1) do |retries|
  puts "There have been #{retries} retries!"
end
```

You can specify a callback to run everytime the code is retried.
```crystal
callback = -> (ex : Exeption) { "The code is about to be retried!" }
retryable(tries: 1, wait: 1, callback: callback) do |retries|
  puts "There have been #{retries} retries!"
end
```

You can specify a callback to run after all retries are exhausted.
```crystal
f = File.open("test")
callback = -> (retries : Int32) { f.close }
retryable(tries: 1, wait: 1, finally: callback) do |retries|
  f.read
end
```
