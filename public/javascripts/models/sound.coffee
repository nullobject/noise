define ->
  class Sound extends Backbone.Model
    defaults:
      buffer: null
      url:    null

    toString: ->
      @id
