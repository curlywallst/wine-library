class OwnersController < ApplicationController

  get '/owners' do
    erb :'owners/index'
  end

  get '/owners/cellar' do
    @bottles = current_user.bottles.all
    erb :'owners/cellar'
  end

  get '/owners/sort' do
    bottles = current_user.bottles.all
    @bottle_types = bottles.uniq{|x| x.wine_type}
    @bottle_wineries = bottles.uniq{|x| x.winery_id}
    erb :'owners/sort'
  end

  post '/owners/by' do
    if params[:winery_id]
      @bottles = current_user.bottles.all.select {|x| x.winery_id == params[:winery_id].to_i}
    # binding.pry
      erb :'bottles/index'
    elsif params[:wine_type]
      @bottles = current_user.bottles.all.select {|x| x.wine_type == params[:wine_type]}
      erb :'bottles/index'
    end
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

  post '/owners/login' do
    @owner = Owner.find_by(:name => params[:name])
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
    redirect "/"
  end

  helpers do

    def logged_in?
      !!session[:owner_id]
    end

    def current_user
      Owner.find(session[:owner_id])
    end
  end

end
