When /^I power machine "([^"]*)" into state "([^"]*)"$/ do |machine, desired_state|
  step %(I run `vmesh power #{machine} #{desired_state}`)
end
