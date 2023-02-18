#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# loop to read through the csv file
echo $($PSQL "truncate teams, games restart identity")
echo -e "/n insterting data"
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != winner ]]
  then
    #need to add data to games and teams column
    #add data to teams
    #GET TEAM ID
    TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    #IF NOT FOUND
    if [[ -z $TEAM_ID ]]
    then
      #insert team
      INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams WINNER, $WINNER
      fi
    else 
      INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams OPPONENT, $OPPONENT
      fi
    fi
  fi
done

echo -e "/n insterting games"
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != winner ]]
then
  echo -e "adding games here"
  #add the game to games table
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
   if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
  then
    echo -e added the game round $ROUND OF YEAR $YEAR
  fi
fi
done
echo added games 










