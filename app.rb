require 'json'
require 'sinatra'
data = [ ] 

get '/' do
  content_type :json
  data.to_json
end

get '/hello/:name' do
  "Hello #{params['name']}!"
end

#GET /foo?par=value

post '/' do
  payload = JSON.parse(request.body.read)
  puts "got amazon request: #{payload['request'].to_s}\n"
  "Intent: #{payload['request']['intent'].to_s}\n"
  response = {} 
  response['version'] = '1.0'
  response['sessionAttributes'] = {
    "supportedPeriods" => {
      "daily" => true,
      "weekly" => false,
      "monthly" => false
    }
  }
  response['response'] = {}
  
  intent = payload['request']['intent']
  
  if (intent['name'] == "CountryFacts") then
    
    if (intent['slots']['CountryName']['value'] == "Sri Lanka") then
      puts "Got a request for CountryFacts for #{intent['slots']['CountryName']['value'].to_s}"
      response['response']["outputSpeech"] = {
        "type" => "PlainText",
        "text" => "Sri Lanka is a beautiful country, has mountains and flavourful foods to eat"
      }
      response['response']['shouldEndSession'] = true
    
    elsif (intent['slots']['CountryName']['value'] == "India") then
      puts "Got a request for CountryFacts for #{intent['slots']['CountryName']['value'].to_s}"
      response['response']["outputSpeech"] = {
        "type" => "PlainText",
        "text" => "India is another 3rd world country which is also beautiful, such as hiking, swiming, skydiving"
      }
      response['response']['shouldEndSession'] = true
    else
      puts "invalid country requested: #{intent['slots']['CountryName']['value']}"
      response['response']["outputSpeech"] = {
        "type" => "PlainText",
        "text" => "Ask for help or contact the front desk"
      }
      response['response']['shouldEndSession'] = true
      puts "invalid country requested: #{intent['slots']['CountryName']['value']}"
    end    
else
  response['response']["outputSpeech"] = {
    "type" => "PlainText",
    "text" => "I did not understand your request, please try again"
  }
  puts "Invalid intent name"
end
response.to_json.to_s
end

#go to the terminal cd .. - to get out of the directory, find the file and say ruby hello.rb, it run, get the port and open a new terminal - do the curl --- curl http://localhost:4567
#to kill the running - press control + c
# curl to test HTTP POST:
# curl -X POST -d "Param: value" http://localhost:4567/
# post JSON: curl -H "Content-Type: application/json" -X POST -d '{"username":"xyz","password":"xyz"}'  http://localhost:4567/