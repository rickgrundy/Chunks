$ ->
  initShowHelp $(button) for button in $(".chunk .controls .show_help")
  initShowPreview $(button) for button in $(".chunk .controls .show_preview")
  
initShowHelp = (button) ->
  chunk = button.parents(".chunk")
  help = chunk.find(".help")
  button.click -> 
    help.dialog
      title: chunk.data("title")
      width: 600
      
initShowPreview = (button) ->
  button.click ->
    chunk = button.parents(".chunk")
    preview = $("<div/>").hide().appendTo("body");
    params = chunk.find(":input").serialize()
    $.post(button.attr("href"), params, (res) ->
      preview.html(res).dialog
        title: "#{chunk.data("title")} Preview"
        width: 600
    )
    false