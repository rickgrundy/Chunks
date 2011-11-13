$ -> new pageedit.Container($(container)) for container in $(".container")
  
pageedit =
  Container: (element) ->
    addChunk = (event) ->
      element.find(".empty_container").remove()
      $.get $(event.target).attr("href"), (form) ->
        chunk = $(form).find(".chunk").appendTo(element.find(".chunks"))
        pageedit.chunk(chunk)
      false
            
    element.find(".available_chunks a").click addChunk
    new pageedit.Chunk(this, $(chunk)) for chunk in element.find(".chunk")
        
  Chunk: (container, element) ->
    title = element.data("title")
    previewUrl = element.find(".show_preview").attr("href")
    
    showHelp = ->
      element.find(".help").dialog
        title: title
        width: 600
  
    showPreview = (url) ->
      element.postToIframeDialog
        url: previewUrl
        title: "#{title} Preview"
        width: 632
      false
    
    moveUp = (chunk, button) ->
      alert("MOVE UP!")
      
    moveDown = (chunk, button) ->
      alert("MOVE DOWN!")
      
    element.find(".show_help").click showHelp
    element.find(".show_preview").click showPreview
    element.find(".move_up").click moveUp
    element.find(".move_down").click moveDown