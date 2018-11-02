from flask import Flask, request, make_response
from flask import render_template,jsonify
from flask_restful import Resource, Api
from json import dumps
from postal.expand import expand_address
from postal.parser import parse_address
import os

# Create the application instance
#app = connexion.App(__name__, specification_dir='./')
app = Flask(__name__)
api = Api(app)


# Create a URL route in our application for "/"
@app.route('/')
def index():
    """
    This function just responds to the browser URL
    localhost:8087/
    :return:        the rendered template 'home.html'
    """
    resp = make_response(render_template('home.html'))
    return resp

#@app.route('/health', methods=['GET'])
class Health(Resource):
    def get(self):
        """
        This function confirms server is up and healthy
        :return:    JSON formatted message confirmin healthy status 
        """
        return jsonify(data='service-libpostal is up!')

#@app.route('/expand', methods=['POST'])
class Expand(Resource):
    def post(self):
        """
        This function expands the given address
        :return:    JSON formatted expanded address
        """

        req_data = request.get_json()
	query = None

        if 'query' in req_data:
            query = req_data['query']
            expansions = expand_address(query)
	else:
	    return jsonify(data='query data required')

        return jsonify(expansions)

#@app.route('/parser', methods=['POST'])
class Parser(Resource):
    def post(self):
        """
        This function parses the given address
        :return:	JSON formatted parsed address
        """

        req_data = request.get_json()
        query = None
        
        if 'query' in req_data:
            query = req_data['query']
            parsed = parse_address(query)
        else:
            return jsonify(data='query data required')

	return jsonify(parsed)

api.add_resource(Expand, '/expand')
api.add_resource(Parser, '/parser') 
api.add_resource(Health, '/health') 

# If we're running in stand alone mode, run the application
if __name__ == '__main__':
    service_name = os.environ.get('SERVICE_NAME', 'service-libpostal')
    service_host = os.environ.get('SERVICE_LIBPOSTAL_URL', '0.0.0.0')
    service_port = os.environ.get('SERVICE_LIBPOSTAL_PORT', 8087)
    service_debug = os.environ.get('APP_DEBUG', False)
    if(service_debug.lower() == "false"):
	    ervice_debug = False

    app.run(host=service_host, port=service_port, debug=service_debug)
