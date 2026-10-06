#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS #break up the data by line by commas and put them into the data lines after read comment
do
  if [[ $YEAR != "year" ]] #ignore the titles (not data) and enter data 
  then
    $PSQL "INSERT INTO teams(name) VALUES('$WINNER') ON CONFLICT (name) DO NOTHING" #name has unique restraint
    $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT') ON CONFLICT (name) DO NOTHING"

    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
    VALUES(
      $YEAR,
      '$ROUND',
      (SELECT team_id FROM teams WHERE name='$WINNER'),
      (SELECT team_id FROM teams WHERE name='$OPPONENT'),
      $WINNER_GOALS,
      $OPPONENT_GOALS
    )"
  fi
done < games.csv