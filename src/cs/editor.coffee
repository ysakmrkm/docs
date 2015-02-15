Editor = (input, preview) ->
  @update = ->
    preview.innerHTML = markdown.toHTML(input.value);

  input.editor = this

  @update()

id = (id) ->
  return document.getElementById(id)

new Editor(id("markdown"), id("preview"));

$ ->
  $(".dropdown-button").dropdown(
    hover: false
    constrain_width: 1000
    alignment: 'right'
    belowOrigin: true
  )

  return
