class WineriesController < ApplicationController

  get '/wineries' do
    @wineries = Winery.all
    erb :'wineries/index'
  end

  get '/wineries/:id/edit' do
    @winery = Winery.find(params[:id])
    erb :'wineries/edit'
  end

  patch '/wineries/:id'do
    @winery = Winery.find(params[:id])
    @winery.name = params[:name]
    @winery.save
    redirect "/wineries/#{@winery.id}"
  end

  get '/wineries/:id' do
    @winery = Winery.find(params[:id])
    erb :'wineries/show'
  end

end
