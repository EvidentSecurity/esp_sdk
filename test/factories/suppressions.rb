FactoryGirl.define do
  factory :suppression, class: 'ESP::Suppression' do
    skip_create

    sequence(:id) { |n| n }
    type "suppressions"
    created_at { Time.current }
    reason "I said"
    resource ''
    suppression_type "regions"
    status "active"
    updated_at { Time.current }
    relationships do
      { organization: {
        data: {
          type: "organizations",
          id: "1"
        },
        links: {
          related: "http://localhost:3000/api/v2/organizations/1.json"
        }
      },
        created_by: {
          data: {
            type: "users",
            id: "23"
          },
          links: {
            related: "http://localhost:3000/api/v2/users/23.json"
          }
        },
        regions: {
          data: [
            {
              id: "1",
              type: "regions"
            }
          ],
          links: {
            related: "http://test.host/api/v2/regions.json?filter%5Bsuppressions_id_eq%5D=4"
          }
        },
        external_accounts: {
          data: [
            {
              id: "1015",
              type: "external_accounts"
            }
          ],
          links: {
            related: "http://test.host/api/v2/external_accounts.json?filter%5Bsuppressions_id_eq%5D=4"
          }
        },
        signatures: {
          data: [
            {
              id: "6",
              type: "signatures"
            }
          ],
          links: {
            related: "http://test.host/api/v2/signatures.json?filter%5Bid_in%5D%5B%5D=6"
          }
        },
        custom_signatures: {
          data: []
        }
      }
    end
  end
end
