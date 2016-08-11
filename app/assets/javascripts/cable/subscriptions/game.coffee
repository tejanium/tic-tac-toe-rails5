$ ->
  $game = $ '#game'

  if $game.data('user') == $game.data('player')
    $('.move').show()

  App.cable.subscriptions.create { channel: 'GameChannel', id: $game.data('id') },
    received: (data) ->
      $('body').html(data.body).promise().done ->
        $('.move').show() if $game.data('user') == data.player
