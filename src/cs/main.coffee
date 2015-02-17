$ ->
  $(".dropdown-button").dropdown(
    hover: false
    constrain_width: 1000
    alignment: 'right'
    belowOrigin: true
  )

  $('.delete').leanModal()

  $('.agree button').on('click', ->
    $(this).parents('form').submit()
  )

  $('.modal .button').on('click', ->
    $(this).parents('.modal').closeModal()
  )

  return
