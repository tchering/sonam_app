$(document).ready(function () {
  $("#user_name").on("input", function () {
    if ($(this).val() !== "") {
      $("#name_error").hide();
    } else {
      $("#name_error").show();
    }
  });

  $("#user_email").on("input", function () {
    var emailRegexp = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i;
    if ($(this).val() !== "" && emailRegexp.test($(this).val())) {
      $("#email_error").hide();
    } else {
      $("#email_error").show();
    }
  });

  $("#user_password").on("input", function () {
    var passwordRegexp = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/;
    if ($(this).val() !== "" && passwordRegexp.test($(this).val())) {
      $("#password_error").hide();
    } else {
      $("#password_error").show();
    }
  });
});
