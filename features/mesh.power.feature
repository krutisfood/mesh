Feature: Change Power State of a VM
  In order to manage servers
  I want to be able to change the power state of VMs
  So I can easily manage these servers

  Scenario: Power with no arguments
    When I power with no arguments
    Then the exit status should be 1

  Scenario: Power vm into an unknown state
    When I power machine "vmfrozen01" into state "unfrozed"
    Then the exit status should be 1
