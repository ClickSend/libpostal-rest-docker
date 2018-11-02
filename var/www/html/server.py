from flask import render_template,jsonify
from postal.expand import expand_address
from postal.parser import parse_address
import connexion

# Create the application instance
app = connexion.App(__name__, specification_dir='./')

# Read the swagger.yml file to configure the endpoints
app.add_api('swagger.yml')

# Create a URL route in our application for "/"
@app.route('/')
def home():
    """
    This function just responds to the browser ULR
    localhost:8000/
    :return:        the rendered template 'home.html'
    """
    return render_template('home.html')

@app.route('/health')
def health():
    """
    This function confirms server is up and healthy
    :return:    JSON formatted message confirmin healthy status 
    """
    return jsonify(
       data='service-libpostal is up!'
    )

@app.route('/expand')
def expand():
    """
    This function expands the given address
    :return:    JSON formatted expanded address
    """
    expansions = expand_address('Quatre vingt douze Ave des Champs-Elysees')
    return jsonify(
	expansions
    )

@app.route('/parser')
def parser():
    """
    This function parses the given address
    :return:	JSON formatted parsed address
    """
    parsed = parse_address('8/42 Charles St South')
    #parsed = {'data': "Parse an address"}
    return jsonify(
        parsed
    )

# If we're running in stand alone mode, run the application
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
