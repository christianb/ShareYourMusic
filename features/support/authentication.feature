Feature: Authentication
  As a user 
  I want to login at the plattform
  So I can share my CDs with other people

  @wip
  Scenario: Click on Register
    Given I am on the Welcome page
		When I follow "Register"
		Then I should see "Login"
		Then I should see a "Firstname" field
		And I should see a "Lastname" field
		And I should see an "Email" field
		And I should see a "Password" field
	
	@wip
	Scenario: Fill form to register
		Given I am on the Register page
    When I fill in "Firstname" with "Christian" in the registration form
    And I fill in "Lastname" with "Bunk" in the registration form
    And I fill in "Password" with "weihnachten1986" in the registration form
    And I fill in "Password confirmation" with "weihnachten1986" in the registration form
    And I fill in "Email" with "hallo@web.de" in the registration form
    #And I fill in "Image" with "image.png" in the registration form
    And I press "Profil erstellen"
    Then I should see "Meine CDs"
		
	@wip
	Scenario: Login User (successful)
	  Given I am on the Welcome page
	  And I should see an "Email" field
	  And I should see a "Password" field
		When I fill in "Email" with "christianb@web.de" in the login form
		And I fill in "Password" with "christianb" in the login form
		And I press "Login"
		Then I should see "Meine CDs"
		
	@wip
	Scenario: Login User (unsuccessful)
    Given I am on the Welcome page
	  And I should see an "Email" field
	  And I should see a "Password" field
		When I fill in "Email" with wrong value "christ@web.de" in the login form
		And I fill in "Password" with wrong value "christian" in the login form
		And I press "Login"
		Then the login should not be successful
		
	@wip
	Scenario: Logout User
	  Given I am logged in
	  When I follow "Logout"
	  Then I should see "Logout Erfolgreich"
	  
	