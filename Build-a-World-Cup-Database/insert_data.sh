#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE teams, games RESTART IDENTITY;" )

cat games.csv | while IFS=',' read -r _ _ THIRD FOURTH _
do
  [[ "$THIRD" == "winner" && "$FOURTH" == "opponent"  ]] && continue

  TEAM_ID_1=$($PSQL "SELECT team_id FROM teams WHERE name='$THIRD';")
  if [[ -z $TEAM_ID_1 ]]
  then
    INSERT_RESULT_1=$($PSQL "INSERT INTO teams(name) VALUES('$THIRD');")
  fi

  TEAM_ID_2=$($PSQL "SELECT team_id FROM teams WHERE name='$FOURTH';")
  if [[ -z $TEAM_ID_2 ]]
  then
    INSERT_RESULT_2=$($PSQL "INSERT INTO teams(name) VALUES('$FOURTH');")
  fi

done



cat games.csv | while IFS=',' read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  [[ "$YEAR" == "year" ]] && continue

  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'; " )

  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'; " )

  GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', $winner_id, $opponent_id, $WINNER_GOALS, $OPPONENT_GOALS)")


done
