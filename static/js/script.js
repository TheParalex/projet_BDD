Promise.all([
    fetch('details.csv').then(response => response.text()),
    fetch('ratings.csv').then(response => response.text())
])
.then(([detailsText, ratingsText]) => {
    const details = Papa.parse(detailsText, { header: true }).data;
    const ratings = Papa.parse(ratingsText, { header: true }).data;

    // Créer une map ID -> rating info
    const ratingsMap = {};
    ratings.forEach(rating => {
        const id = rating.id?.trim();
        if (id) {
            ratingsMap[id] = {
                average: rating.average,
                thumbnail: rating.thumbnail
            };
        }
    });

    const productGrid = document.querySelector('.product-grid');
    productGrid.innerHTML = ""; // vider

    details.forEach(product => {
        const id = product.id?.trim();
        if (!id || !ratingsMap[id]) return; // si pas trouvé dans ratings, ignorer

        const name = product.primary || "Nom inconnu";
        const year = product.yearpublished || "Année inconnue";
        const averageRating = ratingsMap[id].average || "No rating";
        const thumbnail = ratingsMap[id].thumbnail || "placeholder.jpg";

        const productCard = document.createElement('a');
        productCard.href = "product.html?id=" + id;
        productCard.innerHTML = `
            <div class="product-card">
                <div class="product-image" style="background-image: url('${thumbnail}'); background-size: cover; background-position: center;"></div>
                <h3>${name} (${year})</h3>
                <p>Rating: ${parseFloat(averageRating).toFixed(1)}</p>
            </div>
        `;
        productGrid.appendChild(productCard);
    });
})
.catch(error => {
    console.error('Erreur lors du chargement des fichiers CSV:', error);
});
