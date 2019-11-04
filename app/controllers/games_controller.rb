require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a.sample }
    @start_time = Time.now
  end

  def score
    @answer = params[:answer].upcase
    @generated = params[:letters].upcase
    @duration = Time.now - Time.parse(params[:time])
    @score = ((@answer.length / @duration) * 100).to_i
    if api(@answer)['found']
      checker(@answer, @generated) ? @result = "Congratulations! #{@answer} is a valid English word!" : @result = "Sorry but #{@answer} can't be built out of #{@generated}!"
    else
      @result = "Sorry but #{@answer} doesn't seem to be a valid English word.."
    end
    raise
  end

  def checker(word, grid)
    word_array = word.upcase.split('')
    charac_check = true if word_array.all? { |c| grid.include? c }
    try = word_array.all? do |letter|
      word_array.count(letter) <= grid.count(letter)
    end
    charac_check && try
  end

  def api(answer)
    url = "http://wagon-dictionary.herokuapp.com/#{answer}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    word
  end
end


# How to call instance variable inside a different method
# How to call a method in erb
