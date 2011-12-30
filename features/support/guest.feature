Feature: Guest Usability
  As a guest
  I want to have a look at the plattform
	So I can decide whether I want to register or not

  @ok
  Scenario: See Alle CDs
  	Given I am on the Welcome page
		When I follow "Alle CDs"
		Then I should see "Alle CDs"
	
  @ok
  Scenario: See Neuste CDs
  	Given I am on the Welcome page
		When I follow "Neueste CDs"
		Then I should see "Neueste CDs"
	
  @ok
  Scenario: See Aktivste Benutzer
		Given I am on the Welcome page
		When I follow "Aktivste Benutzer"
		Then I should see "Aktivste Benutzer"
		
	@ok
	Scenario: See Tollste CDs
		Given I am on the Welcome page
		When I follow "Tollste CDs"
		Then I should see "Tollste CDs"