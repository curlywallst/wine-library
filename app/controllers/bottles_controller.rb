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

  get '/bottles/:id'do
    @bottle = Bottle.find(params[:id])
    erb :'bottles/show'
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
