var Editor, id;

Editor = function(input, preview) {
  this.update = function() {
    return preview.innerHTML = markdown.toHTML(input.value);
  };
  input.editor = this;
  return this.update();
};

id = function(id) {
  return document.getElementById(id);
};

new Editor(id("markdown"), id("preview"));

$(function() {
  $(".dropdown-button").dropdown({
    hover: false,
    constrain_width: 1000,
    alignment: 'right',
    belowOrigin: true
  });
  $('#m-share a').leanModal();
  $('#m-share .add a').leanModal({
    complete: function() {
      $('#modal-share').find('form')[0].reset();
      $('#modal-share').find('#email').blur();
      return $('#modal-share').find('.results-inner').remove();
    }
  });
  $('#m-share .add a').on('click', function(e) {
    return e.preventDefault();
  });
  $('#m-share .show a').on('click', function(e) {
    var docId;
    e.preventDefault();
    docId = location.pathname.split('/')[2];
    return $.ajax({
      url: '/search/files/' + docId,
      data: {
        docId: docId
      }
    }).then(function(data) {
      var html, sharedAccounts, source, template;
      sharedAccounts = data;
      $('.accounts-inner').remove();
      source = $('#accounts-template').html();
      template = Handlebars.compile(source);
      html = template(sharedAccounts);
      $('.accounts').append(html);
      return $('.shared-account-list .account-item').each(function(e) {
        var $target;
        $target = $(this);
        return $(this).find('a').on('click', function(e) {
          e.preventDefault();
          if ($(this).parents('.shared-account-list').find('.account-item').is(':hidden')) {
            $('.accounts-inner').empty().append('<p>No accounts.</p>');
          }
          data = {};
          data['_method'] = 'PUT';
          data['deleteAccount'] = sharedAccounts[$(this).parents('.account-item').index()]._id;
          $.ajax({
            url: '/files/' + docId,
            type: 'POST',
            data: data
          });
          $target.remove();
          if ($('.shared-account-list .account-item').length === 0) {
            return $('#modal-shared-list').closeModal();
          }
        });
      });
    });
  });
  $('.modal').find('form').on('submit', function(e) {
    var data, key;
    e.preventDefault();
    data = {};
    key = 'email';
    data[key] = $(this).find('input[name=email]').val();
    return $.ajax({
      url: $(this).attr('action'),
      data: data
    }).then(function(data) {
      var html, source, template;
      console.log('================================================');
      console.log('Get account search result');
      console.log('================================================');
      $('.results-inner').remove();
      source = $('#results-template').html();
      template = Handlebars.compile(source);
      html = template(data[0]);
      return $('.results').append(html);
    });
  });
  $(document).on('submit', '.results form', function(e) {
    var data, key;
    e.preventDefault();
    data = {};
    data['_method'] = 'PUT';
    key = 'shareAccountsEmail';
    data[key] = $(this).find('input[name=email]').val();
    return $.ajax({
      url: $(this).attr('action'),
      type: 'POST',
      data: data
    }).then(function(data) {
      console.log('================================================');
      console.log('Add share account data');
      console.log('================================================');
      $('#modal-share').closeModal();
      $('#modal-share').find('form')[0].reset();
      $('#modal-share').find('#email').blur();
      return $('#modal-share').find('.results-inner').remove();
    });
  });
});

//# sourceMappingURL=editor.js.map