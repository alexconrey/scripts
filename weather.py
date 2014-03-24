#Written by Alex Conrey - 2014
#Released under GPLv2 
#All that good stuff.
#Usage 'python weather.py -z 60142'
#or
#'python weather.py -c "Arlington Heights" -s IL
import urllib
import urllib2
import json
import argparse
import sys
import re
apikey = "f2e3e8a493b540f9"
p = argparse.ArgumentParser(description="weather.py")
p.add_argument("-z", dest="zip")
p.add_argument("-c", dest="city")
p.add_argument("-s", dest="state")
args = p.parse_args()

if(args.zip != None):
	f = urllib2.urlopen('http://api.wunderground.com/api/%s/geolookup/conditions/q/%s.json' % (apikey, args.zip))
elif(args.city != None and args.state != None):
	city = re.sub(r"\s", "_", args.city)
	full = args.state +"/"+city
	f = urllib2.urlopen('http://api.wunderground.com/api/%s/geolookup/conditions/q/%s.json' % (apikey, full))
else:
	print "nope"

json_string = f.read()
parsed_json = json.loads(json_string)
location = parsed_json['location']['city']
temp_f = parsed_json['current_observation']['temp_f']
feels_f = parsed_json['current_observation']['feelslike_f']
curweather = parsed_json['current_observation']['weather']
print "Current Weather Conditions in\n\t\t %s, %s %s" % (location, parsed_json['location']['state'], parsed_json['location']['zip'])
print "Current Temperature: %sF" % temp_f
print "\tFeels Like:  %sF" % feels_f
print "Current Weather:     %s" % curweather
f.close()

