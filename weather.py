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
#apikey = "f2e3e8a493b540f9"
p = argparse.ArgumentParser(description="Retrieve and display weather for desired location")
p.add_argument("-z", dest="zip", help='ZIP Code')
p.add_argument("-c", dest="city", help='City')
p.add_argument("-s", dest="state", help='State')
args = p.parse_args()

def process(f):
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
	return	

if(args.zip != None):
	u = urllib2.urlopen('http://api.wunderground.com/api/%s/geolookup/conditions/q/%s.json' % (apikey, args.zip))
	process(u)
elif(args.city != None and args.state != None):
	city = re.sub(r"\s", "_", args.city)
	full = args.state +"/"+city
	u = urllib2.urlopen('http://api.wunderground.com/api/%s/geolookup/conditions/q/%s.json' % (apikey, full))
	process(u)
else:
	print p.print_help()

