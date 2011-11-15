Feature: Authentication
  In order to use the plattform 
  As a user
  I want to be authenticated

  @ok
  Scenario: Click on Register
    Given I am on the Welcome page
		When I follow Register
		Then I should see "Sign up"
		Then I should see a "Firstname" field
		And I should see a "Lastname" field
		And I should see an "Email" field
		And I should see a "Password" field
	
	@ok
	Scenario: Fill Form to register
		Given I am on the Register page
    When I fill in "Firstname" with "Christian"
    And I fill in "Lastname" with "Bunk"
    #And I fill in "Password" with "Secret"
    And I fill in "Password" with "weihnachten1986"
    And I fill in "Password confirmation" with "weihnachten1986"
    And I fill in "Email" with "hallo@web.de"
    And I fill in "Image" with "image.png"
    And I press "Sign up"
    Then I should see "Meine CDs"
		
	@wip
	Scenario: Login User
	  Given I am on the Welcome page
	  Then I should see an "Email" field
	  And I should see a "Password" field
		