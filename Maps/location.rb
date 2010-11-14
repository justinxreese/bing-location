require 'net/http'
require 'tempfile'
require 'fileutils'
require 'yaml'

# {API Documentation}[http://msdn.microsoft.com/en-us/library/ff701724.aspx]
class BingLocator
  attr_accessor	:country_region, :admin_district, :postal_code, :locality, 
		:address_line, :api_key, :obj_type, :query, :map_type, :show_traffic, 
		:zoom_level, # All above are possible sent values in REST request
		:name, :point, :latitude, :longitude, :admin_district_2, :formatted_address, :confidence, # Returned in REST object
		:object, :image # Returned Objects
  $img_base_url = "http://dev.virtualearth.net/REST/v1/Imagery/Map/"
  $obj_base_url = "http://dev.virtualearth.net/REST/v1/Locations/"

  # Makes assumptions for required fields that are not yet defined. Assumptions can be overridden by assigning values
  # [country_region] Country or region, i.e. 'US'
  # [admin_district] Administrative District. In the US this is State i.e. 'PA'
  # [postal_code] Postal code or zip code. i.e. '15213'
  # [locality] Locality The locality, such as the city or neighborhood, that corresponds to an address i.e. 'Pittsburgh'
  # [address_line] The official street line of an address relative to the area i.e. '430 Atwood St'
  # [obj_type] Type of object returned by REST request
  # [map_type] Imagery to use for maps
  # [zoom_level] Zoom level of a map
  def set_defaults
    self.country_region = '-' unless self.country_region
    self.admin_district = '-' unless self.admin_district
    self.postal_code    = '-' unless self.postal_code
    self.locality       = '-' unless self.locality
    self.address_line   = '-' unless self.address_line
    # Allowed values - json, xml
    self.obj_type = 'json'    unless self.obj_type
    # Allowed values - Aerial, AerialWithLabels, Road
    self.map_type = 'Road'    unless self.map_type
    # Allowed values - An integer between 1 and 22 
    self.zoom_level = '11'    unless self.zoom_level
  end

  # Uses the object's address to get a Location object from the Bing API. The object contains a normalized address, extra
  # information, and latitude, longitude information
  def get_obj_by_address
    self.set_defaults
    return 'No address set for location' if !self.country_region && !self.admin_district &&
					    !self.postal_code && !self.locality && !self.address_line
    # Reformat strings
    address_line = self.address_line.gsub(' ','%20')
    locality = self.locality.gsub(' ','%20')
    # Build request URL
    params = "#{self.country_region}/#{self.admin_district}/#{self.postal_code}/"
    params += "#{locality}/#{address_line}?o=#{self.obj_type}"
    request_url = $obj_base_url+params+"&key=#{self.api_key}"
    # REST request !
    begin
      self.object = Net::HTTP.get_response(URI.parse(request_url)).body 
      return self.object
    rescue
      return FALSE
    end
  end

  # Uses the object's latitude and longitude to get a Location object from the Bing API. 
  # The object contains a normalized address, extra information, and latitude, longitude information
  def get_obj_by_point
    self.set_defaults
    return 'No latitude or longitude set for location' unless self.latitude && self.longitude
    # Build request URL
    params = +"#{self.latitude},#{self.longitude}?o=#{self.obj_type}"
    request_url = $obj_base_url+params+"&key=#{self.api_key}"
    # REST request !
    begin
      self.object = Net::HTTP.get_response(URI.parse(request_url)).body 
      return self.object
    rescue
      return FALSE
    end
  end

  
  # Uses the object's query to get a Location object from the Bing API. 
  # The object contains a normalized address, extra information, and latitude, longitude information
  def get_obj_by_query
    self.set_defaults
    return 'No query set for location' if !self.query
    query = self.query.gsub(' ','%20')
    # Build request URL
    params = "#{query}?o=#{self.obj_type}"
    request_url = $obj_base_url+params+"&key=#{self.api_key}"
    # REST request !
    begin
      self.object = Net::HTTP.get_response(URI.parse(request_url)).body 
      return self.object
    rescue
      return FALSE
    end
  end

  # Uses the object's query to get an image file from the Bing API.
  #
  # The file will be returned as a File object. To save the file use something like the following: 
  #   File.rename(my_loc.get_img_by_query(800,600).path,'map.jpeg')
  def get_img_by_query(width,height)
    self.set_defaults
    return 'No query set for location' unless self.query
    query = self.query.gsub(' ','%20')
    # Build request URL
    params = "#{self.map_type}/#{query}?mapSize=#{width},#{height}"
    params += "&mapLayer=TrafficFlow" if self.show_traffic == TRUE 
    request_url = $img_base_url+params+"&key=#{self.api_key}"
    # REST request !
    begin
      tmp = Tempfile.new('map_image.jpeg')
      tmp.write Net::HTTP.get_response(URI.parse(request_url)).body 
      return tmp.flush
    rescue
      return FALSE
    end
  end

  # Uses the object's query to get an image url from the Bing API. Using the Bing URL is discouraged.
  def get_img_url_by_query(width,height)
    self.set_defaults
    return 'No query set for location' unless self.query
    query = self.query.gsub(' ','%20')
    # Build request URL
    params = "#{self.map_type}/#{query}?mapSize=#{width},#{height}"
    params += "&mapLayer=TrafficFlow" if self.show_traffic == TRUE 
    request_url = $img_base_url+params+"&key=#{self.api_key}"
    return request_url
  end
  
  # Uses the object's latitude and longitude to get an image url from the Bing API. 
  # Using the Bing URL is discouraged.
  def get_img_url_by_point(width,height)
    self.set_defaults
    return 'No latitude or longitude set for location' unless self.latitude && self.longitude
    # Build request URL
    params = "#{self.map_type}/#{self.latitude},#{self.longitude}/#{self.zoom_level}"
    params += "?mapSize=#{width},#{height}&pushpin=#{self.latitude},#{self.longitude}"
    params += "&mapLayer=TrafficFlow" if self.show_traffic == TRUE 
    request_url = $img_base_url+params+"&key=#{self.api_key}"
    return request_url
  end

  # Uses the object's latitude and longitude to get an image file from the Bing API.
  #
  # The file will be returned as a File object. To save the file use something like the following: 
  #   File.rename(my_loc.get_img_by_point(800,600).path,'map.jpeg')
  def get_img_by_point(width,height)
    self.set_defaults
    return 'No latitude or longitude set for location' unless self.latitude && self.longitude
    # Build request URL
    params = "#{self.map_type}/#{self.latitude},#{self.longitude}/#{self.zoom_level}"
    params += "?mapSize=#{width},#{height}&pushpin=#{self.latitude},#{self.longitude}"
    params += "&mapLayer=TrafficFlow" if self.show_traffic == TRUE 
    request_url = $img_base_url+params+"&key=#{self.api_key}"
    # REST request !
    begin
      tmp = Tempfile.new('map_image.jpeg')
      tmp.write Net::HTTP.get_response(URI.parse(request_url)).body 
      return tmp.flush
    rescue
      return FALSE
    end
  end

end

my_loc = BingLocator.new()
my_loc.api_key = YAML.load_file('../config/api_key.yml')['production']['key']

# my_loc.country_region = 'US'
# my_loc.admin_district = 'PA'
 my_loc.locality = 'Pittsburgh'
# my_loc.address_line = '48 Shady Dr W'
# my_loc.obj_type = 'json'
# my_loc.get_obj_by_address
# puts my_loc.object

my_loc.query = '48 Shady Dr W Pittsburgh PA 15228'
# my_loc.query = 'south side'
my_loc.latitude = 40.383545
my_loc.longitude = -80.046509

puts my_loc.get_img_url_by_query(800,600)
