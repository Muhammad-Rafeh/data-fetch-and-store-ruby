require 'csv'
require 'net/http'
require 'json'

def write_into_csv(data)
  CSV.open('anime.csv', 'a') do |file|
    file << [data['data']['title'], data['data']['episodes'], data['data']['type']]
  end
end

def write_into_json(data)
  anime_json = stored_anime_json
  anime_json.push(data)
  formatted_json = JSON.pretty_generate(anime_json)
  File.write('anime.json', formatted_json)
end

def stored_anime_json
  stored_anime_json = File.read('anime.json')
  return [] if stored_anime_json.empty?

  JSON.parse(stored_anime_json)
end

anime_quote_api_endpoint = 'https://api.jikan.moe/v4/random/anime'
anime_quote_api_endpoint_uri = URI(anime_quote_api_endpoint)

response = Net::HTTP.get_response(anime_quote_api_endpoint_uri)

data = JSON.parse(response.body)

write_into_csv(data)
write_into_json(data)
