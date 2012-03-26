class window.Item extends Spine.Model
  @configure 'Item', 'name', 'pid', 'price', 'quantity'

  @extend @Local

  total: ->
    @price * @quantity

  increase: (quantity) ->
    quantity = if quantity? then quantity else 1
    @quantity += quantity
    @trigger "quantityChanged"

  decrease: (quantity) ->
    quantity = if quantity? then quantity else 1
    if @quantity >= quantity
      @quantity -= quantity
    else
      @quantity = 0
    @trigger "quantityChanged"

  label: ->
    "#{@name} - $#{@price}"