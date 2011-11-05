$ ->
  pageedit.initChunk $(chunk) for chunk in $(".chunk")
  
pageedit =  
  initChunk: (chunk) -> 
    pageedit.showHelp chunk, chunk.find(".show_help")
    pageedit.showPreview chunk, chunk.find(".show_preview")

  showHelp: (chunk, button) ->
    help = chunk.find(".help")
    button.click -> 
      help.dialog
        title: chunk.data("title")
        width: 620
  
  showPreview: (chunk, button) ->
    button.click ->    
      chunk.postToIframeDialog
        url: button.attr("href")
        title: "#{chunk.data("title")} Preview"
        width: 630
      false