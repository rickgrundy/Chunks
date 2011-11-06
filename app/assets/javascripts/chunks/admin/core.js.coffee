$ -> chunks.popupMenu $(container) for container in $(".popup_menu")

chunks =
  popupMenu: (container) ->
    button = container.find("a:first")
    menu = container.find("ul:first").hide()
    showMenu = ->
      menu.css
        bottom: button.outerHeight()
        "min-width": button.outerWidth(); 
      menu.show()
      false
    button.click(showMenu)      
    container.hoverIntent
      timeout: 500
      over: showMenu
      out: -> menu.hide()
    