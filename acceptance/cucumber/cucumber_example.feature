Feature: Example Cucumber feature
  As a conscientious developer who writes features
  I want to be able to see my features passing on the CI Server
  So that I can bask in the glow of a green bar

  Scenario: Conscientious developer
    Given that I am a conscientious developer
    And I write cucumber features
    Then I should see a green bar

  Scenario: Lazy hacker
    Given that I am a lazy hacker
    And I don't bother writing cucumber features
    Then I should be fired

  Scenario: Forgetful hacker
    Given that I am a forgetful hacker
    And I forgot to define a cucumber step

  Scenario: Bad coder
    Given that I can't code for peanuts
    And I write step definitions that throw exceptions
    Then I shouldn't be allowed out in public

  Scenario: Using a data table in a scenario
    Given that I want to include the following data table
      | Data Column 1 | Data Column 2 | Data Column 3 |
      | Data Cell A   | Data Cell B   | Data Cell C   |
      | Data Cell D   | Data Cell E   | Data Cell F   |
    Then I should not see each row in the table treated as a separate example

  Scenario Outline: Using a scenario outline
    Given that I might use a scenario outline with a data table and an examples table
    And that I want to include the following data table
      | Data Column 4 | Data Column 5 | Data Column 6 |
      | Data Cell G   | Data Cell H   | Data Cell I   |
      | Data Cell J   | Data Cell K   | Data Cell L   |
    Then I want values for <Example Column 1>, <Example Column 2>, and <Example Column 3>

    Examples:
      | Example Column 1 | Example Column 2 | Example Column 3 |
      | Example Cell A   | Example Cell B   | Example Cell C   |
      | Example Cell D   | Example Cell E   | Example Cell F   |
