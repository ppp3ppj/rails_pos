Rails.configuration.to_prepare do
  class PPPError < StandardError
  end
  class PPPAuthenticationError < StandardError
  end
end
