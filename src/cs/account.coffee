$ ->
  $(".dropdown-button").dropdown(
    hover: false
    constrain_width: 1000
    alignment: 'right'
    belowOrigin: true
  )

  $('#password').keyup( ->
    if $(this).val() isnt ''
      $('#password-re').attr('required', 'required')
    else
      $('#password-re').removeAttr('required', 'required')
  )

  $('#password-re').keyup( ->
    passwordCheck($(this).get(0))
  )

passwordCheck = (input) ->
  if input.value isnt document.getElementById('password').value
    input.setCustomValidity('Re type password is no match.')
  else
    input.setCustomValidity('')
  return
