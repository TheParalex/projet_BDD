import json
import os
from flask import Flask, render_template, jsonify
import mysql.connector
from flask import request
from decimal import Decimal
app = Flask(__name__)

# Connexion à la base de données
def get_db_connection():
    return {
        'host': 'localhost',
        'user': 'root',
        'password': '',
        'database': 'projet_bdd'
    }

# Route pour afficher la page index.html
@app.route('/')
def index():
    return render_template('index.html')


def convert_decimal(obj):
    if isinstance(obj, list):
        return [convert_decimal(item) for item in obj]
    elif isinstance(obj, dict):
        return {k: convert_decimal(v) for k, v in obj.items()}
    elif isinstance(obj, Decimal):
        return float(obj)  # ou str(obj) si tu préfères
    else:
        return obj

@app.route('/generate-json')
def generate_json():
    conn = None
    cursor = None
    try:
        conn = mysql.connector.connect(**get_db_connection())
        cursor = conn.cursor(dictionary=True)

        query = """
            SELECT d.*, r.*
            FROM details d
            JOIN ratings r ON d.id = r.id
            WHERE r.thumbnail IS NOT NULL AND r.thumbnail != ''
        """
        cursor.execute(query)
        data = cursor.fetchall()

        # Convertir Decimal en float avant d'écrire JSON
        data_clean = convert_decimal(data)

        output_path = os.path.join(app.static_folder, 'details.json')
        print("Chemin de sortie :", output_path)

        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(data_clean, f, ensure_ascii=False, indent=2)
        print("Fichier écrit avec succès")

        return f"Fichier details.json généré avec {len(data_clean)} éléments."

    except mysql.connector.Error as err:
        print("Erreur MySQL :", err)
        return f"Erreur base de données : {err}"
    except Exception as e:
        print("Erreur générale :", e)
        return f"Erreur : {e}"
    finally:
        if cursor is not None:
            cursor.close()
        if conn is not None:
            conn.close()
            
@app.route('/product.html/<int:id>')
def get_jeu(id):
    return render_template('product.html')
    
@app.route('/api/rechercher-jeux', methods=['GET'])
def rechercher_jeux():
    nom = request.args.get('nom')
    annee_min = request.args.get('annee_min')
    joueurs_min = request.args.get('joueurs_min')
    joueurs_max = request.args.get('joueurs_max')

    try:
        conn = mysql.connector.connect(**get_db_connection())
        cursor = conn.cursor(dictionary=True)

        # Appel de la procédure stockée
        cursor.callproc('RechercherJeuxParFiltres', [
            nom,
            int(annee_min) if annee_min else None,
            int(joueurs_min) if joueurs_min else None,
            int(joueurs_max) if joueurs_max else None
        ])

        # Récupération des résultats depuis le curseur de sortie
        result = []
        for res in cursor.stored_results():
            result.extend(res.fetchall())

        cursor.close()
        conn.close()

        return jsonify(result)

    except mysql.connector.Error as err:
        return jsonify({'error': str(err)}), 50

# Jeux récents
@app.route("/api/jeux_recents", methods=["GET"])
def jeux_recents():
    try:
        conn = mysql.connector.connect(**get_db_connection())
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM vue_jeux_recents")
        jeux = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(jeux)
    except mysql.connector.Error as err:
        return jsonify({'error': str(err)}), 500

# Jeux anciens
@app.route("/api/jeux_anciens", methods=["GET"])
def jeux_anciens():
    try:
        conn = mysql.connector.connect(**get_db_connection())
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM vue_jeux_anciens")
        jeux = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(jeux)
    except mysql.connector.Error as err:
        return jsonify({'error': str(err)}), 500

# Jeux par durée
@app.route("/api/jeux_par_duree", methods=["GET"])
def jeux_par_duree():
    try:
        conn = mysql.connector.connect(**get_db_connection())
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM vue_jeux_par_duree")
        jeux = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(jeux)
    except mysql.connector.Error as err:
        return jsonify({'error': str(err)}), 500

# Jeux par taille de groupe
@app.route("/api/jeux_par_taille", methods=["GET"])
def jeux_par_taille():
    try:
        conn = mysql.connector.connect(**get_db_connection())
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM vue_jeux_par_taille_groupe")
        jeux = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(jeux)
    except mysql.connector.Error as err:
        return jsonify({'error': str(err)}), 500


if __name__ == '__main__':
    app.run(debug=True)
