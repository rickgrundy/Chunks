$ -> pageedit.initContainer $(container) for container in $(".container")
  
pageedit =  
  initContainer: (container) ->
    this.initChunk $(chunk) for chunk in container.find(".chunk")
  
  initChunk: (chunk) -> 
    this.showHelp chunk, chunk.find(".show_help")
    this.showPreview chunk, chunk.find(".show_preview")

  showHelp: (chunk, button) ->
    help = chunk.find(".help")
    button.click -> 
      help.dialog
        title: chunk.data("title")
        width: 600
  
  showPreview: (chunk, button) ->
    button.click ->    
      chunk.postToIframeDialog
        url: button.attr("href")
        title: "#{chunk.data("title")} Preview"
        width: 632
      false