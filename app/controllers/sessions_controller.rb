class SessionsController < ApplicationController
    get '/login' do
      if !logged_in?
        erb :'sessions/login'
      else
        redirect "/cellar"
      end
    end
  
    post '/login' do
      @owner = Owner.find_by(:name => params[:name])
      if @owner && @owner.authenticate(params[:password])
        session[:owner_id] = @owner.id
        redirect "/cellar"
      else
        redirect "/login"
      end
    end
  
    get '/logout' do
      if logged_in?
        session.clear
      end
      redirect "/"
    end
  end