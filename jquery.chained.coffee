$ = jQuery
class Link
  constructor: (@$el, @$parent, @options) ->
    $.extend true, @options, @$el.data()
    @$parent.on 'change', @reset

  remoteLoaderUrl: => @$parent.find('option:selected').data().url

  reset: =>
    @$el.attr('disabled', true)
    @$el.html("<option>Loading...</option>")
    $.getJSON  @remoteLoaderUrl(), @populate if @remoteLoaderUrl()?
    @$el.attr('disabled', false)
    false

  populate: (cities) =>
    @$el.html ("<option value='#{city.id}'>#{city.name}</option>" for city in cities)
    @$el.select2() # refactor dependency

class Chain
  constructor: (@$el, $parent, options) ->
    @links = []
    @addLink($parent, options)

  addLink: ($parent, options) =>
    link = new Link(@$el, $parent, options)
    @links.push link

$.fn.chained = ($parent, options={}) ->
  @each ->
    $el = $(@)

    if (api = $el.data('Chain'))?
      api.addLink($parent, options)
    else
      api = new Chain($el, $parent, options)

      $el.data('Chain', api)
    $el