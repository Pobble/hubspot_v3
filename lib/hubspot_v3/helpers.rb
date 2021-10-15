module HubspotV3
  module Helpers
    extend self

    def map_search_by_email(results_ary)
      results_ary.inject({}) do |hash, result|
        hash[result.fetch('properties').fetch('email')] = result
        hash
      end
    end
  end
end
