$ ->
  $game = $ '#game'

  if $game.data('user') == $game.data('player')
    $('.move').show()

  App.cable.subscriptions.create { channel: 'GameChannel', id: $game.data('id') },
    received: (data) ->
      switch data.topic
        when 'game'
          $('#content').html(data.body).promise().done ->
            $('.move').show() if $game.data('user') == data.player
        when 'move'
          $tile = $("#game .tile[data-column=#{ data.column }][data-row=#{ data.row }]")

          $tile.replaceWith(data.body).promise().done ->
            $('.move').show() if $game.data('user') == data.player

          $('#notification').text(data.notification)
