html_context = {
    'css_files': ['_static/styles.css'],
    'oio_versions': ['16.10', '17.04', 'master'],
    'landing_page': 'source/sandbox-guide/quickstart.html'
}
extensions = [
        'breathe',
        'sphinx.ext.autodoc',
        'sphinx.ext.viewcode',
        'sphinx.ext.todo',
        ]

html_theme = 'basic'
html_sidebars = {'**': ['globaltoc.html', 'searchbox.html']}
html_static_path = ['_static/', ]
templates_path = ['_templates/']
source_suffix = '.rst'
master_doc = 'index'
pygments_style = 'manni'

breathe_default_project = "oio-sds-c-api"
breathe_default_members = ('members', 'undoc-members')
breathe_projects = {
        "oio-sds-c-api": "../build/oio-sds-c-api/xml",
        "oio-sds-java-api": "../build/oio-api-java-doc/xml",
        }
