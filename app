from flask import Flask, jsonify, request, render_template
from flask_cors import CORS

# flask with a lower case 'f', because it is a package
# Flask with a upper case 'F', beacause it is a class
# jsonify with lower case 'j', because it is a method

app = Flask(__name__)
cors = CORS(app)
app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True

stores = [
    {
        'name':'My Wonderful Store',
        'items':[
            {
                'name':"My Item",
                'price':15.99
            }
        ]
    }
]

@app.route('/')
def home():
    return render_template('index.html')

# POST - used to receive data, for the perspective of the server
# GET - used to send data back only

# POST / store data: {name:}
@app.route('/store', methods = ['POST'])
def create_store():
    request_data = request.get_json()
    new_store = {
            'name': request_data['name'],
            'items': []
    }
    stores.append(new_store)
    return jsonify(new_store)


# GET / store/<string:name>
@app.route('/<string:name>') # ;'ttp://127.0.0.1:5000/store/some_name'
def get_store(name):
    for store in stores:
        if store['name'] == name:
            return jsonify(store)

    return jsonify({'message': 'store not found'})
    # Iterate over stores
    # if the store name mathces, return it
    # if non math, return an error message

# GET / store
@app.route('/store')
def get_stores():
    return jsonify({'stores': stores}) # for jason, we need to return a dictionary not a list.

# POST / store/ <string:name>/ item {name:, price:}
@app.route('/store/<string:name>/ item', methods = ['POST'])
def create_item_in_store(name):
    request_data = request.get_json()
    for store in stores:
        if store['name'] == name:
            new_item = {
                'name' : request_data['name'],
                'price' : request_data['price']
            }
            store['items'].append(new_item)
            return jsonify(new_item)
    return jsonify({'message': 'store not found'})

# GET / store/<string:name>/item
@app.route('/<string:name>/item')
def get_items_in_store(name):
    for store in stores:
        if store['name'] == name:
            return jsonify({'items': store['items']})
    return jsonify({'message': 'store not found'})

app.run(port=5000)
