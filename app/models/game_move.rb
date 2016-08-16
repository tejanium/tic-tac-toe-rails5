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

  def sibling_moves
    game_player.game_moves
  end

  def winning_move?
    return if game.game_moves.count < game.board_size * 2

    horizontally_align? ||
    vertically_align?   ||
    diagonally_align?
  end

  def horizontally_align?
    sibling_moves.where(row: row).count == game.board_size
  end

  def vertically_align?
    sibling_moves.where(column: column).count == game.board_size
  end

  def diagonally_align?
    diagonally_align_downward? || diagonally_align_upward?
  end

  private
    def diagonally_align_downward?
      (0...game.board_size).all? do |i|
        sibling_moves.where(row: i, column: i).count == 1
      end
    end

    def diagonally_align_upward?
      limit = game.board_size - 1

      (0...game.board_size).all? do |i|
        sibling_moves.where(row: i, column: limit - i).count == 1
      end
    end
end
