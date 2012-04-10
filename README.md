# bing-location rubygem
## Important
This is nowhere near ready to be implemented. The code still includes debugging steps, please do not try to implement this without being willing to do some work to get it ready for your project
## Ignored File 'config/api.yml'
In order to run the tests in /test, the following file will need to be created as /config/api.yml. Alternatively, you can edit the test files to use a string for the API key. This step is not necessary to use the gem, for development purposes only.
    
    production:
     key: YOUR API KEY 
    development:
     key: YOUR API KEY 
     
## Install

    gem install bing-location --pre

## Dependencies
- net/http
- tempfile
- fileutils

## Example
    require 'location'
    
    my_loc = BingLocator.new()
    my_loc.api_key = 'YOUR API KEY GOES HERE' 
   
    # Using detailed addresses 
    # my_loc.country_region = 'US'
    # my_loc.admin_district = 'PA'
    # my_loc.locality = 'Pittsburgh'
    # my_loc.address_line = '738 William Pitt Union'
    
    # Using a query
    my_loc.query = '738 William Pitt Union Pittsburgh PA 15260'
    # my_loc.query = 'south side pittsburgh'
    # my_loc.query = 'eiffel tower'

    # Using latitude and longitude
    # my_loc.latitude = 40.383545
    # my_loc.longitude = -80.046509
    
    # Returning the results 
    # my_loc.obj_type = 'json'
    # my_loc.get_obj_by_address
    # puts my_loc.object
    puts my_loc.get_img_url_by_query(800,600)
