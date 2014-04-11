Feature: Create a new VM
  In order to provision new infrastructure
  I want to be able to create new templated VMs
  So I have consistent easily created VMs

  Scenario: Create with no arguments
    When I create with no arguments
    Then the exit status should be 1

  Scenario: Create with unknown vm type
    When I create with "unknown" template and name "anything"
    Then the exit status should be 1
     And the stderr should contain "unknown machine type"

