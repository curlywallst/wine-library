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
    elsif !!params[:wine_type] && params[:wine_type] != ""
      wine_type = params[:wine_type]
    else
      raise ArgumentError.new('Must choose existing wine type or enter new wine type')
    end

    if !!params[:winery_name]
      winery_name = params[:winery_name]
    elsif !!params[:winery] && params[:winery] != ""
      winery_name = params[:winery]
    else
      raise ArgumentError.new('Must choose existing winery or enter new winery')
    end

    check_validity
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
      bottles = Bottle.all
      @bottle_types = bottles.uniq{|x| x.wine_type}
      @bottle_wineries = bottles.uniq{|x| x.winery_id}
      erb :'bottles/edit'
    else
      erb :index
    end
  end

  patch '/bottles/:id'do
    @bottle = Bottle.find(params[:id])
    if !!params[:wine_type] && params[:wine_type] != ""
      wine_type = params[:wine_type]
    elsif !!params[:type]
        wine_type = params[:type]
    else
      raise ArgumentError.new('Must choose existing wine type or enter new wine type')
    end

    if !!params[:winery] && params[:winery] != ""
      winery_name = params[:winery]
    elsif !!params[:winery_name]
      winery_name = params[:winery_name]
    else
      raise ArgumentError.new('Must choose existing winery or enter new winery')
    end

    @bottle.wine_type = wine_type
    @bottle.year = params[:year]
    @bottle.price = params[:price]
    winery = Winery.find_or_create_by(:name => winery_name)
    @bottle.winery_id = winery.id
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

    def check_validity
      if !(/^(19|20)[0-9][0-9]/).match?(params[:year])
        raise ArgumentError.new('Invalid Year - must be 4 digits starting with 19 or 20')
      end

      if !((/^\d+/).match?(params[:price]) || (/^\d+(\.\d{2})/).match?(params[:price]))
        raise ArgumentError.new('Invalid price - must be all digits starting with either no decimals or 2 decimals')
      elsif !(params[:price]==(/^\d+/).match(params[:price]).string || params[:price] == (/^\d+(\.\d{2})/).match(params[:price]).string)
        raise ArgumentError.new('Invalid price - must be all digits starting with either no decimals or 2 decimals')
      end
    end

    def logged_in?
      !!session[:owner_id]
    end

    def current_user
      Owner.find(session[:owner_id])
    end
  end

end
