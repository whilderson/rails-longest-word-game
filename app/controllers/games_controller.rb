require 'pry-byebug'
require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @word = params[:letterword]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    serialised = URI.open(url).read
    response = JSON.parse(serialised)['found']
    @message = if check_word_out_of_letters(@word, @letters) && response == 'true'
                 return 'Good game!'
               elsif response == 'false'
                 return "Sorry, but #{@word} is not an English word"
               else
                 return "Sorry, but #{@word} can't be build out of #{@letters.join(', ')}"
               end
    binding.pry
  end

  def make_hash_out_of_array(array)
    hash = {}
    array.each { |letter| hash[letter] ? hash[letter] += 1 : hash[letter] = 1 }
    hash
  end

  def check_word_out_of_letters(word, letter_array)
    letter_hash = make_hash_out_of_array(letter_array)
    word_hash = make_hash_out_of_array(word.split(''))
    word_hash.each { |k, v| return false if letter_hash[k] < v }
    true
  end
end
