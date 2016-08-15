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
      flash[:error] = @game.errors.full_messages.join(', ')

      redirect_to games_path
    end
  end

  def show
    game
  end

  def move
    begin
      game.move current_user, params[:row], params[:column]

      broadcast_game
    rescue RuntimeError => e
      flash[:error] = e
    ensure
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

    def broadcast_game
      GameChannel.broadcast_to game,
                               body: render_to_string(:show, layout: false),
                               player: game.current_player&.id
    end
end
