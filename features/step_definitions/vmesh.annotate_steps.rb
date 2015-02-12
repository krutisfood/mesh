When /^I annotate set with no note$/ do
  step %(I run `vmesh -u user -p secret annotate`)
end

When /^I annotate set with a note$/ do
  step %(I run `vmesh -u user -p secret annotate`)
end
