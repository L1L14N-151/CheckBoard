#!/bin/bash

echo "🏗️ Compilation de MatinPro..."

# Nettoyer les anciens binaires
rm -f MatinPro .build -rf

# Compilation avec Swift Package Manager
swift build --configuration release

if [ $? -eq 0 ]; then
    # Copier le binaire
    cp .build/release/MatinPro ./MatinPro 2>/dev/null || echo "⚠️ Binaire non trouvé, utilisation directe"
    echo "✅ Compilation réussie!"
    echo "🚀 Lancement de l'application..."
    .build/release/MatinPro 2>/dev/null || ./MatinPro
else
    echo "❌ Erreur de compilation"
    exit 1
fi