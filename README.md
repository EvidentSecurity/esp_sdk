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
TODO: Change this to require an external account id before release instead of an ARN/External ID. As of right now this will allow them to run any ARN/External ID
    
    # Run an Evident Signature
    Required :signature_name => name of signature to run
    Required :arn => Arn to use
    Required :external_id => External ID
    Required :regions => Array of regions to run the signature in
    Required :name => Name of current run
    
    api.signatures.run(signature_name: 'validate_cloud_formation_template', arn: 'ARN', external_id: 'EXTERNAL ID', regions: [:us_east_1], name: 'test' ) =>
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
                                      "sso_idp_id" => "ee3894d2-b65a-46db-ba7a-0925754fe67b"
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
                                  "sso_idp_id" => "ee3894d2-b65a-46db-ba7a-0925754fe67b"
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
                                  "sso_idp_id" => "ee3894d2-b65a-46db-ba7a-0925754fe67b"
    }

## Contributing

1. Fork it ( https://github.com/[my-github-username]/esp_sdk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
