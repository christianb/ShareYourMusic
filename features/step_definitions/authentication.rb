Given /^I am on the (.*) page$/ do |arg1|
  visit path_to(arg1)
end

When /^I press (.*)$/ do |arg1|
  visit path_to(arg1)
end

Then /^I should see (an|a) (.*) Field$/ do |_, arg2|
  element = find_by_id(field_to(arg2))
end