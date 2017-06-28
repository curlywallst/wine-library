class BottlesController < ApplicationController

  get '/bottles' do
    @bottles = Bottle.all
    erb :'bottles/index'
  end

  get '/bottles/new' do
    erb :'bottles/new'
  end

  post '/bottles' do
    @bottle = Bottle.create(:wine_type => params[:wine_type], :price => params[:price], :year => params[:year])
    winery = Winery.find_or_create_by(:name => params[:winery])
    @bottle.winery_id = winery.id
    @bottle.owner_id = current_user.id
    @bottle.save
    redirect "/bottles/#{@bottle.id}"
  end

  get '/bottles/:id/edit' do
    @bottle = Bottle.find(params[:id])
    erb :'bottles/edit'
  end

  patch '/bottles/:id'do
    @bottle = Bottle.find(params[:id])
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
