from flask import Blueprint, request, jsonify
import cx_Oracle

from globals import GLOBAL_VARS

pfresco = Blueprint("pfresco", __name__)

# TEST ROUTE PFRESCO
@caja.route("/")
def home():
    return "caja home"