$ -> new pageedit.Container($(container)) for container in $(".container")
  
pageedit =
  Container: class
    constructor: (@element) ->
      @chunks = []
      @chunks.push(new pageedit.Chunk(this, $(chunk))) for chunk in @element.find(".chunk")
      @element.find(".available_chunks a").click (event) => this.addChunk($(event.target)); false
    
    swapChunks: (chunkA, chunkB) ->
      a = chunks.indexOf(chunkA)
      b = chunks.indexOf(chunkB)
      chunks[a] = chunkB
      chunks[b] = chunkA
      chunkA.setPosition(b+1)
      chunkB.setPosition(a+1)
    
    moveUp: (chunk) ->
      higher = @chunks[@chunks.indexOf(chunk)-1]
      return if higher == undefined
      this.swapChunks(chunk, higher)
      chunk.element.insertBefore(higher.element)
        
    moveDown: (chunk) ->
      lower = @chunks[@chunks.indexOf(chunk)+1]
      return if lower == undefined
      this.swapChunks(chunk, lower)
      chunk.element.insertAfter(lower.element)
    
    addChunk: (link) ->
      @element.find(".empty_container").remove()
      $.get link.attr("href"), (form) =>
        chunk = new pageedit.Chunk(this, $(form).find(".chunk")) 
        @chunks.push(chunk)
        @element.find(".chunks").append(chunk.element)
    


  Chunk: class
    constructor: (@container, @element) ->
      @title = @element.data("title")
      @previewUrl = @element.find(".show_preview").attr("href")
      @element.find(".show_help").click => this.showHelp(); false
      @element.find(".show_preview").click => this.showPreview(); false
      @element.find(".move_up").click => @container.moveUp(this); false
      @element.find(".move_down").click => @container.moveDown(this); false
          
    setPosition: (newPosition) -> 
      @element.find(".position").val(newPosition)
    
    showHelp: ->
      @element.find(".help").dialog
        title: @title
        width: 600
  
    showPreview: ->
      @element.postToIframeDialog
        url: @previewUrl
        title: "#{@title} Preview"
        width: 632