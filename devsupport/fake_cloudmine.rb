require 'sinatra'
require 'json'

get '/text' do
  {
    "success" => {
      params[:keys] => {
        "name" => "George Washington", # not implemented in cloudmine. but would be cool
        "sites" => [
          'http://en.wikipedia.org/wiki/George_Washington',
          'http://en.wikipedia.org/wiki/American_Revolutionary_War',
          'http://www.nps.gov/wamo/index.htm'
        ],
        "eyesOn" => "http://www.w3schools.com/cssref/css3_pr_border-radius.asp"
      }
    },
    "errors" => {
    }
  }.to_json
end

get '*' do
  status 404
  "Not Found\n"
end
