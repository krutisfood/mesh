Feature: My bootstrapped app kinda works
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

  Scenario: mesh just runs
    When I get help for "mesh"
    Then the exit status should be 0


  Scenario: mesh create just runs
    When I get help for "mesh create"
    Then the exit status should be 0

  Scenario: mesh power just runs
    When I get help for "mesh power"
    Then the exit status should be 0

