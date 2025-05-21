import json
import os
from flask import Flask, render_template, jsonify
import mysql.connector
from flask import request

app = Flask(__name__)

# Connexion à la base de données
def get_db_connection():
    return {
        'host': 'localhost',
        'user': 'root',
        'password': 'VotreMotDePasse',
        'database': 'projet_bdd'
    }

# Route pour afficher la page index.html
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/generate-json')
def generate_json():
    conn = None
    cursor = None
    try:
        conn = mysql.connector.connect(**get_db_connection())
        cursor = conn.cursor(dictionary=True)

        query = """
            SELECT d.id, r.name, d.yearpublished, r.thumbnail, d.description
            FROM details d
            JOIN ratings r ON d.id = r.id
            WHERE r.thumbnail IS NOT NULL AND r.thumbnail != ''
        """
        cursor.execute(query)
        data = cursor.fetchall()

        output_path = os.path.join(app.static_folder, 'details.json')
        print("Chemin de sortie :", output_path)

        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print("Fichier écrit avec succès")

        return f"Fichier details.json généré avec {len(data)} éléments."

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
    
@app.route('/avis/<int:id>')
def get_avis(id):
    conn = None
    cursor = None
    try:
        conn = mysql.connector.connect(**get_db_connection())
        cursor = conn.cursor(dictionary=True)
        query = """
            SELECT nom, note, commentaire
            FROM avis
            WHERE jeu_id = %s
        """
        cursor.execute(query, (id,))
        avis = cursor.fetchall()
        return jsonify(avis)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

@app.route('/avis', methods=['POST'])
def ajouter_avis():
    data = request.get_json()
    conn = None
    cursor = None
    try:
        conn = mysql.connector.connect(**get_db_connection())
        cursor = conn.cursor()
        query = """
            INSERT INTO avis (jeu_id, nom, note, commentaire)
            VALUES (%s, %s, %s, %s)
        """
        cursor.execute(query, (data['jeu_id'], data['nom'], data['note'], data['commentaire']))
        conn.commit()
        return jsonify({'message': 'Avis ajouté'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

if __name__ == '__main__':
    app.run(debug=True)
