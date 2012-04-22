require 'rubygems'
require 'bundler/setup'

require 'sinatra'

require_relative 'models'

get '/' do
  "I am the .NET Exception Muncher, and I am hungry!"
end

post '/v1/submit' do
  sub = ExceptionEntry.create title: params[:title],
                              body: params[:body],
                              ip: request.ip
end

