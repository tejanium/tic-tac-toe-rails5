module GameHelper
  def render_game(game)
    matrix = Matrix.new(game).process

    matrix.each_with_index.inject('') do |acc, (row, index)|
      acc + render('games/template/row', row: row, row_index: index)
    end.html_safe
  end
end
