#!/bin/bash

# Arrêter le script en cas d'erreur
set -e

# Lire les arguments
directory=$1
project_name=$2

echo "Début de l'exportation Expo..."

# Chemin vers le répertoire des mises à jour
UPDATE_DIR="updates/$project_name/$directory"

# Passer au répertoire 'mobile'
cd ../mobile/$project_name
echo "Répertoire actuel: $(pwd)"

# Exporter le bundle Expo
npx expo export --platform android
echo "Exportation Expo terminée."

# Revenir au répertoire 'autoupdate_server24i'
cd ../../autoupdate_server24i
echo "Répertoire actuel: $(pwd)"

# Supprimer tous les anciens répertoires de mise à jour
rm -rf updates/$project_name/*
echo "Tous les anciens répertoires de mises à jour supprimés."

# Créer les répertoires nécessaires pour la nouvelle mise à jour
mkdir -p $UPDATE_DIR/assets
mkdir -p $UPDATE_DIR/bundles
echo "Répertoires $UPDATE_DIR/assets et $UPDATE_DIR/bundles créés."

# Copier les fichiers nécessaires
cp -r ../mobile/$project_name/dist/assets/* $UPDATE_DIR/assets/
cp -r ../mobile/$project_name/dist/bundles/* $UPDATE_DIR/bundles/
cp ../mobile/$project_name/dist/metadata.json $UPDATE_DIR/
echo "Fichiers copiés vers $UPDATE_DIR."

# Générer le fichier expoConfig.json
node ./scripts/exportClientExpoConfig.js $project_name > $UPDATE_DIR/expoConfig.json
echo "Fichier expoConfig.json généré."

echo "Mise à jour publiée avec succès dans $UPDATE_DIR"
