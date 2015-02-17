$(function() {
  $(".dropdown-button").dropdown({
    hover: false,
    constrain_width: 1000,
    alignment: 'right',
    belowOrigin: true
  });
  $('.delete').leanModal();
  $('.agree button').on('click', function() {
    return $(this).parents('form').submit();
  });
  $('.modal .button').on('click', function() {
    return $(this).parents('.modal').closeModal();
  });
});

//# sourceMappingURL=main.js.map