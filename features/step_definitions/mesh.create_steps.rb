When /^I create with no arguments$/ do 
  step %(I run `mesh create`)
end

When /^I create with "([^"]*)" template and name "([^"]*)"$/ do |type, name|
  step %(I run `mesh create #{type} #{name}`)
end
