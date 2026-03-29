from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route("/")
def home():
    return jsonify({
        "message": "Backend Flask is running 🚀"
    })

@app.route("/api/test")
def test():
    return jsonify({
        "status": "success",
        "data": "API siap menerima request dari Flutter"
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)