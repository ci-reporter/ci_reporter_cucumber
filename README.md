# CI::Reporter::Cucumber

Connects [Cucumber][cuke] to [CI::Reporter][ci], and then to your CI
system.

[![Gem Version](https://badge.fury.io/rb/ci_reporter_cucumber.svg)](http://badge.fury.io/rb/ci_reporter_cucumber)
[![Build Status](https://travis-ci.org/ci-reporter/ci_reporter_cucumber.svg?branch=master)](https://travis-ci.org/ci-reporter/ci_reporter_cucumber)
[![Dependency Status](https://gemnasium.com/ci-reporter/ci_reporter_cucumber.svg)](https://gemnasium.com/ci-reporter/ci_reporter_cucumber)
[![Code Climate](https://codeclimate.com/github/ci-reporter/ci_reporter_cucumber.png)](https://codeclimate.com/github/ci-reporter/ci_reporter_cucumber)

[cuke]: http://cukes.info/
[ci]: https://github.com/ci-reporter/ci_reporter

## Supported versions

The latest release of Cucumber 1.3 is supported.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ci_reporter_cucumber'
```

And then install it:

```
$ bundle
```

## Usage

Require the reporter in your Rakefile, and ensure that
`ci:setup:cucumber` is a dependency of your Cucumber task:

```ruby
require 'ci/reporter/rake/cucumber'

# ...
# Rake code that creates a task called `:cucumber`
# ...

task :cucumber => 'ci:setup:cucumber'
```

### Advanced usage

If you want to treat `undefined` and `pending` steps as failures
(instead of skipping them), set the `CI_PENDING_IS_FAILURE`
environment variable to `true`.

Refer to the shared [documentation][ci] for details on setting up
CI::Reporter.

### Spinach

If you use both Cucumber and Spinach, you are likely to see strange
errors due to `gherkin` and `gherkin-ruby` both being loaded. Choose
only one of these frameworks.

## Contributing

1. Fork it ( https://github.com/ci-reporter/ci_reporter_cucumber/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add a failing test.
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Ensure tests pass.
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new Pull Request
