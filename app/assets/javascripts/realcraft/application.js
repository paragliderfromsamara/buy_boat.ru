// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require motion-ui
//= require foundation-sites
//= require turbolinks
//= require ./components
//= require_tree .

var footerResFunc = function()
    {
        var f,c,l,curState;
        f = $("#footer");
        c = f.find("#footer-contacts");
        l = f.find("#footer-logo");
        curState = Foundation.MediaQuery.current;
        if (curState !== "small")
        {
            f.html(l).append(c);
            l.removeClass("tb-pad-s");
        }
        else 
        {
            f.html(c).append(l);
            l.addClass("tb-pad-s");
        }
    }

var readyFunc = function()
{
    //var elem = null;
    var elem, requestHash;
    $(document).foundation();
    requestHash = window.location.hash;
   // elem = new Foundation.Tabs("#rc-data-tabs", {});
    windowResizeFunc();
    $("#rc-data-tabs").on('change.zf.tabs', function() {
        var tOffset = $("#rc-data-tabs").offset().top - 20;
        var curScroll = $(window).scrollTop();
        history.pushState('', '', $('[data-tabs]').find(".is-active a").attr("href"));
        if (Math.abs(tOffset-curScroll) > 15) $('html, body').stop(true, true).animate({ scrollTop: tOffset }, 1000);
        
        return false;
    });
    
    if ($('[data-tabs]').length > 0 && requestHash.length>1)
    {
            $("#rc-data-tabs").foundation('selectTab', $(requestHash));   
    }
    
    //elem = new Foundation.DropdownMenu($("#dd-menu"));
    
}

var windowResizeFunc = function()
{
    $(".orbit-container").height($(".orbit").height());
    footerResFunc();
}



document.addEventListener("turbolinks:load", readyFunc);
$(window).resize(windowResizeFunc);