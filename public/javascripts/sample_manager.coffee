define ->
  # Triggers events after each individual sample is loaded and after all
  # samples are loaded.
  #
  #   sampleManager = new SampleManager(kick: "/sounds/kick.wav", snare: "/sounds/snare.wav")
  #   data = sampleManager.get("kick")
  class SampleManager
    constructor: (@context) ->
      _.extend(this, Backbone.Events)
      @samples = {}

    get: (name) ->
      @samples[name]

    loadSamples: (map) ->
      for name, url of map
        this.loadSample(name, url)

    loadSample: (name, url) ->
      @samples[name] = null
      request = new XMLHttpRequest()
      request.open("GET", url, true)
      request.responseType = "arraybuffer"
      request.onload = => this._onLoaded(name, request.response)
      request.send()

    _onLoaded: (name, data) =>
      buffer = @context.createBuffer(data, false)
      @samples[name] = buffer
      this.trigger("loaded", name, buffer)
