$ ->
  pageedit.initContainer $(container) for container in $(".container")
  
pageedit =  
  initContainer: (container) ->
    # this.iconifyAvailableChunks(container)
    this.initChunk $(chunk) for chunk in container.find(".chunk")
  
  iconifyAvailableChunks: (container) ->
    setBackgroundImage = (li) -> 
      link = li.find("a")
      link.css("background-image", "url('/assets/chunks/#{li.data('chunk')}.png')")
    setBackgroundImage $(li) for li in container.find("ul.available_chunks li")
  
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