#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -q -c"

# Generate a random number between 1 and 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
NUMBER_OF_GUESSES=0

# Read username
echo "Enter your username:"
read -r USERNAME

SAFE_USERNAME=${USERNAME//\'/\'\'}

# Find the user
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$SAFE_USERNAME'")

# Check if the user exists
if [[ -z $USER_ID ]]
then
    # Create a new user
    $PSQL "INSERT INTO users(username) VALUES('$SAFE_USERNAME')" > /dev/null

    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$SAFE_USERNAME'")

    echo "Welcome, $USERNAME! It looks like this is your first time here."
else
    # Get user statistics
    GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")

    BEST_GAME=$($PSQL "SELECT COALESCE(MIN(guesses), 0) FROM games WHERE user_id=$USER_ID")

    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Ask for the first guess
echo "Guess the secret number between 1 and 1000:"

# Game loop
while read -r GUESS
do
    NUMBER_OF_GUESSES=$(( NUMBER_OF_GUESSES + 1 ))

    # Check if the guess is an integer
    if [[ ! $GUESS =~ ^-?[0-9]+$ ]]
    then
        echo "That is not an integer, guess again:"

    # Check if the guess is correct
    elif [[ $GUESS -eq $SECRET_NUMBER ]]
    then
        # Save the game
        $PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $NUMBER_OF_GUESSES)" > /dev/null

        # Display the result
        echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

        exit 0

    # Guess is too high
    elif [[ $GUESS -gt $SECRET_NUMBER ]]
    then
        echo "It's lower than that, guess again:"

    # Guess is too low
    else
        echo "It's higher than that, guess again:"
    fi
done
