from flask import Flask, request, Response
import json
import xmltodict

app = Flask(__name__)

@app.route('/json_to_xml', methods=['POST'])
def json_to_xml():
    try:
        json_data = request.get_json()
        xml_data = xmltodict.unparse({"root": json_data}, pretty=True)
        return Response(xml_data, mimetype='text/xml')
    except Exception as e:
        return str(e), 400

if __name__ == '__main__':
    app.run(debug=True)
