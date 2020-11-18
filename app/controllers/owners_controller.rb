class OwnersController < ApplicationController

  get '/owners' do
    erb :'owners/index'
  end

  get '/cellar' do
    redirect_if_not_logged_in
    @bottles = current_user.bottles
    erb :'owners/cellar'
  end

  get '/owners/sort' do
    @bottle_types = current_user.bottles.uniq{|x| x.wine_type}
    @bottle_wineries = current_user.bottles.uniq{|x| x.winery_id}
    erb :'owners/sort'
  end

  post '/owners/by' do
    if params[:winery_id]
      @bottles = current_user.bottles.all.select {|x| x.winery_id == params[:winery_id].to_i}
      erb :'bottles/index'
    elsif params[:wine_type]
      @bottles = current_user.bottles.all.select {|x| x.wine_type == params[:wine_type]}
      erb :'bottles/index'
    end
  end

  get '/signup' do
    if !logged_in?
      erb :'owners/new'
    else
      redirect "/cellar"
    end
  end

  post '/owners/signup' do
    if params[:name].length >0 && params[:password].length >0
      @owner=Owner.new(:name => params[:name], :password => params[:password])
      if @owner.save
        session[:owner_id] = @owner.id
        redirect "/cellar"
      else
        redirect "/owners/signup"
      end
    else
      redirect "/signup"
    end
  end
end
