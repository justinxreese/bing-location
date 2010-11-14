require 'yaml'

config = YAML.load_file('../config/api.yml')
api_key = config['production']['key']
puts api_key
