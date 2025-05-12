import json
import os
from flask import Flask, render_template
import mysql.connector

app = Flask(__name__)

# Connexion à la base de données
def get_db_connection():
    return mysql.connector.connect(
        host='localhost',
        user='root',
        password='',
        database='projet_bdd'
    )

# Fonction pour convertir les résultats sous forme de dictionnaires
def convert_to_dict(columns, rows):
    result = []
    for row in rows:
        result.append(dict(zip(columns, row)))  # Zip les noms des colonnes avec les données de la ligne
    return result

# Route pour afficher la page index.html
@app.route('/')
def index():
    return render_template('index.html')

def generate_json():
    try:
        conn = mysql.connector.connect(get_db_connection())
        cursor = conn.cursor(dictionary=True)

        # Récupérer uniquement les colonnes utiles avec jointure
        query = """
            SELECT d.name, d.year, r.thumbnail
            FROM details d
            JOIN ratings r ON d.id = r.id
            WHERE r.thumbnail IS NOT NULL AND r.thumbnail != ''
        """
        cursor.execute(query)
        data = cursor.fetchall()

        # Sauvegarde dans le fichier static/details.json
        output_path = os.path.join(app.static_folder, 'details.json')
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

        return f"Fichier details.json généré avec {len(data)} jeux.", 200

    except mysql.connector.Error as err:
        return f"Erreur base de données : {err}", 500
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

if __name__ == '__main__':
    app.run(debug=True)
    generate_json()
