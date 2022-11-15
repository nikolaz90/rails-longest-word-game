require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('a'..'z').to_a.sample }
  end

  def score
    @attempt = params[:users_word].upcase
    @letters = params[:letters].gsub!(" ", "").upcase
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    fetch = URI.open(url).read
    data = JSON.parse(fetch)
    define_response(@attempt, @letters, data)
  end

  def define_response(attempt, grid, data)
    @response = 'that has letters not in the grid...'
    @response = 'Hmmm... thats not in the dictionary...' if attempt_in_grid?(attempt, grid)
    @response = 'Well done' if data['found']
    @response = 'You have used to many letters' if over_used?(@attempt, @letters)
  end

  def attempt_in_grid?(attempt, grid)
    attempt_is_in_grid = true
    attempt.chars.each do |i|
      attempt_is_in_grid = false unless grid.include?(i)
    end
    attempt_is_in_grid
  end

  def over_used?(attempt, grid)
    attempt.chars.each { |item| return true if grid.count(item) < attempt.count(item) }
    false
  end
end
