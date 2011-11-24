Given /^I am on the (.*) page$/ do |arg1|
  visit path_to(arg1)
end

Given /^I am logged in$/ do
  visit path_to("Welcome")
  within("#login") do 
    fill_in(field_to("Email"), :with => "christianb@web.de")
    fill_in(field_to("Password"), :with => "christianb")
  end
  click_button("Login")
  page.should have_content("Meine CDs")
end

When /^I follow "([^\"]*)"$/ do |link|
  visit path_to(link)
end

When /^I press "([^\"]*)"$/ do |button|
  click_button(button)
  #role=Role.where(:id => 10)
  #element = find_by_id("user_new")
  #Capybara::RackTest::Form.new(page.driver, element.native).submit :name => nil
end

When /^I fill in "([^\"]*)" with "([^\"]*)" in the login form$/ do |field, value|
  fill_in(field_to(field), :with => value)
end

When /^I fill in "([^\"]*)" with "([^\"]*)"$/ do |field, value|
  fill_in(field_to(field), :with => value)
end

When /^I fill in "([^\"]*)" with wrong value "([^\"]*)" in the login form$/ do |field, value|
  #within("#login") do 
    #fill_in(field_to(field), :with => value)
  #end
  fill_in(field_to(field), :with => value)
end

When /^I fill in "([^\"]*)" with "([^\"]*)" in the registration form$/ do |field, value|
  within("#user_new") do
    fill_in(field_to(field), :with => value)
  end
end

Then /^I should see (an|a) "([^\"]*)" field$/ do |_, arg2|
  element = find_by_id(field_to(arg2))
end

Then /^I should see "([^\"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^I should not see "([^\"]*)"$/ do |text|
  !page.should have_content(text)
end

Then /^the login should not be successful$/ do
  page.should have_content("Sign in")
end