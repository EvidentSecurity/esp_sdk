FactoryGirl.define do
  factory :stat, class: 'ESP::Stat' do
    skip_create

    sequence(:id) { |n| n }
    type "stats"
    total 47
    total_suppressed 38
    total_new_1h_fail 5
    total_new_1d_fail 4
    total_new_1w_fail 5
    total_old_fail 5
    total_new_1h_warn 5
    total_new_1d_warn 4
    total_new_1w_warn 4
    total_old_warn 1
    total_new_1h_error 7
    total_new_1d_error 7
    total_new_1w_error 7
    total_old_error 4
    total_new_1h_pass 11
    total_new_1d_pass 4
    total_new_1w_pass 3
    total_old_pass 8
    total_new_1h_info 2
    total_new_1d_info 8
    total_new_1w_info 6
    total_old_info 4
    total_new_1h 30
    total_new_1d 27
    total_new_1w 25
    total_old 22
    total_suppressed_fail 4
    total_suppressed_warn 9
    total_suppressed_error 10
    total_suppressed_pass 8
    total_suppressed_info 7
    new_1h_high_pass 3
    new_1d_high_pass 4
    new_1w_high_pass 2
    old_high_pass 2
    new_1h_high_fail 3
    new_1d_high_fail 0
    new_1w_high_fail 0
    old_high_fail 1
    new_1h_high_warn 3
    new_1d_high_warn 0
    new_1w_high_warn 1
    old_high_warn 0
    new_1h_high_error 4
    new_1d_high_error 4
    new_1w_high_error 4
    old_high_error 2
    new_1h_medium_pass 4
    new_1d_medium_pass 0
    new_1w_medium_pass 1
    old_medium_pass 2
    new_1h_medium_fail 2
    new_1d_medium_fail 0
    new_1w_medium_fail 3
    old_medium_fail 2
    new_1h_medium_warn 0
    new_1d_medium_warn 2
    new_1w_medium_warn 1
    old_medium_warn 1
    new_1h_medium_error 2
    new_1d_medium_error 2
    new_1w_medium_error 3
    old_medium_error 1
    new_1h_low_pass 4
    new_1d_low_pass 0
    new_1w_low_pass 0
    old_low_pass 4
    new_1h_low_fail 0
    new_1d_low_fail 4
    new_1w_low_fail 2
    old_low_fail 2
    new_1h_low_warn 2
    new_1d_low_warn 2
    new_1w_low_warn 2
    old_low_warn 0
    new_1h_low_error 1
    new_1d_low_error 1
    new_1w_low_error 0
    old_low_error 1
    suppressed_high_pass 3
    suppressed_high_fail 1
    suppressed_high_warn 4
    suppressed_high_error 3
    suppressed_medium_pass 2
    suppressed_medium_fail 0
    suppressed_medium_warn 3
    suppressed_medium_error 4
    suppressed_low_pass 3
    suppressed_low_fail 3
    suppressed_low_warn 2
    suppressed_low_error 3
    new_1h_high_info 0
    new_1d_high_info 4
    new_1w_high_info 2
    old_high_info 1
    new_1h_medium_info 1
    new_1d_medium_info 2
    new_1w_medium_info 1
    old_medium_info 3
    new_1h_low_info 1
    new_1d_low_info 2
    new_1w_low_info 3
    old_low_info 0
    suppressed_high_info 4
    suppressed_medium_info 1
    suppressed_low_info 2
    relationships do
      { report: {
        data: {
          id: "3",
          type: "reports"
        },
        links: {
          related: "http://test.host/api/v2/reports/3.json"
        }
      },
        regions: {
          data: [
            {
              id: "3",
              type: "stat_regions"
            }
          ]
        },
        signatures: {
          data: [
            {
              id: "3",
              type: "stat_signatures"
            }
          ]
        },
        custom_signatures: {
          data: [
            {
              id: "3",
              type: "stat_custom_signatures"
            }
          ]
        }
      }
    end
    included do
      [
        {
          id: "3",
          type: "reports",
          attributes: {
            created_at: "2015-09-28T14:59:43.432Z",
            status: "complete",
            updated_at: "2015-09-28T14:59:43.432Z"
          },
          relationships: {
            organization: {
              data: {
                id: "7",
                type: "organizations"
              },
              links: {
                related: "http://test.host/api/v2/organizations/7.json"
              }
            },
            sub_organization: {
              data: {
                id: "5",
                type: "sub_organizations"
              },
              links: {
                related: "http://test.host/api/v2/sub_organizations/5.json"
              }
            },
            team: {
              data: {
                id: "5",
                type: "teams"
              },
              links: {
                related: "http://test.host/api/v2/teams/5.json"
              }
            },
            alerts: {
              links: {
                related: "http://test.host/api/v2/reports/3/alerts.json"
              }
            }
          }
        },
        {
          id: "3",
          type: "stat_regions",
          attributes: {
            total: 65,
            total_suppressed: 34,
            total_new_1h_fail: 10,
            total_new_1d_fail: 10,
            total_new_1w_fail: 9,
            total_old_fail: 8,
            total_new_1h_warn: 4,
            total_new_1d_warn: 4,
            total_new_1w_warn: 8,
            total_old_warn: 7,
            total_new_1h_error: 5,
            total_new_1d_error: 3,
            total_new_1w_error: 10,
            total_old_error: 4,
            total_new_1h_pass: 11,
            total_new_1d_pass: 5,
            total_new_1w_pass: 7,
            total_old_pass: 7,
            total_new_1h_info: 1,
            total_new_1d_info: 8,
            total_new_1w_info: 2,
            total_old_info: 3,
            total_new_1h: 31,
            total_new_1d: 30,
            total_new_1w: 36,
            total_old: 29,
            total_suppressed_fail: 8,
            total_suppressed_warn: 6,
            total_suppressed_error: 11,
            total_suppressed_pass: 6,
            total_suppressed_info: 3,
            new_1h_high_pass: 3,
            new_1d_high_pass: 0,
            new_1w_high_pass: 4,
            old_high_pass: 1,
            new_1h_high_fail: 3,
            new_1d_high_fail: 3,
            new_1w_high_fail: 2,
            old_high_fail: 4,
            new_1h_high_warn: 1,
            new_1d_high_warn: 0,
            new_1w_high_warn: 3,
            old_high_warn: 4,
            new_1h_high_error: 1,
            new_1d_high_error: 0,
            new_1w_high_error: 4,
            old_high_error: 0,
            new_1h_medium_pass: 4,
            new_1d_medium_pass: 3,
            new_1w_medium_pass: 0,
            old_medium_pass: 2,
            new_1h_medium_fail: 4,
            new_1d_medium_fail: 3,
            new_1w_medium_fail: 3,
            old_medium_fail: 3,
            new_1h_medium_warn: 3,
            new_1d_medium_warn: 1,
            new_1w_medium_warn: 4,
            old_medium_warn: 3,
            new_1h_medium_error: 0,
            new_1d_medium_error: 2,
            new_1w_medium_error: 3,
            old_medium_error: 4,
            new_1h_low_pass: 4,
            new_1d_low_pass: 2,
            new_1w_low_pass: 3,
            old_low_pass: 4,
            new_1h_low_fail: 3,
            new_1d_low_fail: 4,
            new_1w_low_fail: 4,
            old_low_fail: 1,
            new_1h_low_warn: 0,
            new_1d_low_warn: 3,
            new_1w_low_warn: 1,
            old_low_warn: 0,
            new_1h_low_error: 4,
            new_1d_low_error: 1,
            new_1w_low_error: 3,
            old_low_error: 0,
            suppressed_high_pass: 2,
            suppressed_high_fail: 2,
            suppressed_high_warn: 2,
            suppressed_high_error: 3,
            suppressed_medium_pass: 4,
            suppressed_medium_fail: 2,
            suppressed_medium_warn: 4,
            suppressed_medium_error: 4,
            suppressed_low_pass: 0,
            suppressed_low_fail: 4,
            suppressed_low_warn: 0,
            suppressed_low_error: 4,
            new_1h_high_info: 1,
            new_1d_high_info: 4,
            new_1w_high_info: 0,
            old_high_info: 0,
            new_1h_medium_info: 0,
            new_1d_medium_info: 2,
            new_1w_medium_info: 1,
            old_medium_info: 2,
            new_1h_low_info: 0,
            new_1d_low_info: 2,
            new_1w_low_info: 1,
            old_low_info: 1,
            suppressed_high_info: 0,
            suppressed_medium_info: 2,
            suppressed_low_info: 1,
            region: {
              id: "3",
              type: "regions",
              attributes: {
                code: "us_east_test_3"
              }
            }
          }
        },
        {
          id: "3",
          type: "stat_signatures",
          attributes: {
            total: 26,
            total_suppressed: 10,
            total_new_1h_fail: 4,
            total_new_1d_fail: 0,
            total_new_1w_fail: 3,
            total_old_fail: 2,
            total_new_1h_warn: 3,
            total_new_1d_warn: 3,
            total_new_1w_warn: 4,
            total_old_warn: 4,
            total_new_1h_error: 4,
            total_new_1d_error: 0,
            total_new_1w_error: 4,
            total_old_error: 3,
            total_new_1h_pass: 0,
            total_new_1d_pass: 4,
            total_new_1w_pass: 1,
            total_old_pass: 2,
            total_new_1h_info: 0,
            total_new_1d_info: 0,
            total_new_1w_info: 3,
            total_old_info: 0,
            total_new_1h: 11,
            total_new_1d: 7,
            total_new_1w: 15,
            total_old: 11,
            total_suppressed_fail: 4,
            total_suppressed_warn: 1,
            total_suppressed_error: 1,
            total_suppressed_pass: 3,
            total_suppressed_info: 1,
            new_1h_pass: 0,
            new_1d_pass: 4,
            new_1w_pass: 1,
            old_pass: 2,
            new_1h_fail: 4,
            new_1d_fail: 0,
            new_1w_fail: 3,
            old_fail: 2,
            new_1h_warn: 3,
            new_1d_warn: 3,
            new_1w_warn: 4,
            old_warn: 4,
            new_1h_error: 4,
            new_1d_error: 0,
            new_1w_error: 4,
            old_error: 3,
            suppressed_pass: 3,
            suppressed_fail: 4,
            suppressed_warn: 1,
            suppressed_error: 1,
            new_1h_info: 0,
            new_1d_info: 0,
            new_1w_info: 3,
            old_info: 0,
            suppressed_info: 1,
            signature: {
              id: "3",
              type: "signatures",
              attributes: {
                created_at: "2015-09-28T14:59:43.432Z",
                description: "Some description for some test",
                identifier: "3 Unique ID",
                name: "3_test_signature",
                resolution: "Turn on some setting",
                risk_level: "High",
                updated_at: "2015-09-28T14:59:43.432Z"
              },
              relationships: {
                service: {
                  data: {
                    id: "9",
                    type: "services"
                  },
                  links: {
                    related: "http://test.host/api/v2/services/9.json"
                  }
                }
              }
            }
          }
        },
        {
          id: "3",
          type: "stat_custom_signatures",
          attributes: {
            total: 20,
            total_suppressed: 9,
            total_new_1h_fail: 0,
            total_new_1d_fail: 4,
            total_new_1w_fail: 0,
            total_old_fail: 2,
            total_new_1h_warn: 0,
            total_new_1d_warn: 1,
            total_new_1w_warn: 2,
            total_old_warn: 0,
            total_new_1h_error: 1,
            total_new_1d_error: 0,
            total_new_1w_error: 4,
            total_old_error: 3,
            total_new_1h_pass: 3,
            total_new_1d_pass: 1,
            total_new_1w_pass: 1,
            total_old_pass: 2,
            total_new_1h_info: 3,
            total_new_1d_info: 3,
            total_new_1w_info: 4,
            total_old_info: 2,
            total_new_1h: 7,
            total_new_1d: 9,
            total_new_1w: 11,
            total_old: 9,
            total_suppressed_fail: 1,
            total_suppressed_warn: 1,
            total_suppressed_error: 3,
            total_suppressed_pass: 2,
            total_suppressed_info: 2,
            new_1h_pass: 3,
            new_1d_pass: 1,
            new_1w_pass: 1,
            old_pass: 2,
            new_1h_fail: 0,
            new_1d_fail: 4,
            new_1w_fail: 0,
            old_fail: 2,
            new_1h_warn: 0,
            new_1d_warn: 1,
            new_1w_warn: 2,
            old_warn: 0,
            new_1h_error: 1,
            new_1d_error: 0,
            new_1w_error: 4,
            old_error: 3,
            suppressed_pass: 2,
            suppressed_fail: 1,
            suppressed_warn: 1,
            suppressed_error: 3,
            new_1h_info: 3,
            new_1d_info: 3,
            new_1w_info: 4,
            old_info: 2,
            suppressed_info: 2,
            custom_signature: {
              id: "3",
              type: "custom_signatures",
              attributes: {
                active: true,
                created_at: "2015-09-28T14:59:43.432Z",
                description: "Test description",
                identifier: "AWS::Test::001",
                name: "Test",
                resolution: "Test resolution",
                risk_level: "Medium",
                signature: "Some javascript",
                language: "javascript",
                updated_at: "2015-09-28T14:59:43.432Z"
              },
              relationships: {
                organization: {
                  data: {
                    id: "8",
                    type: "organizations"
                  },
                  links: {
                    related: "http://test.host/api/v2/organizations/8.json"
                  }
                },
                service: {
                  data: {
                    id: "11",
                    type: "services"
                  },
                  links: {
                    related: "http://test.host/api/v2/services/11.json"
                  }
                }
              }
            }
          }
        }
      ]
    end
  end
end
