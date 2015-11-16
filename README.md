[![Build Status](https://travis-ci.org/EvidentSecurity/esp_sdk.svg?branch=master)](https://travis-ci.org/EvidentSecurity/esp_sdk)
[![Code Climate](https://codeclimate.com/repos/546a526f6956800d2900e3fb/badges/841000b5295e533401c3/gpa.svg)](https://codeclimate.com/repos/546a526f6956800d2900e3fb/feed)
[![Coverage Status](https://coveralls.io/repos/EvidentSecurity/esp_sdk/badge.svg)](https://coveralls.io/r/EvidentSecurity/esp_sdk)
[![Gem Version](https://badge.fury.io/rb/esp_sdk.svg)](http://badge.fury.io/rb/esp_sdk)

# Evident Security Platform SDK

A Ruby interface for calling the [Evident.io](https://www.evident.io) API.

This Readme is for the V2 version of the ESP SDK.  For V1 information, see the [**V1 WIKI**](https://github.com/EvidentSecurity/esp_sdk/wiki).

## Installation

Add this line to your application's Gemfile:

    gem 'esp_sdk'

And then execute:

     bundle

Or install it yourself as:

     gem install esp_sdk

# Configuration

## Set your HMAC security keys:

You must set your access_key_id and your secret_access_key.  
You can set these directly:

```ruby
ESP.access_key_id = <your key>
ESP.secret_access_key = <your secret key>
```
      
or with environment variables:

```ruby
ENV['ESP_ACCESS_KEY_ID'] = <you key>
ENV['ESP_SECRET_ACCESS_KEY'] = <your secret key>
```
      
or, if in a Rails application, you can use the configure block in an initializer:

```ruby
ESP.configure do |config|
  config.access_key_id = <your key>
  config.secret_access_key = <your secret key>
end
```
      
Get your HMAC keys from the Evident.io website, [esp.evident.io](https://esp.evident.io/settings/api_keys)

## Appliance Users

Users of Evident.io's AWS marketplace appliance will need to set the host for their appliance instance.
You can set this directly:

```ruby
ESP.host = <host for appliance instance>
```
      
or, if in a Rails application, you can use the configure block in an initializer:

```ruby
ESP.configure do |config|
  config.host = <host for appliance instance>
end
```

Alternatively, the site can also be set with an environment variable.


```
export ESP_HOST=<host for appliance instance>
```

# Usage

## Everything is an Object

The Evident.io SDK uses Active Resource, so the DSL acts very much like Active Record providing by default, the standard CRUD actions
`find`, `all`, `create`, `update`, `destroy`, only instead of a database as the data store, it makes calls to the Evident.io API.  Not all
methods are available for all ESP objects.  See the [documentation](http://www.rubydoc.info/gems/esp_sdk) to see all the methods 
available for each object.
So, for instance, to get a report by ID:

```ruby
espsdk:003:0> report = ESP::Report.find(234)
```
    
And to get the alerts for that report:

```ruby
espsdk:003:0> alerts = report.alerts
```

For objects that are creatable, updatable, and destroyable, you make the exact same calls you would expect to use with Active Record.

```ruby
espsdk:003:0> team = ESP::Team.create(name: 'MyTeam', organization_id: 452, sub_organization_id: 599)
    
espsdk:003:0> team.name = 'NewName'
espsdk:003:0> team.save
    
espsdk:003:0> team.destroy
```
    
Use the `attributes` method to get a list of all available attributes that each object has.

```ruby
espsdk:003:0> team = ESP::Team.find(1)
espsdk:004:0> team.attributes
# => {
# =>                       "id" => "1",
# =>                     "type" => "teams",
# =>            "relationships" => #<ESP::Team::Relationships:0x007fdf1b451710 @attributes={"sub_organization"=>#<ESP::SubOrganization:0x007fdf1b450d60 @attributes={"data"=>#<ESP::SubOrganization::Data:0x007fdf1b450978 @attributes={"id"=>"1", "type"=>"sub_organizations"}, @prefix_options={}, @persisted=true>, "links"=>#<ESP::SubOrganization::Links:0x007fdf1b4503b0 @attributes={"related"=>"http://localhost:3000/api/v2/sub_organizations/1.json_api"}, @prefix_options={}, @persisted=true>}, @prefix_options={}, @persisted=true>, "organization"=>#<ESP::Organization:0x007fdf1b45bbc0 @attributes={"data"=>#<ESP::Organization::Data:0x007fdf1b45b7d8 @attributes={"id"=>"1", "type"=>"organizations"}, @prefix_options={}, @persisted=true>, "links"=>#<ESP::Organization::Links:0x007fdf1b45b210 @attributes={"related"=>"http://localhost:3000/api/v2/organizations/1.json_api"}, @prefix_options={}, @persisted=true>}, @prefix_options={}, @persisted=true>, "external_accounts"=>#<ESP::Team::Relationships::ExternalAccounts:0x007fdf1b45a040 @attributes={"data"=>[#<ESP::Team::Relationships::ExternalAccounts::Datum:0x007fdf1b458830 @attributes={"id"=>"1", "type"=>"external_accounts"}, @prefix_options={}, @persisted=true>], "links"=>#<ESP::Team::Links:0x007fdf1b463e38 @attributes={"related"=>"http://localhost:3000/api/v2/external_accounts.json_api"}, @prefix_options={}, @persisted=true>}, @prefix_options={}, @persisted=true>}, @prefix_options={}, @persisted=true>,
# =>                     "name" => "Default Team",
# =>               "created_at" => "2015-09-23T14:37:48.000Z",
# =>               "updated_at" => "2015-09-23T14:37:48.000Z",
# =>      "sub_organization_id" => "1",
# =>          "organization_id" => "1",
# =>     "external_account_ids" => [
# =>         [0] "1"
# =>     ]
# => }
```
    
## Errors
Active Resource objects have an errors collection, just like Active Record objects.  If the API call returns a non fatal response, like 
validation issues, you can check the errors object to see what went wrong.

```ruby
espsdk:003:0> t = ESP::Team.create(name: '')
espsdk:003:0> t.errors
# => {
# =>     :base => [
# =>         [0] "Organization can't be blank",
# =>         [1] "Sub organization can't be blank"
# =>     ],
# =>     :name => [
# =>         [0] "can't be blank"
# =>     ]
# => }
```
    
The errors will be in the :base key rather than the corresponding attribute key, since we have not defined a schema for the objects
in order to stay more loosely coupled to the API.

```ruby
espsdk:003:0> t.errors.full_messages
# => [
# =>     [0] "Organization can't be blank",
# =>     [1] "Sub organization can't be blank",
# =>     [2] "Name can't be blank"
# => ]
```

When an error is thrown, you can rescue the error and check the error message:

```ruby
espsdk:003:0> c = ESP::CustomSignature.find(435)
espsdk:003:0> c.run!(external_account_id: 999)
# =>  ActiveResource::ResourceInvalid: Failed.  Response code = 422.  Response message = Couldn't find ExternalAccount. 
# =>    from /Users/kevintyll/evident/esp_sdk/lib/esp/resources/custom_signature.rb:23:in `run!'

begin
  c.run!(external_account_id: 999)
rescue ActiveResource::ResourceInvalid => e
  puts e.message
end
# => Failed.  Response code = 422.  Response message = Couldn't find ExternalAccount.
```
    
All non get requests have a corresponding `!` version of the method.  These methods will throw an error rather than swallow
the error and return an object with the errors object populated. For example, the `run` and `run!` methods on CustomSignature.

## Pagination
Evident.io API endpoints that return a collection of objects allows for paging and only returns a limited number of items at a time.
The Evident.io SDK returns an ESP::PaginatedCollection object that provides methods for paginating through the collection. 
The methods with a `!` suffix update the object, methods without the `!` suffix return a new page object preserving the
original object.

```ruby
espsdk:004:0> alerts = ESP::Alert.for_report(345)
espsdk:004:0> alerts.current_page_number # => "1"
espsdk:004:0> page2 = alerts.next_page
espsdk:004:0> alerts.current_page_number # => "1"
espsdk:004:0> page2.current_page_number # => "2"
espsdk:004:0> page2.previous_page!
espsdk:004:0> page2.current_page_number # => "1"
espsdk:004:0> alerts.last_page!
espsdk:004:0> alerts.current_page_number # => "25"
espsdk:004:0> page4 = alerts.page(4)
espsdk:004:0> alerts.current_page_number # => "25"
espsdk:004:0> page4.current_page_number # => "4"
```
    
## Associated Objects
Most of the objects in the Evident.io SDK have a corresponding API call associated with it.  That means if you call an object's
association, then that will make another API call.  For example:

```ruby
espsdk:004:0> external_account = ESP::ExternalAccount.find(3)
espsdk:004:0> organization = external_account.organization
espsdk:004:0> sub_organization = external_account.sub_organization
espsdk:004:0> team = external_account.team
```

The above code will make 4 calls to the Evident.io API.  1 each for the external account, organization, sub_organization and team.
The [JSON API Specification](http://jsonapi.org/format/#fetching-includes), which the Evident.io API tries to follow, provides
a means for returning nested objects in a single call.  With the SDK, that can be done by providing a comma separated string
of the relations wanted in an +include+ option.

```ruby
espsdk:004:0> external_account = ESP::ExternalAccount.find(3, include: 'organization,sub_orgnanization,team')
```

With that call, organization, sub_organization and team will all come back in the response, and calling, `external_account.organization`,
`external_account.sub_organization` and `external_account.team`, will not make another API call.  Most objects' find method accepts the
+include+ option.
    
See the [**Documentation**](http://www.rubydoc.info/gems/esp_sdk/ESP/ActiveResource/PaginatedCollection.html) for all the pagination methods available.

## Available Objects
* [ESP::Alert](http://www.rubydoc.info/gems/esp_sdk/ESP/Alert.html)
* [ESP::CloudTrailEvent](http://www.rubydoc.info/gems/esp_sdk/ESP/CloudTrailEvent.html)
* [ESP::ContactRequest](http://www.rubydoc.info/gems/esp_sdk/ESP/ContactRequest.html)
* [ESP::CustomSignature](http://www.rubydoc.info/gems/esp_sdk/ESP/CustomSignature.html)
* [ESP::Dashboard](http://www.rubydoc.info/gems/esp_sdk/ESP/Dashboard.html)
* [ESP::ExternalAccount](http://www.rubydoc.info/gems/esp_sdk/ESP/ExternalAccount.html)
* [ESP::Organization](http://www.rubydoc.info/gems/esp_sdk/ESP/Organization.html)
* [ESP::Region](http://www.rubydoc.info/gems/esp_sdk/ESP/Region.html)
* [ESP::Report](http://www.rubydoc.info/gems/esp_sdk/ESP/Report.html)
* [ESP::Service](http://www.rubydoc.info/gems/esp_sdk/ESP/Service.html)
* [ESP::Signature](http://www.rubydoc.info/gems/esp_sdk/ESP/Signature.html)
* [ESP::Stat](http://www.rubydoc.info/gems/esp_sdk/ESP/Stat.html)
* [ESP::SubOrganization](http://www.rubydoc.info/gems/esp_sdk/ESP/SubOrganization.html)
* [ESP::Suppression](http://www.rubydoc.info/gems/esp_sdk/ESP/Suppression.html)
* [ESP::Suppression::Region](http://www.rubydoc.info/gems/esp_sdk/ESP/Suppression::Region.html)
* [ESP::Suppression::Signature](http://www.rubydoc.info/gems/esp_sdk/ESP/Suppression::Signature.html)
* [ESP::Suppression::UniqueIdentifier](http://www.rubydoc.info/gems/esp_sdk/ESP/Suppression::UniqueIdentifier.html)
* [ESP::Tag](http://www.rubydoc.info/gems/esp_sdk/ESP/Tag.html)
* [ESP::Team](http://www.rubydoc.info/gems/esp_sdk/ESP/Team.html)
* [ESP::User](http://www.rubydoc.info/gems/esp_sdk/ESP/User.html)

# Console
The Evident.io SDK gem also provides an IRB console you can use if not using it in a Rails app.  Run it with `bin/esp_console`


## Contributing

1. Fork it ( https://github.com/[my-github-username]/esp_sdk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
