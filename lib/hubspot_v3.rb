# frozen_string_literal: true

require 'httparty'
require 'json'
require_relative "hubspot_v3/version"

module HubspotV3
  class RequestFailedError < StandardError; end

  API_URL='https://api.hubapi.com'
  SEARCH_CONTACTS='/crm/v3/objects/contacts/search'

  def self.contacts_search_by_email(email)
    body = {
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
    post(SEARCH_CONTACTS, body)
  end

  def self.url(path)
    "#{API_URL}#{path}?hapikey=#{config.apikey}"
  end

  def self.post(path, body)
    res = HTTParty.post(url(path), {
      body: body.to_json,
      headers: {'Content-Type' => 'application/json'}
    })
    case res.code
    when 200
      res.parsed_response['results']
    else
      raise(RequestFailedError, res.message)
    end
  end
end
