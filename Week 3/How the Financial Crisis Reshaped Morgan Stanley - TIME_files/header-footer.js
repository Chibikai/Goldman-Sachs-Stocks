(function() {
  jQuery(document).ready(function($) {
    var trimmedURL;
    trimmedURL = document.URL.split('?');
    trimmedURL = trimmedURL[0];
    $('[name="rurl"]').val(trimmedURL + '?loginfailure=true');
    $('[name="turl"]').val(trimmedURL);
    $('.header-nav-button').click(function(e) {
      e.preventDefault();
      return $('body').toggleClass('show-nav');
    });
    $('.sign-sub-wrap a[href="#signin"], .sign-in').click(function(e) {
      e.preventDefault();
      return $('.modal-container').addClass('active');
    });
    $('.modal__close').click(function(e) {
      e.preventDefault();
      return $('.modal-container').removeClass('active');
    });
    return $('#Sign_In').click(function(e) {
      e.preventDefault();
      return $('#sign-in-form').submit();
    });
  });

}).call(this);
