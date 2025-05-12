document.addEventListener("DOMContentLoaded", () => {
    const params = new URLSearchParams(window.location.search);
    const id = params.get("id");
    if (!id) return;

    fetch(`/jeu/${id}`)
        .then(response => response.json())
        .then(jeu => {
            document.getElementById("product-name").textContent = jeu.nom;
            document.getElementById("product-description").textContent = jeu.description;
            document.getElementById("product-year").textContent = jeu.annee;
            document.getElementById("product-image").innerHTML = `<img src="${jeu.image_url}" alt="${jeu.nom}">`;
        })
        .catch(error => console.error("Erreur chargement jeu :", error));

    fetch(`/avis/${id}`)
        .then(response => response.json())
        .then(data => {
            const reviewGrid = document.getElementById("review-grid");
            reviewGrid.innerHTML = "";
            data.forEach(avis => {
                const div = document.createElement("div");
                div.classList.add("review-card");
                div.innerHTML = `
                    <p><strong>${avis.nom}</strong> — ${avis.note}/5</p>
                    <p>${avis.commentaire}</p>
                `;
                reviewGrid.appendChild(div);
            });
        })
        .catch(error => console.error("Erreur chargement avis :", error));
});

function submitReview() {
    const params = new URLSearchParams(window.location.search);
    const id = params.get("id");
    const commentaire = document.getElementById("comment-text").value;

    const avis = {
        jeu_id: parseInt(id),
        nom: "Anonymous",  // À remplacer si authentification
        note: 5,            // À remplacer si tu ajoutes une échelle
        commentaire: commentaire
    };

    fetch("/avis", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(avis)
    })
    .then(res => res.json())
    .then(data => {
        alert("Commentaire envoyé !");
        window.location.reload();
    })
    .catch(err => console.error("Erreur ajout avis :", err));
}
