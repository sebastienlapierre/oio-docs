import alabaster

html_theme_path = [alabaster.get_path()]
extensions = ['alabaster']
html_theme = 'alabaster'
html_theme_options = {
        'github_user': 'open-io',
        'description': 'Next-Gen object storage & grid for apps',
        'show_related': True,
        'show_powered_by': False,
        'analytics_id': 'UA-60343306-1',
        'font_family': 'regular',
        'font_size': '16px',
        'head_font_family': 'regular_bold',
        'code_font_size': '0.9em',
        'page_width': '1280px',
        'sidebar_width': '260px'
        }
html_sidebars = {'**': ['localtoc.html', 'sourcelink.html', 'searchbox.html']}
html_static_path = ["_static/", ]
templates_path = ['_templates']
pygments_style = 'alabaster.support.Alabaster'

