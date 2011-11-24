Feature: Manage User Data
  As a user 
  I want to view my and other profiles
  So I can manage my information

  @ok
  Scenario: Miss Password at Edit Form
    Given I am logged in
      When I follow "Edit registration"
      And I fill in "Lastname" with "Schmidt"
      And I press "Absenden"
      Then I should see "Current password can't be blank"
    
  @wip
  Scenario: Update Data
    Given I am logged in
    When I follow "Edit registration"
    And I fill in "Lastname" with "Schmidt"
    And I fill in my Password
    And I press "Update"
    Then I should see "Profil erfolgreich geupdated"
    
  @ok
  Scenario: View Profil
    Given I am logged in
      When I follow "Profil"
      Then I should see "Benutzerprofil"
      And I should see "Name:"
      And I should see "Alias:"
      And I should see "eMail:"
      And I should see "Bearbeiten"
      And I should see "Account löschen"
      
  @wip
  Scenario: Delete Profil
    Given I am logged in
    When I follow "Profil"
    And I delete my Account
    Then I should see "Logout erfolgreich"