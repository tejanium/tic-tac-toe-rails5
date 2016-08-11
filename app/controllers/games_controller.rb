class GamesController < ApplicationController
  before_action :login_required, only: [:create, :show, :move]

  def index
    @user = User.new
    @game = Game.new

    @games = Game.available(current_user) if current_user
  end

  def create
    @game = Game.new_game current_user

    redirect_to game_path @game
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
      @game ||= Game.find params[:id]
    end

    def login_required
      redirect_to root_path unless current_user
    end

    def broadcast_game
      GameChannel.broadcast_to game,
                               body: render_to_string(:show, layout: false),
                               player: game.current_player.id
    end
end
