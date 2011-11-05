function guid() {
  function S4() {
    return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
  }
  return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
}

$.extend($.fn, { 
  cloneFormFields: function() {
    var clone = $("<div/>").append(this.find(":input").clone());
    this.find("textarea").each(function() {
      var orig = $(this);
      clone.find("textarea[name='" + orig.attr("name") + "']").val(orig.val());
    });
    return clone;
  },
  
  postToIframeDialog: function(opts) {
    var iframeGuid = guid();
    var container = $("<div style='position: relative;'/>");
    var iframe = $("<iframe id='" + iframeGuid + "' name='" + iframeGuid + "'/>").appendTo(container);
    var eventShield = $("<div style='position: absolute; top: 0; left: 0;'/>");

    function resizeIframeToMatchContainer() {
      var height = container.dialog("widget").find(".ui-dialog-content").height();
      iframe.css({height: height+"px"});
      eventShield.css({height: height+"px", width: "100%"});
    }

    container.dialog({
       title: opts.title,
       width: opts.width,
       resizeStart: function() { eventShield.appendTo(container) },
       resizeStop: function() { eventShield.remove() },
       resize: resizeIframeToMatchContainer,
       open: resizeIframeToMatchContainer
    });

    form = $("<form action='" + opts.url + "' method='post' target='" + iframeGuid + "'/>");
    form.append(this.cloneFormFields()).submit();
  }
})