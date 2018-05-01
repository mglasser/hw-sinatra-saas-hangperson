class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end

  attr_accessor :word, :guesses, :wrong_guesses

  # Player guesses a letter
  def guess(letter)
    # Error Handling
    if letter == nil ||  
       letter == '' || 
       letter =~ /[^A-Za-z]/
      raise ArgumentError, "Guess must be a letter"
    # Already guessed letter
    elsif @guesses.include?(letter.downcase) || @wrong_guesses.include?(letter.downcase)
      return false
    # Found a match -> add to @guesses
    elsif word.include?(letter.downcase)
      @guesses += letter 
    # No match -> add to @wrong_guesses
    else
      @wrong_guesses += letter 
    end
  end

  def word_with_guesses
    # Set up toDisplay as "----" matching length of word
    toDisplay = ""
    @word.chars do |letter|
      if @guesses.include? letter
        toDisplay += letter 
      else
        toDisplay += '-'
      end
    end
    toDisplay
  end

  def check_win_or_lose
    # 7 incorrect guesses -> lose
    if @wrong_guesses.length >= 7
      return :lose
    # Display word has no '-' -> guessed all letters -> win
    elsif !word_with_guesses.include? '-'
      return :win
    else
      return :play
    end
  end



  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
