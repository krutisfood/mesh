Feature: Annotate a VM
  In order to manage servers
  I want to be able to add an annotation to the VM
  So I can understand what they're for

  Scenario: Annotate with no arguments
    When I annotate with no arguments
    Then the exit status should be 1

  Scenario: Annotate passing set but no note
    When I annotate set with no note
    Then the exit status should be 1
