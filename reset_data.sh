#!/bin/bash
set -e

echo "⚠️  ATTENTION : cette opération va SUPPRIMER et RECRÉER la base de données."
read -p "Es-tu sûr de vouloir continuer ? (oui/non) : " confirm

if [ "$confirm" != "oui" ]; then
  echo "❌ Opération annulée."
  exit 0
fi

echo "➜ Réinitialisation de la base (rails db:reset)..."
rails db:reset

echo "➜ Exécution du seed principal (rails db:seed)..."
rails db:seed

echo "➜ Exécution du seed des images (rails runner db/seed_images.rb)..."
rails runner db/seed_images.rb

echo "✅ Terminé ! La base a été entièrement reconstruite et remplie."
