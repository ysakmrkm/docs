$ ->
  $(".dropdown-button").dropdown(
    hover: false
    constrain_width: 1000
    alignment: 'right'
    belowOrigin: true
  )

  $('.delete').on('click', ->
    $(this).submit()
  )

  return
