require 'spec_helper'

RSpec.describe HubspotV3::MockContract do
  describe '#contacts_search_by_emails_mapped' do
    it do
      res = described_class.contacts_search_by_emails_mapped(["hello@pobble.com", "info@pobble.com"])

      expect(res).to match({
        "hello@pobble.com"=>
          {
            "id"=>1589,
            "createdAt"=>"2020-09-10T10:29:54.714Z",
            "updatedAt"=>"2021-10-13T10:16:19.015Z",
            "archived"=>false,
            "properties"=>
            {
              "createdate"=>"2020-09-10T10:29:54.714Z",
              "email"=>"hello@pobble.com",
              "firstname"=>"hello",
              "hs_object_id"=>1589,
              "lastmodifieddate"=>"2021-10-13T10:16:19.015Z",
              "lastname"=>"pobble.com"}},

         "info@pobble.com"=>
           {
             "id"=>1485,
             "createdAt"=>"2020-09-10T10:29:54.714Z",
             "updatedAt"=>"2021-10-13T10:16:19.015Z",
             "archived"=>false,
             "properties"=>
             { "createdate"=>"2020-09-10T10:29:54.714Z",
               "email"=>"info@pobble.com",
               "firstname"=>"info",
               "hs_object_id"=>1485,
               "lastmodifieddate"=>"2021-10-13T10:16:19.015Z",
               "lastname"=>"pobble.com"}}
      })
    end
  end

  describe '#contacts_search_by_emails' do
    it do
      res = described_class.contacts_search_by_emails(["hello@pobble.com", "info@pobble.com"])
      expect(res).to match_array([
          {"id"=>1589,
           "createdAt"=>"2020-09-10T10:29:54.714Z",
           "updatedAt"=>"2021-10-13T10:16:19.015Z",
           "archived"=>false,
           "properties"=>
            {"createdate"=>"2020-09-10T10:29:54.714Z",
             "email"=>"hello@pobble.com",
             "firstname"=>"hello",
             "hs_object_id"=>1589,
             "lastmodifieddate"=>"2021-10-13T10:16:19.015Z",
             "lastname"=>"pobble.com"}},

          {"id"=>1485,
           "createdAt"=>"2020-09-10T10:29:54.714Z",
           "updatedAt"=>"2021-10-13T10:16:19.015Z",
           "archived"=>false,
           "properties"=>
            {"createdate"=>"2020-09-10T10:29:54.714Z",
             "email"=>"info@pobble.com",
             "firstname"=>"info",
             "hs_object_id"=>1485,
             "lastmodifieddate"=>"2021-10-13T10:16:19.015Z",
             "lastname"=>"pobble.com"}}
      ])
    end

    it do
      res = described_class.contacts_search_by_emails(["hello@pobble.com", "anythnig-notfound@pobble.com"])
      expect(res).to match_array([
          {"id"=>1589,
           "createdAt"=>"2020-09-10T10:29:54.714Z",
           "updatedAt"=>"2021-10-13T10:16:19.015Z",
           "archived"=>false,
           "properties"=>
            {"createdate"=>"2020-09-10T10:29:54.714Z",
             "email"=>"hello@pobble.com",
             "firstname"=>"hello",
             "hs_object_id"=>1589,
             "lastmodifieddate"=>"2021-10-13T10:16:19.015Z",
             "lastname"=>"pobble.com"}},
      ])
    end
  end

  describe '#companies_search' do
    it do
      expect { described_class.contacts_search('whatever') }
        .to raise_exception('HubspotV3::MockContract.contacts_search should be stubbed or overridden')
    end
  end

  describe '#companies_search_by_ids' do
    it do
      res = described_class.companies_search_by_ids(["123456", "654321"])

      expect(res).to match_array([be_kind_of(Hash),be_kind_of(Hash)])
      expect(res.map { |item| item['id'] }).to match_array(["123456", "654321"])

      expect(item = res.first).to match({
        "id" => "123456",
        "archived" => false,
        "createdAt" => "2022-09-13T15:06:03.116Z",
        "id" => "123456",
        "properties" => be_kind_of(Hash),
        "updatedAt" => "2022-09-13T15:20:48.331Z",
      })

      expect(item['properties']).to match({
        "createdate" => "2022-09-13T15:06:03.116Z",
        "domain" => nil,
        "hs_lastmodifieddate" => "2022-09-13T15:20:48.331Z",
        "hs_object_id" => "123456",
        "name" => "ACME Company 123456",
      })
    end

    it do
      res = described_class.companies_search_by_ids(["666666", "555566"])
      expect(res).to match_array([be_kind_of(Hash)])
      expect(res.map { |item| item['id'] }).to match_array(["555566"])
    end
  end

  describe '#companies_search' do
    it do
      expect { described_class.companies_search('whatever') }
        .to raise_exception('HubspotV3::MockContract.companies_search should be stubbed or overridden')
    end
  end

  describe '#companies_create' do
    let(:response) { described_class.companies_create(bodyhash) }

    let(:bodyhash) do
      {
        "inputs" => [
          {
            "properties" => {
              "name" => "ACME Corporation"
            }
          }
        ]
      }
    end

    it do
      expect(response).to be_kind_of(Array)

      item = response.first
      expect(item.keys).to match_array(["archived", "createdAt", "id", "properties", "updatedAt"])
      expect(item).to match({
        "archived"=>false,
        "createdAt"=>"2022-09-13T15:06:03.116Z",
        "updatedAt"=>"2022-09-13T15:06:03.116Z",
        "id"=>'1001478',
        "properties"=> be_kind_of(Hash)
      })

      expect(item.fetch('properties')).to match({
        "createdate"=>"2022-09-13T15:06:03.116Z",
        "hs_lastmodifieddate"=>"2022-09-13T15:06:03.116Z",
        "hs_object_id"=>'1001478',
        "hs_pipeline"=>"companies-lifecycle-pipeline",
        "lifecyclestage"=>"lead",
        "name"=>"ACME Corporation"
      })
    end
  end

  describe '#companies_update ' do
    let(:response) { described_class.companies_update(bodyhash) }

    let(:bodyhash) do
      {
        "inputs" => [
          {
            "id" => "1478",
            "properties" => {
              "name" => "ACME Quest"
            }
          }
        ]
      }
    end

    it do
      expect(response).to be_kind_of(Array)

      item = response.first
      expect(item.keys).to match_array(["archived", "createdAt", "id", "properties", "updatedAt"])
      expect(item).to match({
        "archived"=>false,
        "createdAt"=>"2022-09-13T15:06:03.116Z",
        "updatedAt"=>"2022-09-13T15:06:33.116Z",
        "id"=>'1478',
        "properties"=> be_kind_of(Hash)
      })

      expect(item.fetch('properties')).to match({
        "createdate"=>"2022-09-13T15:06:03.116Z",
        "hs_lastmodifieddate"=>"2022-09-13T15:06:33.116Z",
        "hs_object_id"=>"1478",
        "hs_pipeline"=>"companies-lifecycle-pipeline",
        "lifecyclestage"=>"lead",
        "name"=>"ACME Quest"
      })
    end
  end
end
