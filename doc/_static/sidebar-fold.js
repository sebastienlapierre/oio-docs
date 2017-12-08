$(document).ready(function() {

    // Sidebar collapse

    var s = {
        'toc': $('.sphinxsidebarwrapper .toctree-l1'),
        'ttc': $('.to-top-container'),
        'sidebar': $('.sphinxsidebar')
    }

    s.toc.addClass('toctree-closed');
    s.ttc.hide();

    $('.sphinxsidebarwrapper .toctree-l1 > ul').hide();
    $('.sphinxsidebarwrapper .toctree-l1.current > ul').show();
    $('.sphinxsidebarwrapper .toctree-l1.current').addClass('toctree-open');
    $('.sphinxsidebarwrapper .toctree-l1.current').removeClass('toctree-closed');



    var viewPort = !!($(document).width() > 1200);
    var sidebarVisible = !!($(document).width() > 1200);
    (viewPort)?showSidebar():hideSidebar();

    s.toc.on('click', function(e) {
        if($(e.target).parent().attr('class').startsWith('toctree-l2'))
            return

        e.preventDefault();
        var c = $($(this).children('ul')[0]);

        $('.sphinxsidebarwrapper .toctree-l1 > ul').slideUp();
        s.toc.removeClass('toctree-open');
        s.toc.addClass('toctree-closed');
        if(!c.is(":visible")) {
            c.slideDown();
            $(this).addClass('toctree-open');
            $(this).removeClass('toctree-closed');
        }
    });

    function hideSidebar() {
        s.sidebar.removeClass('open');
        s.sidebar.delay(200).queue(function(next) {
            $(this).addClass('sidebar-hide');
            if(viewPort)
                $('.sidebar-mini').show();
            next();
        })
        sidebarVisible=false;
    }

    function showSidebar(e) {
        if(e) e.stopPropagation();
        $('.sidebar-mini').hide();
        s.sidebar.removeClass('sidebar-hide');
        s.sidebar.delay(200).queue(function(next) {
            $(this).addClass('open')
            next();
        })
        sidebarVisible=true;
    }

    $('.toggle-sidebar').on('click', function() {
        (sidebarVisible)?hideSidebar():showSidebar();
    });

    $('.sidebar-mini, .searchbox-mobile-menu').on('click', showSidebar);

    s.ttc.on('click', function() {
        $('.documentwrapper').scrollTop(0);
    });

    $('.documentwrapper').on("scroll", function() {
        ($('.documentwrapper').scrollTop() <= 0)?s.ttc.fadeOut(200):s.ttc.fadeIn(200);
    });



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

    // Tag current version

    var path = window.location.pathname.split('/');
    var sel;
    if(window.location.pathname.split('/').length) {
        sel = $('#opt-' + path[1].replace('/', '-'));
        if(sel.length)
            $('#opt-' + path[1].replace('/', '-')).prop('selected', 'selected');
    }
});
