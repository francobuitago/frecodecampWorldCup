#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    #get winner team id
    TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")

    #if not found winner team
    if [[ -z $TEAM_ID ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "insert into teams (name) values ('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then 
        echo Inserted into teams, $WINNER
      fi
    fi

    #get opponent team id
    TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

    #if not found opponent team
    if [[ -z $TEAM_ID ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "insert into teams (name) values ('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then 
        echo Inserted into teams, $OPPONENT
      fi
    fi

    #Fullfill games
    WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
    INSERT_GAME_RESULT=$($PSQL "insert into games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) values ($YEAR, '$ROUND',$WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    

  fi
done
