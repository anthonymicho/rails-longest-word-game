class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
   @letters = Array.new(10) { alphabet.sample }
   session[:letters] = @letters
  end

def score
    @word = params[:word].upcase
    @letters = session[:letters]
    @result = {}

    if included_in_grid?(@word, @letters)
      if english_word?(@word)
        @result[:message] = "Congratulations! #{@word} is a valid English word."
        @result[:score] = @word.length
      else
        @result[:message] = "Sorry but #{@word} is not a valid English word."
        @result[:score] = 0
      end
    else
      @result[:message] = "Sorry but #{@word} can't be built out of #{@letters.join(', ')}"
      @result[:score] = 0
    end
  end

  private

  def included_in_grid?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  rescue
    false
  end
end
