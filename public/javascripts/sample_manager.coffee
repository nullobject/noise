define ->
  # Triggers events after each individual sample is loaded and after all
  # samples are loaded.
  #
  #   sampleManager = new SampleManager(kick: "/sounds/kick.wav", snare: "/sounds/snare.wav")
  #   data = sampleManager.get("kick")
  class SampleManager
    constructor: (@map) ->
      _.extend(this, Backbone.Events)

    loadSample: (url) ->
      request = new XMLHttpRequest()
      request.open("GET", "/sounds/test.wav", true)
      request.responseType = "arraybuffer"
      request.onload = -> handler(request.response)
      request.send()

    _onLoaded: (data) =>

