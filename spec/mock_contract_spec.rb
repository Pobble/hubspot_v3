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
end
