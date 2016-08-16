class GamesController < ApplicationController
  before_action :login_required, only: [:create, :show, :move]

  def index
    @user = User.new
    @game = Game.new

    if current_user
      @available_games = Game.available_for(current_user)
      @playing_games   = current_user.played_games.not_end
      @played_games    = current_user.played_games.unavailable
    end
  end

  def create
    @game = Game.new_game current_user, params_game[:board_size]

    if @game.valid?
      redirect_to game_path @game
    else
      flash[:error] = "WARNING: #{ @game.errors.full_messages.join(', ') }"

      redirect_to games_path
    end
  end

  def show
    game
  end

  def move
    begin
      move = game.move current_user, params[:row], params[:column]

      if game.over?
        broadcast_game
      else
        broadcast_move(move)
      end
    rescue RuntimeError => e
      flash[:error] = e

      redirect_to game_path game
    end
  end

  def join
    begin
      game.add_player current_user

      broadcast_game
    rescue RuntimeError => e
      flash[:error] = e
      redirect_to games_path
    end

    redirect_to game_path game
  end

  private
    def game
      @game ||= Game.includes(game_moves: :game_player, game_players: [:user, :game])
                    .find params[:id]
    end

    def params_game
      params[:game].permit(:board_size)
    end

    def login_required
      redirect_to root_path unless current_user
    end

    helper_method def game_notification
      if game.over?
        if game.draw?
          "It's a draw"
        else
          "#{ @game.winner.name } won!"
        end
      else
        "It's #{ @game.current_player.name }'s turn"
      end
    end

    def broadcast_game
      GameChannel.broadcast_to game,
                               topic: :game,
                               body: render_to_string(:show, layout: false),
                               player: game.current_player&.id
    end

    def broadcast_move(move)
      tile = render_to_string partial: 'games/template/tile',
                              locals: {
                                column: move.column,
                                row: move.row,
                                tile: move.game_player.token
                              }

      GameChannel.broadcast_to game,
                               topic: :move,
                               body: tile,
                               player: game.current_player&.id,
                               column: move.column,
                               row: move.row,
                               notification: game_notification
    end
end
