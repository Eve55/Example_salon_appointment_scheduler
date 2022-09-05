#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

SERVICES() {
  
  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi

  echo -e "\nWelcome to My Salon, how can I help you?\n"
  SERVICES=$($PSQL "SELECT*FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
  echo "$SERVICE_ID) $NAME"
  done
  echo "6) Exit"
  echo -e "\nPlease enter a service number."
  
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
  1) SET_APPOINTMENT ;;
  2) SET_APPOINTMENT ;;
  3) SET_APPOINTMENT ;;
  4) SET_APPOINTMENT ;;
  5) SET_APPOINTMENT ;;
  6) EXIT ;;
  *) SERVICES "I could not find that service. What would you like today?" ;;
  esac
  
}
  SET_APPOINTMENT(){
  
# if not number

if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
# send to SERVICES
SERVICES "That is not a valid service number."
else 
# show services
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

# if service no exist

if [[ -z $SERVICE_NAME ]]
then
SERVICES "No service with number: $SERVICE_ID_SELECTED"
else 
# get customer phone
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

# if customer doesn't exist
if [[ -z $CUSTOMER_NAME ]]
then
# get new customer name
echo -e "\nWhat's your name?"
read CUSTOMER_NAME

# insert new customer
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone,name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
fi
# ask for service time
echo -e "\nWhat time would you like you $SERVICE_ID_SELECTED, $CUSTOMER_NAME?"
read SERVICE_TIME

 # insert appointment
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
INSERT_APP=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

# show message
echo -e "\nI have put you down for a $(echo $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME | sed -E 's/^ +| +$//g')."
fi
fi
}
EXIT(){
  echo "Goodbye!"
}
SERVICES





