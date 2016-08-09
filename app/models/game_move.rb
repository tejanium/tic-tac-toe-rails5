# == Schema Information
#
# Table name: game_moves
#
#  id             :integer          not null, primary key
#  game_id        :integer
#  game_player_id :integer
#  row            :integer
#  column         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class GameMove < ApplicationRecord
  belongs_to :game
  belongs_to :game_player

  delegate :user, to: :game_player, allow_nil: true
end
