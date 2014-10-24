# EspSdk

Ruby SDK for Evident.io API

## Installation

Add this line to your application's Gemfile:

    gem 'esp_sdk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install esp_sdk

## Usage

## Constructor

    # Required :password, :email
    # Optional :version
    # Default and current version 'v1'
    api = EspSdk::Api.new(email: 'me@google.com', password: 'password', version: 'optional')

## Configuration
    
    api.config => #<EspSdk::Configure:0x00000102890f28 @email="me@gmail.com", @version="v1", @uri="https://api.evident.io/api", @token="6_4wys1a2FhqsECstavC", @token_expires_at=Fri, 19 Sep 2014 15:39:10 UTC +00:00>
    
    # Authorization token
    api.config.token => "6_4wys1a2FhqsECstavC"
    
    # Token expiration. ActiveSupport::TimeWithZone
    api.config.token_expires_at => Fri, 19 Sep 2014 15:39:10 UTC +00:00
    
    # Authorization email
    api.config.email => "me@gmail.com"

## End points array

    # Current and all endpoints in a single array
    
    api.end_points =>
    [
        [0] #<EspSdk::EndPoints::Reports:0x000001019bc498 @config=#<EspSdk::Configure:0x00000102890f28 @email="me@gmail.com", @version="v1", @uri="https://api.evident.io/api", @token="6_4wys1a2FhqsECstavC", @token_expires_at=Fri, 19 Sep 2014 15:39:10 UTC +00:00>>,
        [1] #<EspSdk::EndPoints::Users:0x000001019bc038 @config=#<EspSdk::Configure:0x00000102890f28 @email="me@gmail.com", @version="v1", @uri="https://api.evident.io/api", @token="6_4wys1a2FhqsECstavC", @token_expires_at=Fri, 19 Sep 2014 15:39:10 UTC +00:00>>,
        [2] #<EspSdk::EndPoints::ExternalAccounts:0x000001028a3ab0 @config=#<EspSdk::Configure:0x00000102890f28 @email="me@gmail.com", @version="v1", @uri="https://api.evident.io/api", @token="6_4wys1a2FhqsECstavC", @token_expires_at=Fri, 19 Sep 2014 15:39:10 UTC +00:00>>,
        [3] #<EspSdk::EndPoints::CustomSignatures:0x000001028a3560 @config=#<EspSdk::Configure:0x00000102890f28 @email="me@gmail.com", @version="v1", @uri="https://api.evident.io/api", @token="6_4wys1a2FhqsECstavC", @token_expires_at=Fri, 19 Sep 2014 15:39:10 UTC +00:00>>,
        [4] #<EspSdk::EndPoints::Organizations:0x000001028a3100 @config=#<EspSdk::Configure:0x00000102890f28 @email="me@gmail.com", @version="v1", @uri="https://api.evident.io/api", @token="6_4wys1a2FhqsECstavC", @token_expires_at=Fri, 19 Sep 2014 15:39:10 UTC +00:00>>,
        [5] #<EspSdk::EndPoints::SubOrganizations:0x000001028a2bb0 @config=#<EspSdk::Configure:0x00000102890f28 @email="me@gmail.com", @version="v1", @uri="https://api.evident.io/api", @token="6_4wys1a2FhqsECstavC", @token_expires_at=Fri, 19 Sep 2014 15:39:10 UTC +00:00>>,
        [6] #<EspSdk::EndPoints::Teams:0x000001028a2750 @config=#<EspSdk::Configure:0x00000102890f28 @email="me@gmail.com", @version="v1", @uri="https://api.evident.io/api", @token="6_4wys1a2FhqsECstavC", @token_expires_at=Fri, 19 Sep 2014 15:39:10 UTC +00:00>>,
        [7] #<EspSdk::EndPoints::Signatures:0x000001028a22f0 @config=#<EspSdk::Configure:0x00000102890f28 @email="me@gmail.com", @version="v1", @uri="https://api.evident.io/api", @token="6_4wys1a2FhqsECstavC", @token_expires_at=Fri, 19 Sep 2014 15:39:10 UTC +00:00>>,
        [8] #<EspSdk::EndPoints::Dashboard:0x000001028a1e90 @config=#<EspSdk::Configure:0x00000102890f28 @email="me@gmail.com", @version="v1", @uri="https://api.evident.io/api", @token="6_4wys1a2FhqsECstavC", @token_expires_at=Fri, 19 Sep 2014 15:39:10 UTC +00:00>>,
        [9] #<EspSdk::EndPoints::ContactRequests:0x000001028a1940 @config=#<EspSdk::Configure:0x00000102890f28 @email="me@gmail.com", @version="v1", @uri="https://api.evident.io/api", @token="6_4wys1a2FhqsECstavC", @token_expires_at=Fri, 19 Sep 2014 15:39:10 UTC +00:00>>
        [10] #<EspSdk::EndPoints::Services:0x000001031949f8 @config=#<EspSdk::Configure:0x000001010880e8 @email="me@gmail.com", @version="v1", @uri="https://api.evident.io/api", @token="6_4wys1a2FhqsECstavC", @token_expires_at=Fri, 19 Sep 2014 15:39:10 UTC +00:00>>
    ]

