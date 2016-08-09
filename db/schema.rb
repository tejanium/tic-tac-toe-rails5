# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160809030545) do

  create_table "game_moves", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "game_player_id"
    t.integer  "row"
    t.integer  "column"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["game_id"], name: "index_game_moves_on_game_id"
    t.index ["game_player_id"], name: "index_game_moves_on_game_player_id"
  end

  create_table "game_players", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_players_on_game_id"
    t.index ["user_id"], name: "index_game_players_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "board_size"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "winner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_games_on_creator_id"
    t.index ["winner_id"], name: "index_games_on_winner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
  end

end
