define ->
  # Triggers events after each individual sample is loaded and after all
  # samples are loaded.
  #
  #   sampleManager = new SampleManager(context)
  #   sampleManager.loadSamples(kick: "/sounds/kick.wav", snare: "/sounds/snare.wav")
  #   buffer = sampleManager.get("kick")
  class SampleManager
    constructor: (@context) ->
      _.extend(this, Backbone.Events)
      @samples = {}
      @remaining = 0

    get: (name) ->
      @samples[name]

    loadSamples: (map) ->
      for name, url of map
        this.loadSample(name, url)

    loadSample: (name, url) ->
      @remaining++
      request = new XMLHttpRequest()
      request.open("GET", url, true)
      request.responseType = "arraybuffer"
      request.onload = => this._onSampleLoaded(name, request.response)
      request.send()

    _onSampleLoaded: (name, data) =>
      @remaining--
      @samples[name] = @context.createBuffer(data, false)
      this.trigger("sample:loaded", name, data)
      this.trigger("all:loaded") if @remaining == 0
