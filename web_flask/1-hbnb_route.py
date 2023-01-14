#!/usr/bin/python3
""" A script that starts a flask web application """
from flask import Flask

app = Flask(__name__)


@app.route("/", strict_slashes=False)
def index():
    """ Function called with / route """
    return "Hello HBNB!"


@app.route("/hbnb", strict_slashes=False)
def hbnb():
    """ Function called with /hbnb route """
    return "HBNB"


if __name__ == "__main__":
    """ Main Function """
    app.run(host='0.0.0.0', port=5000)
