$(function() {
  $(".dropdown-button").dropdown({
    hover: false,
    constrain_width: 1000,
    alignment: 'right',
    belowOrigin: true
  });
  $('.delete').on('click', function() {
    return $(this).submit();
  });
});

//# sourceMappingURL=main.js.map