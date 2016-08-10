# == Schema Information
#
# Table name: users
#
#  id   :integer          not null, primary key
#  name :string
#

class User < ApplicationRecord
  has_many :games, foreign_key: :creator_id
  has_many :game_players
  has_many :played_games, through: :game_players, source: :game
end
