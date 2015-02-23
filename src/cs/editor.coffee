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

  $('#m-share a').leanModal()

  $('#m-share .add a').leanModal(
    complete: ()->
      $('#modal-share').find('form')[0].reset()
      $('#modal-share').find('#email').blur()
      $('#modal-share').find('.results-inner').remove()
  )

  $('#m-share .add a').on('click', (e)->
    e.preventDefault()
  )

  $('#m-share .show a').on('click', (e)->
    e.preventDefault()

    docId = location.pathname.split('/')[2]

    $.ajax(
      url: '/search/files/'+docId
      data:
        docId: docId
    ).then( (data)->
      sharedAccounts = data

      $('.accounts-inner').remove()
      source = $('#accounts-template').html()
      template = Handlebars.compile(source)
      html = template(sharedAccounts)
      $('.accounts').append(html)

      $('.shared-account-list .account-item').each( (e)->
        $target = $(this)
        $(this).find('a').on('click', (e)->
          e.preventDefault()

          if $(this).parents('.shared-account-list').find('.account-item').is(':hidden')
            $('.accounts-inner').empty().append('<p>No accounts.</p>')

          data = {}
          data['_method'] = 'PUT'
          data['deleteAccount'] = sharedAccounts[$(this).parents('.account-item').index()]._id

          $.ajax(
            url: '/files/'+docId
            type: 'POST'
            data: data
          )

          $target.remove()

          if $('.shared-account-list .account-item').length is 0
            $('#modal-shared-list').closeModal()
        )
      )
    )
  )

  $('.modal').find('form').on('submit', (e)->
    e.preventDefault()

    data = {}
    key = 'email'
    data[key] = $(this).find('input[name=email]').val()

    $.ajax(
      url: $(this).attr('action')
      data: data
    ).then( (data)->
      console.log '================================================'
      console.log 'Get account search result'
      console.log '================================================'
      $('.results-inner').remove()
      source = $('#results-template').html()
      template = Handlebars.compile(source)
      html = template(data[0])
      $('.results').append(html)
    )
  )

  $(document).on('submit', '.results form', (e)->
    e.preventDefault()

    data = {}
    data['_method'] = 'PUT'
    key = 'shareAccountsEmail'
    data[key] = $(this).find('input[name=email]').val()

    $.ajax(
      url: $(this).attr('action')
      type: 'POST'
      data: data
    ).then( (data)->
      console.log '================================================'
      console.log 'Add share account data'
      console.log '================================================'
      $('#modal-share').closeModal()
      $('#modal-share').find('form')[0].reset()
      $('#modal-share').find('#email').blur()
      $('#modal-share').find('.results-inner').remove()
    )
  )

  return
