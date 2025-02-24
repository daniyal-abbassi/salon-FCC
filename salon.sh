#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "$1\n"
  fi
  echo -e "Welcome to My Salon, how can I help you?\n"
  SERVICES_INFO=$($PSQL "SELECT service_id,name FROM services ORDER BY service_id")
  echo "$SERVICES_INFO" | while IFS="|" read -r ID SERVICE_NAME
  do
    ID=$(echo "$ID" | xargs)
    SERVICE_NAME=$(echo "$SERVICE_NAME" | xargs)
    echo "$ID) $SERVICE_NAME"
  done
  #get user input
  read SERVICE_ID_SELECTED
  
  #if service id was not valid
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then 
    MAIN_MENU "I could not find that service."
    return
  fi
  # see if service is available
  SERVICE_EXISTS=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_EXISTS ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
    return
  else 
    SET_APPOINTEMENTS
  fi
  #user select a service
  # case $SERVICE_ID_SELECTED in
  #   1) SET_APPOINTEMENTS ;;
  #   2) SET_APPOINTEMENTS ;;
  #   3) SET_APPOINTEMENTS ;;
  #   4) SET_APPOINTEMENTS ;;
  #   5) SET_APPOINTEMENTS ;;
  #   *) echo "$SERVICES_INFO" | while IFS="|" read -r ID SERVICE_NAME
  # do
  #   ID=$(echo "$ID" | xargs)
  #   SERVICE_NAME=$(echo "$SERVICE_NAME" | xargs)
  #   echo "$ID) $SERVICE_NAME"
  # done ;;
  # esac
}



SET_APPOINTEMENTS() {
  #get service info 
  SERVICE_NAME=$($PSQL "SELECT name from services WHERE service_id=$SERVICE_ID_SELECTED")
  #get customer phone number
  echo "What's your phone number?"
  read CUSTOMER_PHONE
  # search in customers for that phone number(its name)
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # if this is new customer, take its name
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo I don't have a record for that phone number, what's your name?
    read CUSTOMER_NAME
    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    
    #set a time appointement
    echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    # add the new customer in appointements for that service
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(service_id,time) VALUES($SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  else
    echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(service_id,time) VALUES($SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi

  
}

MAIN_MENU
