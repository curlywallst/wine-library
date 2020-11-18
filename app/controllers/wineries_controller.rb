class WineriesController < ApplicationController

  get '/wineries' do
    @wineries = Winery.all
    erb :'wineries/index'
  end

  get '/wineries/:id/bottles' do
    winery = Winery.find(params[:id])
    @bottles = winery.bottles
    erb :'/bottles/index'
  end

  get '/wineries/:id' do
    @winery = Winery.find(params[:id])
    erb :'wineries/show'
  end

end
