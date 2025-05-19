document.addEventListener('DOMContentLoaded', function() {
    let currentPage = 0;  // Page actuelle
    const pageSize = 6;   // Jeux par page

    const gamesContainer = document.querySelector('#games-container');
    const prevBtn = document.querySelector('#prev-btn');
    const nextBtn = document.querySelector('#next-btn');

    if (!gamesContainer || !prevBtn || !nextBtn) {
        console.error('Impossible de trouver certains éléments du DOM.');
        return;
    }

    fetch('/static/details.json')  // On récupère le JSON
        .then(response => response.json())
        .then(details => {
            function renderPage(page) {
                gamesContainer.innerHTML = '';  // On vide le container

                const start = page * pageSize;
                const end = start + pageSize;
                const pageDetails = details.slice(start, end);

                pageDetails.forEach(detail => {
                    const gameCard = document.createElement('div');
                    gameCard.classList.add('game-card');

                    const name = document.createElement('h3');
                    const link = document.createElement('a');
                    link.href = `product.html/${detail.id}`;
                    link.textContent = detail.name;
                    name.appendChild(link);
                    gameCard.appendChild(name);


                    const year = document.createElement('p');
                    year.textContent = `Année de sortie : ${detail.yearpublished.toString()}`;
                    gameCard.appendChild(year);

                    const image = document.createElement('img');
                    image.src = detail.thumbnail;
                    image.alt = detail.name;
                    image.width = 150;
                    gameCard.appendChild(image);

                    gamesContainer.appendChild(gameCard);
                });

                prevBtn.disabled = page === 0;
                nextBtn.disabled = page * pageSize + pageSize >= details.length;
            }

            renderPage(currentPage);

            prevBtn.addEventListener('click', () => {
                if (currentPage > 0) {
                    currentPage--;
                    renderPage(currentPage);
                }
            });

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
