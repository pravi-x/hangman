# Hangman Game

This project is part of The Odin Project's Ruby curriculum. It's a command-line implementation of the classic Hangman game, where players try to guess a secret word letter by letter before running out of attempts.

## Features

- Generate a random secret word from a dictionary file
- Display the game state (remaining guesses, used letters, and current word progress)
- Allow players to make letter guesses
- Update the word display as correct guesses are made
- Track and display used letters
- Implement win/lose conditions
- Save and load game functionality

## Requirements

- Ruby (version 2.5 or higher recommended)
- Colorize gem (`gem install colorize`)

## How to Play

1. Clone this repository or download the `hangman.rb` file.
2. Make sure you have the required dictionary file (`google-10000-english-no-swears.txt`) in the same directory as the script.
3. Run the game by executing `ruby hangman.rb` in your terminal.
4. Choose to start a new game or load a saved game.
5. Guess letters one at a time to uncover the secret word.
6. You have 8 incorrect guesses before the game ends.
7. You can choose to save your game at the beginning of each turn.

## File Structure

- `hangman.rb`: The main game script
- `google-10000-english-no-swears.txt`: Dictionary file for secret words (not included in this repository)
- `save/`: Directory where saved games are stored (created automatically)

## Customization

You can modify the following variables in the `initialize` method to customize the game:

- `@min_length`: Minimum length of the secret word (default: 5)
- `@max_length`: Maximum length of the secret word (default: 12)
- `@remaining_guesses`: Number of allowed incorrect guesses (default: 8)

## Credits

This Hangman game was created as part of The Odin Project's Ruby curriculum. The project helps practice file I/O, serialization, and core Ruby concepts.

## License

This project is open source and available under the [MIT License](https://opensource.org/licenses/MIT).