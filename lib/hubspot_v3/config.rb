module HubspotV3
  class Config
    attr_writer :token, :contract

    def token
      @token || raise('Hubspot API key is not set. Set it with HubspotV3.config.token="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"')
    end

    def apikey=(*)
      raise 'Hubspot API keys are deprecated. Don\'t use HubspotV3.config.apikey="hubspotApiKeyNoLongerWorks".' +
       ' Make sure you set up Hubspot private app and set the token for this gem' +
       ' with HubspotV3.config.token="xxMyHubspotPrivateAppTokenxx"'
    end
  end

  def self.config
    @config ||= Config.new
  end
end
