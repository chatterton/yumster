window.Yumster or= {}
window.Yumster.Locations or= {}
window.Yumster.LocationManager or= {}

class LocationManager

  @CLUSTER_PERCENT = .1

  constructor: () ->
    @clear()

  addLocations: (locationArray, lat, lng, span) ->
    @locations = locationArray
    @currentLat = lat
    @currentLng = lng
    @currentSpan = span

  clear: () ->
    @locations = []
    @currentLat = null
    @currentLng = null
    @currentSpan = null

  canShow: (checkLat, checkLng, checkSpan) ->
    return @contains(@currentLat, @currentLng, @currentSpan, checkLat, checkLng, checkSpan)

  contains: (lat, lng, span, checkLat, checkLng, checkSpan) ->
    return ((checkLat - checkSpan / 2) >= (lat - span / 2)) and
      ((checkLat + checkSpan / 2) <= (lat + span / 2)) and
      ((checkLng - checkSpan / 2) >= (lng - span / 2)) and
      ((checkLng + checkSpan / 2) <= (lng + span / 2))

  getLocationsInArea: (lat, lng, span) ->
    locations = []
    for location in @locations
      if @contains(lat, lng, span, location.latitude, location.longitude, 0)
        locations.push location
    locations

  getClusterLocations: (lat, lng, span) ->
    cluster_size = span * LocationManager.CLUSTER_PERCENT
    clusters = []
    clusteredlocations = []
    locations = @getLocationsInArea(lat, lng, span)
    for location, i in locations
      if clusteredlocations.indexOf(location) >= 0
        continue
      cluster =
        locations: [location]
      for check, j in locations when j > i
        if @contains(location.latitude, location.longitude, cluster_size, check.latitude, check.longitude, 0)
          cluster.locations.push check
      if cluster.locations.length > 1
        longitudeSum = 0
        latitudeSum = 0
        for lc in cluster.locations
          clusteredlocations.push lc
          longitudeSum += lc.longitude
          latitudeSum += lc.latitude
        cluster.latitude = latitudeSum / cluster.locations.length
        cluster.longitude = longitudeSum / cluster.locations.length
        clusters.push cluster
    return clusters

  getMarkerLocations: (lat, lng, span) ->
    locations = @getLocationsInArea(lat, lng, span)
    clusters = @getClusterLocations(lat, lng, span)
    clustered = []
    for cluster in clusters
      clustered = clustered.concat cluster.locations
    return (loc for loc in locations when clustered.indexOf(loc) == -1)

$ ->
  window.Yumster.LocationManager = new LocationManager
  window.Yumster._LocationManager = LocationManager
