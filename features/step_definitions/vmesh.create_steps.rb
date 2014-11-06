=begin
When /^I create with no arguments$/ do 
  step %(I run `vmesh create`)
end
=end

When /^I create with "([^"]*)" template and name "([^"]*)"$/ do |type, name|
  step %(I run `vmesh -u user -p fakepass create #{name} #{type}`)
end