## Reports end point
### List action
    # List action is a pageable response with a total of 5 reports per page.
    api.reports.list => 
    {
            "report" => 130,
        "created_at" => "2014-08-06T19:59:57.540Z",
              "team" => "Evident",
            "alerts" => [
            [  0] {
                          "signature" => "Sss Global Any Bucket Permissions",
                             "status" => "fail",
                             "region" => "us_east_1",
                   "external_account" => "Development",
                         "identifier" => "AWS:SSS-008",
                         "risk_level" => "Low",
                            "service" => "SSS",
                        "description" => "Check if S3 buckets have any global permissions enabled",
                         "resolution" => "This signature is under active development.",
                "related_information" => {
                            "message" => "A permission is granted to Everyone on the 'evident-prod' bucket",
                             "bucket" => "evident-prod",
                    "deep_inspection" => nil
                }
            },
    }
    
    # Current page
    api.reports.current_page
    
    # Next page sets current_page with the next page results.
    api.reports.next_page
    
    # Previous page sets current_page with the previous page results.
    api.reports.prev_page

### Show action
    # Show a specific report
    # Required :id
    api.reports.show(id: 130) => 
    {
                "report" => 130,
            "created_at" => "2014-08-06T19:59:57.540Z",
                  "team" => "Evident",
                "alerts" => [
                [  0] {
                              "signature" => "Sss Global Any Bucket Permissions",
                                 "status" => "fail",
                                 "region" => "us_east_1",
                       "external_account" => "Development",
                             "identifier" => "AWS:SSS-008",
                             "risk_level" => "Low",
                                "service" => "SSS",
                            "description" => "Check if S3 buckets have any global permissions enabled",
                             "resolution" => "This signature is under active development.",
                    "related_information" => {
                                "message" => "A permission is granted to Everyone on the 'evident-prod' bucket",
                                 "bucket" => "evident-prod",
                        "deep_inspection" => nil
                    }
                },
    }
    
    # Current record shows the current record
    api.reports.current_record

## Dashboard end point

### List action

    # List your current dashboard stats
    api.dashboard.list =>
    {
        "enterprise" => true,
             "teams" => [
            [0] {
                "report" => {
                                "name" => "Evident",
                             "team_id" => 1,
                    "sub_organization" => "Evident",
                          "created_at" => "2014-08-06T19:59:57.540Z",
                           "report_id" => 130,
                               "stats" => {
                             "total" => 196,
                           "regions" => [
                            [0] {
                                     "code" => "ap_northeast_1",
                                "region_id" => 1,
                                    "total" => 2,
                                     "pass" => 5,
                                     "high" => 1,
                                   "medium" => 1,
                                      "low" => 0
                            },
                            [1] {
                                     "code" => "ap_southeast_1",
                                "region_id" => 2,
                                    "total" => 2,
                                     "pass" => 6,
                                     "high" => 1,
                                   "medium" => 1,
                                      "low" => 0
                            },
                            [2] {
                                     "code" => "eu_west_1",
                                "region_id" => 4,
                                    "total" => 2,
                                     "pass" => 5,
                                     "high" => 1,
                                   "medium" => 1,
                                      "low" => 0
                            },
                            [3] {
                                     "code" => "sa_east_1",
                                "region_id" => 5,
                                    "total" => 2,
                                     "pass" => 5,
                                     "high" => 1,
                                   "medium" => 1,
                                      "low" => 0
                            },
                            [4] {
                                     "code" => "ap_southeast_2",
                                "region_id" => 3,
                                    "total" => 2,
                                     "pass" => 5,
                                     "high" => 1,
                                   "medium" => 1,
                                      "low" => 0
                            },
                            [5] {
                                     "code" => "us_west_1",
                                "region_id" => 7,
                                    "total" => 2,
                                     "pass" => 5,
                                     "high" => 1,
                                   "medium" => 1,
                                      "low" => 0
                            },
                            [6] {
                                     "code" => "us_west_2",
                                "region_id" => 8,
                                    "total" => 1,
                                     "pass" => 7,
                                     "high" => 0,
                                   "medium" => 1,
                                      "low" => 0
                            },
                            [7] {
                                     "code" => "global",
                                "region_id" => 9,
                                    "total" => 7,
                                     "pass" => 13,
                                     "high" => 1,
                                   "medium" => 6,
                                      "low" => 0
                            },
                            [8] {
                                     "code" => "us_east_1",
                                "region_id" => 6,
                                    "total" => 45,
                                     "pass" => 80,
                                     "high" => 0,
                                   "medium" => 22,
                                      "low" => 23
                            }
                        ],
                        "signatures" => [
                            [ 0] {
                                "signature_id" => 86,
                                   "unique_id" => "AWS:EC2-030",
                                       "total" => 2
                            },
                            [ 1] {
                                "signature_id" => 22,
                                   "unique_id" => "AWS:VPC-009",
                                       "total" => 6
                            },
                            [ 2] {
                                "signature_id" => 77,
                                   "unique_id" => "AWS:ELB-001",
                                       "total" => 6
                            },
                            [ 3] {
                                "signature_id" => 76,
                                   "unique_id" => "AWS:EC2-032",
                                       "total" => 21
                            },
                            [ 4] {
                                "signature_id" => 75,
                                   "unique_id" => "AWS:EC2-031",
                                       "total" => 8
                            },
                            [ 5] {
                                "signature_id" => 92,
                                   "unique_id" => "AWS:ELB-007",
                                       "total" => 1
                            },
                            [ 6] {
                                "signature_id" => 78,
                                   "unique_id" => "AWS:IAM-008",
                                       "total" => 1
                            },
                            [ 7] {
                                "signature_id" => 90,
                                   "unique_id" => "AWS:SSS-006",
                                       "total" => 1
                            },
                            [ 8] {
                                "signature_id" => 89,
                                   "unique_id" => "AWS:SSS-007",
                                       "total" => 1
                            },
                            [ 9] {
                                "signature_id" => 17,
                                   "unique_id" => "AWS:EC2-001",
                                       "total" => 17
                            },
                            [10] {
                                "signature_id" => 88,
                                   "unique_id" => "AWS:SSS-008",
                                       "total" => 1
                            }
                        ],
                          "services" => [
                            [0] {
                                   "service" => "VPC",
                                     "total" => 6,
                                "service_id" => 8
                            },
                            [1] {
                                   "service" => "ELB",
                                     "total" => 7,
                                "service_id" => 7
                            },
                            [2] {
                                   "service" => "IAM",
                                     "total" => 1,
                                "service_id" => 2
                            },
                            [3] {
                                   "service" => "EC2",
                                     "total" => 48,
                                "service_id" => 5
                            },
                            [4] {
                                   "service" => "SSS",
                                     "total" => 3,
                                "service_id" => 4
                            }
                        ],
                        "severities" => [
                            [0] {
                                "severity" => "medium",
                                   "total" => 35
                            },
                            [1] {
                                "severity" => "high",
                                   "total" => 7
                            },
                            [2] {
                                "severity" => "pass",
                                   "total" => 131
                            },
                            [3] {
                                "severity" => "low",
                                   "total" => 23
                            }
                        ]
                    }
                }
            }
        ]
    }

### Timewarp action
#### This endpoint is used for returning dashboard stats at a specific hour in the past
    # Required params: time: => '1413999010' Unix Time
    # The time is floored and has five minutes subtracted. Then adds an hour for the end time. Any reports between that hour will have their stats returned.
    # EX: 
    # start_time =  DateTime.strptime('1413999010','%s').at_beginning_of_hour - 5.minutes
    # end_time   = start_time + 1.hour
    api.dashboard.timewarp(time: '1413999010') =>
    {
        "enterprise" => false,
             "teams" => [
            [0] {
                            "name" => "Default Team",
                         "team_id" => 1,
                "sub_organization" => "Default Sub Organization",
                      "created_at" => "2014-10-22T17:30:10.086Z",
                       "report_id" => 5,
                           "stats" => {
                         "total" => 356,
                       "regions" => [
                        [0] {
                                 "code" => "global",
                            "region_id" => 9,
                                "total" => 23,
                                 "pass" => 22,
                                 "high" => 1,
                               "medium" => 22,
                                  "low" => 0
                        },
                        [1] {
                                 "code" => "us_east_1",
                            "region_id" => 6,
                                "total" => 139,
                                 "pass" => 105,
                                 "high" => 0,
                               "medium" => 67,
                                  "low" => 72
                        },
                        [2] {
                                 "code" => "eu_west_1",
                            "region_id" => 4,
                                "total" => 3,
                                 "pass" => 6,
                                 "high" => 2,
                               "medium" => 1,
                                  "low" => 0
                        },
                        [3] {
                                 "code" => "ap_northeast_1",
                            "region_id" => 1,
                                "total" => 3,
                                 "pass" => 6,
                                 "high" => 2,
                               "medium" => 1,
                                  "low" => 0
                        },
                        [4] {
                                 "code" => "us_west_1",
                            "region_id" => 7,
                                "total" => 3,
                                 "pass" => 6,
                                 "high" => 2,
                               "medium" => 1,
                                  "low" => 0
                        },
                        [5] {
                                 "code" => "ap_southeast_1",
                            "region_id" => 2,
                                "total" => 3,
                                 "pass" => 7,
                                 "high" => 2,
                               "medium" => 1,
                                  "low" => 0
                        },
                        [6] {
                                 "code" => "us_west_2",
                            "region_id" => 8,
                                "total" => 2,
                                 "pass" => 10,
                                 "high" => 1,
                               "medium" => 1,
                                  "low" => 0
                        },
                        [7] {
                                 "code" => "sa_east_1",
                            "region_id" => 5,
                                "total" => 3,
                                 "pass" => 6,
                                 "high" => 2,
                               "medium" => 1,
                                  "low" => 0
                        },
                        [8] {
                                 "code" => "ap_southeast_2",
                            "region_id" => 3,
                                "total" => 3,
                                 "pass" => 6,
                                 "high" => 2,
                               "medium" => 1,
                                  "low" => 0
                        }
                    ],
                    "signatures" => [
                        [ 0] {
                            "signature_id" => 88,
                               "unique_id" => "AWS:SSS-006",
                                   "total" => 1
                        },
                        [ 1] {
                            "signature_id" => 89,
                               "unique_id" => "AWS:SSS-008",
                                   "total" => 1
                        },
                        [ 2] {
                            "signature_id" => 87,
                               "unique_id" => "AWS:SSS-007",
                                   "total" => 1
                        },
                        [ 3] {
                            "signature_id" => 14,
                               "unique_id" => "AWS:EC2-001",
                                   "total" => 21
                        },
                        [ 4] {
                            "signature_id" => 70,
                               "unique_id" => "AWS:SSS-001",
                                   "total" => 1
                        },
                        [ 5] {
                            "signature_id" => 72,
                               "unique_id" => "AWS:CLT-001",
                                   "total" => 7
                        },
                        [ 6] {
                            "signature_id" => 69,
                               "unique_id" => "AWS:EC2-031",
                                   "total" => 44
                        },
                        [ 7] {
                            "signature_id" => 18,
                               "unique_id" => "AWS:VPC-009",
                                   "total" => 6
                        },
                        [ 8] {
                            "signature_id" => 68,
                               "unique_id" => "AWS:IAM-008",
                                   "total" => 1
                        },
                        [ 9] {
                            "signature_id" => 82,
                               "unique_id" => "AWS:ELB-007",
                                   "total" => 43
                        },
                        [10] {
                            "signature_id" => 81,
                               "unique_id" => "AWS:SSS-003",
                                   "total" => 1
                        },
                        [11] {
                            "signature_id" => 80,
                               "unique_id" => "AWS:ELB-001",
                                   "total" => 8
                        },
                        [12] {
                            "signature_id" => 11,
                               "unique_id" => "AWS:IAM-007",
                                   "total" => 14
                        },
                        [13] {
                            "signature_id" => 83,
                               "unique_id" => "AWS:ELB-008",
                                   "total" => 4
                        },
                        [14] {
                            "signature_id" => 77,
                               "unique_id" => "AWS:RDS-002",
                                   "total" => 2
                        },
                        [15] {
                            "signature_id" => 67,
                               "unique_id" => "AWS:EC2-032",
                                   "total" => 24
                        },
                        [16] {
                            "signature_id" => 1,
                               "unique_id" => "AWS:EC2-030",
                                   "total" => 3
                        }
                    ],
                      "services" => [
                        [0] {
                               "service" => "RDS",
                                 "total" => 2,
                            "service_id" => 10
                        },
                        [1] {
                               "service" => "ELB",
                                 "total" => 55,
                            "service_id" => 8
                        },
                        [2] {
                               "service" => "IAM",
                                 "total" => 15,
                            "service_id" => 3
                        },
                        [3] {
                               "service" => "VPC",
                                 "total" => 6,
                            "service_id" => 7
                        },
                        [4] {
                               "service" => "CLT",
                                 "total" => 7,
                            "service_id" => 9
                        },
                        [5] {
                               "service" => "EC2",
                                 "total" => 92,
                            "service_id" => 1
                        },
                        [6] {
                               "service" => "SSS",
                                 "total" => 5,
                            "service_id" => 5
                        }
                    ],
                    "severities" => [
                        [0] {
                            "severity" => "high",
                               "total" => 14
                        },
                        [1] {
                            "severity" => "medium",
                               "total" => 96
                        },
                        [2] {
                            "severity" => "low",
                               "total" => 72
                        },
                        [3] {
                            "severity" => "pass",
                               "total" => 174
                        }
                    ]
                }
            }
        ]
    }


## Services end point
#### *Note this end point is a read only end point, and requires the user to have manager role access
#### This end point can be used to for retrieving a service id to apply to a custom signature. Example your custom signature targets EC2 services.
### List action
    # list is a pageable response of 25 total signatures per page
    api.services.list => 
    [
        [ 4] {
                        "id" => 5,
                      "name" => "EC2",
                      "code" => "EC2",
                "created_at" => "2014-07-15T16:45:43.457Z",
                "updated_at" => "2014-07-15T16:45:43.457Z"
            }
    ]

### Show action
    # Show a specific signature
    # Required :id
    
    api.show(id: 5) =>
    {
                "id" => 5,
              "name" => "EC2",
              "code" => "EC2",
        "created_at" => "2014-07-15T16:45:43.457Z",
        "updated_at" => "2014-07-15T16:45:43.457Z"
    }



## Custom Signatures end point
### List action
    # List is a pageable response of 25 total signatures per page
    api.custom_signatures.list => 
    [
        [ 0] {
                         "id" => 4,
            "organization_id" => 1,
                  "signature" => "// Demo Signature\r\ndsl.configure(function(c) {\r\n  c.module        = 'check_user_count_javascript';  // Required\r\n  c.identifier    = 'AWS:GLO-001';                  // Required unique identifier for this signature\r\n  c.description   = 'Check IAM user count';         // Required short description\r\n  c.valid_regions = ['us_east_1'];                  // Only run in us_east_1\r\n  c.display_as    = 'global';                       // Display as region global instead of region us_east_1\r\n});\r\n\r\n// Required perform function\r\nfunction perform(aws) {\r\n    try {\r\n        var count = aws.iam.list_users().users.length || 0;\r\n        if (count === 0) {\r\n            return dsl.fail({\r\n            user_count: count,\r\n            condition: 'count == 0' });\r\n        } else {\r\n            return dsl.pass({\r\n                    user_count: count,\r\n                    condition: 'count >= 1' });\r\n        }\r\n    }\r\n    catch(err) {\r\n        return dsl.error({error: err.message});\r\n    }\r\n}\r\n",
                "description" => "test",
                 "resolution" => "test",
                       "name" => "Testing",
                     "active" => true,
                 "created_at" => "2014-07-21T20:09:24.809Z",
                 "updated_at" => "2014-08-04T14:15:28.326Z",
                 "risk_level" => "High",
                 "identifier" => nil,
                 "service_id" => nil,
                 "deleted_at" => nil
        }
    }
    
    # Current page
    api.custom_signatures.current_page
    
    # Next page sets current page with the next page results.
    api.custom_signatures.next_page
    
    # Prev page sets current page with the previous page results.
    api.custom_signatures.prev_page
    
### Show action
    # Show a specific custom signature
    # Required :id
    
    api.custom_signatures.show(id: 4) =>
    {
                     "id" => 4,
        "organization_id" => 1,
              "signature" => "// Demo Signature\r\ndsl.configure(function(c) {\r\n  c.module        = 'check_user_count_javascript';  // Required\r\n  c.identifier    = 'AWS:GLO-001';                  // Required unique identifier for this signature\r\n  c.description   = 'Check IAM user count';         // Required short description\r\n  c.valid_regions = ['us_east_1'];                  // Only run in us_east_1\r\n  c.display_as    = 'global';                       // Display as region global instead of region us_east_1\r\n});\r\n\r\n// Required perform function\r\nfunction perform(aws) {\r\n    try {\r\n        var count = aws.iam.list_users().users.length || 0;\r\n        if (count === 0) {\r\n            return dsl.fail({\r\n            user_count: count,\r\n            condition: 'count == 0' });\r\n        } else {\r\n            return dsl.pass({\r\n                    user_count: count,\r\n                    condition: 'count >= 1' });\r\n        }\r\n    }\r\n    catch(err) {\r\n        return dsl.error({error: err.message});\r\n    }\r\n}\r\n",
            "description" => "test",
             "resolution" => "test",
                   "name" => "Testing",
                 "active" => true,
             "created_at" => "2014-07-21T20:09:24.809Z",
             "updated_at" => "2014-08-04T14:15:28.326Z",
             "risk_level" => "High",
             "identifier" => nil,
             "service_id" => 11,
             "deleted_at" => nil
    }

### Update action
    # Update a custom signature
    # Required :id
    # Valid :description, :resolution, :name, :active, :signature, :risk_level
    api.custom_signatures.update(id: 4, active: false, name: 'Updated Name') =>
    {
                     "id" => 4,
        "organization_id" => 1,
              "signature" => "// Demo Signature\r\ndsl.configure(function(c) {\r\n  c.module            = 'check_user_count_javascript';  // Required\r\n  c.identifier        = 'AWS:GLO-001';                  // Required unique identifier for this signature\r\n  c.description       = 'Check IAM user count';         // Required short description\r\n  c.valid_regions     = ['us_east_1'];                  // Only run in us_east_1\r\n  c.display_as        = 'global';                       // Display as region global instead of region us_east_1\r\n  c.deep_inspection   = ['users'];\r\n  c.unique_identifier = [{'user_name': 'user_id'}];\r\n});\r\n\r\n// Required perform function\r\nfunction perform(aws) {\r\n    try {\r\n        var count = aws.iam.list_users().users.length || 0;\r\n        \r\n        // Setup the deep inspection and unique identifier data\r\n        dsl.set_data(aws.iam.list_users());\r\n        if (count === 0) {\r\n            return dsl.fail({\r\n                user_count: count,\r\n                condition: 'count == 0' });\r\n        } else {\r\n            return dsl.pass({\r\n                    user_count: count,\r\n                    condition: 'count >= 1' });\r\n        }\r\n    }\r\n    catch(err) {\r\n        return dsl.error({error: err.message});\r\n    }\r\n}",
            "description" => "test",
             "resolution" => "test",
                   "name" => "Updated Name",
                 "active" => false,
             "created_at" => "2014-07-21T20:09:24.809Z",
             "updated_at" => "2014-09-24T20:48:21.822Z",
             "risk_level" => "High",
             "identifier" => nil,
             "service_id" => 11,
             "deleted_at" => nil
    }

### Create Action
    # Create a new custom signature
    # Required :signature, :name, :risk_level
    signature = "// Demo Signature\r\ndsl.configure(function(c) {\r\n  c.module            = 'check_user_count_javascript';  // Required\r\n  c.identifier        = 'AWS:GLO-001';                  // Required unique identifier for this signature\r\n  c.description       = 'Check IAM user count';         // Required short description\r\n  c.valid_regions     = ['us_east_1'];                  // Only run in us_east_1\r\n  c.display_as        = 'global';                       // Display as region global instead of region us_east_1\r\n  c.deep_inspection   = ['users'];\r\n  c.unique_identifier = [{'user_name': 'user_id'}];\r\n});\r\n\r\n// Required perform function\r\nfunction perform(aws) {\r\n    try {\r\n        var count = aws.iam.list_users().users.length || 0;\r\n        \r\n        // Setup the deep inspection and unique identifier data\r\n        dsl.set_data(aws.iam.list_users());\r\n        if (count === 0) {\r\n            return dsl.fail({\r\n                user_count: count,\r\n                condition: 'count == 0' });\r\n        } else {\r\n            return dsl.pass({\r\n                    user_count: count,\r\n                    condition: 'count >= 1' });\r\n        }\r\n    }\r\n    catch(err) {\r\n        return dsl.error({error: err.message});\r\n    }\r\n}"
    api.custom_signatures.create(signature: signature, name: 'Demo Signature', risk_level: 'High') =>
    {
                     "id" => 97,
        "organization_id" => 1,
              "signature" => "// Demo Signature\r\ndsl.configure(function(c) {\r\n  c.module            = 'check_user_count_javascript';  // Required\r\n  c.identifier        = 'AWS:GLO-001';                  // Required unique identifier for this signature\r\n  c.description       = 'Check IAM user count';         // Required short description\r\n  c.valid_regions     = ['us_east_1'];                  // Only run in us_east_1\r\n  c.display_as        = 'global';                       // Display as region global instead of region us_east_1\r\n  c.deep_inspection   = ['users'];\r\n  c.unique_identifier = [{'user_name': 'user_id'}];\r\n});\r\n\r\n// Required perform function\r\nfunction perform(aws) {\r\n    try {\r\n        var count = aws.iam.list_users().users.length || 0;\r\n        \r\n        // Setup the deep inspection and unique identifier data\r\n        dsl.set_data(aws.iam.list_users());\r\n        if (count === 0) {\r\n            return dsl.fail({\r\n                user_count: count,\r\n                condition: 'count == 0' });\r\n        } else {\r\n            return dsl.pass({\r\n                    user_count: count,\r\n                    condition: 'count >= 1' });\r\n        }\r\n    }\r\n    catch(err) {\r\n        return dsl.error({error: err.message});\r\n    }\r\n}",
            "description" => nil,
             "resolution" => nil,
                   "name" => "Demo Signature",
                 "active" => nil,
             "created_at" => "2014-09-24T20:51:08.901Z",
             "updated_at" => "2014-09-24T20:51:08.901Z",
             "risk_level" => "High",
             "identifier" => nil,
             "service_id" => 11,
             "deleted_at" => nil
    }

### Destroy Action
    # Destroy a custom signature
    # Required :id
    api.custom_signatures.destroy(id: 97) =>
    {
        "success" => "Demo Signature has been destroyed"
    }
    
### Run action
    # Run a custom signature
    # Required :id => ID of the custom signature to run
    # Required :external_account_id => ID of the external account to use
    # Required :regions => Array of regions to run the signature in
    
    api.custom_signatures.run(id: 1, external_account_id: 1, regions: [:us_east_1]) =>
    {
        "alerts" => [
            [0] {
                             "info" => {
                         "user_count" => 1,
                          "condition" => "count >= 1",
                    "deep_inspection" => [
                        [0] {
                            "users" => [
                                [ 0] {
                                           "path" => "/",
                                      "user_name" => "demouser",
                                        "user_id" => "AIDAHJFKDHGFHFGKHKGFH",
                                            "arn" => "arn:aws:iam::00000000:user/demouser",
                                    "create_date" => "2014-01-16T19:05:36.000Z"
                                }
                            ]
                        }
                    ]
                },
                           "status" => "pass",
                           "config" => {
                                "module" => "check_user_count_javascript",
                           "description" => "Check IAM user count",
                         "valid_regions" => [
                        [0] "us_east_1"
                    ],
                            "identifier" => "AWS:GLO-001",
                       "deep_inspection" => [
                        [0] "users"
                    ],
                     "unique_identifier" => [
                        [0] {
                            "user_name" => "user_id"
                        }
                    ],
                            "display_as" => "global",
                    "validation_context" => nil,
                                "errors" => {}
                },
                           "region" => "us_east_1",
                "unique_identifier" => {
                          "demouser"  => "AIDAHJFKDHGFHFGKHKGFH",
                }
            }
        ]
    }

### Run Raw action
    # Run a raw custom signature 
    # Required: :signature => JavaScript signature to run as a string
    # Required :external_account_id => ID of the external account to use
    # Required :regions => Array of regions to run the signature in
    api.custom_signatures.run_raw(signature: "Javascript", regions: [:us_east_1], external_account_id: 1) =>
    {
        "alerts" => [
            [0] {
                             "info" => {
                         "user_count" => 1,
                          "condition" => "count >= 1",
                    "deep_inspection" => [
                        [0] {
                            "users" => [
                                [ 0] {
                                           "path" => "/",
                                      "user_name" => "demouser",
                                        "user_id" => "AIDAHJFKDHGFHFGKHKGFH",
                                            "arn" => "arn:aws:iam::00000000:user/demouser",
                                    "create_date" => "2014-01-16T19:05:36.000Z"
                                }
                            ]
                        }
                    ]
                },
                           "status" => "pass",
                           "config" => {
                                "module" => "check_user_count_javascript",
                           "description" => "Check IAM user count",
                         "valid_regions" => [
                        [0] "us_east_1"
                    ],
                            "identifier" => "AWS:GLO-001",
                       "deep_inspection" => [
                        [0] "users"
                    ],
                     "unique_identifier" => [
                        [0] {
                            "user_name" => "user_id"
                        }
                    ],
                            "display_as" => "global",
                    "validation_context" => nil,
                                "errors" => {}
                },
                           "region" => "us_east_1",
                "unique_identifier" => {
                          "demouser"  => "AIDAHJFKDHGFHFGKHKGFH",
                }
            }
        ]
    }

    
## Signatures end point
### List action
    # List is a pageable response of 25 total signatures per page.
    api.signatures.list => 
    [
        [ 0] {
                     "id" => 35,
                   "name" => "Global Telnet",
            "description" => "Globally Accessible Administrative Port -- Telnet (tcp/23)",
               "provider" => "AWS",
                  "scope" => "Service",
             "resolution" => "This alert triggers when global permission to access tcp port 23 (telnet) is detected in a security group. This is dangerous, as it permits the entire internet access to connect to tcp port 23 -- usually where a telnet daemon is listening. Reducing the permitted IP Addresses or ranges allowed to communicate to destination hosts on tcp port 23 is advised. We recommend utilizing the static office or home IP addresses of your employees as the permitted hosts, or deploying a bastion host with 2-factor authentication if this is infeasible. This bastion host is then the only permitted IP to communicate with any other nodes inside your account. If you must permit global access to tcp port 23 (telnet), then you may disable this alert to silence it.",
             "risk_level" => "High",
             "identifier" => "AWS:EC2-003",
             "created_at" => "2014-06-23T18:53:25.988Z",
             "updated_at" => "2014-07-21T16:36:29.427Z",
             "service_id" => 5,
                "service" => {
                "name" => "EC2"
            }
        },
    ]
    
    # Current page
    api.signatures.current_page
    
    # Next page sets current page with the next page results.
    api.signatures.next_page
    
    # Prev page sets current page with the previous page results.
    api.signatures.prev_page

### Show action
    # Show a specific signature
    # Required :id
    api.signatures.show(id: 35) => 
    {
                 "id" => 35,
               "name" => "Global Telnet",
        "description" => "Globally Accessible Administrative Port -- Telnet (tcp/23)",
           "provider" => "AWS",
              "scope" => "Service",
         "resolution" => "This alert triggers when global permission to access tcp port 23 (telnet) is detected in a security group. This is dangerous, as it permits the entire internet access to connect to tcp port 23 -- usually where a telnet daemon is listening. Reducing the permitted IP Addresses or ranges allowed to communicate to destination hosts on tcp port 23 is advised. We recommend utilizing the static office or home IP addresses of your employees as the permitted hosts, or deploying a bastion host with 2-factor authentication if this is infeasible. This bastion host is then the only permitted IP to communicate with any other nodes inside your account. If you must permit global access to tcp port 23 (telnet), then you may disable this alert to silence it.",
         "risk_level" => "High",
         "identifier" => "AWS:EC2-003",
         "created_at" => "2014-06-23T18:53:25.988Z",
         "updated_at" => "2014-07-21T16:36:29.427Z",
         "service_id" => 5,
            "service" => {
            "name" => "EC2"
        }
    }

### Names action

    # List the names of signatures that can be run through the api
    api.signatures.names =>
    {
        "names" => [
            [ 0] "validate_cloud_formation_template",
            [ 1] "cloud_trails_enabled",
            [ 2] "frequent_snapshots",
            [ 3] "security_group_check",
            [ 4] "detect_unattached_ebs_volumes",
            [ 5] "unused_security_groups",
            [ 6] "ebs_encryption_enabled",
            [ 7] "security_group_instance_map",
            [ 8] "strong_ssl_ciphers",
            [ 9] "heartbleed",
            [10] "unused_security_groups_elb",
            [11] "check_user_count",
            [12] "api_keys_on_root",
            [13] "one_user_with_api_keys",
            [14] "user_console_access_strong_password",
            [15] "mfa_on_root",
            [16] "mfa_on_devices",
            [17] "check_assigned_role",
            [18] "third_party_account",
            [19] "key_expiry_check",
            [20] "count_privileged_users",
            [21] "check_privileged_spofs",
            [22] "restrict_s3_delete",
            [23] "evident_role_permissions",
            [24] "route53_in_use",
            [25] "rds_backup_policy_too_short",
            [26] "latest_restorable_time",
            [27] "sss_object_versioning_enabled",
            [28] "cloud_trails_bucket_iam_delete",
            [29] "sss_global_edit_bucket_permissions",
            [30] "sss_global_upload_bucket_permissions",
            [31] "sss_global_list_bucket_permissions",
            [32] "sss_global_view_bucket_permissions",
            [33] "sss_global_any_bucket_permissions",
            [34] "vpc_nacls",
            [35] "nacls_on_subnets",
            [36] "non_default_vpc_nacl"
        ]
    }

### Run action
    
    # Run an Evident Signature
    Required :signature_name => name of signature to run
    Required :external_account_id => ID of the external account with the ARN/External ID to use
    Required :regions => Array of regions to run the signature in
    # Requires manager role access
    
    api.signatures.run(signature_name: 'validate_cloud_formation_template', regions: [:us_east_1], external_account_id: 1)
    {
        "alerts" => [
            [0] {
                             "info" => {
                            "message" => "No CloudFormation template contains globally permissive traffic",
                    "deep_inspection" => nil
                },
                           "status" => "pass",
                           "config" => {
                                "module" => "validate_cloud_formation_template",
                           "description" => "Validate security parameters in CloudFormation templates",
                         "valid_regions" => [
                        [0] "us_east_1"
                    ],
                            "identifier" => "AWS:CFM-001",
                                 "usage" => "metascrape.signatures.validate_cloud_formation_template.perform metascrape.customers.evident.aws.us_east_1",
                                  "tags" => [
                        [0] "cfm",
                        [1] "signature"
                    ],
                                 "tests" => [
                        [0] "test_validate_cloud_formation_template"
                    ],
                    "validation_context" => nil,
                                "errors" => {}
                },
                           "region" => "us_east_1",
                "unique_identifier" => nil
            }
        ]
    }

## Organizations end point

### List Action
    # List your organizations information
    api.organizations.list =>
    [
        [0] {
                                              "id" => 1,
                                            "name" => "Evident",
                                      "created_at" => "2014-06-23T18:53:25.500Z",
                                      "updated_at" => "2014-07-15T18:40:30.451Z",
                 "external_account_setup_complete" => true,
            "encrypted_stripe_customer_identifier" => nil,
                                      "enterprise" => true,
                  "enterprise_contract_expires_on" => "2034-06-23",
                                         "plan_id" => 7,
                  "stripe_last_payment_successful" => true,
                      "stripe_subscription_active" => true,
                                      "deleted_at" => nil,
                           "free_trial_expires_at" => nil,
                             "plan_setup_complete" => true,
                                      "enable_sso" => false,
                                      "sso_idp_id" => "19f780c8-46eb-4ad1-ba6a-2c954aff49f1"
        }
    ]

### Show action
    # Show your organizations information. Same as List just returns the object instead of an array with the object.
    # Required :id
    api.organizations.show(id: 1) =>
    {
                                          "id" => 1,
                                        "name" => "Evident",
                                  "created_at" => "2014-06-23T18:53:25.500Z",
                                  "updated_at" => "2014-07-15T18:40:30.451Z",
             "external_account_setup_complete" => true,
        "encrypted_stripe_customer_identifier" => nil,
                                  "enterprise" => true,
              "enterprise_contract_expires_on" => "2034-06-23",
                                     "plan_id" => 7,
              "stripe_last_payment_successful" => true,
                  "stripe_subscription_active" => true,
                                  "deleted_at" => nil,
                       "free_trial_expires_at" => nil,
                         "plan_setup_complete" => true,
                                  "enable_sso" => false,
                                  "sso_idp_id" => "19f780c8-46eb-4ad1-ba6a-2c954aff49f1"
    }

    
### Update action
    # Update your organizations information
    # Required :id
    # Valid Params :name
    api.organizations.update(id: 1, name: 'Updated Name') =>
    {
                                          "id" => 1,
                                        "name" => "Updated Name",
                                  "created_at" => "2014-06-23T18:53:25.500Z",
                                  "updated_at" => "2014-09-19T15:36:40.521Z",
             "external_account_setup_complete" => true,
        "encrypted_stripe_customer_identifier" => nil,
                                  "enterprise" => true,
              "enterprise_contract_expires_on" => "2034-06-23",
                                     "plan_id" => 7,
              "stripe_last_payment_successful" => true,
                  "stripe_subscription_active" => true,
                                  "deleted_at" => nil,
                       "free_trial_expires_at" => nil,
                         "plan_setup_complete" => true,
                                  "enable_sso" => false,
                                  "sso_idp_id" => "19f780c8-46eb-4ad1-ba6a-2c954aff49f1"
    }

## Sub Organizations end point
### List action
    # List is a pageable response of 25 total signatures per page.
    api.sub_organizations.list =>
    [
        [0] {
                         "id" => 1,
            "organization_id" => 1,
                       "name" => "Evident",
                 "created_at" => "2014-06-23T18:53:25.531Z",
                 "updated_at" => "2014-09-03T12:32:50.472Z"
        }
    ]
    
    # Current page
    api.sub_organizations.current_page
    
    # Next page sets current page with the next page results.
    api.sub_organizations.next_page
    
    # Prev page sets current page with the previous page results.
    api.sub_organizations.prev_page

### Show action
    # Show a specific sub organization
    # Required :id
    api.sub_organizations.show(id: 1) =>
    {
                     "id" => 1,
        "organization_id" => 1,
                   "name" => "Evident",
             "created_at" => "2014-06-23T18:53:25.531Z",
             "updated_at" => "2014-09-03T12:32:50.472Z"
    }


### Update action
    # Update a specific sub organization
    # Required :id
    # Valid param :name
    api.sub_organizations.update(id: 1, name: 'Test') =>
    {
                     "id" => 1,
        "organization_id" => 1,
                   "name" => "Test",
             "created_at" => "2014-06-23T18:53:25.531Z",
             "updated_at" => "2014-09-24T18:37:02.252Z"
    }

### Create action
    # Create a new sub organization
    # Required :name
    api.sub_organizations.create(name: 'Test') =>
    {
                     "id" => 3,
        "organization_id" => 1,
                   "name" => "Test",
             "created_at" => "2014-09-24T18:39:25.493Z",
             "updated_at" => "2014-09-24T18:39:25.493Z"
    }

### Destroy Action
#### * Note this action will also destroy every team within the sub organization and any external accounts attached.
    # Destroy a sub organization
    # Required :id
    api.sub_organizations.destroy(id: 3) =>
    {
        "success" => "Test has been destroyed"
    }

    
## Teams end point
### List action
    # List is a pageable response of 25 total signatures per page.
    api.teams.list =>
    [
        [ 0] {
                             "id" => 1,
            "sub_organization_id" => 1,
                           "name" => "Evident",
                     "created_at" => "2014-06-23T18:53:25.552Z",
                     "updated_at" => "2014-06-23T18:53:25.552Z",
                "organization_id" => 1,
                     "deleted_at" => nil
        },
    ]
    
    # Current page
    api.teams.current_page
    
    # Next page sets current page with the next page results.
    api.teams.next_page
    
    # Prev page sets current page with the previous page results.
    api.teams.prev_page

### Show action
    # Show a specific team
    # Required :id
    api.teams.show(id: 1) =>
    {
                         "id" => 1,
        "sub_organization_id" => 1,
                       "name" => "Evident",
                 "created_at" => "2014-06-23T18:53:25.552Z",
                 "updated_at" => "2014-06-23T18:53:25.552Z",
            "organization_id" => 1,
                 "deleted_at" => nil
    }

### Create action
    # Create a new team
    # Required :sub_organization_id => id of the sub organization to add this team to. Must have access to the sub organization as well.
    # Required :name
    api.teams.create(name: 'testing', sub_organization_id: 1) =>
    {
                         "id" => 52,
        "sub_organization_id" => 1,
                       "name" => "testing",
                 "created_at" => "2014-09-24T18:51:28.517Z",
                 "updated_at" => "2014-09-24T18:51:28.517Z",
            "organization_id" => 1,
                 "deleted_at" => nil
    }

### Update action
    # Update a team
    # Required :id
    # Valid :sub_organization_id, :name
    api.teams.update(id: 52, name: 'New Name') =>
    {
                         "id" => 52,
        "sub_organization_id" => 1,
                       "name" => "New Name",
                 "created_at" => "2014-09-24T18:51:28.517Z",
                 "updated_at" => "2014-09-24T18:53:20.313Z",
            "organization_id" => 1,
                 "deleted_at" => nil
    }

### Destroy Action
#### * Note this will destroy any external accounts attached.
    # Destroy a team
    # Required :id
    api.teams.destroy(id: 52) =>
    {
        "success" => "New Name has been destroyed"
    }

    
## Contributing

1. Fork it ( https://github.com/[my-github-username]/esp_sdk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
