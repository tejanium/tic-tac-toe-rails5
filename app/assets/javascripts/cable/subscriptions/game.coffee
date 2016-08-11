$ ->
  App.cable.subscriptions.create { channel: 'GameChannel', id: $('#game').data('id') },
    received: (data) ->
      $('body').html data.body
