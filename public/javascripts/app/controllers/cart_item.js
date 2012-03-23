var CartItem = Spine.Controller.sub({ 
   init: function(){
       var cartItem = this;
       
       this.item.bind("quantityChanged", function() { cartItem.updateQty() });
       
       $('#cartitem_' + this.item.pid + ' .add').live('click', function(e) { 
           cartItem.add(); 
           e.preventDefault(); 
       });
       
       $('#cartitem_' + this.item.pid + ' .remove').live('click', function(e) { 
           cartItem.remove(); 
           e.preventDefault(); 
       });

       $('#cartitem_' + this.item.pid + ' .removemenuitem').live('click', function(e) { 
           cartItem.item.destroy(); 
       });
   },
   
   render: function(){
       this.el = $.mustache($("#cartItem").html(), this.item);
       
       return this;
   },

   // event handlers
   add: function(e) {
       this.item.increase();
   },
       
   remove: function(e) {
       this.item.decrease();
   },

   // ui methods
   updateQty: function() {
       $('#cartitem_' + this.item.pid + ' #qty').text(this.item.quantity);
       $('#cartitem_' + this.item.pid + ' #item-total').text(this.item.total);
   }
});
