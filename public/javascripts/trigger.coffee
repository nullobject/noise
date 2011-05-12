define ->
  class Trigger extends Backbone.Model
    defaults:
      selected: false

    toggle: ->
      this.set(selected: !this.get("selected"))
