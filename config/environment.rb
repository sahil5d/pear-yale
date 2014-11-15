# Load the Rails application.
require File.expand_path('../application', __FILE__)
require 'tzinfo' #time zone info

# Initialize the Rails application.
Pear::Application.initialize!

#CAS configuration
CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "https://secure.its.yale.edu/cas/",
  :username_session_key => :cas_user,
  :extra_attributes_session_key => :cas_extra_attributes
)
