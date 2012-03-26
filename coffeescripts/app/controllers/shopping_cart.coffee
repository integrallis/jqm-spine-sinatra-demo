class window.ShoppingCart extends Spine.Controller
  el: $("#theCart")
  
  constructor: ->
    super
    cart = this
    @items = {}
    $.each Item.all(), ->
      cart.addItem this

  clear: ->
    $.each @items, ->
      @destroy()

    @items = {}
    @updateCartTotal()

  total: ->
    sum = 0.0
    $.each @items, ->
      sum += @total()

    sum

  isEmpty: ->
    @itemsCount() is 0

  itemsCount: ->
    size = 0
    items = @items
    $.each items, ->
      size++ if items.hasOwnProperty(this)

    size

  addItemById: (pid, price, name, quantity) ->
    quantity = if quantity? then quantity else 1
    if @items.hasOwnProperty(pid)
      @items[pid].increase quantity
    else
      item = Item.create(
        name: name
        pid: pid
        price: price
        quantity: quantity
      )
      @addItem item
      cartItem = new CartItem(item)
      $(".items").append cartItem.render().el

  render: (target) ->
    target = if target? then target else @el
    processedTemplate = $.mustache($("#shoppingCart").html(), {})
    target.html processedTemplate
    $carTop = target.find("#cart_top")
    $.each @items, ->
      cartItem = new CartItem(this)
      $carTop.after cartItem.render().el

    @updateCartTotal()

  removeItem: (item) ->
    delete @items[item.pid]

    $("#cartitem_#{item.pid}").remove()

  updateCartTotal: ->
    $("#total").text @total()

  removeIfQuantityZero: (item) ->
    @removeItem item if item.quantity is 0

  addItem: (item) ->
    console.log "Added item " + item
    @items[item.pid] = item
    item.bind "quantityChanged", @proxy(@updateCartTotal)
    item.bind "quantityChanged", @proxy(@removeIfQuantityZero)
    item.bind "quantityChanged", ->
      item.save()

    item.bind "destroy", @proxy(@removeItem)
    item.bind "destroy", @proxy(@updateCartTotal)
    item.save()
    @updateCartTotal()    