require 'colorize'

class Hangman
  def initialize
    @min_length = 5
    @max_length = 12
    @secret_word = generate_secret_word
    @mask = '_ ' * @secret_word.length
    @remaining_guesses = 6
    @letters_used = []
  end

  def generate_secret_word
    words = File.readlines("google-10000-english-no-swears.txt").map(&:chomp).select { |word| word.length.between?(@min_length, @max_length) }
    words.sample.upcase
  rescue IOError => e
    puts "An error occurred while reading the file: #{e.message}"
  end

  def guess
    loop do
      puts "Enter your guess:".colorize(color: :blue, background: :white)
      g = gets.chomp.upcase
      return g if g.match?(/^[A-Z]$/)
    end
  end

  def display_before_move
    puts "\n"
    puts "REMAINING GUESSES: #{@remaining_guesses}".colorize(color: :blue, background: :white)
    puts "USED LETTERS: #{@letters_used.join(', ')}".colorize(color: :blue, background: :white)
    puts "SECRET: #{@mask}".colorize(color: :blue, background: :white)
  end

  def display_win
    puts "CONGRATS!! YOU FOUND THE SECRET WORD, WITH #{@remaining_guesses} GUESSES REMAINING!!".colorize(color: :green, background: :white)
    puts "SECRET: #{@secret_word}".colorize(color: :green, background: :white)
  end

  def display_defeat
    puts "YOU USED ALL THE GUESSES. BETTER LUCK NEXT TIME".colorize(color: :red, background: :white)
    puts "SECRET WORD: #{@secret_word}".colorize(color: :red, background: :white)
  end

  def run
    puts "LET'S PLAY HANGMAN. YOU HAVE #{@remaining_guesses} GUESSES TO FIND THE SECRET WORD".colorize(color: :blue, background: :white)
    puts "\t#{@mask}".colorize(color: :blue)

    loop do
      display_before_move
      letter = guess
      if @secret_word.include?(letter)
        update_mask(letter)
      else
        @letters_used << letter
        @remaining_guesses -= 1
      end

      break if end?
    end
  end

  def update_mask(letter)
    @secret_word.chars.each_with_index do |char, index|
      @mask[index * 2] = char if char == letter
    end
  end

  def end?
    if @remaining_guesses.zero?
      display_defeat
      true
    elsif @secret_word == @mask.delete(' ')
      display_win
      true
    else
      false
    end
  end
end

Hangman.new.run