var passwordCheck;

$(function() {
  $(".dropdown-button").dropdown({
    hover: false,
    constrain_width: 1000,
    alignment: 'right',
    belowOrigin: true
  });
  $('#password').keyup(function() {
    if ($(this).val() !== '') {
      return $('#password-re').attr('required', 'required');
    } else {
      return $('#password-re').removeAttr('required', 'required');
    }
  });
  return $('#password-re').keyup(function() {
    return passwordCheck($(this).get(0));
  });
});

passwordCheck = function(input) {
  if (input.value !== document.getElementById('password').value) {
    input.setCustomValidity('Re type password is no match.');
  } else {
    input.setCustomValidity('');
  }
};

//# sourceMappingURL=account.js.map
