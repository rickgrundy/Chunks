$ ->
  initChunk $(chunk) for chunk in $(".chunk")
    
initChunk = (chunk) -> 
  initShowHelp chunk, chunk.find(".show_help")
  initShowPreview chunk, chunk.find(".show_preview")
  
initShowHelp = (chunk, button) ->
  help = chunk.find(".help")
  button.click -> 
    help.dialog
      title: chunk.data("title")
      width: 600
      
initShowPreview = (chunk, button) ->
  button.click ->
    renderFormInIframeDialog("#{chunk.data("title")} Preview", button.attr("href"), -> chunk.clone())
    false
    
    
    
renderFormInIframeDialog = (dialogTitle, href, formFields) ->
  iframe_guid = guid()
  preview = $("<div style='position: relative;'/>")
  iframe = $("<iframe id='#{iframe_guid}' name='#{iframe_guid}'/>").appendTo(preview)
  eventCatcher = $("<div style='position: absolute; top: 0; left: 0;'/>")
  resizeIframe = ->
    height = preview.dialog("widget").find(".ui-dialog-content").height()
    iframe.css
      height: height+"px"
    eventCatcher.css
      height: height+"px"
      width: "100%"
  preview.dialog
    title: dialogTitle
    width: 600
    resizeStart: -> preview.append(eventCatcher)
    resizeStop: -> eventCatcher.remove()
    resize: resizeIframe
    open: resizeIframe
  form = $("<form action='" + href + "' method='post' target='#{iframe_guid}'/>")
  form.append("<input type='hidden' name='iframe_id' value='#{iframe_guid}'/>")
  form.append(formFields).submit()