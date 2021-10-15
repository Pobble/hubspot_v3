module HubspotV3
  class Config
    attr_writer :apikey, :contract

    def apikey
      @apikey || raise('Hubspot API key is not set. Set it with HubspotV3.config.apikey="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"')
    end
  end

  def self.config
    @config ||= Config.new
  end
end
