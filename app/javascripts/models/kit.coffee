define ["models/instrument"], (Instrument) ->
  # A kit represents a collection of instruments.
  class Kit extends Backbone.Collection
    model: Instrument
