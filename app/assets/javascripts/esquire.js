$(document).ready(function(){
    $('#loading')
        .hide().
        ajaxStart(function() {
            $(this).show();
        })
        .ajaxStop(function() {
            $(this).hide();
        });
    
    function change_authority(id, auth)
    {
        $.ajax({
            type:'POST',
            url: '/user/edit/'+id, 
            data: { 'user':{'authority':auth} },
            success: function(data) {
                console.log(data);
            },
            error: function() {
                alert("System Error, Please try it later!");
            }
        });
    }
    
    $('select.edit_user_authority').change(function(){
        var val = $(this).val();
        var id = $(this).id;
        change_authority(id, val);
    });
});