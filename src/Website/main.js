$("#contactForm").submit(function (event) {
    event.preventDefault();
    var $form = $(this);
    var msg = {
        Name: $("input[name=name]", $form).val(),
        Email: $("input[name=email]", $form).val(),
        Message: $("textarea[name=message]", $form).val()
    };

    $("#send-loading").removeClass("d-none");
    $("#send-static").addClass("d-none");

    $.ajax({
        url: $form.attr("action"),
        type: 'post', 
        dataType: 'json',
        contentType: 'application/json',
        data: JSON.stringify(msg),
        success: function (rsp) {
            $('#email-alert').removeClass("d-none");
            $("input[name=name],input[name=email],textarea[name=message]", $form).val("");
            $("#send-loading").addClass("d-none");
            $("#send-static").removeClass("d-none");
        }
    });
});