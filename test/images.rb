require '../lib/location'
require 'yaml'

my_loc = BingLocator.new()
my_loc.api_key = YAML.load_file('../config/api.yml')['production']['key']

# my_loc.country_region = 'US'
# my_loc.admin_district = 'PA'
 my_loc.locality = 'Pittsburgh'
# my_loc.address_line = '48 Shady Dr W'
# my_loc.obj_type = 'json'
# my_loc.get_obj_by_address
# puts my_loc.object

# my_loc.query = '48 Shady Dr W Pittsburgh PA 15228'
# my_loc.query = 'south side'
my_loc.query = 'eifel tower'
# my_loc.latitude = 40.383545
# my_loc.longitude = -80.046509

puts my_loc.get_img_url_by_query(800,600)
