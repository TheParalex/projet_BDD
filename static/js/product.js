document.addEventListener('DOMContentLoaded', function() {
    let currentPage = 0;  // La page actuelle
    const pageSize = 6;   // Nombre de jeux à afficher par page

    const gamesContainer = document.querySelector('#games-container');
    const prevBtn = document.querySelector('#prev-btn');
    const nextBtn = document.querySelector('#next-btn');

    // Vérifiez si l'élément est trouvé
    if (!gamesContainer || !prevBtn || !nextBtn) {
        console.error('Impossible de trouver certains éléments du DOM. Vérifiez votre HTML.');
        return;
    }

    fetch('/static/details.json')  // Charge le fichier JSON
        .then(response => response.json())
        .then(details => {
            // Fonction pour afficher les jeux
            function renderPage(page) {
                // Vide le container avant de le remplir
                gamesContainer.innerHTML = '';

                // Calcule les indices de début et de fin pour cette page
                const start = page * pageSize;
                const end = start + pageSize;
                const pageDetails = details.slice(start, end);

                // Remplir le container avec les jeux de la page actuelle
                pageDetails.forEach(detail => {
                    const gameCard = document.createElement('div');
                    gameCard.classList.add('game-card');

                    // Crée les éléments pour chaque attribut du jeu
                    const name = document.createElement('h3');
                    name.textContent = detail.nom;
                    gameCard.appendChild(name);

                    const year = document.createElement('p');
                    year.textContent = `Année de sortie: ${detail.anneeSortie}`;
                    gameCard.appendChild(year);

                    const image = document.createElement('img');
                    image.src = detail.imageUrl;  // Assurez-vous que l'URL de l'image est correcte
                    image.alt = detail.nom;
                    image.width = 150;  // Ajustez la taille de l'image
                    gameCard.appendChild(image);

                    // Ajoute la carte du jeu au container
                    gamesContainer.appendChild(gameCard);
                });

                // Gestion des boutons Précédent/Suivant
                prevBtn.disabled = page === 0;
                nextBtn.disabled = page * pageSize + pageSize >= details.length;
            }

            // Initialiser la page
            renderPage(currentPage);

            // Gestion du bouton Précédent
            prevBtn.addEventListener('click', () => {
                if (currentPage > 0) {
                    currentPage--;
                    renderPage(currentPage);
                }
            });

            // Gestion du bouton Suivant
            nextBtn.addEventListener('click', () => {
                if (currentPage * pageSize + pageSize < details.length) {
                    currentPage++;
                    renderPage(currentPage);
                }
            });
        })
        .catch(error => {
            console.error('Erreur de récupération des détails:', error.message);
        });
});
