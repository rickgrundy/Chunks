$ -> new chunks.PopupMenu($(container)) for container in $(".popup_menu")

chunks =
  PopupMenu: class
    constructor: (@container) ->
      @menu = @container.find("ul:first").hide()
      @button = @container.find("a:first")
      @button.click => this.showMenu(); false
      @container.hoverIntent
        timeout: 500
        over: => this.showMenu()
        out: => @menu.hide()
      
    showMenu: ->
      @menu.css
        bottom: @button.outerHeight()
        "min-width": @button.outerWidth()
      @menu.show()