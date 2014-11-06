When /^I power machine "([^"]*)" into state "([^"]*)"$/ do |machine, desired_state|
  step %(I run `vmesh -u user -p secret power #{machine} #{desired_state}`)
end
