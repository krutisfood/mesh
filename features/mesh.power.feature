Feature: Change Power State of a VM
  In order to manage servers
  I want to be able to change the power state of VMs
  So I can easily manage these servers

  Scenario: Create with no arguments
    When I create with no arguments
    Then the exit status should be 1

  Scenario: Create with unknown vm type
    When I create with "unknown" template and name "anything"
    Then the exit status should be 1
     And the stderr should contain "unknown machine type"

