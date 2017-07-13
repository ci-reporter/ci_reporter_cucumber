begin
  require 'rspec/expectations'
rescue LoadError
  require 'spec/expectations'
end

Given /^that I am a conscientious developer$/ do
end

Given /^I write cucumber features$/ do
end

Then /^I should see a green bar$/ do
end

Given /^that I am a lazy hacker$/ do
end

Given /^I don't bother writing cucumber features$/ do
 expect(false).to eql true
end

Then /^I should be fired$/ do
end

Given /^that I can't code for peanuts$/ do
end

Given /^I write step definitions that throw exceptions$/ do
  raise RuntimeError, "User error!"
end

Then /^I shouldn't be allowed out in public$/ do
end
