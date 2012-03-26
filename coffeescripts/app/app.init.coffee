Item.fetch()
Menu.fetch()
cart = new ShoppingCart()
methods =
  initSearchPage: (options) ->
    settings = callback: ->

    $.extend settings, options  if options

    $("#use_location").change ->
      $(this).mouseup()
      if $(this).attr("value") is "yes"
        try
          $.mobile.showPageLoadingMsg()
          navigator.geolocation.getCurrentPosition ((location) ->
              $("#search_form #latitude").val(location.coords.latitude)
              $("#search_form #longitude").val(location.coords.longitude)
              console.log "Latitude: #{location.coords.latitude}, Longitude: #{location.coords.longitude}"
          ), (error) ->
              error_message = switch error.code
                when error.PERMISSION_DENIED
                  "GeoLocation: Location Denied by User"
                when error.POSITION_UNAVAILABLE
                  "GeoLocation: Location Not Available"
                when error.TIMEOUT
                  "GeoLocation: Timeout waiting for Location"
                else
                  "GeoLocation: Unknown Error"
              console.log("ERROR: #{error_message}")
          , { maximumAge:60000, timeout:10000 }
        finally
          $.mobile.hidePageLoadingMsg()
    
    $("#search_form").on "submit", (e) ->
      $this = $(this)
      e.preventDefault()
      $.mobile.showPageLoadingMsg()
      $.getJSON($this.attr("action"), $this.serialize(), (response) ->
        Menu.deleteAll()
        $.mobile.hidePageLoadingMsg()
        $page = $("#search_results")
        $content = $page.find("#restaurants_found")
        processedTemplate = $.mustache($("#restaurants_tmpl").html(), response)
        $content.html processedTemplate
        $content.trigger "create"
        $.mobile.changePage $("#search_results"), "slideup"
      ).error (jqXHR, textStatus, errorThrown) ->
        console.log "error #{textStatus} incoming Text #{jqXHR.responseText}"

  initSearchResultsPage: (options) ->
    settings = callback: ->

    $.extend settings, options  if options
    $("#restaurant_selection_form").on "submit", (e) ->
      $this = $(this)
      e.preventDefault()
      $.mobile.showPageLoadingMsg()
      $.getJSON($this.attr("action"), $this.serialize(), (response) ->
        $.mobile.hidePageLoadingMsg()
        menu = Menu.create(contents: JSON.stringify(response))
        window.location.href = "/menus"
      ).error (jqXHR, textStatus, errorThrown) ->
        console.log "error #{textStatus} incoming Text #{jqXHR.responseText}"

  initMenuPage: (options) ->
    settings = callback: ->

    $.extend settings, options  if options
    console.log "The page is ===> " + options.$page
    $page = $("#menu")
    $list = $page.find("#menu_items")
    $page.bind "pagebeforeshow", ->
      $list.listview "refresh"
      console.log "pagebeforeshow for Menu Page"

    processedTemplate = $.mustache($("#menuTemplate").html(), Menu.first().contentsAsJSON().menu)
    $list.html processedTemplate
    $list.listview "refresh"
    $(".currency").formatCurrency()
    $(document).delegate ".addmenuitem", "click", ->
      element = $(this)
      menuItemId = $(this).data("menuitemid")
      name = $(this).data("name")
      price = $(this).data("price")
      $(this).simpledialog
        mode: "string"
        prompt: "How Many?"
        cleanOnClose: true
        buttons:
          OK:
            click: ->
              howMany = parseInt(element.attr("data-string"))
              cart.addItemById menuItemId, price, name, howMany

          Cancel:
            click: ->
              console.log this

            icon: "delete"
            theme: "c"

  initOrderPage: (options) ->
    settings = callback: ->

    $.extend settings, options  if options
    $page = $("#order")
    $("#dump", @el).live "click", ->
      cart.clear()

    $page.bind "pagebeforeshow", ->
      $page = $(this)
      $cart = $page.find("#theCart")
      cart.render $cart
      $cart.find("ul[data-role=listview]").listview inset: true
      $("#dump").button()
      $(".currency").formatCurrency()
      console.log "pagebeforeshow for Order Page"

$.fn.initApp = (method, page) ->
  $page = $(page)
  if typeof $page isnt "undefined" and $page isnt null
    console.log "Initializing mobile page: #{page}"
    if methods[method]
      methods[method].apply this, Array::slice.call(arguments, 1)
    else if typeof method is "object" or not method
      methods.initAll.apply this, arguments
    else
      $.error "Method #{method} does not exist"