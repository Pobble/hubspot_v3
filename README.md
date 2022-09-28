# HubspotV3

Ruby gem wrapper around Hubspot CRM API V3

Currently this gem focuses on **Batch** update/create/search of Contacts. More info in [source code](https://github.com/Pobble/hubspot_v3/blob/master/lib/hubspot_v3.rb)


Reason why Batch (or Bulk) operations are preferred by this gem is that Hubspot has a strict [limits on number of requests](https://developers.hubspot.com/apisbytier)
(around 100 requests per 10seconds,  up to 200 requests per 10 seconds).
When dealing with large number of Contacts single request operations are
killing those limits quite quickly.


## Other solutions out there

Gem currently covers only features that are needed for our use cases (CRM Contacts & Companies),
however this repo/gem is open for any Pull Requests with additional features.

If you need other features and wish not to contribute to this gem there are 2 existing Hubspot gems out there:

* [Official gem](https://github.com/HubSpot/hubspot-api-ruby) based on V3 API but is just generated Ruby code
* [Community gem](https://github.com/HubspotCommunity/hubspot-ruby) which is better code quality but based on V1 API

It's possible to use our gem along with  any of these two gems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hubspot_v3'
```

[![Gem Version](https://badge.fury.io/rb/hubspot_v3.svg)](https://badge.fury.io/rb/hubspot_v3)

And then execute:

    $ bundle install

## Usage

### set App Token (API key)

> **NOTE**: Starting November 30, 2022, HubSpot API keys will no longer be able to be used as an
> authentication method to access HubSpot APIs [source](https://developers.hubspot.com/changelog/upcoming-api-key-sunset)

This means you cannot use Hubspot API KEY (a.k.a hapikey) to authenticate but rather create Hubspot Private App and use it's auth token
 ([how to setup Hubspot private app](https://developers.hubspot.com/docs/api/private-apps#make-api-calls-with-your-app-s-access-token))


```
# Hubspot private app token (It's not the same as API KEY)
HubspotV3.config.token = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
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

* Full list of search filters and operators can be found in [official hubspot docs](https://developers.hubspot.com/docs/api/crm/contacts)
* More examples how to use `HubspotV3.contacts_search` can be found in [Search examples](https://github.com/Pobble/hubspot_v3/blob/master/README_SEARCH_EXAMPLES.md)


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

### Companies - Search

```
bodyhash = {
  "filterGroups":[
    {
      "filters": [
        {
          "propertyName": "name",
          "operator": "EQ",
          "value": "ACME Company"
        }
      ]
    }
  ]
}
HubspotV3.companies_search(bodyhash)
```

### Companies - Search by id

```
HubspotV3.companies_search_by_ids(['9582682125'])
#=> [
#  {
#    "id"=>"9582682125",
#    "properties"=> {
#      "createdate"=>"2022-09-13T15:06:03.116Z",
#      "domain"=>nil,
#      "hs_lastmodifieddate"=>"2022-09-13T15:20:48.331Z",
#      "hs_object_id"=>"9582682125",
#      "name"=>"ACME Company"},
#    "createdAt"=>"2022-09-13T15:06:03.116Z",
#    "updatedAt"=>"2022-09-13T15:20:48.331Z",
#    "archived"=>false
#  }
#]

HubspotV3.companies_search_by_ids(['66666'])
#=> []

```


* Full list of search filters and operators can be found in [official hubspot docs](https://developers.hubspot.com/docs/api/crm/companies)

### Companies - Batch Create

```
bodyhash = {
  "inputs": [
    {
      "properties": {
        "name": "ACME Corporation"
      }
    },
    {
      "city": "Cambridge",
      "domain": "biglytics.net",
      "industry": "Technology",
      "name": "Biglytics",
      "phone": "(877) 929-0687",
      "state": "Massachusetts"
    }
  ]
}

begin
  HubspotV3.companies_create(bodyhash)
rescue HubspotV3::RequestFailedError => e
  puts e.message
  # => 409 - some error reason (I never encounterd an error when creating company)

  httparty_response_object = e.httparty_response
  # =>  #<HTTParty::Response:0x1d920 parsed_response={"status"=>"error"...
end
```

return value:

```
[
  {
    "id"=>"9674616673",
    "properties"=> {
      ...
    }
    ...
  },
  {
    "id"=>"9674616674",
    "properties"=> {
      ...
    }
    ...
  }
]
```

### Companies - Batch Update

```
bodyhash = {
  "inputs": [
    {
      "id": "9582682125",
      "properties": {
        "name": "ACME Company"
      }
    }
  ]
}
HubspotV3.companies_update(bodyhash)
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
#     "id" => 1589,
#     "properties" => {
#       "email"=>"hello@pobble.com",
#       ...
#     }
#   },
#   {
#    "id" => 1485,
#    "properties" => {
#       "email"=>"info@pobble.com",
#       ...
#       }
#   }
# ]

HubspotV3::MockContract.contacts_search_by_emails_mapped(["hello@pobble.com", "notfound@pobble.com", "info@pobble.com"]).keys
# => ["hello@pobble.com", "info@pobble.com"]
```

`id` field of test Contact contracts is calculated as `'info@pobble.com'.bytes.sum == 1485` ([source](https://github.com/Pobble/hubspot_v3/blob/master/lib/hubspot_v3/mock_contract.rb#L181)), create contacts will be `'info@pobble.com'.bytes.sum + 1_000_000 == 1001485` ([source](https://github.com/Pobble/hubspot_v3/blob/master/lib/hubspot_v3/mock_contract.rb#L29))

> More info on how to use [Contract tests](https://blog.eq8.eu/article/explicit-contracts-for-rails-http-api-usecase.html)

## Troubleshooting

#### Error - Cannot deserialize value of type
```
`post': 400 - Invalid input JSON on line 1, column 1: Cannot deserialize value of type `com.hubspot.apiutils.core.models.batch.BatchInput$Json<com.hubspot.inbounddb.publicobject.core.v2.SimplePublicObjectBatchInput>` from Array value (token `JsonToken.START_ARRAY`) (HubspotV3::RequestFailedError)
```

You probably forgot to wrap your batch call  body hash  in `inputs`.

E.g.:

instead of

```
HubspotV3.companies_update([{"id"=>"1234", "properties"=> {"city" => "Cambridge"}}])
```

you need to do:

```
HubspotV3.companies_update("inputs" => [{"id"=>"1234", "properties"=> {"city" => "Cambridge"}}])
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Pobble/hubspot_v3.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
