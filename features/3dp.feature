@announce
Feature: 3dp
  As a rails developer
  I want to release apps in no time
  In order to make gigantic piles of money :)

  Scenario: Cucumber support
    When I run `bundle exec rake cucumber`
    Then it should pass with:
      """
      Using the default profile...
      0 scenarios
      0 steps
      0m0.000s
      """
  
  Scenario: Jasmine support
    When I run `bundle exec rake jasmine:ci`
    Then it should pass with:
      """
      jasmine server started.
      
      0 specs, 0 failures
      """
  
  Scenario: RSpec support
    When I run `bundle exec rake spec`
    Then it should pass with:
      """
      30 examples, 0 failures, 17 pending
      """
  
  @local
  Scenario: Guard support
    When I run `bundle exec guard` interactively
    And I type "q"
    Then it should pass with:
      """
      - INFO - Bye bye...
      """
  
  Scenario: Guard support
    When I run `bundle exec guard list`
    Then it should pass with:
      """
        +---------+-----------+
        | Plugin  | Guardfile |
        +---------+-----------+
        | Jasmine | ✔         |
        | Rspec   | ✔         |
        +---------+-----------+
      """
  
  Scenario: MongoDB support
    When I create Post record
    And I run `bundle exec rails runner 'puts Post.count'`
    Then it should pass with:
      """
      1
      """


