(function($) {
	Item.fetch();
	var cart = new ShoppingCart();
	
	var methods = {	
		/* ------------------------ */
		/* Initialize the Menu Page */
		/* ------------------------ */	
		initMenuPage : function(options) {
			var settings = {
				callback: function() {}
			};
			if ( options ) {
				$.extend( settings, options );
			}
	  
			var $page = $("#menu");
	  		var $list = $page.find("#menu_items");
	
			$page.bind("pagebeforeshow", function() {
			    $list.listview("refresh");	
				console.log("pagebeforeshow for Menu Page");
			});
			
			$.getJSON('menu.json', function(menu) {
				var processedTemplate = $.mustache($("#menuTemplate").html(), menu.menu);
				$list.html(processedTemplate);
				$list.listview("refresh");
			})
			// .error(function(jqXHR, textStatus, errorThrown) {
			//         alert("error " + textStatus + " incoming Text " + jqXHR.responseText);
			// });
			.error(function() { alert("Sorry can't load JSON file locally in this browser!")});
			
			$(".currency").formatCurrency();
			
			$(document).delegate('.addmenuitem', 'click', function() {
				var element = $(this);
				var menuItemId = $(this).data('menuitemid');
				var name = $(this).data('name');
				var price = $(this).data('price');
				
				$(this).simpledialog({
					'mode' : 'string',
					'prompt' : 'How Many?',
					'cleanOnClose': true,
					'buttons' : {
						'OK': {
							click: function () { 
								var howMany = parseInt(element.attr('data-string'));
								// pid, price, name, quantity
								cart.addItemById(menuItemId, price, name, howMany);
							}
						},
						'Cancel': {
							click: function () { console.log(this); },
							icon: "delete",
							theme: "c"
						}
					}
				})
			});
		},
		
		/* ------------------------- */
		/* Initialize the Order Page */
		/* ------------------------- */
		initOrderPage :function(options) {
			var settings = {
				callback: function() {}
			};
			if ( options ) {
				$.extend( settings, options );
			}
	  
			var $page = $("#order");

            $('#dump', this.el).live('click', function() { 
				cart.clear(); 
			});
			
			$page.bind("pagebeforeshow", function() {
				var $page = $(this);
				var $cart = $page.find("#theCart");
			
			    cart.render($cart);

			    $cart.find("ul[data-role=listview]").listview({
				    "inset": true
				});	
				
				$("#dump").button();	
				$(".currency").formatCurrency();
				
				console.log("pagebeforeshow for Order Page");
			});	
		},
	
		/* -------------------- */
		/* Initialize All Pages */
		/* -------------------- */	
		initAll : function(options) {
			var settings = {
				callback: function() {}
			};
			if ( options ) {
				$.extend( settings, options );
			}

			$().initApp("initMenuPage");
			$().initApp("initOrderPage");
		}
	}
  
	/* --------------------------------- */
	/* Initialize App and Pass Arguments */
	/* --------------------------------- */
	$.fn.initApp = function(method) {
		// Method calling logic
		if ( methods[method] ) {
			return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
		} else if ( typeof method === 'object' || ! method ) {
			return methods.initAll.apply( this, arguments );
		} else {
			$.error( 'Method ' +  method + ' does not exist' );
		} 
	}
})(jQuery);

/* ----------------------------- */
/* Initialize the App when Ready */
/* ----------------------------- */
$(document).bind("mobileinit", function() {
    $.mobile.page.prototype.options.addBackBtn = true;
});

$(document).ready(function() {
	$().initApp();
})