class AddDeviseToUsers < ActiveRecord::Migration[7.1]
  def change
    # 1. D'abord, nettoyer les données : supprimer les users sans email
    reversible do |dir|
      dir.up do
        User.where(email: nil).delete_all
      end
    end

    # 2. Ensuite, modifier la colonne email
    change_column :users, :email, :string, null: false, default: ""

    # 3. Supprimer l'ancienne colonne password
    remove_column :users, :password

    # 4. Ajouter les colonnes Devise
    add_column :users, :encrypted_password, :string, null: false, default: ""

    ## Recoverable
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime

    ## Rememberable
    add_column :users, :remember_created_at, :datetime

    # 5. Ajouter les index
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
