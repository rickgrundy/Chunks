$ -> new pageedit.Container($(container)) for container in $(".container")
  
pageedit =
  Container: (element) ->
    chunks = []
    
    swapChunks = (chunkA, chunkB) ->
      a = chunks.indexOf(chunkA)
      b = chunks.indexOf(chunkB)
      chunks[a] = chunkB
      chunks[b] = chunkA
      chunkA.setPosition(b+1)
      chunkB.setPosition(a+1)
    
    this.moveUp = (chunk) ->
      higher = chunks[chunks.indexOf(chunk)-1]
      return if higher == undefined
      swapChunks(chunk, higher)
      chunk.element.insertBefore(higher.element)
        
    this.moveDown = (chunk) ->
      lower = chunks[chunks.indexOf(chunk)+1]
      return if lower == undefined
      swapChunks(chunk, lower)
      chunk.element.insertAfter(lower.element)
    
    addChunk = (event) =>
      element.find(".empty_container").remove()
      $.get $(event.target).attr("href"), (form) =>
        chunk = new pageedit.Chunk(this, $(form).find(".chunk")) 
        chunks.push(chunk)
        element.find(".chunks").append(chunk.element)
      false
            
    element.find(".available_chunks a").click addChunk
    chunks.push(new pageedit.Chunk(this, $(chunk))) for chunk in element.find(".chunk")
    return this
    


  Chunk: (container, element) ->
    console.log container
    this.element = element
    title = element.data("title")
    previewUrl = element.find(".show_preview").attr("href")
          
    this.setPosition = (newPosition) -> 
      element.find(".position").val(newPosition)
    
    showHelp = ->
      element.find(".help").dialog
        title: title
        width: 600
  
    showPreview = ->
      element.postToIframeDialog
        url: previewUrl
        title: "#{title} Preview"
        width: 632
      false
      
    element.find(".show_help").click showHelp; false
    element.find(".show_preview").click showPreview; false
    element.find(".move_up").click => container.moveUp(this); false
    element.find(".move_down").click => container.moveDown(this); false
    return this