require './config/environment'
#
class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :'index'
  end

  get '/signup' do
    if !logged_in?
      erb :'owners/create_owner'
    else
      redirect "/bottles"
    end
  end

  post '/signup' do
    if params[:name].length >0 && params[:password].length >0
      @owner=Owner.new(:name => params[:name], :password => params[:password])
      if @owner.save
        session[:owner_id] = @owner.id
        redirect "/bottles"
      else
        redirect "/signup"
      end
    else
      redirect "/signup"
    end
  end

  get '/login' do
    if !logged_in?
      erb :'owners/login'
    else
      redirect "/bottles"
    end
  end

  post '/login' do
    @owner = User.find_by(:name => params[:name])
    if !!@owner && @owner.authenticate(params[:password])
      session[:owner_id] = @owner.id
      redirect "/bottles"
    else
      redirect "/login"
    end
  end



  get '/logout' do
    if logged_in?
      session.clear
    end
    redirect "/login"
  end

	helpers do

		def logged_in?
			!!session[:owner_id]
		end

		def current_user
			User.find(session[:owner_id])
		end
	end

end
