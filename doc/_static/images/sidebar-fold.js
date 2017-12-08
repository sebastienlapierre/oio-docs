$(document).ready(function() {

    // Sidebar collapse

    var toc = $('.toctree-l1');
    toc.on('click', function(e) {
        if($(e.target).parent().attr('class') == 'toctree-l2')
            return
        e.preventDefault();
        var c = $(this).children('ul')[0];
        var visible = $(c).is(":visible");


        $('.toctree-l1 > ul').slideUp();
        toc.removeClass('toctree-open');
        toc.addClass('toctree-closed');
        if(!visible) {
            $(c).slideDown();
            $(this).addClass('toctree-open');
            $(this).removeClass('toctree-closed');
        }
    })

    toc.addClass('toctree-closed');
    $('.toctree-l1 > ul').hide();
    $('.toctree-l1.current > ul').show();
    $('.toctree-l1.current').addClass('toctree-open');
    $('.toctree-l1.current').removeClass('toctree-closed');

    var viewPort = !!($(document).width() > 1200);
    var sidebarVisible = !!($(document).width() > 1200);
    (viewPort)?showSidebar():hideSidebar();


    // Sidebar show/hide


    function hideSidebar() {
        $('.sphinxsidebar').removeClass('open');
        $('.sphinxsidebar').delay(200).queue(function(next) {
            $(this).addClass('sidebar-hide');
            $('.sidebar-mini').show();
            next();
        })
        sidebarVisible=false;
    }

    function showSidebar() {
        $('.sidebar-mini').hide();
        $('.sphinxsidebar').removeClass('sidebar-hide');
        $('.sphinxsidebar').delay(200).queue(function(next) {
            $(this).addClass('open')
            next();
        })
        sidebarVisible=true;
    }

    $('.toggle-sidebar').on('click', function() {
        (sidebarVisible)?hideSidebar():showSidebar();
    });

    $('.sidebar-mini').on('click', function() {
        showSidebar();
    });

    $('.to-top-container').on('click', function() {
        $('.documentwrapper').scrollTop(0);
    });

    $('.documentwrapper').on("scroll", function() {
        var scrollPos = $('.documentwrapper').scrollTop();
        if (scrollPos <= 0)
            $(".to-top-container").fadeOut(200);
        else
            $(".to-top-container").fadeIn(200);
    });

    $(".to-top-container").hide();

    $('.documentwrapper, .header-container').on('click', function(e) {
        if(viewPort || ($(e.target).attr('class') == 'toggle-sidebar'))
            return
        hideSidebar();
    });

    // Version toggle

    function goTo(url) {
        window.location.href = url;
    }

    $(".switch-version").on('change', function() {
        var version = $($(this).children('option:selected')[0]).attr('value');
        var urlDefault = [window.location.origin, version, ''].join('/');
        var url = [window.location.origin, version, window.location.pathname.substring(1)].join('/');
        $.ajax({method: 'HEAD', url: url}).done(function() {
            goTo(url);
        }).fail(function() {
            goTo(urlDefault);
        })
    });
});
$(document).ready(function() {

    // Sidebar collapse

    var toc = $('.toctree-l1');
    toc.on('click', function(e) {
        if($(e.target).parent().attr('class') == 'toctree-l2')
            return
        e.preventDefault();
        var c = $(this).children('ul')[0];
        var visible = $(c).is(":visible");


        $('.toctree-l1 > ul').slideUp();
        toc.removeClass('toctree-open');
        toc.addClass('toctree-closed');
        if(!visible) {
            $(c).slideDown();
            $(this).addClass('toctree-open');
            $(this).removeClass('toctree-closed');
        }
    })

    toc.addClass('toctree-closed');
    $('.toctree-l1 > ul').hide();
    $('.toctree-l1.current > ul').show();
    $('.toctree-l1.current').addClass('toctree-open');
    $('.toctree-l1.current').removeClass('toctree-closed');

    var viewPort = !!($(document).width() > 1200);
    var sidebarVisible = !!($(document).width() > 1200);
    (viewPort)?showSidebar():hideSidebar();


    // Sidebar show/hide


    function hideSidebar() {
        $('.sphinxsidebar').removeClass('open');
        $('.sphinxsidebar').delay(200).queue(function(next) {
            $(this).addClass('sidebar-hide');
            $('.sidebar-mini').show();
            next();
        })
        sidebarVisible=false;
    }

    function showSidebar() {
        $('.sidebar-mini').hide();
        $('.sphinxsidebar').removeClass('sidebar-hide');
        $('.sphinxsidebar').delay(200).queue(function(next) {
            $(this).addClass('open')
            next();
        })
        sidebarVisible=true;
    }

    $('.toggle-sidebar').on('click', function() {
        (sidebarVisible)?hideSidebar():showSidebar();
    });

    $('.sidebar-mini').on('click', function() {
        showSidebar();
    });

    $('.to-top-container').on('click', function() {
        $('.documentwrapper').scrollTop(0);
    });

    $('.documentwrapper').on("scroll", function() {
        var scrollPos = $('.documentwrapper').scrollTop();
        if (scrollPos <= 0)
            $(".to-top-container").fadeOut(200);
        else
            $(".to-top-container").fadeIn(200);
    });

    $(".to-top-container").hide();

    $('.documentwrapper, .header-container').on('click', function(e) {
        if(viewPort || ($(e.target).attr('class') == 'toggle-sidebar'))
            return
        hideSidebar();
    });

    // Version toggle

    function goTo(url) {
        window.location.href = url;
    }

    $(".switch-version").on('change', function() {
        var version = $($(this).children('option:selected')[0]).attr('value');
        var urlDefault = [window.location.origin, version, ''].join('/');
        var url = [window.location.origin, version, window.location.pathname.substring(1)].join('/');
        $.ajax({method: 'HEAD', url: url}).done(function() {
            goTo(url);
        }).fail(function() {
            goTo(urlDefault);
        })
    });
});
