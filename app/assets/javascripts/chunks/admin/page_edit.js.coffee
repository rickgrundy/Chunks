$ ->
  initChunk $(chunk) for chunk in $(".chunk")
    
initChunk = (chunk) -> 
  initShowHelp chunk, chunk.find(".show_help")
  initShowPreview chunk, chunk.find(".show_preview")
  
initShowHelp = (chunk, button) ->
  help = chunk.find(".help")
  button.click -> 
    help.dialog
      title: chunk.data("title")
      width: 600
      
initShowPreview = (chunk, button) ->
  button.click ->    
    chunk.postToIframeDialog
      url: button.attr("href")
      title: "#{chunk.data("title")} Preview"
      width: 600
    false