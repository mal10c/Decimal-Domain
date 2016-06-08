# Decimal-Domain
Script that creates an alternate URL for a given domain.

This is just a simple script that determines the IPv4 address of a given domain (example: google.com) 
then converts that IPv4 address to decimal - which removes the dots.

Finally the binary value is converted to base 10.

As an example, [google.com](http://google.com) will be converted to [http://2811160620](http://2811160620)

# How to run
This script has been tested on Linux Mint, so it should work on any Debian based distro.
To run, clone/download the get-decimal-domain.sh script and run it as follows:

```bash
./get-decimal-domain google.com
```
