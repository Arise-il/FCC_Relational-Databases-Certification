#! /bin/bash

PSQL="psql --username=postgres --dbname=salon -t --no-align -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "\nWelcome to My Salon, how can I help you?\n"

MAX_OPTION=$($PSQL "SELECT COUNT(*) FROM services;")

option(){
  for (( i=1 ; i<=MAX_OPTION ; i++  ))
  do
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $i;")
    echo "$i) $SERVICE_NAME" 
  done
}

option
read SERVICE_ID_SELECTED

until (( SERVICE_ID_SELECTED > 0 && SERVICE_ID_SELECTED < 4 ))
do
  echo -e "\nI could not find that service. What would you like today?"
  option
  read SERVICE_ID_SELECTED
done

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_SEARCH=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE' ;")

if [[ -z "$CUSTOMER_SEARCH" ]]
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  INSERT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
fi


echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
read SERVICE_TIME

customer_id=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE' ;")

SET_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$customer_id', '$SERVICE_ID_SELECTED', '$SERVICE_TIME') ;")

NAME_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED ;")

echo -e "\nI have put you down for a $NAME_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME.\n"
