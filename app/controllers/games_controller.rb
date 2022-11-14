require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @answer = params[:users_word]
    @letters = params[:letters].to_a
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    fetch = URI.open(url).read
    data = JSON.parse(fetch)
    @response = 'Hmmm... thats not in the dictionary...'
    @response = 'Well done' if data['found']
  end
end
