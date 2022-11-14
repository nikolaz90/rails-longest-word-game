require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @answer = params[:users_word]
    @letters = params[:letters].gsub!(" ", "").upcase
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    fetch = URI.open(url).read
    data = JSON.parse(fetch)
    if attempt_in_grid?(@answer, @letters)
      @response = 'Hmmm... thats not in the dictionary...'
      @response = 'Well done' if data['found']
    else
      @response = 'that has letters not in the grid...'
    end
  end

  def attempt_in_grid?(attempt, grid)
    attempt_is_in_grid = true
    attempt.chars.each do |i|
      attempt_is_in_grid = false unless grid.include?(i.upcase)
    end
    attempt_is_in_grid
  end
end
