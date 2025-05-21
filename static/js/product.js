document.addEventListener('DOMContentLoaded', function () {
    let currentPage = 0;
    const pageSize = 6;
    let allGames = [];

    const gamesContainer = document.querySelector('#games-container');
    const prevBtn = document.querySelector('#prev-btn');
    const nextBtn = document.querySelector('#next-btn');
    const filterBtn = document.querySelector('#filter-btn');

    const nameInput = document.querySelector('#filter-name');
    const anneeInput = document.querySelector('#filter-annee');
    const joueursMinInput = document.querySelector('#filter-joueurs-min');
    const joueursMaxInput = document.querySelector('#filter-joueurs-max');
    const typeSelect = document.querySelector('#filter-type');
    const groupFilter = document.querySelector('#groupFilter'); // <= NOUVEAU

    // Gérer l'affichage dynamique du menu secondaire
    typeSelect.addEventListener('change', () => {
        const type = typeSelect.value;

        if (type === 'duree') {
            groupFilter.style.display = 'inline-block';
            groupFilter.innerHTML = `
                <option value="">-- Choisir une durée --</option>
                <option value="Court">Court</option>
                <option value="Moyen">Moyen</option>
                <option value="Long">Long</option>
            `;
        } else if (type === 'taille') {
            groupFilter.style.display = 'inline-block';
            groupFilter.innerHTML = `
                <option value="">-- Choisir une taille --</option>
                <option value="Solo">Solo</option>
                <option value="Petit groupe">Petit groupe</option>
                <option value="Groupe moyen">Groupe moyen</option>
                <option value="Grand groupe">Grand groupe</option>
            `;
        } else {
            groupFilter.style.display = 'none';
        }
    });

    function renderPage(page) {
        gamesContainer.innerHTML = '';

        const start = page * pageSize;
        const end = start + pageSize;

        if (typeSelect.value === 'duree' || typeSelect.value === 'taille') {
            const grouped = {};

            allGames.forEach(game => {
                const key = typeSelect.value === 'duree' ? game.Duree_Type : game.Type_Jeu;
                if (!grouped[key]) grouped[key] = [];
                grouped[key].push(game);
            });

            const ordreDuree = ['Court', 'Moyen', 'Long'];
            const ordreTaille = ['Solo', 'Petit groupe', 'Groupe moyen', 'Grand groupe'];
            const ordre = typeSelect.value === 'duree' ? ordreDuree : ordreTaille;

            let affiches = 0;

            ordre.forEach(key => {
                const jeux = grouped[key] || [];

                if (jeux.length > 0) {
                    const sectionTitle = document.createElement('h2');
                    sectionTitle.textContent = key;
                    gamesContainer.appendChild(sectionTitle);
                }

                jeux.forEach(game => {
                    if (affiches >= start && affiches < end) {
                        const gameCard = document.createElement('div');
                        gameCard.classList.add('game-card');

                        const name = document.createElement('h3');
                        const link = document.createElement('a');
                        link.href = `product.html/${game.id}`;
                        link.textContent = game.name || 'Jeu sans nom';
                        name.appendChild(link);
                        gameCard.appendChild(name);

                        const year = document.createElement('p');
                        year.textContent = `Année : ${game.yearpublished || 'Non précisée'}`;
                        gameCard.appendChild(year);

                        if (game.thumbnail) {
                            const img = document.createElement('img');
                            img.src = game.thumbnail;
                            img.alt = game.name;
                            img.width = 150;
                            gameCard.appendChild(img);
                        }

                        gamesContainer.appendChild(gameCard);
                    }
                    affiches++;
                });
            });

            prevBtn.disabled = page === 0;
            nextBtn.disabled = (page + 1) * pageSize >= allGames.length;
        } else {
            const pageDetails = allGames.slice(start, end);

            pageDetails.forEach(detail => {
                const gameCard = document.createElement('div');
                gameCard.classList.add('game-card');

                const name = document.createElement('h3');
                const link = document.createElement('a');
                link.href = `product.html/${detail.id}`;
                link.textContent = detail.name || 'Jeu sans nom';
                name.appendChild(link);
                gameCard.appendChild(name);

                const year = document.createElement('p');
                year.textContent = `Année : ${detail.yearpublished || 'Non précisée'}`;
                gameCard.appendChild(year);

                if (detail.thumbnail) {
                    const img = document.createElement('img');
                    img.src = detail.thumbnail;
                    img.alt = detail.name;
                    img.width = 150;
                    gameCard.appendChild(img);
                }

                gamesContainer.appendChild(gameCard);
            });

            prevBtn.disabled = page === 0;
            nextBtn.disabled = (page + 1) * pageSize >= allGames.length;
        }
    }

    function fetchGames() {
    const type = typeSelect.value;
    let url = '';
    let params = new URLSearchParams();

    const tailles = ['Solo', 'Petit groupe', 'Groupe moyen', 'Grand groupe'];
    const durees = ['Court', 'Moyen', 'Long'];

    if (tailles.includes(type)) {
        url = '/api/jeux_par_taille';
    } else if (durees.includes(type)) {
        url = '/api/jeux_par_duree';
    } else {
        switch (type) {
            case 'recherche':
                url = '/api/rechercher-jeux';
                if (nameInput.value) params.append('nom', nameInput.value);
                if (anneeInput.value) params.append('annee_min', anneeInput.value);
                if (joueursMinInput.value) params.append('joueurs_min', joueursMinInput.value);
                if (joueursMaxInput.value) params.append('joueurs_max', joueursMaxInput.value);
                url += '?' + params.toString();
                break;
            case 'recents':
                url = '/api/jeux_recents';
                break;
            case 'anciens':
                url = '/api/jeux_anciens';
                break;
            default:
                console.warn('Type de filtre inconnu');
                return;
        }
    }

    fetch(url)
        .then(res => res.json())
        .then(data => {
            // Filtrage si une durée ou taille spécifique est sélectionnée
            if (tailles.includes(type)) {
                allGames = data.filter(g => g.Type_Jeu === type);
            } else if (durees.includes(type)) {
                allGames = data.filter(g => g.Duree_Type === type);
            } else {
                allGames = data;
            }

            currentPage = 0;
            renderPage(currentPage);
        })
        .catch(err => {
            console.error("Erreur lors de la récupération des jeux :", err);
        });
}


    filterBtn.addEventListener('click', () => {
        fetchGames();
    });

    prevBtn.addEventListener('click', () => {
        if (currentPage > 0) {
            currentPage--;
            renderPage(currentPage);
        }
    });

    nextBtn.addEventListener('click', () => {
        if ((currentPage + 1) * pageSize < allGames.length) {
            currentPage++;
            renderPage(currentPage);
        }
    });

    fetchGames(); // Chargement initial
});
