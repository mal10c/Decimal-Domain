#!/bin/bash
#
# The MIT License (MIT)
#
# Copyright (c) 2016 Eric Ratliff
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Date Created:		2016-06-07
# -------------------------------------------------------------------------------------------
# Determines an "alternate" address that can be used for a given domain.
# For example, http://google.com also resolves to http://2811160616.
# The script determines the IPv4 address of a given domain, then converts that
# address to binary.  Next it converts that binary value to base 10.
# 
# NOTE: Some results may not properly resolve because some servers may have improperly configured
# 		reverse DNS entries!
# 
# To run, pass a domain as an argument without the protocol.
# 

# Ensure the user entered one argument, if not present an error and show the proper syntax
if [ $# -ne 1 ]; then
	echo "Invalid command syntax, please specify domain argument as follows:"
	echo -ne "\t$0 <domain>\n"
	echo ""
	echo "Example:"
	echo -ne "\t$0 google.com\n"
	exit 1
fi


# Decimal to 8-bit binary converter function
D2B=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1})

# Determine IPv4 IP address that belongs to incoming domain name, most will have more than one server so just get the first
ipAddr=`dig +short $1 | head -1`

# Convert the IPv4 address to binary - which will remove dots between the octets
ip=`echo "$ipAddr" | \
	sed 's/\(\([012]\?[0-9]\{1,2\}\)\.\([012]\?[0-9]\{1,2\}\)\.\([012]\?[0-9]\{1,2\}\)\.\([012]\?[0-9]\{1,2\}\)\)/\2\n\3\n\4\n\5/' | \
	while read octet
	do
		echo ${D2B[$octet]}
	done | tr -d '\n'`


# Convert binary IPv4 address to base 10
ipDec=`bc <<< "ibase=2;$ip"`

if [ "$ipDec" -ne 0 ]; then

	# Present the address to the user (http protocol is assumed)
	echo -ne "http://$ipDec\n"

else

	# Present an error code (1) back to the system to prevent it from running anything chained with the && operator
	echo "Invalid domain or domain does not support IPv4"
	exit 1

fi

# Successfully return control back to the system
exit 0
