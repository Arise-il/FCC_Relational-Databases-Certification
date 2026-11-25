#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -q"

if [[ -z "$1" ]]
then
    echo "Please provide an element as an argument."
    exit 0
fi

ELEMENT_INFO=$($PSQL -v element="$1" <<'SQL'
SELECT
    e.atomic_number,
    e.name,
    e.symbol,
    t.type,
    p.atomic_mass,
    p.melting_point_celsius,
    p.boiling_point_celsius
FROM elements AS e
JOIN properties AS p
    ON e.atomic_number = p.atomic_number
JOIN types AS t
    ON p.type_id = t.type_id
WHERE
    e.atomic_number::TEXT = :'element'
    OR e.symbol = :'element'
    OR e.name = :'element';
SQL
)

if [[ -z "$ELEMENT_INFO" ]]
then
    echo "I could not find that element in the database."
    exit 0
fi

IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT_INFO"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
