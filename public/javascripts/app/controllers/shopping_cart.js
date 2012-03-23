var ShoppingCart = Spine.Controller.sub({
    el: $("#theCart"),
    
    init: function() {
        var cart = this;
        this.items = {};
        $.each(Item.all(), function(){ cart.addItem(this); });
    },
    
    // removes all items from the cart
    clear: function() {
        $.each(this.items, function(){ this.destroy(); });
        this.items = {};
        this.updateCartTotal(); 
    },
    
    total: function() {
        var sum = 0.0;
        $.each(this.items, function(){ sum += this.total(); });

        return sum;
    },
    
    isEmpty: function() {
        return this.itemsCount() == 0;
    },
    
    itemsCount: function() {
        var size = 0;
        var items = this.items;
        $.each(items, function(){ if (items.hasOwnProperty(this)) size++; });

        return size;
    },
    
    addItemById: function(pid, price, name, quantity) {
	    quantity = (typeof(quantity) != 'undefined') ? quantity : 1;
        if (this.items.hasOwnProperty(pid)) {
            this.items[pid].increase(quantity);
        }
        else {
            var item = Item.create({name: name, pid: pid, price: price, quantity: quantity});
            this.addItem(item);
            $(".items").append(CartItem.init({item: item}).render().el);
        }
    },
    
    render: function(target) {
	    target = (typeof(target) != 'undefined') ? target : this.el;
	    var processedTemplate = $.mustache($("#shoppingCart").html(), {});
        target.html(processedTemplate);

        var $carTop = target.find("#cart_top");
        $.each(this.items, function(){ 
            $carTop.after(CartItem.init({item: this}).render().el);
        });
        
        this.updateCartTotal();
    },
    
    removeItem: function(item) {
        delete this.items[item.pid];
        $('#cartitem_' + item.pid).remove();
    },

    updateCartTotal: function() {
        $('#total').text(this.total());
    },
    
    removeIfQuantityZero: function(item) {
        if (item.quantity == 0) {
            this.removeItem(item);
        }
    },
    
    addItem: function(item) {
	    console.log("Added item " + item);
        this.items[item.pid] = item;
        item.bind("quantityChanged", this.proxy(this.updateCartTotal));
        item.bind("quantityChanged", this.proxy(this.removeIfQuantityZero));
        item.bind("quantityChanged", function() { item.save() });
        item.bind("destroy", this.proxy(this.removeItem));
        item.bind("destroy", this.proxy(this.updateCartTotal));
        item.save();
        this.updateCartTotal();
    }

});