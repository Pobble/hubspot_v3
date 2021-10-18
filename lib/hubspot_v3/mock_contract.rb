module HubspotV3
  module MockContract
    extend self

    def contacts_search_by_emails(emails)
      emails = emails.reject { |e| e.match?(/notfound/)}

      emails.map do |email|
        id = email.bytes.sum # sum of asci values of the email string
        first_name = email.split('@').first
        last_name  = email.split('@').last


        {
          "id"=>id,
          "createdAt"=>"2020-09-10T10:29:54.714Z",
          "updatedAt"=>"2021-10-13T10:16:19.015Z",
          "archived"=>false,
          "properties"=> {
            "createdate"=>"2020-09-10T10:29:54.714Z",
            "email"=>email,
            "firstname"=>first_name,
            "hs_object_id"=>id,
            "lastmodifieddate"=>"2021-10-13T10:16:19.015Z",
            "lastname"=>last_name
          }
        }
      end
    end

    def contacts_search_by_emails_mapped(emails_ary)
      HubspotV3::Helpers.map_search_by_email(contacts_search_by_emails(emails_ary))
    end
  end
end
