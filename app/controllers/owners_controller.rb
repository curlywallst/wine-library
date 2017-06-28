class OwnersController < ApplicationController

  get 'owners/cellar' do
    @bottles = current_user.bottles.all
    erb :'owners/cellar'
  end

  get '/owners/signup' do
    if !logged_in?
      erb :'owners/create_owner'
    else
      redirect "/owners/cellar"
    end
  end

  post '/owners/signup' do
    if params[:name].length >0 && params[:password].length >0
      @owner=Owner.new(:name => params[:name], :password => params[:password])
      if @owner.save
        session[:owner_id] = @owner.id
        redirect "owners/cellar"
      else
        redirect "/owners/signup"
      end
    else
      redirect "/owners/signup"
    end
  end

  get '/owners/login' do
    if !logged_in?
      erb :'owners/login'
    else
      redirect "owners/cellar"
    end
  end

  post 'owners/login' do
    @owner = User.find_by(:name => params[:name])
    if !!@owner && @owner.authenticate(params[:password])
      session[:owner_id] = @owner.id
      redirect "owners/cellar"
    else
      redirect "owners/login"
    end
  end



  get '/owners/logout' do
    if logged_in?
      session.clear
    end
    redirect "/owners/login"
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
