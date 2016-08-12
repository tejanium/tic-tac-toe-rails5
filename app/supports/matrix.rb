class Matrix
  def initialize(game)
    @game   = game
    @matrix =  Array.new(game.board_size) { Array.new(game.board_size) }
  end

  def process
    @game.game_moves.each do |game_move|
      @matrix[game_move.row][game_move.column] = game_move.game_player.token
    end

    @matrix
  end
end
