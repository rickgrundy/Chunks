$ -> new pageedit.Container($(container)) for container in $(".container")
  
pageedit =
  # Manages a list of contained chunks.
  Container: class
    constructor: (@element) ->
      @empty = @element.find(".empty_container")
      @chunks = []
      @chunks.push(new pageedit.Chunk(this, $(chunk))) for chunk in @element.find(".chunk")
      @element.find(".available_chunks a").click (event) => this.addChunk($(event.target)); false
      
    addChunk: (link) ->
      @empty.hide()
      $.get link.attr("href"), (form) =>
        chunk = new pageedit.Chunk(this, $(form).find(".chunk"), true)
        @chunks.push(chunk)
        chunk.setPosition(@chunks.length)
        @element.find(".chunks").append(chunk.element)
    
    swap: (chunkA, chunkB) ->
      a = @chunks.indexOf(chunkA)
      b = @chunks.indexOf(chunkB)
      @chunks[a] = chunkB
      @chunks[b] = chunkA
      chunkA.setPosition(b+1)
      chunkB.setPosition(a+1)
      if a > b
        chunkA.element.insertBefore(chunkB.element)
      else
        chunkA.element.insertAfter(chunkB.element)
        
    remove: (chunk) ->
      this.swap(chunk, @chunks[i+1]) while (i = @chunks.indexOf(chunk)) < @chunks.length - 1
      @chunks.pop()
      @empty.show() if @chunks.length == 0
      

  # Wires up all controls for a single chunk.
  Chunk: class
    constructor: (@container, @element, @newRecord=false) ->
      @title = @element.data("title")
      @shareLink = @element.find(".share")
      @previewLink = @element.find(".show_preview")
      
      @element.find(".show_help").click => this.showHelp(); false
      @element.find(".move_up").click => this.moveUp(); false
      @element.find(".move_down").click => this.moveDown(); false
      @element.find(".delete").click => this.delete(); false
      @previewLink.click => this.showPreview(); false
      @shareLink.click => this.share(); false
          
    setPosition: (newPosition) -> 
      @element.find(".position").val(newPosition)
    
    showHelp: ->
      @element.find(".help").dialog
        title: @title
        width: 600
  
    showPreview: ->
      @element.postToIframeDialog
        url: @previewLink.attr("href")
        title: "#{@title} Preview"
        width: 632

    moveUp: -> 
      higher = @container.chunks[@container.chunks.indexOf(this)-1]
      @container.swap(this, higher) if higher?
      
    moveDown: ->
      lower = @container.chunks[@container.chunks.indexOf(this)+1]
      @container.swap(this, lower) if lower?
      
    delete: ->
      return unless confirm "Are you sure you want to delete this #{@title.toLowerCase()} chunk?"
      @element.hide()
      @container.remove(this)
      if @newRecord then @element.remove() else @element.find("._destroy").attr("checked", true)
      
    share: ->
      new chunks.FormDialog
        title: "Share this chunk"
        url: @shareLink.attr("href")
        method: "post"
        fields: [
          {name: "name", type: "text", value: "", required: true}
        ]
        success: => @shareLink.parents("li").hide()