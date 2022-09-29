# frozen_string_literal: true

require 'httparty'
require 'json'
require_relative "hubspot_v3/version"
require_relative "hubspot_v3/config"
require_relative "hubspot_v3/helpers"

module HubspotV3
  class RequestFailedError < StandardError
    attr_reader :httparty_response
    def initialize(message, httparty_response = nil)
      super(message)
      @httparty_response = httparty_response
    end
  end

  RequestFailedError = Class.new(RequestFailedError)

  API_URL='https://api.hubapi.com'
  CONTACTS_SEARCH='/crm/v3/objects/contacts/search'
  CONTACTS_CREATE='/crm/v3/objects/contacts/batch/create'
  CONTACTS_UPDATE='/crm/v3/objects/contacts/batch/update'
  COMPANIES_SEARCH='/crm/v3/objects/companies/search'
  COMPANIES_CREATE='/crm/v3/objects/companies/batch/create'
  COMPANIES_UPDATE='/crm/v3/objects/companies/batch/update'

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
    HubspotV3::Helpers.map_search_by_email(contacts_search_by_emails(emails_ary))
  end

  def self.companies_create(bodyhash)
    post(COMPANIES_CREATE, bodyhash)
  end

  def self.companies_update(bodyhash)
    post(COMPANIES_UPDATE, bodyhash)
  end

  def self.companies_search(bodyhash)
    post(COMPANIES_SEARCH, bodyhash)
  end

  def self.companies_search_by_ids(hubspot_object_ids_ary)
    filters_group_ary = hubspot_object_ids_ary.map do |e|
      {
        "filters": [
          {
            "propertyName": "hs_object_id",
            "operator": "EQ",
            "value": e
          }
        ]
      }
    end

    bodyhash = { "filterGroups": filters_group_ary }
    companies_search(bodyhash)
  end

  def self.url(path)
    "#{API_URL}#{path}"
  end

  def self.post(path, bodyhash)
    res = HTTParty.post(url(path), {
      body: bodyhash.to_json,
      headers: headers
    })
    case res.code
    when 200, 201
      res.parsed_response['results']
    when 429
      # Hubspot error 429 - You have reached your secondly limit.
      raise HubspotV3::HubspotSecondlyLimitReached.new("#{res.code} - #{res.parsed_response['message']}", res)
    else
      raise HubspotV3::RequestFailedError.new("#{res.code} - #{res.parsed_response['message']}", res)
    end
  end

  def self.headers
    {
      'Content-Type' => 'application/json',
      'Authorization': "Bearer #{config.token}"
    }
  end
end
