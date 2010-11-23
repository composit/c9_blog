Feature: manage entries
  In order to
  want to

  Scenario: I should see entries listed in reverse chronological order, blog-like
    Given the following entry records:
      | content | created_at |
      | Test 1  | 2002-02-02 |
      | Test 2  | 2003-03-03 |
      | Test 3  | 2001-01-01 |
    When I am on the entries page
    Then I should see the following text in order:
      | text   |
      | Test 2 |
      | Test 1 |
      | Test 3 |
