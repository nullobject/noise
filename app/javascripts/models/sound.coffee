define ->
  class Sound extends Backbone.Model
    defaults:
      buffer: null
      url:    null

    # Returns the buffer.
    getBuffer: -> this.get("buffer")

    # Returns the URL.
    getUrl: -> this.get("url")

    toString: -> @id
