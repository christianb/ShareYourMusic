Feature: Authentication
  In order to use the plattform 
  As a user
  I want to be authenticated

  Scenario: Register new User
    Given I am on the Welcome page
		When I press Register
		Then I should see a Firstname Field
		And I should see a Lastname Field
		And I should see an Email Field
		And I should see a Password Field
		
		