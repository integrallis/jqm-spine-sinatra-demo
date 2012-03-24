$(document).ready(function() {	
	Menu.fetch();
	Menu.deleteAll();
	
    $('#search_form').on('submit', function (e) {
	    $this = $(this);
	
	    // prevent the form submission
	    e.preventDefault();

	    // show spinner thingy
	    $.mobile.showPageLoadingMsg();

	    $.getJSON($this.attr('action'), $this.serialize(), function(response) {

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
            window.location.href="/menus";
            //$.mobile.changePage("/menus", { transition: "slideup", reloadPage: true, data-ajax : false});
	    })
		.error(function(jqXHR, textStatus, errorThrown) {
		        alert("error " + textStatus + " incoming Text " + jqXHR.responseText);
		});
	});
});