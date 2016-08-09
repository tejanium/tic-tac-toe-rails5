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

require 'rails_helper'

RSpec.describe Game do
  let(:user_1) { User.create! name: 'User 1' }
  let(:user_2) { User.create! name: 'User 2' }

  let(:game) { Game.new_game user_1 }

  it 'user_2 join the game' do
    expect {
      game.add_player user_2
    }.to change { game.players.to_a }.from([user_1]).to [user_1, user_2]
  end

  it 'will not add existing player' do
    game.add_player user_2

    expect {
      game.add_player user_2
    }.not_to change { game.players.to_a }.from [user_1, user_2]
  end

  it 'will not start if game only have one player' do
    expect {
      game.start!
    }.to raise_error RuntimeError
  end

  describe 'game commencing' do
    before do
      game.add_player user_2
      game.start!
    end

    it 'move player 1' do
      expect {
        game.move user_1, 0, 0
      }.to change { game.game_moves.last }.from nil
    end

    it 'do not move player 2, while it still player 1 turn' do
      expect {
        game.move user_2, 0, 0
      }.to raise_error RuntimeError
    end

    it 'cannot move to occupied space' do
      game.move user_1, 0, 0

      expect {
        game.move user_2, 0, 0
      }.to raise_error RuntimeError
    end

    describe 'game draw' do
      it 'draw' do
        game.move user_1, 0, 0
        game.move user_2, 1, 0
        game.move user_1, 0, 1
        game.move user_2, 1, 1

        game.move user_1, 1, 2
        game.move user_2, 0, 2

        game.move user_1, 2, 0
        game.move user_2, 2, 1

        expect {
          game.move user_1, 2, 2
        }.to change { game.over? }.from(false).to true

        expect(game).to be_draw
        expect(game.winner).to be_nil
      end
    end

    describe 'game winning' do
      it 'won vertically by player 1' do
        game.move user_1, 0, 0
        game.move user_2, 0, 1
        game.move user_1, 1, 0
        game.move user_2, 1, 1

        # useless moves
        game.move user_1, 0, 2
        game.move user_2, 1, 2

        expect {
          game.move user_1, 2, 0
        }.to change { game.over? }.from(false).to true

        expect(game.winner).to eql user_1
      end

      it 'won horizontally by player 1' do
        game.move user_1, 0, 0
        game.move user_2, 1, 0
        game.move user_1, 0, 1
        game.move user_2, 1, 1

        # useless moves
        game.move user_1, 2, 0
        game.move user_2, 2, 1

        expect {
          game.move user_1, 0, 2
        }.to change { game.over? }.from(false).to true

        expect(game.winner).to eql user_1
      end

      it 'won diagonally (1) by player 1' do
        game.move user_1, 0, 0
        game.move user_2, 1, 0
        game.move user_1, 1, 1
        game.move user_2, 2, 0

        # useless moves
        game.move user_1, 0, 1
        game.move user_2, 0, 2

        expect {
          game.move user_1, 2, 2
        }.to change { game.over? }.from(false).to true

        expect(game.winner).to eql user_1
      end

      it 'won diagonally (2) by player 1' do
        game.move user_1, 0, 2
        game.move user_2, 1, 0
        game.move user_1, 1, 1
        game.move user_2, 2, 1

        # useless moves
        game.move user_1, 0, 1
        game.move user_2, 1, 2

        expect {
          game.move user_1, 2, 0
        }.to change { game.over? }.from(false).to true

        expect(game.winner).to eql user_1
      end
    end
  end
end
