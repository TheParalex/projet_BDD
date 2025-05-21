document.addEventListener('DOMContentLoaded', function () {
    const pathParts = window.location.pathname.split('/');
    const gameId = parseInt(pathParts[pathParts.length - 1]);

    const gameDetailsContainer = document.getElementById('game-details');

    if (!gameDetailsContainer || isNaN(gameId)) {
        console.error('ID de jeu non trouvé dans l’URL.');
        return;
    }

    fetch('/static/details.json')
        .then(response => response.json())
        .then(games => {
            const game = games.find(g => g.id === gameId);

            if (!game) {
                gameDetailsContainer.innerHTML = '<p>Jeu non trouvé.</p>';
                return;
            }

            const title = document.createElement('h2');
            title.textContent = game.name;

            const year = document.createElement('p');
            year.textContent = `Année de sortie : ${game.yearpublished}`;

            const minPlayers = game.minplayers || 'Non précisé';
            const maxPlayers = game.maxplayers || 'Non précisé';
            const players = document.createElement('p');
            players.textContent = `Nombre de joueurs : ${maxPlayers}`;
            gameDetailsContainer.appendChild(players);
            const playTime = game.playingtime || 'Non précisé';
            const playTimeElement = document.createElement('p');
            playTimeElement.textContent = `Durée de jeu : ${playTime} minutes`;
            gameDetailsContainer.appendChild(playTimeElement);

            const image = document.createElement('img');
            image.src = game.thumbnail;
            image.alt = game.name;
            image.width = 150;

            const description = document.createElement('p');
            description.innerHTML = (game.description || '')
                .replace(/&#10;/g, '<br>')
                .replace(/&quot;/g, '"')
                .replace(/&amp;/g, '&')
                .replace(/&mdash;/g, '—');

            gameDetailsContainer.appendChild(title);
            gameDetailsContainer.appendChild(year);
            gameDetailsContainer.appendChild(image);
            gameDetailsContainer.appendChild(description);
        })
        .catch(error => {
            console.error('Erreur de récupération des détails :', error.message);
        });
});
