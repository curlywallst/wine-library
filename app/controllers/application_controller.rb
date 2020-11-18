require './config/environment'
#
class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  register Sinatra::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    if !logged_in?
      erb :'index'
    else
      redirect '/cellar'
    end
  end

  helpers do

    def redirect_if_not_logged_in
      redirect '/' if !logged_in?
    end

    def logged_in?
      !!session[:owner_id]
    end

    def current_user
      Owner.find(session[:owner_id])
    end
  end



end
