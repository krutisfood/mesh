When /^I power machine "([^"]*)" into state "([^"]*)"$/ do |machine, desired_state|
  step %(I run `mesh power #{machine} #{desired_state}`)
end
