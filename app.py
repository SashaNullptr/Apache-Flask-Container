# System
import json

# Third Party
from flask import Flask, json
from flask_cors import CORS

# Local
from example_app.hello_world import hello_world_dictionary

app = Flask(__name__)
CORS(app)

@app.route('/example', methods=['GET'])
def counter_endpoint( event=None, context=None ):
    """
    API endpoint that returns a generic greeting

    An example request might look like:

    .. sourcecode:: http

       GET www.x.com/example HTTP/1.1
       Host: example.com
       Accept: application/json, text/javascript

    Results will be returned as JSON object with the following format:

    .. code-block:: json

        {
          "hello": "world"
        }

    """

    return app.response_class( json.dumps( hello_world_dictionary() ), mimetype='application/json' )

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
