class window.CartItem extends Spine.Controller  
  constructor: (item) ->
    cartItem = this
    @item = item
    @item.bind "quantityChanged", ->
      cartItem.updateQty()

    $("#cartitem_#{@item.pid} .add").live "click", (e) ->
      cartItem.add()
      e.preventDefault()

    $("#cartitem_#{@item.pid} .remove").live "click", (e) ->
      cartItem.remove()
      e.preventDefault()

    $("#cartitem_#{@item.pid} .removemenuitem").live "click", (e) ->
      cartItem.item.destroy()

  render: ->
    @el = $.mustache($("#cartItem").html(), @item)
    this

  add: (e) ->
    @item.increase()

  remove: (e) ->
    @item.decrease()

  updateQty: ->
    $("#cartitem_#{@item.pid} #qty").text @item.quantity
    $("#cartitem_#{@item.pid} #item-total").text @item.total