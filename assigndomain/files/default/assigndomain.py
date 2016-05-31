#!/usr/bin/python
import sys,requests
import boto.route53

if len(sys.argv) < 5 :
        print "Usage: " + sys.argv[0] + " <subdomain> <zone> <access_key> <secret_key>"
        exit(1)

res = requests.get('http://169.254.169.254/latest/meta-data/public-ipv4')
myip = res.text

#conn = boto.route53.connect_to_region('us-east-1')
conn = boto.route53.connection.Route53Connection(sys.argv[3],sys.argv[4])
zone = conn.get_zone(sys.argv[2])

if zone.find_records(sys.argv[1]+'.'+sys.argv[2],'A',desired=1):
    print "A record exists, updating " + sys.argv[1] + "." + sys.argv[2] + " to " + myip + " ..."
    zone.update_a(sys.argv[1].lower()+"."+sys.argv[2].lower(),myip,300)
else:
    print "A record doesn't exist, creating one ..."
    zone.add_a(sys.argv[1].lower()+"."+sys.argv[2].lower(),myip,300)
