#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

IS_NUMBER() {
  #ARG = $1
  ATOMIC_NUMBER_EXIST=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  #SYMBOL_EXIST=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
  #NAME_EXIST=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
  if [[ $ATOMIC_NUMBER_EXIST ]]
  then
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1")
    ELEMENT_SYMBOL_FORMATTED=$(echo $ELEMENT_SYMBOL | sed -r 's/^ *| *$//g')
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")
    ELEMENT_NAME_FORMATTED=$(echo $ELEMENT_NAME | sed -r 's/^ *| *$//g')
    ELEMENT_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $1")
    ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $ELEMENT_TYPE_ID")
    ELEMENT_TYPE_FORMATTED=$(echo $ELEMENT_TYPE | sed -r 's/^ *| *$//g')
    ELEMENT_PROPERTIES=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number = $1")
    echo "$ELEMENT_PROPERTIES" | while read ATOMIC_MASS BAR MP_CEL BAR BP_CEL
    do
      echo "The element with atomic number $1 is $ELEMENT_NAME_FORMATTED ($ELEMENT_SYMBOL_FORMATTED). It's a $ELEMENT_TYPE_FORMATTED, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME_FORMATTED has a melting point of $MP_CEL celsius and a boiling point of $BP_CEL celsius."
    done
  
  else
    echo I could not find that element in the database.
  fi
}

IS_STRING() {
  #ARG = $1
  #ATOMIC_NUMBER_EXIST=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ARG")
  SYMBOL_EXIST=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
  NAME_EXIST=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
  if [[ $SYMBOL_EXIST ]]
  then
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $SYMBOL_EXIST")
    ELEMENT_NAME_FORMATTED=$(echo $ELEMENT_NAME | sed -r 's/^ *| *$//g')
    ELEMENT_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $SYMBOL_EXIST")
    ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $ELEMENT_TYPE_ID")
    ELEMENT_TYPE_FORMATTED=$(echo $ELEMENT_TYPE | sed -r 's/^ *| *$//g')
    SYMBOL_EXIST_FORMATTED=$(echo $SYMBOL_EXIST | sed -r 's/^ *| *$//g')
    ELEMENT_PROPERTIES=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number = $SYMBOL_EXIST")
    echo "$ELEMENT_PROPERTIES" | while read ATOMIC_MASS BAR MP_CEL BAR BP_CEL
    do
      echo "The element with atomic number $SYMBOL_EXIST_FORMATTED is $ELEMENT_NAME_FORMATTED ($1). It's a $ELEMENT_TYPE_FORMATTED, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME_FORMATTED has a melting point of $MP_CEL celsius and a boiling point of $BP_CEL celsius."
    done
  elif [[ $NAME_EXIST ]]
  then
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $NAME_EXIST")
    ELEMENT_SYMBOL_FORMATTED=$(echo $ELEMENT_SYMBOL | sed -r 's/^ *| *$//g')
    ELEMENT_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $NAME_EXIST")
    ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $ELEMENT_TYPE_ID")
    ELEMENT_TYPE_FORMATTED=$(echo $ELEMENT_TYPE | sed -r 's/^ *| *$//g')
    NAME_EXIST_FORMATTED=$(echo $NAME_EXIST | sed -r 's/^ *| *$//g')
    ELEMENT_PROPERTIES=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number = $NAME_EXIST")
    echo "$ELEMENT_PROPERTIES" | while read ATOMIC_MASS BAR MP_CEL BAR BP_CEL
    do
      echo "The element with atomic number $NAME_EXIST_FORMATTED is $1 ($ELEMENT_SYMBOL_FORMATTED). It's a $ELEMENT_TYPE_FORMATTED, with a mass of $ATOMIC_MASS amu. $1 has a melting point of $MP_CEL celsius and a boiling point of $BP_CEL celsius."
    done
  else
    echo I could not find that element in the database.
  fi
}

if [[ $1 ]]
then
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    IS_STRING $1
  else
    IS_NUMBER $1
  fi

else
  echo Please provide an element as an argument.
fi
