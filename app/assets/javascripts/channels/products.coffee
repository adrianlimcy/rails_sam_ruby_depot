App.products = App.cable.subscriptions.create "ProductsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    #$(".store #main").html(data.ha_sh)
    #alert data.ProductPrice
    $('#productsDisplay').html(data.ha_sh);
    $('#current_product').css({'background-color':'#88ff88'}).animate({'background-color':''}, 1000);
