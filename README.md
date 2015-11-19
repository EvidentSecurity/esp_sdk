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

See ActiveResource::PaginatedCollection for all the pagination methods available.

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

```ruby
espsdk:004:0> external_account = ESP::ExternalAccount.where(id_eq: 3, include: 'organization,sub_organization,team')
```

With that call, organization, sub_organization and team will all come back in the response, and calling, `external_account.organization`,
`external_account.sub_organization` and `external_account.team`, will not make another API call.

You can nest include requests with the dot property. For example, requesting `external_account.team` on an alert will expand the `external_account` property into a full `External Account` object, and will then expand the `team` property on that external account into a full `Team` object.
Deep nesting is available as well.  `external_account.team.organization`

```ruby
alert = ESP::Alert.find(1, include: 'tags,external_account.team')
#=> <ESP::Alert:0x007fb82acd3298 @attributes={"id"=>"1", "type"=>"alerts"...}>

alerts = ESP::Alert.where(report_id: 4, include: 'tags,external_account.team')
#=> #<ActiveResource::PaginatedCollection:0x007fb82b0b54b0 @elements=[#<ESP::Alert:0x007fb82b0b1fb8 @attributes={"id"=>"1", "type"=>"alerts"...>
```

Most objects' find and where methods accept the +include+ option.  Those methods that accept the +include+ option are documented with the available associations that are includable.

## Filtering/Searching
For objects that implement `where`, parameters can be passed that will filter the results based on the search criteria specified.
The criteria that can be specified depends on the object.  Each object is documented whether it implements `where` or not,
and if so, which attributes can be included in the search criteria.

### Searching

The primary method of searching is by using what is known as *predicates*.

