$ ->
  $game = $ '#game'

  if $game.data('user') == $game.data('player')
    $('.move').show()

  App.cable.subscriptions.create { channel: 'GameChannel', id: $game.data('id') },
    received: (data) ->
      show_move = (data) ->
        if $game.data('user') == data.player
          $('.move').show()
        else
          $('.move').hide()

      switch data.topic
        when 'game'
          $('#content').html(data.body).promise().done ->
            show_move(data)

        when 'move'
          $tile = $("#game .tile[data-column=#{ data.column }][data-row=#{ data.row }]")

          $tile.replaceWith(data.body).promise().done ->
            show_move(data)

          $('#notification').text(data.notification)
