# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  creator_id :integer
#  board_size :integer
#  start_at   :datetime
#  end_at     :datetime
#  winner_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Let's not get confused
#
# 0,0 | 0,1 | 0,2
# ---------------
# 1,0 | 1,1 | 1,2
# ---------------
# 2,0 | 2,1 | 2,2

class Game < ApplicationRecord
  belongs_to :creator, class_name: User
  belongs_to :winner,  class_name: User, required: false

  has_many   :game_players
  has_many   :players, through: :game_players, source: :user
  has_many   :game_moves

  scope :not_start, -> { where(start_at: nil) }
  scope :not_end,   -> { where(end_at: nil) }
  scope :available, -> { not_start.not_end }
  scope :available_for, ->(user) do
    available
    .where.not(id: user.played_game_ids)
  end
  scope :unavailable, -> { where.not(end_at: nil) }

  validates :board_size, numericality: { greater_than: 2 }

  def self.new_game(user, board_size = 3)
    user.games.create(board_size: board_size).tap do |game|
      game.add_player(user) if game.valid?
    end
  end

  def add_player(user)
    return if players.include? user

    players << user
  end

  def move(player, row, column)
    raise "it's #{ current_player.name }'s turn" unless current_player == player
    raise 'it\'s occupied' if game_moves.find_by(row: row, column: column)
    raise 'game already over' if over?

    start! unless game_started?

    game_moves.create! game_player: game_player(player), row: row, column: column

    check_winner!
    end! if draw?
  end

  def game_player(player)
    game_players.find_by(user: player)
  end

  def last_player
    game_moves.last.try :user
  end

  def current_player
    return if over?
    return players.first unless last_player

    smart_index = players.to_a.index(last_player) - players.length + 1

    players[smart_index]
  end

  def game_started?
    start_at.present?
  end

  def player_turn?(player)
    current_player == player
  end

  def start!
    raise 'only have one player' if players.count == 1
    raise 'game already started' if game_started?

    update_attribute :start_at, Time.zone.now
  end

  def over?
    winner_id.present? || draw?
  end

  def draw?
    board_full? && winner_id.nil?
  end

  def board_full?
    game_moves.count == board_size ** 2
  end

  private
    def check_winner!
      winner = game_players.to_a.detect do |game_player|
                 game_player.horizontally_align? ||
                 game_player.vertically_align?   ||
                 game_player.diagonally_align?
               end

      winning(winner.user) if winner
    end

    def winning(winner)
      update_attribute :winner_id, winner.id
      end!
    end

    def end!
      update_attribute :end_at, Time.zone.now
    end
end
