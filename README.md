# HubspotV3

Ruby gem wrapper around Hubspot API V3 

Currently this gem focuses on **Batch** update/create/search of Contacts. More info in [source code](https://github.com/Pobble/hubspot_v3/blob/master/lib/hubspot_v3.rb)


Reason why Batch (or Bulk) operations are preferred by this gem is that Hubspot has a strict [limits on number of requests](https://developers.hubspot.com/apisbytier)
(around 100 requests per 10seconds,  up to 200 requests per 10 seconds).
When dealing with large number of Contacts single request operations are
killing those limits quite quickly.


## Other solutions out there

Gem currently covers only features that are needed for our use cases, however this repo/gem is open for any Pull Requests with additional features.

If you need other features and wish not to contribute to this gem there are 2 existing Hubspot gems out there:

* [Official gem](https://github.com/HubSpot/hubspot-api-ruby) based on V3 API but is just generated Ruby code
* [Community gem](https://github.com/HubspotCommunity/hubspot-ruby) which is better code quality but based on V1 API

It's possible to use our gem along with  any of these two gems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hubspot_v3', github: 'Pobble/hubspot_v3'
```

And then execute:

    $ bundle install

## Usage

### set API key

```
HubspotV3.config.apikey = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
```

### Contacts - Search

```

bodyhash = {
  "filterGroups":[
    {
      "filters": [
        {
          "propertyName": "email",
          "operator": "EQ",
          "value": email
        }
      ]
    }
  ]
}
HubspotV3.contacts_search(bodyhash)

```

### Contacts - find by email

```
HubspotV3.contacts_search_by_emails(["hello@pobble.com", "info@pobble.com"])
[
 {"id"=>"901",
  "properties"=>
   {"createdate"=>"2020-09-10T10:29:54.714Z",
    "email"=>"hello@pobble.com",
    "firstname"=>nil,
    "hs_object_id"=>"901",
    "lastmodifieddate"=>"2021-10-13T10:16:19.015Z",
    "lastname"=>"test"},
  "createdAt"=>"2020-09-10T10:29:54.714Z",
  "updatedAt"=>"2021-10-13T10:16:19.015Z",
  "archived"=>false},
 {"id"=>"3401",
  "properties"=>
   {"createdate"=>"2021-10-13T13:31:04.599Z",
    "email"=>"info@pobble.com",
    "firstname"=>"Bryan",
    "hs_object_id"=>"3401",
    "lastmodifieddate"=>"2021-10-13T13:31:07.126Z",
    "lastname"=>"Cooper"},
  "createdAt"=>"2021-10-13T13:31:04.599Z",
  "updatedAt"=>"2021-10-13T13:31:07.126Z",
  "archived"=>false}
]
```

> Note: will search only primary email of a Contact

### Contacts - find by email & results mapped by email

```
HubspotV3.contacts_search_by_emails(["hello@pobble.com", "info@pobble.com"])

{
    "anas+10093@pobble.com" => {
                "id" => "901",
        "properties" => {
                  "createdate" => "2020-09-10T10:29:54.714Z",
                       "email" => "hello@pobble.com",
                   "firstname" => nil,
                "hs_object_id" => "901",
            "lastmodifieddate" => "2021-10-13T10:16:19.015Z",
                    "lastname" => "test"
        },
         "createdAt" => "2020-09-10T10:29:54.714Z",
         "updatedAt" => "2021-10-13T10:16:19.015Z",
          "archived" => false
    },
    "bcooper@biglytics.net" => {
                "id" => "3401",
        "properties" => {
                  "createdate" => "2021-10-13T13:31:04.599Z",
                       "email" => "info@pobble.com",
                   "firstname" => "Bryan",
                "hs_object_id" => "3401",
            "lastmodifieddate" => "2021-10-13T13:31:07.126Z",
                    "lastname" => "Cooper"
        },
         "createdAt" => "2021-10-13T13:31:04.599Z",
         "updatedAt" => "2021-10-13T13:31:07.126Z",
          "archived" => false
    }
}
```

> Note: will search only primary email of a Contact

### Contacts - Batch Create

```
bodyhash = {
  "inputs": [
    {
      "properties": {
        "email": "equivalent@eq8.eu",
        "firstname": "Tomas",
        "lastname": "Talent",
      }
    }
  ]
}

begin
  HubspotV3.contacts_create(bodyhash)
rescue HubspotV3::RequestFailedError => e
  puts e.message
  # => 409 - Contact already exists. Existing ID: 3401

  httparty_response_object = e.httparty_response
  # =>  #<HTTParty::Response:0x1d920 parsed_response={"status"=>"error"...
end
```

### Contacts - Batch Update

```
bodyhash = {
  "inputs": [
    {
      "id": "1",
      "properties": {
        "company": "Biglytics",
        "email": "bcooper@biglytics.net",
        "firstname": "Bryan",
        "lastname": "Cooper",
        "phone": "(877) 929-0687",
        "website": "biglytics.net"
      }
    }
  ]
}
HubspotV3.contacts_update(bodyhash)
```

## Test your app

You can use http interceptor like [webmock](https://github.com/bblimke/webmock), [vcr](https://github.com/vcr/vcr).

Or you can use explicit contracts provided in this gem.

```
require 'hubspot_v3'
require 'hubspot_v3/mock_contract'

HubspotV3::MockContract.contacts_search_by_emails(["hello@pobble.com", "notfound@pobble.com", "info@pobble.com"])
# [
#   {
#     "id" => 1589, "properties" => {
#       "email"=>"hello@pobble.com",
#       ...
#     }
#   },
    {
#    "id" => 1485, "properties" => {
#       "email"=>"info@pobble.com",
#       ...
#       }
#   }
# ]

HubspotV3::MockContract.contacts_search_by_emails_mapped(["hello@pobble.com", "notfound@pobble.com", "info@pobble.com"]).keys
# => ["hello@pobble.com", "info@pobble.com"]
```

`id` field of test Contact contracts is calculated as `'info@pobble.com'.bytes.sum == 1485`, create contacts will be `'info@pobble.com'.bytes.sum + 1_000_000 == 1001485`

> More info on how to use [Contract tests](https://blog.eq8.eu/article/explicit-contracts-for-rails-http-api-usecase.html)



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Pobble/hubspot_v3.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
