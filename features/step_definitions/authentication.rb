Given /^I am on the (.*) page$/ do |arg1|
  visit path_to(arg1)
end

When /^I follow (.*)$/ do |link|
  visit path_to(link)
end

When /^I press "([^\"]*)"$/ do |button|
  click_button(button)
  role=Role.where(:id => 10)
  #element = find_by_id("user_new")
  #Capybara::RackTest::Form.new(page.driver, element.native).submit :name => nil
end
#
When /^I fill in "([^\"]*)" with "([^\"]*)"$/ do |field, value|
  #fill_in "Email", :with => "hallo@welt.de"
#  find_by_id("user_email").set("hallo@web.de")
#  fill_in(field_to(field), :with => value)
  #click_button 'Sign up'
  #within '#content'
  #     fill_in "user[email]", :with => "hallo@welt.de"
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