Settings.define :api_salt, 
  :env_var => "ADDONS_API_SALT", 
  :description => "Salt used for hashing login",
  :required => true
Settings.define :api_password, 
  :env_var => "ADDONS_API_PASSWORD", 
  :description => "Addons API password", 
  :required => true
