class BottlesController < ApplicationController

  get '/bottles' do
    redirect_if_not_logged_in
    @bottles = Bottle.all
    erb :'bottles/index'
  end

  get '/bottles/new' do
    redirect_if_not_logged_in
    @bottle_types = Bottle.all.uniq{|x| x.wine_type}
    @wineries = Winery.all
    erb :'bottles/new'
  end

  post '/bottles' do
    check_validity
    @bottle = current_user.bottles.create(:wine_type => @wine_type, :price => params[:price], :year => params[:year])
    winery = Winery.find_or_create_by(:name =>@winery_name)
    @bottle.winery_id = winery.id
    winery.bottles << @bottle
    @bottle.save
    redirect "/bottles/#{@bottle.id}"
  end

  get '/bottles/:id/edit' do
    redirect_if_not_logged_in
    @bottle = current_user.bottles.find(params[:id])
    if @bottle
      bottles = Bottle.all
      @bottle_types = bottles.uniq{|x| x.wine_type}
      @wineries = Winery.all
      erb :'bottles/edit'
    else
      erb :index
    end
  end

  patch '/bottles/:id' do
    @bottle = current_user.bottles.find(params[:id])
    check_validity
    @bottle.wine_type = @wine_type
    @bottle.year = params[:year]
    @bottle.price = params[:price]
    winery = Winery.find_or_create_by(:name => @winery_name)
    @bottle.winery_id = winery.id
    @bottle.save
    redirect "/bottles/#{@bottle.id}"
  end

  get '/bottles/:id'do
    @bottle = current_user.bottles.find(params[:id])
    erb :'bottles/show'
  end

  delete '/bottles/:id' do
    redirect_if_not_logged_in
    @bottle = current_user.bottles.find(params[:id])
    if @bottle
      @bottle.delete
      redirect "/cellar"
    else
      erb :'index'
    end
  end

  helpers do

    def check_validity

      if !!params[:type]
        @wine_type = params[:type]
      elsif !!params[:wine_type] && params[:wine_type] != ""
        @wine_type = params[:wine_type]
      else
        raise ArgumentError.new('Must choose existing wine type or enter new wine type')
      end

      if !!params[:winery_name]
        @winery_name = params[:winery_name]
      elsif !!params[:winery] && params[:winery] != ""
        @winery_name = params[:winery]
      else
        raise ArgumentError.new('Must choose existing winery or enter new winery')
      end

      if !(/^(19|20)[0-9][0-9]/).match?(params[:year])
        raise ArgumentError.new('Invalid Year - must be 4 digits starting with 19 or 20')
      end

      if !((/^\d+/).match?(params[:price]) || (/^\d+(\.\d{2})/).match?(params[:price]))
        raise ArgumentError.new('Invalid price - must be all digits starting with either no decimals or 2 decimals')
      elsif !(params[:price]==(/^\d+/).match(params[:price]).string || params[:price] == (/^\d+(\.\d{2})/).match(params[:price]).string)
        raise ArgumentError.new('Invalid price - must be all digits starting with either no decimals or 2 decimals')
      end
    end
  end

end
