require 'bundler/setup'
Bundler.require

require 'json'

require_relative 'strategies.rb'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def provider_key(provider)
    if session[:keys][provider]
      session[:keys][provider]
    else
      {status: "#{provider} not yet authenticated"}
    end
  end
end

configure do
  use OmniAuth::Builder do
    StrategyDSL.strategies.each do |name, strategy|
      provider name.to_sym,
        strategy.client_id,
        strategy.client_secret,
        scope: strategy.scopes.join(" ")
    end
  end

  enable :sessions
  set :session_secret, ENV['SESSION_SECRET']
end

get '/' do
  "Render template wot has buttons for enabled strategies"
end

get '/show/:provider' do
  content_type :json
  JSON.pretty_unparse(provider_key params[:provider])
end

get '/auth/:provider/callback' do
  auth_hash = request.env['omniauth.auth']
  session[:keys] ||= {}
  session[:keys][params[:provider]] = auth_hash
  redirect "/show/#{params[:provider]}"
end

get '/logout' do
  session.clear

  redirect '/'
end
