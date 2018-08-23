//= require jquery
//= require jquery_ujs


$(document).on('click', '#search_for_char input',(function() {
    $("#search_for_char input").keyup(function() {
        $.get($("#search_for_char").attr("action"),  $("#search_for_char").serialize(), null, "script");
        return false;
    });

}));

$(document).ready(function () {
    setInterval(function () {

        $('#server_time').load('/welcome/give_time');

    }, 1000);
});