$ -> new pageedit.Container($(container)) for container in $(".container")
  
pageedit =
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
        @element.find(".chunks").append(chunk.element)
    
    swap: (chunkA, chunkB) ->
      a = @chunks.indexOf(chunkA)
      b = @chunks.indexOf(chunkB)
      @chunks[a] = chunkB
      @chunks[b] = chunkA
      chunkA.setPosition(b+1)
      chunkB.setPosition(a+1)
      if a > b
        chunkB.element.insertAfter(chunkA.element)
      else
        chunkA.element.insertAfter(chunkB.element)
        
    remove: (chunk) ->
      while (i = @chunks.indexOf(chunk)) < @chunks.length-1
        this.swap(chunk, @chunks[i+1])
      @chunks.pop()
      @empty.show() if @chunks.length == 0
      


  Chunk: class
    constructor: (@container, @element, @newRecord=false) ->
      @title = @element.data("title")
      @previewUrl = @element.find(".show_preview").attr("href")
      @element.find(".show_help").click => this.showHelp(); false
      @element.find(".show_preview").click => this.showPreview(); false
      @element.find(".move_up").click => this.moveUp(); false
      @element.find(".move_down").click => this.moveDown(); false
      @element.find(".delete").click => this.delete(); false
          
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

    moveUp: -> 
      higher = @container.chunks[@container.chunks.indexOf(this)-1]
      return if higher == undefined
      @container.swap(this, higher)
      
    moveDown: ->
      lower = @container.chunks[@conatiner.chunks.indexOf(this)+1]
      return if lower == undefined
      this.swap(this, lower)
      
    delete: ->
      return unless confirm "Are you sure you want to delete this #{@title.toLowerCase()} chunk?"
      @element.hide()
      @container.remove(this)
      if @newRecord
        @element.remove()
      else
        @element.find("._destroy").attr("checked", true)