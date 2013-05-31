#Geocoder.configure(

  # geocoding service (see below for supported options):
  ## This one works for bulk imports. Seems to quota at 10000 / day, maybe.
  #:lookup => :esri,

  # raise all errors
  #:always_raise => :all

  # to use an API key:
  #:api_key => "...",

  # geocoding service request timeout, in seconds (default 3):
  #:timeout => 5,

  # set default units to kilometers:
  #:units => :km,

  # caching (see below for details):
  #:cache => Redis.new,
  #:cache_prefix => "..."

#)
