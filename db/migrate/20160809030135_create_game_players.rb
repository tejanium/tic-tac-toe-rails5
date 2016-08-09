class CreateGamePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :game_players do |t|
      t.references :user
      t.references :game

      t.timestamps null: false
    end
  end
end
