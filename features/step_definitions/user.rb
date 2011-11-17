When /^I fill in "([^\"]*)" with "([^\"]*)" in the edit form$/ do |field, value|
  #within("#user_edit") do
    #fill_in(field_to(field), :with => value)
  #end
  fill_in (field_to(field)), :with => value
end

When /^I fill in my Password$/ do
  within("#user_edit") do
    fill_in(field_to("Password confirmation"), :with => "christianb")
  end

end

When /^I delete my Account$/ do
  delete path_to("Account loeschen")
end