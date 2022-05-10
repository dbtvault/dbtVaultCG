Feature: [SF-STS] Status Tracking Satellites

  @fixture.sts
  Scenario: [SF-STS-01] Load data into a non-existent status tracking satellite
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE | STATUS |
      | 1001        | Alice         | 1993-01-01 | *      | D      |
      | 1002        | Bob           | 1993-01-01 | *      | C      |
      | 1003        | Chad          | 1993-01-01 | *      | U      |
      | 1003        | Chaz          | 1993-01-02 | *      | U      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | D      |
      | md5('1002') | 1993-01-01 | *      | C      |
      | md5('1003') | 1993-01-01 | *      | U      |
      | md5('1003') | 1993-01-02 | *      | U      |

  @fixture.sts
  Scenario: [SF-STS-02] Load data into a non-existent status tracking satellite
    Given the STS sts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE | STATUS |
      | 1001        | Alice         | 1993-01-01 | *      | D      |
      | 1002        | Bob           | 1993-01-01 | *      | C      |
      | 1003        | Chad          | 1993-01-01 | *      | U      |
      | 1003        | Chaz          | 1993-01-02 | *      | U      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | D      |
      | md5('1002') | 1993-01-01 | *      | C      |
      | md5('1003') | 1993-01-01 | *      | U      |
      | md5('1003') | 1993-01-02 | *      | U      |

  @fixture.sts
  Scenario: [SF-STS-03] Load data into a populated status tracking satellite where some records overlap
    Given the STS sts is already populated with data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | D      |
      | md5('1002') | 1993-01-01 | *      | C      |
      | md5('1003') | 1993-01-01 | *      | U      |
      | md5('1003') | 1993-01-02 | *      | U      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE | STATUS |
      | 1001        | Alice         | 1993-01-03 | *      | I      |
      | 1002        | Bob           | 1993-01-03 | *      | C      |
      | 1003        | Chaz          | 1993-01-03 | *      | D      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | D      |
      | md5('1002') | 1993-01-01 | *      | C      |
      | md5('1003') | 1993-01-01 | *      | U      |
      | md5('1003') | 1993-01-02 | *      | U      |
      | md5('1001') | 1993-01-03 | *      | I      |
      | md5('1002') | 1993-01-03 | *      | C      |
      | md5('1003') | 1993-01-03 | *      | D      |