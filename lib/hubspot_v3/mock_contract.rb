module HubspotV3
  module MockContract
    extend self

    def contacts_update(bodyhash)
      inputs = _fetch_inputs(bodyhash)

      inputs.map do |input|
        id = _fetch_input_id(input)
        properties = _fetch_input_properties(input)

        {
          "id"=>id,
          "properties"=>properties,
          "createdAt"=>"2021-10-18T15:12:14.245Z",
          "updatedAt"=>"2021-10-18T15:12:16.539Z",
          "archived"=>false
        }
      end
    end

    def contacts_create(bodyhash)
      inputs = _fetch_inputs(bodyhash)

      inputs.map do |input|
        properties = _fetch_input_properties(input)

        email = properties.fetch('email') { raise KeyError.new("Item in Inputs hash must contain key 'properties.email' - hash['inputs'][0]['properties']['email']") }
        id = _calculate_id(email) + 1_000_000

        sanitized_email = _sanitize_email_as_hubspot_would(email) # sanitize after id was generated

        default_properties = {
          "createdate"=>"2021-10-18T15:12:14.245Z",
          "email"=>sanitized_email,
          "hs_all_contact_vids"=>"3451",
          "hs_email_domain"=>sanitized_email.split('@').last,
          "hs_is_unworked"=>"true",
          "hs_object_id"=>id,
          "hs_pipeline"=>"contacts-lifecycle-pipeline",
          "lastmodifieddate"=>"2021-10-18T15:12:14.245Z",
        }

        properties = default_properties.merge(properties)

        {
          "id"=>id,
          "properties"=> properties,
          "createdAt"=>"2021-10-18T15:12:14.245Z",
          "updatedAt"=>"2021-10-18T15:12:14.245Z",
          "archived"=>false
        }
      end
    end

    def contacts_search_by_emails(emails)
      emails = emails.reject { |e| e.match?(/notfound/)}

      emails.map do |email|
        id = _calculate_id(email)
        first_name = email.split('@').first
        last_name  = email.split('@').last
        sanitized_email = _sanitize_email_as_hubspot_would(email) # sanitize after id was generated

        {
          "id"=>id,
          "createdAt"=>"2020-09-10T10:29:54.714Z",
          "updatedAt"=>"2021-10-13T10:16:19.015Z",
          "archived"=>false,
          "properties"=> {
            "createdate"=>"2020-09-10T10:29:54.714Z",
            "email"=>sanitized_email,
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

    def _calculate_id(email)
      email.bytes.sum  # sum of asci values of the email string
    end

    def _sanitize_email_as_hubspot_would(email)
      # Hubspot downcase all emails e.g. tomas@Pobble.com would be tomas@pobble.com
      email.downcase.strip
    end

    def _fetch_inputs(bodyhash)
      bodyhash.fetch('inputs') { raise KeyError.new("Inputs hash must contain key 'inputs' - hash['inputs']") }
    end

    def _fetch_input_properties(input)
      input.fetch('properties') { raise KeyError.new("Item in Inputs hash must contain key 'properties' - hash['inputs'][0]['properties']") }
    end

    def _fetch_input_id(input)
      input.fetch('id') { raise KeyError.new("Item in Inputs hash must contain key 'id' - hash['inputs'][0]['id']") }
    end
  end
end
