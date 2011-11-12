$ -> pageedit.initContainer $(container) for container in $(".container")
  
pageedit =  
  initContainer: (container) ->
    this.addChunk container, $(link) for link in container.find(".available_chunks a")
    this.initChunk $(chunk) for chunk in container.find(".chunk")
    
  addChunk: (container, link) ->
    link.click ->
      container.find(".empty_container").remove()
      $.get link.attr("href"), (form) ->
        chunk = $(form).find(".chunk").appendTo(container.find(".chunks"))
        pageedit.initChunk(chunk)
      false
  
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