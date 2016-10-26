#!/usr/bin/python
import sys,requests,boto.ec2

if len(sys.argv) == 4:
    zone=sys.argv[1]
    access_key=sys.argv[2]
    secret_key=sys.argv[3]
else:
    print "Usage "+sys.argv[0]+" <dnszone> <access_key> <secret_key>"
    sys.exit(1)

if zone == "dcoupon.com":
    sgid='sg-059d9d7c'
elif zone == "dcoupon.eu":
    sgid='sg-bd7994db'

PROTOCOL="tcp"
FROMPORT=str(3306)
TOPORT=str(3306)

myregion = requests.get('http://169.254.169.254/latest/meta-data/placement/availability-zone').text[:-1]
myip = requests.get('http://169.254.169.254/latest/meta-data/public-ipv4').text

ec2conn = boto.ec2.connect_to_region(myregion, aws_access_key_id=access_key, aws_secret_access_key=secret_key)
sg = ec2conn.get_all_security_groups(group_ids=sgid)

# Check if IP already granted access in rules:
for eachrule in sg[0].rules:
    for source in eachrule.grants:
        if myip+"/32" == str(source) and str(eachrule.ip_protocol) == PROTOCOL and str(eachrule.from_port) == FROMPORT and str(eachrule.to_port) == TOPORT:
            print "Rule already exists: "+PROTOCOL+","+FROMPORT+","+TOPORT+","+str(source)
            sys.exit(1)

# Otherwise grant access to IP:
sg[0].authorize(ip_protocol='tcp', from_port=FROMPORT, to_port=TOPORT, cidr_ip=myip+'/32')
print "Rule \""+PROTOCOL+","+FROMPORT+","+TOPORT+","+str(source)+"\" has been added to "+sgid
