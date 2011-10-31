$ ->
  initShowHelp $(button) for button in $(".chunk .controls .show_help")
  
initShowHelp = (button) ->
  chunk = button.parents(".chunk")
  help = chunk.find(".help")
  button.click -> 
    help.dialog
      title: chunk.find("h4").text()
      width: 600