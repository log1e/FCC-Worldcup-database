#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != 'winner' || $OPPONENT != 'opponent' ]] 
  then
    # GET TEAM_ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    # IF NOT FOUND
    if [[ -z $WINNER_ID ]] 
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      echo 'Winner inserted, $INSERT_WINNER_RESULT'
      # GET NEW TEAM_ID
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      
    fi

    # GET TEAM_ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    # IF NOT FOUND
    if [[ -z $OPPONENT_ID ]] 
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      
      echo 'Opponent inserted, $INSERT_OPPONENT_RESULT'
      # GET NEW TEAM_ID
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    fi
  fi


  if [[ $YEAR != 'year' ]]
    then
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round, opponent_id, winner_goals, opponent_goals, winner_id) VALUES($YEAR, '$ROUND', $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID)")
    fi
done
