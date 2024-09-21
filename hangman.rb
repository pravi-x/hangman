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

  def menu_answer
    loop do
      puts "Enter your answer:".colorize(color: :blue, background: :white)
      answer = gets.chomp.to_i
      return answer if [1, 2].include?(answer)
    end
  end

  def display_before_move
    puts "\n"
    puts "REMAINING GUESSES: #{@remaining_guesses} ".colorize(color: :blue, background: :white)
    puts "USED LETTERS: #{@letters_used.join(', ')} ".colorize(color: :blue, background: :white)
    puts "SECRET: #{@mask} ".colorize(color: :blue, background: :white)
    puts "DO YOU WANT TO SAVE YOUR GAME? (y/n)".colorize(color: :gray, background: :white)
    answer = gets.chomp.upcase
    return ["Y", "YES"].include?(answer)
  end

  def display_win
    puts "CONGRATS!! YOU FOUND THE SECRET WORD, WITH #{@remaining_guesses} GUESSES REMAINING!! ".colorize(color: :white, background: :green)
    puts "SECRET: #{@secret_word} ".colorize(color: :white, background: :green)
  end

  def display_defeat
    puts "YOU USED ALL THE GUESSES. BETTER LUCK NEXT TIME  ".colorize(color: :red, background: :white)
    puts "SECRET WORD: #{@secret_word}  ".colorize(color: :red, background: :white)
  end

  def run
    puts "LET'S PLAY HANGMAN.".colorize(color: :blue, background: :white)
    puts " [1] START A NEW GAME ".colorize(color: :blue, background: :white)
    puts " [2] LOAD AN OLD GAME ".colorize(color: :blue, background: :white)

    case menu_answer
    when 1 then new_game
    when 2 then load_game
    end
  end
  
  def new_game
    loop do
      save = display_before_move
      if save
        save_game
      end
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

  def save_game
    # Implement functionality here
    puts "Game saved! " # Placeholder implementation
  end

  def load_game
    # Implement functionality here
    puts "Game loaded! " # Placeholder implementation
  end
end

Hangman.new.run