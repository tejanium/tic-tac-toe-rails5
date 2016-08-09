class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.references :creator
      t.integer    :board_size
      t.datetime   :start_at
      t.datetime   :end_at
      t.references :winner

      t.timestamps null: false
    end
  end
end
