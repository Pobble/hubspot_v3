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

    def contacts_search(bodyhash)
      puts _general_batch_search_should_be_overridden_msg('contacts_search')
      raise "HubspotV3::MockContract.contacts_search should be stubbed or overridden"
    end

    def companies_create(bodyhash)
      inputs = _fetch_inputs(bodyhash)
      inputs.map do |input|
        properties = _fetch_input_properties(input)

        #note: Hubspot API doesn't really require name, but for sake of this
        # contract functionality we need properties.name
        name = properties.fetch('name') { raise KeyError.new("Item in Inputs hash must contain key 'properties.name' - hash['inputs'][0]['properties']['name']") }

        id = _calculate_id(name) + 1_000_000

        default_properties = {
          "createdate"=>"2022-09-13T15:06:03.116Z",
          "hs_lastmodifieddate"=>"2022-09-13T15:06:03.116Z",
          "hs_object_id"=>id.to_s,
          "hs_pipeline"=>"companies-lifecycle-pipeline",
          "lifecyclestage"=>"lead",
          "name"=>name
        }

        properties = default_properties.merge(properties)

        {
          "id"=>id.to_s,
          "properties"=> properties,
          "createdAt"=>"2022-09-13T15:06:03.116Z",
          "updatedAt"=>"2022-09-13T15:06:03.116Z",
          "archived"=>false
        }
      end
    end

    def companies_update(bodyhash)
      inputs = _fetch_inputs(bodyhash)

      inputs.map do |input|
        id = _fetch_input_id(input)
        properties = _fetch_input_properties(input)

        default_properties = {
          "hs_lastmodifieddate"=>"2022-09-13T15:06:33.116Z",
          "createdate"=>"2022-09-13T15:06:03.116Z",
          "hs_object_id"=>id.to_s,
          "hs_pipeline"=>"companies-lifecycle-pipeline",
          "lifecyclestage"=>"lead"
        }
        properties = default_properties.merge(properties)

        {
          "id"=>id.to_s,
          "properties"=>properties,
          "createdAt"=>"2022-09-13T15:06:03.116Z",
          "updatedAt"=>"2022-09-13T15:06:33.116Z",
          "archived"=>false
        }
      end
    end

    def companies_search_by_ids(ids)
      raise 'argument must be an Array' unless ids.is_a?(Array)
      raise 'Array must include only String ids' if ids.select { |x| ! x.is_a?(String) }.any?

      resp = ids.map do |id|
        if id.match(/666666/)
          # this represents not found records
          nil
        else
          {
            "id"=>id,
            "properties"=>{
              "createdate"=>"2022-09-13T15:06:03.116Z",
              "domain"=>nil,
              "hs_lastmodifieddate"=>"2022-09-13T15:20:48.331Z",
              "hs_object_id"=>id,
              "name"=>"ACME Company #{id}"},
            "createdAt"=>"2022-09-13T15:06:03.116Z",
            "updatedAt"=>"2022-09-13T15:20:48.331Z",
            "archived"=>false
          }
        end
      end

      resp.compact
    end

    def companies_search(*)
      puts _general_batch_search_should_be_overridden_msg('companies_search')
      raise "HubspotV3::MockContract.companies_search should be stubbed or overridden"
    end

    def _calculate_id(whatever)
      whatever.bytes.sum  # sum of asci values of the email string
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

    def _general_batch_search_should_be_overridden_msg(name)
      "General search queries are not covered by test contract and should be customly" +
      "\noverridden based on your usecase.  E.g.:" +
      "\n    expect(HubspotV3::MockContract)" +
      "\n      .to receive(:#{name})" +
      "\n      .and_return([{'id'=>'12345', 'properties'=>{  }])\n\n"
    end
  end
end
