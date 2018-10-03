#!/bin/bash
# GET request to contacts API (250 Contacts/request) & Pipe JSON to file contactlist.txt
#slyons-interlaced-2018
curl https://api.hubapi.com/contacts/v1/lists/all/contacts/all\?hapikey\=c5c5658b-73a6-40d0-bcb5-8f5eb72ea7a1\&count\=100 > contacts.txt
# Trimming JSON file to only include Firstname / Lastname and piping accordingly to file
cat contacts.txt |tr , '\n'|grep firstname|cut -c37-|rev|cut -c 3-|rev > firstnames.txt
cat contacts.txt |tr , '\n'|grep lastname|cut -c22-|rev|cut -c 4-|rev > lastnames.txt
## Add whatever interlace wants here -- Phone Number -- Organization --

#Create offset variable
offset=(`tail contacts.txt|tr , '\n'|grep vid-offset|sed 's/[^0-9]*//g'`)
echo $offset > offset.txt

# Add all firstnames to array1
while read line; do
  array1+=("$line")
done < firstnames.txt
# Add all lastnames to array2
while read line; do
  array2+=("$line")
done < lastnames.txt

#call corresponding array value (firstname lastname)
paste <(printf "%s\n" "${array1[@]}") <(printf "%s\n" "${array2[@]}") > contacts.txt

#Cleaning up contacts list (Whitespace management)
awk '{$2=$2};1' contacts.txt > contactlist.txt

#Cleaning up sorted files
rm -rf firstnames.txt
rm -rf lastnames.txt
rm -rf contacts.txt

##variablize offset value
offset=(`cat offset.txt`)

## Loop the logic so long as offset contains value -- remember to duplicate here dummy
while  [ "$offset" -gt "1" ]; do
  curl https://api.hubapi.com/contacts/v1/lists/all/contacts/all\?hapikey\=c5c5658b-73a6-40d0-bcb5-8f5eb72ea7a1\&count=250\&vidOffset=$offset > contacts.txt
  # Trimming JSON file to only include Firstname / Lastname and piping accordingly to file
  cat contacts.txt |tr , '\n'|grep firstname|cut -c37-|rev|cut -c 3-|rev > firstnames.txt
  cat contacts.txt |tr , '\n'|grep lastname|cut -c22-|rev|cut -c 4-|rev > lastnames.txt
  ## Add whatever filter here -- Phone Number -- Organization --

  #Create offset variable
  offset=(`tail contacts.txt|tr , '\n'|grep vid-offset|sed 's/[^0-9]*//g'`)
  echo $offset > offset.txt

  # Add all firstnames to array1
  while read line; do
    array1+=("$line")
  done < firstnames.txt
  # Add all lastnames to array2
  while read line; do
    array2+=("$line")
  done < lastnames.txt

  #call corresponding array value (firstname lastname)
  paste <(printf "%s\n" "${array1[@]}") <(printf "%s\n" "${array2[@]}") > contacts.txt

  #Cleaning up contacts list (Whitespace management)
  awk '{$2=$2};1' contacts.txt > contactlist.txt;
  mv contactlist.txt AllContacts.txt

  #Cleaning up sorted files
  rm -rf firstnames.txt
  rm -rf lastnames.txt
  rm -rf contacts.txt
  rm -rf offset.txt
done

echo "Done Syncing..."