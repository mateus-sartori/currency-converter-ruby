# app/services/currency_converter_service.rb
class CurrencyConverterService
  include HTTParty
  base_uri 'https://api.currencyapi.com/v3'

  def initialize
    @api_key = ENV["CURRENCY_API_KEY"]
  end

  def convert(from:, to:)
    response = self.class.get("/latest", query: {
      apikey: @api_key,
      base_currency: from,
      currencies: to
    })

    raise StandardError, response["error"]["message"] unless response.success?

    rate = response.parsed_response.dig("data", to, "value")
    raise StandardError, "Invalid response format" unless rate

    rate.to_f
  end
end
