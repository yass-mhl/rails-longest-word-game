require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    # Créer un tableau de 10 lettres au hasard
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    raise
    # Récupere la réponse
    @answer = params[:word]
    # récupere la grille de lettre
    @grid = params[:grid]
    # Décompose la grille de lettre pour l'affichage
    grid_letters = @grid.each_char { |letter| print letter, '' }
    # Si les lettres ne corresspondent pas = false
    if !good_letters?
      @result = "Sorry, but #{@answer.upcase} can’t be built out of #{grid_letters}."
    elsif !english_word
      @result = "Sorry but #{@answer.upcase} does not seem to be an English word."
    elsif good_letters? && english_word
      @result = "Congratulation! #{@answer.upcase} is a valid English word."
    end
  end

  private

  def english_word
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    dictionary = URI.open(url).read
    word = JSON.parse(dictionary)
    word['found']
  end

  # savoir si les lettres utilisés sont bien dans @letters
  def good_letters?
    @answer.chars.sort.all? { |letter| @grid.include?(letter) }
  end
end
