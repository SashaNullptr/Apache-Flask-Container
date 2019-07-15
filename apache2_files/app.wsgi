import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0,'/var/www/app')

from flask_app import app as application
