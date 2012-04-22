require 'rubygems'
require 'bundler/setup'

require 'sinatra'

require_relative 'helpers'
require_relative 'models'

configure do
  enable :sessions
end

get '/' do
  "I am the Exception Muncher, and I am hungry!"
end

post '/v1/submit' do
  sub = ExceptionEntry.create title: params[:title],
                              body: params[:body],
                              ip: request.ip
end

get '/admin' do
  ensure_logged_in
  @exceptions = ExceptionEntry.all resolved: (params[:resolved] || false)
  erb :admin
end

get '/admin/exception/:id' do
  ensure_valid_exception
  erb :exception
end
get '/admin/exception/:id/resolve' do
  ensure_valid_exception
  @exception.resolved = true
  @exception.save
  redirect '/admin'
end
get '/admin/exception/:id/unresolve' do
  ensure_valid_exception
  @exception.resolved = false
  @exception.save
  redirect '/admin'
end
get '/admin/exception/:id/delete' do
  ensure_valid_exception
  @exception.destroy
  redirect '/admin'
end

get '/admin/login' do
  redirect '/admin/create_user' if no_users?
  redirect '/admin' if logged_in?
  erb :login
end

post '/admin/login' do
  user = User.first username: params[:username]
  if user
    if user.password == params[:password]
      session[:authenticated] = user
      redirect '/admin'
    else
      redirect '/login?error'
    end
  else
    redirect '/login?error'
  end
end

get '/admin/logout' do
  session.delete :authenticated
  redirect '/admin/login'
end

get '/admin/create_user' do
  halt 403, 'Admin already exists' unless no_users?
  halt 403, 'You\'re already logged in!' if logged_in?
  @user = User.new
  erb :create_user
end

post '/admin/create_user' do
  @user = User.create username: params[:username],
                      email: params[:email],
                      password: params[:password]
  if @user.valid?
    redirect '/admin/login'
  else
    erb :create_user
  end
end
