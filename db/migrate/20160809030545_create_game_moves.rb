class CreateGameMoves < ActiveRecord::Migration[5.0]
  def change
    create_table :game_moves do |t|
      t.references :game
      t.references :game_player
      t.integer    :row
      t.integer    :column

      t.timestamps null: false
    end
  end
end
