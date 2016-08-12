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

  def token
    TOKEN[game.players.to_a.index(user)]
  end

  def game_moves
    game.game_moves.where(game_player_id: id)
  end

  def horizontally_align?
    (0...game.board_size).detect do |i|
      game_moves.where(row: i).count == game.board_size
    end
  end

  def vertically_align?
    (0...game.board_size).detect do |i|
      game_moves.where(column: i).count == game.board_size
    end
  end

  def diagonally_align?
    diagonally_align_downward? || diagonally_align_upward?
  end

  private
    def diagonally_align_downward?
      (0...game.board_size).all? do |i|
        game_moves.where(row: i, column: i).count == 1
      end
    end

    def diagonally_align_upward?
      limit = game.board_size - 1

      (0...game.board_size).all? do |i|
        game_moves.where(row: i, column: limit - i).count == 1
      end
    end
end
