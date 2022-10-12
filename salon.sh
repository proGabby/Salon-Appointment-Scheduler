#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICE_MENU(){
AVAILABLE_SERVICE=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
echo -e "\nAVAILABLE SERVICES ARE"
echo "$AVAILABLE_SERVICE" | while read SERVICE_ID BAR SERVICE_NAME
do
  echo "$SERVICE_ID) $SERVICE_NAME"
done
}

SERVICE_MENU
echo -e "\nPlease pick a service "
read SERVICE_ID_SELECTED
CHECK_PICKED_SERVICE=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
if [[ -z $CHECK_PICKED_SERVICE ]]
then
  SERVICE_MENU "Please enter a valid service option"
else
  echo -e "\nplease enter your phone number"
  read CUSTOMER_PHONE
  CUSTOMER_PHONE_FOUND=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
  #check if customer is available on db
  if [[ -z $CUSTOMER_PHONE_FOUND ]]
  then
      echo -e "\nplease enter your name"
      read CUSTOMER_NAME
      SAVE_CUSTOMER_ON_DB=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME');")
      echo -e "\nEnter appointment time"
      read SERVICE_TIME
      GET_CUSTOMER_ID=$($PSQL "SELECT customer_id from customers WHERE phone='$CUSTOMER_PHONE'")

      INSERT_APPOINT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($GET_CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")
      GET_SERVICE_NAME=$($PSQL "SELECT name From services WHERE service_id=$SERVICE_ID_SELECTED")
      echo "I have put you down for a $GET_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  else
      CUSTOMER_NAME_FOUND=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
      echo -e "\nEnter appointment time"
      read SERVICE_TIME
      GET_CUSTOMER_ID=$($PSQL "SELECT customer_id from customers WHERE phone='$CUSTOMER_PHONE'")

      INSERT_APPOINT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($GET_CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")
      GET_SERVICE_NAME=$($PSQL "SELECT name From services WHERE service_id=$SERVICE_ID_SELECTED")
      echo "I have put you down for a $GET_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME_FOUND."
  fi
fi


