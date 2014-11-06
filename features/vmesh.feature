Feature: My bootstrapped app kinda works
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

  Scenario: vmesh just runs
    When I get help for "vmesh"
    Then the exit status should be 0


  Scenario: vmesh create just runs
    When I get help for "vmesh create"
    Then the exit status should be 0

  Scenario: vmesh power just runs
    When I get help for "vmesh power"
    Then the exit status should be 0

