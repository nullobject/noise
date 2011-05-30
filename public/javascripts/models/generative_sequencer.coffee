define ->
  # A generative sequencer represents a pattern of notes which bounce around
  # and trigger sounds when they collide with the edges of the pattern.
  #
  # A generative sequencer has a Pattern and a TunedInstrument.
  class GenerativeSequencer extends Backbone.Model
    initialize: ->

    tick: (currentTime) ->