Predicates are used within Evident.io API search queries to determine what information to
match. For instance, the `cont` predicate, when added to the `name` attribute, will check to see if `name`` contains a value using a wildcard query.

```ruby
ESP::Signature.where(name_cont: 'dns')
#=> will return signatures `where name LIKE '%dns%'`
```

### OR Conditions

You can also combine predicates for OR queries:

```ruby
ESP::Signature.where(name_or_description_cont: 'dns')
#=> will return signatures `where name LIKE '%dns%' or description LIKE '%dns%'`
```

### Conditions on Relationships

The syntax for queries on an associated relationship is to just append the association name to the attribute:

```ruby
ESP::Suppression.where(regions_code_eq: 'us_east_1')
#=> will return suppressions that have a region relationship `where code = 'us_east_1'`
```

### Complex Filtering

Add multiple attributes and predicates to form complex queries:

```ruby
ESP::Suppression.where(regions_code_start: 'us', created_by_email_eq: 'bob@mycompany.com', resource_not_null: '1')
#=> will return suppressions that have a region relationship `where code LIKE 'us%'` and created_by relationship `where email = 'bob@mycompany.com'` and `resource IS NOT NULL`
```

You can also change the `combinator` for complex queries from the default `AND` to `OR` by adding the `m: 'or'` parameter

```ruby
ESP::Suppression.where(regions_code_start: 'us', created_by_email_eq: 'bob@mycompany.com', resource_not_null: '1', m: 'or')
#=> will return suppressions that have a region relationship `where code LIKE 'us%'` **OR** created_by relationship `where email = 'bob@mycompany.com'` **OR** `resource IS NOT NULL`
```

### Bad Attributes

**Please note:** any attempt to use a predicate for an attribute that does not exist will return a
*422 (Unprocessable Entity)* response. For instance, this will not work:

```ruby
ESP::Suppression.where(bad_attribute_eq: 'something')
#=> ActiveResource::ResourceInvalid: Failed.  Response code = 422.  Response message = Invalid search term bad_attribute_eq.
```

**Also note:** any attempt to use a predicate for an attribute that exists on the object, but is not a documented searchable attribute will _silently fail_
and will be excluded from the search criteria.

## Available Predicates

Below is a list of the available predicates and their opposites.

### eq (equals)

The `eq` predicate returns all records where a field is *exactly* equal to a given value:

```ruby
ESP::Suppression.where(regions_code_eq: 'us_east_1')
#=> will return suppressions that have a region relationship `where code = 'us_east_1'`
```

**Opposite: `not_eq`**

### lt (less than)

The `lt` predicate returns all records where a field is less than a given value:

```ruby
ESP::Report.where(created_at_lt: 1.hour.ago)
#=> will return reports `where created_at < '2015-11-11 16:25:30'`
```

**Opposite: `gt` (greater than)**

### lteq (less than or equal to)

The `lteq` predicate returns all records where a field is less than *or equal to* a given value:

```ruby
ESP::Report.where(created_at_lteq: 1.hour.ago)
#=> will return reports `where created_at <= '2015-11-11 16:25:30'`
```

**Opposite: `gteq` (greater than or equal to)**

### in

The `in` predicate returns all records where a field is within a specified list:

```ruby
ESP::Signature.where(risk_level_in: ['Low', 'Medium'])
#=> will return signatures `where risk_level IN ('Low', 'Medium')`
```

**Opposite: `not_in`**

### cont (contains)

The `cont` predicate returns all records where a field contains a given value:

```ruby
ESP::Signature.where(name_cont: 'dns')
#=> will return signatures `where name LIKE '%dns%'`
```

**Opposite: `not_cont`**

**Please note:** This predicate is only available on attributes listed in the "Valid Matching Searchable Attributes"" section
for each implemented `where` method.

### cont_any (contains any)

The `cont_any` predicate returns all records where a field contains any of given values:

```ruby
ESP::Signature.where(name_cont_any: ['dns', 'EC2'])
#=> will return signatures `where name LIKE '%dns%' or name LIKE '%EC2%'`
```

**Opposite: `not_cont_any`**

**Please note:** This predicate is only available on attributes listed in the "Valid Matching Searchable Attributes"" section
for each implemented `where` method.


### start (starts with)

The `start` predicate returns all records where a field begins with a given value:

```ruby
ESP::Signature.where(name_start: 'dns')
#=> will return signatures `where name LIKE 'dns%'`
```

**Opposite: `not_start`**

**Please note:** This predicate is only available on attributes listed in the "Valid Matching Searchable Attributes"" section
for each implemented `where` method.

### end (ends with)

The `end` predicate returns all records where a field ends with a given value:

```ruby
ESP::Signature.where(name_end: 'dns')
#=> will return signatures `where name LIKE '%dns'`
```

**Opposite: `not_end`**

**Please note:** This predicate is only available on attributes listed in the "Valid Matching Searchable Attributes"" section
for each implemented `where` method.

### present

The `present` predicate returns all records where a field is present (not null and not a
blank string).

```ruby
ESP::Signature.where(identifier_present: '1')
#=> will return signatures `where identifier IS NOT NULL AND identifier != ''`
```

**Opposite: `blank`**

### null

The `null` predicate returns all records where a field is null:

```ruby
ESP::Signature.where(identifier_null: 1)
#=> will return signatures `where identifier IS NULL`
```

**Opposite: `not_null`**

## Sorting

Lists can also be sorted by adding the `sorts` parameter with the field to sort by to the `filter` parameter.

```ruby
ESP::Signature.where(name_cont: 'dns', sort: 'risk_level desc')
#=> will return signatures `where name LIKE '%dns%'` sorted by `risk_level` in descending order.
```

Lists can be sorted by multiple fields by specifying an ordered array.

```ruby
ESP::Signature.where(name_cont: 'dns', sorts: ['risk_level desc', 'created_at'])
#=> will return signatures `where name LIKE '%dns%'` sorted by `risk_level` in descending order and then by `created_at` in ascending order.
```

## Available Objects
* ESP::Alert
* ESP::CloudTrailEvent
* ESP::ContactRequest
* ESP::CustomSignature
* ESP::Dashboard
* ESP::ExternalAccount
* ESP::Organization
* ESP::Region
* ESP::Report
* ESP::Service
* ESP::Signature
* ESP::Stat
* ESP::Stat
* ESP::Stat
* ESP::Stat
* ESP::Stat
* ESP::SubOrganization
* ESP::Suppression
* ESP::Suppression::Region
* ESP::Suppression::Signature
* ESP::Suppression::UniqueIdentifier
* ESP::Tag
* ESP::Team
* ESP::User

# Console
The Evident.io SDK gem also provides an IRB console you can use if not using it in a Rails app.  Run it with `bin/esp_console`


## Contributing

1. Fork it ( https://github.com/[my-github-username]/esp_sdk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
