(function($) {
	Item.fetch();
	Menu.fetch();
	
	var cart = new ShoppingCart();
	
	var methods = {	
		/* -------------------------- */
		/* Initialize the Search Page */
		/* -------------------------- */	
		initSearchPage : function(options) {
			var settings = {
				callback: function() {}
			};
			if ( options ) {
				$.extend( settings, options );
			}

		    $('#search_form').on('submit', function (e) {
			    $this = $(this);

			    // prevent the form submission
			    e.preventDefault();

			    // show spinner thingy
			    $.mobile.showPageLoadingMsg();

			    $.getJSON($this.attr('action'), $this.serialize(), function(response) {
				    // delete all menus because we are using it as a singleton, yuck!
			        Menu.deleteAll();
			
		            // hide spinner thingy
			        $.mobile.hidePageLoadingMsg();

			        // find the content page
					var $page = $("#search_results");
			  		var $content = $page.find("#restaurants_found");

		            // render the template using the json response
					var processedTemplate = $.mustache($("#restaurants_tmpl").html(), response);

					// append the template and apply jQM goodness
					$content.html(processedTemplate);
					$content.trigger('create');

		            // navigate to the search results page
		            $.mobile.changePage($("#search_results"), "slideup");
			    })
				.error(function(jqXHR, textStatus, errorThrown) {
				        alert("error " + textStatus + " incoming Text " + jqXHR.responseText);
				});
			});
		},
		
		/* ---------------------------------- */
		/* Initialize the Search Results Page */
		/* ---------------------------------- */	
		initSearchResultsPage : function(options) {
			var settings = {
				callback: function() {}
			};
			if ( options ) {
				$.extend( settings, options );
			}

			$('#restaurant_selection_form').on('submit', function (e) {
			    $this = $(this);

				// prevent the form submission
			    e.preventDefault();

			    // show spinner thingy
			    $.mobile.showPageLoadingMsg();

			    $.getJSON($this.attr('action'), $this.serialize(), function(response) {

		            // hide spinner thingy
			        $.mobile.hidePageLoadingMsg();

			        // persist the menus retrieved
			        menu = Menu.create({contents : JSON.stringify(response)});

		            // navigate to the search results page 
		            // - we need the initialization to for each page to happen before show
		            window.location.href="/menus";
			    })
				.error(function(jqXHR, textStatus, errorThrown) {
				        alert("error " + textStatus + " incoming Text " + jqXHR.responseText);
				});
			});
		},		
		
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
			
			console.log("The page is ===> " + options.$page);
	  
			var $page = $("#menu");
	  		var $list = $page.find("#menu_items");
	
			$page.bind("pagebeforeshow", function() {
			    $list.listview("refresh");	
				console.log("pagebeforeshow for Menu Page");
			});
			
			var processedTemplate = $.mustache($("#menuTemplate").html(), Menu.first().contentsAsJSON().menu);
		    $list.html(processedTemplate);
		    $list.listview("refresh");
			
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
		}
	}
  
	/* --------------------------------- */
	/* Initialize App and Pass Arguments */
	/* --------------------------------- */
	$.fn.initApp = function(method, page) {
		// only initialize if the target page exists
		var $page = $(page);
		if (typeof $page !== "undefined" && $page !== null) {
			console.log("Initializing mobile page: " + page);
			// Method calling logic
			if ( methods[method] ) {
				return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
			} else if ( typeof method === 'object' || ! method ) {
				return methods.initAll.apply( this, arguments );
			} else {
				$.error( 'Method ' +  method + ' does not exist' );
			} 
	    }
	}
})(jQuery);

/* ----------------------------- */
/* Initialize the App when Ready */
/* ----------------------------- */
$(document).bind("mobileinit", function() {
    $.mobile.page.prototype.options.addBackBtn = true;
});