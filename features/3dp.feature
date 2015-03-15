@announce
Feature: 3dp
  As a rails developer
  I want to release apps in no time
  In order to make gigantic piles of money :)

  Scenario: MondodDB support
    When I create Post record
    Then I run "bundle exec rails runner 'puts Post.count'"
    And it should pass with:
      """
      1
      """

