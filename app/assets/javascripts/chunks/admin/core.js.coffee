$ -> new chunks.PopupMenu($(container)) for container in $(".popup_menu")

window.chunks =
  # Displays a list of links as a popup above a button.
  PopupMenu: class
    constructor: (@container) ->
      @menu = @container.find("ul:first").hide()
      @button = @container.find("a:first")
      @button.click => this.showMenu(); false
      @container.hoverIntent
        timeout: 500
        over: => this.showMenu()
        out: => @menu.hide()
      
    showMenu: ->
      @menu.css
        bottom: @button.outerHeight()
        "min-width": @button.outerWidth()
      @menu.show()
      
      
  # Builds a form and displays it as a dialog, submitting it via AJAX and displaying any validation errors.    
  FormDialog: class
    constructor: (@opts) ->
      @form = this.buildForm(@opts)
      @form.dialog
        title: @opts.title
        width: 500
        minHeight: 100
        resizable: false
      @form.submit => this.submitForm(); false
      @form.find(".cancel").click => this.close(); false
      
    buildForm: (opts) ->
      form = $("<form action='#{opts.url}' method='#{opts.method}'>
        <div class='buttons'><a href='#cancel' class='cancel'>Cancel</a><input type='submit' value='#{opts.title}'/></div>
      </form>")
      form.prepend(this.buildField(field)) for field in opts.fields
      form
        
    buildField: (opts) ->
      field = $("<div class='field'><label for='#{opts.name}'>#{opts.name.toTitleCase()}</label></div>")
      field.addClass("req") if opts.required
      switch opts.type
        when "text" then field.append("<input type='text' name='#{opts.name}' value='#{opts.value}'/>")
      field
      
    submitForm: ->
      this.clearErrors()
      $.ajax
        type: @opts.method
        url: @opts.url
        data: @form.serialize()
        success: (success) => this.close(); @opts.success()
        error: (res) => this.renderValidationErrors(res)
        
    renderValidationErrors: (res) ->
      errorList = $("<ul class='errors'/>").prependTo(@form)
      render = (name, msg) =>
        errorList.append("<li>#{name.toTitleCase()} #{msg}</li>")
        @form.find("[name=#{name}]").parents(".field").addClass("field_with_errors")
      render(name, msg) for name, msg of eval("(#{res.responseText})")
      
    clearErrors: ->
      @form.find(".errors").remove()
      @form.find(".field_with_errors").removeClass("field_with_errors")
      
    close: ->
      @form.dialog("close")