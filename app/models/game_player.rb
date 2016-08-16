# == Schema Information
#
# Table name: game_players
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  game_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GamePlayer < ApplicationRecord
  TOKEN = (%w(X O) + ('A'..'Z').to_a).uniq

  belongs_to :game
  belongs_to :user

  has_many :game_moves, ->(game_player){
    where(game_player_id: game_player.id)
  }, through: :game

  def token
    TOKEN[game.players.to_a.index(user)]
  end
end
