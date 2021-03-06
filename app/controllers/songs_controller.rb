require 'sinatra/base'
require 'rack-flash'

class SongsController < ApplicationController
   enable :sessions
   use Rack::Flash

   get '/songs' do
      erb :'songs/index'
   end

   get '/songs/new' do
      erb :'songs/new'
   end

   post '/songs' do
      @song = Song.create(name: params[:Name])
      @song.artist = Artist.find_or_create_by(name: params["Artist Name"])
      params[:genres].each {|genre| @song.genres << Genre.find(genre)}
      @song.save
      flash[:message] = "Successfully created song."
      redirect to "/songs/#{@song.slug}"
   end

   get '/songs/:slug' do
      # binding.pry
      @song = Song.find_by_slug(params[:slug])
      erb :'songs/show'
   end

   get '/songs/:slug/edit' do
      @song = Song.find_by_slug(params[:slug])
      erb :'songs/edit'
   end

   patch '/songs/:slug' do
      @song = Song.find_by_slug(params[:slug])
      @song.name = params[:Name]
      @song.artist = Artist.find_or_create_by(name: params["Artist Name"])
      @song.genres = []
      params[:genres].each do |genre|
         @song.genres << Genre.find(genre)
      end
      @song.save
      flash[:message] = "Successfully updated song."
      redirect to "/songs/#{@song.slug}"
   end
end
