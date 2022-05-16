# frozen_string_literal: true

require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
    @time = Time.now
  end

  def score
    @letters = params[:letters].split
    @word = params[:word]
    @time = params[:time]
    @score = 0
    session[:score] ||= 0
    if !word_is_possible(@word, @letters)
      @status = "Sorry but #{@word} can't be built out of #{@letters.join(', ')}"
    elsif !word_exists(@word)
      @status = "Sorry but #{@word} does not seem to be a valid English word"
    else
      @status = "Congratulations! #{@word} is a valid English word"
      @score = (@word.size * 10 - (Time.now - Time.parse(@time))).round
      session[:score] += @score
    end
  end

  private

  def word_exists(word)
    response = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{word.strip}").read)
    response["found"]
  end

  def word_is_possible(word, letters)
    arr = letters.clone
    word.upcase.chars.all? { |l| arr.delete_at(arr.index(l)) if arr.include? l }
  end
end
