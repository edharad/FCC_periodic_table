#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c" 

START() {
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  PRINT_ATOM $1
fi
}

PRINT_ATOM() {
  INPUT=$1
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT' OR name='$INPUT';" | sed 's/ //g')
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT;" | sed 's/ //g')
  fi
  
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER;" | sed 's/ //g')
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER;" | sed 's/ //g')
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER;" | sed 's/ //g')
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER;" | sed 's/ //g')
    MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;" | sed 's/ //g')
    BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;" | sed 's/ //g')
    TYPE=$($PSQL "SELECT t.type FROM elements e LEFT JOIN properties p ON e.atomic_number = p.atomic_number LEFT JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number=$ATOMIC_NUMBER;" | sed 's/ //g')

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
}

START $1