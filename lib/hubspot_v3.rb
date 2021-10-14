# frozen_string_literal: true

require 'httparty'
require 'json'
require_relative "hubspot_v3/version"
require_relative "hubspot_v3/config"

module HubspotV3
  class RequestFailedError < StandardError
    attr_reader :httparty_response
    def initialize(message, httparty_response = nil)
      super(message)
      @httparty_response = httparty_response
    end
  end

  API_URL='https://api.hubapi.com'
  CONTACTS_SEARCH='/crm/v3/objects/contacts/search'
  CONTACTS_CREATE='/crm/v3/objects/contacts/batch/create'
  CONTACTS_UPDATE='/crm/v3/objects/contacts/batch/update'

  def self.contacts_create(bodyhash)
    post(CONTACTS_CREATE, bodyhash)
  end

  def self.contacts_update(bodyhash)
    post(CONTACTS_UPDATE, bodyhash)
  end

  def self.contacts_search(bodyhash)
    post(CONTACTS_SEARCH, bodyhash)
  end

  def self.contacts_search_by_emails(emails_ary)
    filters_group_ary = emails_ary.map do |e|
      {
        "filters": [
          {
            "propertyName": "email",
            "operator": "EQ",
            "value": e
          }
        ]
      }
    end

    bodyhash = { "filterGroups": filters_group_ary }
    contacts_search(bodyhash)
  end

  def self.contacts_search_by_emails_mapped(emails_ary)
    contacts_search_by_emails(emails_ary).inject({}) do |hash, result|
      hash[result.fetch('properties').fetch('email')] = result
      hash
    end
  end

  def self.url(path)
    "#{API_URL}#{path}?hapikey=#{config.apikey}"
  end

  def self.post(path, bodyhash)
    res = HTTParty.post(url(path), {
      body: bodyhash.to_json,
      headers: {'Content-Type' => 'application/json'}
    })
    case res.code
    when 200, 201
      res.parsed_response['results']
    else
      raise HubspotV3::RequestFailedError.new("#{res.code} - #{res.parsed_response['message']}", res)
    end
  end
end
