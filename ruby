require 'sinatra'
require 'twilio-ruby'

post '/call' do
  response = Twilio::TwiML::Response.new do |r|
    r.Say "This call will be recorded."
    r.Record action: ENV['BASE_URL'] + "/after-record"
  end

  content_type "text/xml"
  response.text
end

def twilio_client
  Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
end

post '/after-record' do
  user_phone_number = params['From']
  twilio_phone_number = params['To']
  url = params['RecordingUrl']

  twilio_client.messages.create(
    to: user_phone_number,
    from: twilio_phone_number,
    body: "Here's your recording: #{url}"
  )

 200
end
