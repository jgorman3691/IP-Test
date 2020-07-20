#!/usr/bin/env bash



# This is the section where I pull the public IP address, get the info from the file that currently holds the recorded public address, and creates a nicely formatted date.
# It also pulls the number from the counter file.

newip=$(eval curl -sSL icanhazip.com)
oldip=$(eval cat /etc/iptest/currentip)
change=$(date +"%A, %B %e, %Y")
counting=$(eval cat /etc/iptest/bash_counter)


# Ignore this section, it's for testing whether the variables were working or not.  They are working quite fine :-D
#echo "${newip}"
#echo "${oldip}"
#echo "${counting}"
#echo "${change}"

# This section is where I initialize the Bash Arrays that will hold the old and new IP addresses.  Instead of using sed or awk, I used the cut command with the delimiter
# as a period and the output delimiter as a space.  Doing this ensures that the array is properly initialized.  I could have done it in one statement, but meh.
old=()
new=()
old=($(cut -d "." -f 1-4 <<< ${oldip} --output-delimiter=" "))
new=($(cut -d "." -f 1-4 <<< ${newip} --output-delimiter=" "))


# More tests to see if the arrays were created and initialized properly.  The use of the @ sign I found because I read all those comments about the history of
# UNIX, and found out that this is an OLD command that replaces the $@ with $1, $2, $3...
#echo "${old[@]}";
#echo "${new[@]}";

# This is the branch that does the work.  The @ sign has already been explained, and I use Postfix and mailutils along with SMTP through Gmail to text
# myself.  Either nothing has changed, in which case I increment the count, send it to the counter file, and text myself the number.  Otherwise
# I text myself the number of days since the last change, send myself the new IP, store it, store the date of the change, and reset the counter.



if [[ ${old[@]} == ${new[@]} ]];then
	((counting++)); # echo "${counting}";
	echo "${counting}" | cat > /etc/iptest/bash_counter;
	echo "It's been ${counting} days since the last change.  There is nothing new to report." | mail 5618701924@vtext.com;
elif [[ ${old[@]} != ${new[@]} ]];then
	echo "It's been ${counting} days since the last change.  The new IP is ${newip}" | mail 5618701924@vtext.com;
	cat ${newip} > /etc/iptest/currentip;
	cat ${change} >> /etc/iptest/date_change;
	:>| /etc/iptest/bash_counter;
fi
