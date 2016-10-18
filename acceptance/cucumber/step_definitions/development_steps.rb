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

Given /^that I want to include the following data table$/ do |table|
  expect(table).to be_a(Cucumber::Ast::Table)
end

Then /^I should not see each row in the table treated as a separate example$/ do
end

Given /^that I might use a scenario outline with a data table and an examples table$/ do
end

Then /^I want values for (.*), (.*), and (.*)$/ do |arg_1, arg_2, arg_3|
  expect(arg_1).to be_a(String)
  expect(arg_2).to be_a(String)
  expect(arg_3).to be_a(String)
end
