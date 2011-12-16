$(document).ready(function(){
    
    var spin_opts = {
      lines: 10, // The number of lines to draw
      length: 3, // The length of each line
      width: 2, // The line thickness
      radius: 4, // The radius of the inner circle
      color: '#fff', // #rbg or #rrggbb
      speed: 1, // Rounds per second
      trail: 100, // Afterglow percentage
      shadow: false // Whether to render a shadow
    };
    $('#loading .spinner').spin(spin_opts);
    
    $('#loading')
        .hide().
        ajaxStart(function() {
            $(this).show();
        })
        .ajaxStop(function() {
            $(this).hide();
        });
    
    function change_authority(dom)
    {
        var auth = dom.val();
        var id = dom.attr('id');
        dom.attr("disabled","disabled");
        $.ajax({
            type:'POST',
            url: '/user/authorize/'+id, 
            data: { 'user':{'authority':auth} },
            dataType: "json",
            success: function(data) {
                dom.removeAttr("disabled");
                console.log(data);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                dom.removeAttr("disabled");
                console.log(textStatus);
            }
        });
    }
    
    function choose_to_change_article_attr(dom, attr)
    {
        var val = dom.val();
        var id = dom.attr('tabindex');
        dom.attr("disabled","disabled");
        var data = new Object;
        data[attr] = val;
        console.log(data);
        $.ajax({
            type:'POST',
            url: '/article/update/'+id, 
            data: { 'article':data },
            dataType: "json",
            success: function(data) {
                dom.removeAttr("disabled");
                console.log(data);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                dom.removeAttr("disabled");
                console.log(textStatus);
            }
        });
    }
    
    
    function cancel_article(dom, val)
    {
        dom.button('loading');
        var id = dom.attr('data-value');
        dom.attr("disabled","disabled");
        var danger = dom.hasClass('danger');
        $.ajax({
            type:'POST',
            url: '/article/update/'+id, 
            data: { 'article':{'canceled':danger} },
            dataType: "json",
            success: function(data) {
                dom.removeAttr("disabled");
                if (danger)
                {
                    dom.SwitchClass("danger","success");
                    //dom.text("激活");
                    dom.button('complete');
                }else{
                    dom.SwitchClass("success","danger");
                    //dom.text("取消");
                    dom.button('cancel');
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                dom.removeAttr("disabled");
                console.log(textStatus);
            }
        });
    }
    
    function print_confirm(dom)
    {
        var id = dom.attr("tabindex");
        dom.attr("disabled","disabled");
        $.ajax({
            type:'POST',
            url: '/article/update/'+id, 
            data: {'print_confirm':true},
            dataType: "json",
            success: function(data) {
                dom.removeAttr("disabled");
                dom.parent().text(data.signed_at);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                dom.removeAttr("disabled");
                console.log(textStatus);
            }
        });
    }
    
    function got_material(dom)
    {
        var id = dom.attr("tabindex");
        dom.attr("disabled","disabled");
        $.ajax({
            type:'POST',
            url: '/article/update/'+id, 
            data: {'got_material':true},
            dataType: "json",
            success: function(data) {
                dom.removeAttr("disabled");
                dom.parent().html("<strong>实际: </strong>" + data.signed_at);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                dom.removeAttr("disabled");
                console.log(textStatus);
            }
        });
    }
    
    function got_draft(dom)
    {
        var id = dom.attr("tabindex");
        dom.attr("disabled","disabled");
        $.ajax({
            type:'POST',
            url: '/article/update/'+id, 
            data: {'got_draft':true},
            dataType: "json",
            success: function(data) {
                dom.removeAttr("disabled");
                dom.parent().html("<strong>实际: </strong>" + data.signed_at);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                dom.removeAttr("disabled");
                console.log(textStatus);
            }
        });
    }
    
    function got_final(dom)
    {
        var id = dom.attr("tabindex");
        dom.attr("disabled","disabled");
        $.ajax({
            type:'POST',
            url: '/article/update/'+id, 
            data: {'got_final':true},
            dataType: "json",
            success: function(data) {
                dom.removeAttr("disabled");
                dom.parent().html("<strong>确认: </strong>" + data.signed_at);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                dom.removeAttr("disabled");
                console.log(textStatus);
            }
        });
    }
    
    function print_at(dom)
    {
        var id = dom.attr("tabindex");
        dom.attr("disabled","disabled");
        $.ajax({
            type:'POST',
            url: '/article/update/'+id, 
            data: {'print_at':true},
            dataType: "json",
            success: function(data) {
                dom.removeAttr("disabled");
                dom.parent().text(data.signed_at);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                dom.removeAttr("disabled");
                console.log(textStatus);
            }
        });
    }
    
    function close_confirm(dom)
    {
        var id = dom.attr("tabindex");
        dom.attr("disabled","disabled");
        var danger = dom.hasClass('danger');
        $.ajax({
            type:'POST',
            url: '/article/update/'+id, 
            data: { 'article':{'closed':danger} },
            dataType: "json",
            success: function(data) {
                dom.removeAttr("disabled");
                if (danger)
                {
                    dom.SwitchClass("danger","success");
                    //dom.text("激活");
                    dom.button('complete');
                }else{
                    dom.SwitchClass("success","danger");
                    //dom.text("取消");
                    dom.button('cancel');
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                dom.removeAttr("disabled");
                console.log(textStatus);
            }
        });
    }
    
    function message_alert(data)
    {
        console.log(JSON.stringify(data));
        if (data.unread)
        {
            if (data.unread > 0)
            {
                $('.unread_count').html('消息<span class="label important">' + data.unread + '</span>');
            }else{
                $('.unread_count').html('消息');
            }
        }
        if (data.msg)
        {
            var img = null;
            if (data.img)
            {
                img = $(data.img).src
            }
            $.gritter.add({
            	// (string | mandatory) the heading of the notification
            	title: '来自 ' + data.from,
            	// (string | mandatory) the text inside the notification
            	text: data.msg,
            	// (string | optional) the image to display on the left
            	image: img,
            	// (bool | optional) if you want it to fade out on its own or just sit there
            	sticky: true, 
            });
        }
        //setTimeout(unread_count, 1000*60);
    }
    
    function unread_count()
    {
        if ($('.unread_count').length==0) return;
        $.ajax({
            type:'GET',
            url: '/unread_count', 
            dataType: "json",
            success: function(data) {
                message_alert(data);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.log(textStatus);
            }
        });
    }
    
    function receive_message()
    {
        var profile_id = $('a.profile_link').attr('tabindex');
        if (!profile_id) return;
        var channel = "user_message_count_" + profile_id;
        var p = PUBNUB;
        var net = p.init({
            publish_key   : 'pub-c-abced66b-f358-4899-bb63-23c8a422739d',
            subscribe_key : 'sub-c-1a24d77d-25a4-11e1-b313-bd289def0c80',
        });
        net.subscribe({
            channel: channel,
            connect: function() {
                console.log('CONNECTED TO:' + channel);
            },
            callback: function(msg) {
                console.log("Got pushed message");
                message_alert(msg);
            },
            error: function() { console.log("Connection Lost"); }
        });
        net.history({
            channel: channel,
            limit: 1,
            callback: function(messages){
                console.log(messages);
                if (messages.length == 0) return;
                //msg = messages[0];
                //message_alert(msg);
                unread_count();
            }
        });
    }
    
    function mark_read()
    {
        var ids = [];
        $('li.msg').each(function(){
            if ($(this).hasClass('unread'))
            {
                ids.push($(this).attr('tabindex'));
            }
        });
        if (ids.length==0) 
        {
            //unread_count();
            return;
        }
        $.ajax({
            type:'GET',
            url: '/mark_read', 
            data: {'ids':ids},
            dataType: "json",
            success: function(data) {
                console.log(data);
                //unread_count();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.log(textStatus);
            }
        });
    }
    
    function text_image_section_switch()
    {
        var selector = $("select.choose_career");
        if (jQuery.inArray(selector.val(), ['0','1'])>=0) {
            $("div.text_section").show();
            $("div.image_section").hide();
        }else if (jQuery.inArray(selector.val(), ['2','3'])>=0) {
            $("div.text_section").hide();
            $("div.image_section").show();
        }else if (selector.val() == '4'){
            $("div.text_section").show();
            $("div.image_section").show();
        }
    }
    
    function update_expense_form()
    {
        var total_fee = $('#expense_text_count').val()/1000 * $('#expense_fee_per_word').val() + $('#expense_pages').val() * $('#expense_fee_per_page').val();
        $('#expense_total_fee').val(total_fee);
        $('#expense_paid').val(total_fee);
    }
    
    function get_contact()
    {
        var data = {'name':$('#expense_author').val()};
        if ($('#expense_career'))
        {
            data['career'] = $('#expense_career').val();
        }
        
        $.ajax({
            type:'GET',
            url: '/contact/show/', 
            data: data,
            dataType: "json",
            success: function(data) {
                if (data == null) { return ;}
                if ($('#expense_realname')) {$('#expense_realname').val(data.realname);}
                $('#expense_address').val(data.address);
                $('#expense_email').val(data.email);
                $('#expense_idcard').val(data.idcard);
                $('#expense_bankno').val(data.bankno);
                $('#expense_bank').val(data.bank);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.log(textStatus);
            }
        });
    }
    
    $('select.edit_user_authority').change(function(){
        change_authority($(this));
    });
    $('select.edit_article_editor').change(function(){
        choose_to_change_article_attr($(this), "editor_id");
    });
    $('select.edit_article_designer').change(function(){
        choose_to_change_article_attr($(this), "designer_id");
    });
    $('a.cancel_article').click(function(){
        cancel_article($(this));
    });
    $("a.print_confirm").click(function(){
        if ($(this).attr('disabled')) return;
        print_confirm($(this));
    });
    $("a.got_material").click(function(){
        if ($(this).attr('disabled')) return;
        got_material($(this));
    });
    $("a.got_draft").click(function(){
        if ($(this).attr('disabled')) return;
        got_draft($(this));
    });
    $("a.got_final").click(function(){
        if ($(this).attr('disabled')) return;
        got_final($(this));
    });
    $("a.print_at").click(function(){
        if ($(this).attr('disabled')) return;
        print_at($(this));
    });
    $("a.close_confirm").click(function(){
        if ($(this).attr('disabled')) return;
        close_confirm($(this));
    });
    $("select.choose_career").change(function(){
        text_image_section_switch();
    });
    $('input.fee').change(function(){
        update_expense_form();
    });
    $('#expense_author').change(function(){
        get_contact();
    });
    $('span.switchbtn').click(function(){
        if ($(this).hasClass('all')){
            $('tr').show();
        }else if ($(this).hasClass('notstart')){
            if ($('tr.warning').is(":visible"))
            {
                $(this).text('显示未分配项目');
                $('tr.warning').hide();
                $('tr:not(.warning)').show();
            }else if ($('tr.warning').length>0){
                $(this).text('隐藏未分配项目');
                $('tr.warning').show();
                $('tr:not(.warning)').hide();
            }
        }else if ($(this).hasClass('canceled')){
            if ($('tr.important').is(":visible"))
            {
                $(this).text('显未取消项目');
                $('tr.important').hide();
                $('tr:not(.important)').show();
            }else if ($('tr.important').length>0){
                $(this).text('隐藏取消项目');
                $('tr.important').show();
                $('tr:not(.important)').hide();
            }
        }else if ($(this).hasClass('printed')){
            if ($('tr.success').is(":visible"))
            {
                $(this).text('显示未下厂项目');
                $('tr.success').hide();
                $('tr:not(.success)').show();
            }else if ($('tr.success').length>0){
                $(this).text('隐藏未下厂项目');
                $('tr.success').show();
                $('tr:not(.success)').hide();
            }
        }else if ($(this).hasClass('closed')){
            if ($('tr.notice').is(":visible"))
            {
                $(this).text('显示结案项目');
                $('tr.notice').hide();
                $('tr:not(.notice)').show();
            }else if ($('tr.notice').length>0){
                $(this).text('隐藏结案项目');
                $('tr.notice').show();
                $('tr:not(.notice)').hide();
            }
        }
    });
    $("a[rel=twipsy]").twipsy({
        live: true
    });
    $("a[rel=popover]").popover({
        offset: 10,
        html: true
    }).click(function(e) {
        //e.preventDefault();
    });
    $('.tabs').tabs();
    $("a").click(function(e){
        if ($(this).attr('disabled')){
            e.preventDefault();
        }
    });
    text_image_section_switch();
    $('#intro-image-modal').modal({keyboard: true, backdrop: true});
    $('.show_modal_image').click(function(e){
        console.log($(this).attr('title'));
        $('#intro-image-modal h3').text($(this).attr('title'));
        $('#intro-image-modal .body p').html("<img src='"+$(this).attr('href')+"' width=550/>");
        $('#intro-image-modal').modal('show');
        e.preventDefault();
    });
    $.extend($.gritter.options, { 
        position: 'bottom-right', // defaults to 'top-right' but can be 'bottom-left', 'bottom-right', 'top-left', 'top-right' (added in 1.7.1)
    	fade_in_speed: 'medium', // how fast notifications fade in (string or int)
    	fade_out_speed: 2000, // how fast the notices fade out
    	time: 10000 // hang on the screen for...
    });
    mark_read();
    receive_message();
});