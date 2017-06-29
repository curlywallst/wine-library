class BottlesController < ApplicationController

  get '/bottles' do
    @bottles = Bottle.all
    erb :'bottles/index'
  end

  get '/bottles/new' do
    bottles = Bottle.all
    @bottle_types = bottles.uniq{|x| x.wine_type}
    @bottle_wineries = bottles.uniq{|x| x.winery_id}
    erb :'bottles/new'
  end

  post '/bottles' do
    if !!params[:type]
      wine_type = params[:type]
    else
      wine_type = params[:wine_type]
    end

    if !!params[:winery_name]
      winery_name = params[:winery_name]
    else
      winery_name = params[:winery]
    end
    @bottle = Bottle.create(:wine_type => wine_type, :price => params[:price], :year => params[:year])
    winery = Winery.find_or_create_by(:name => winery_name)
    @bottle.winery_id = winery.id
    @bottle.owner_id = current_user.id
    winery.bottles << @bottle
    @bottle.save
    redirect "/bottles/#{@bottle.id}"
  end

  get '/bottles/:id/edit' do
    @bottle = Bottle.find(params[:id])
    if @bottle.owner_id == current_user.id
      erb :'bottles/edit'
    else
      erb :index
    end
  end

  patch '/bottles/:id'do
    @bottle = Bottle.find(params[:id])
    binding.pry
    @bottle.wine_type = params[:wine_type]
    @bottle.year = params[:year]
    @bottle.price = params[:price]
    @bottle.winery_id = params[:winery_id]
    @bottle.save
    redirect "/bottles/#{@bottle.id}"
  end

  get '/bottles/:id'do
    @bottle = Bottle.find(params[:id])
    erb :'bottles/show'
  end

  delete '/bottles/:id/delete' do
    @bottle = Bottle.find(params[:id])
    if @bottle.owner_id == current_user.id
      @bottle.delete
      redirect "/bottles"
    else
      erb :'index'
    end
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
