function guid() {
  function S4() {
    return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
  }
  return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
}

$.extend($.fn, {   
  postToIframeDialog: function(opts) {
    var iframeGuid = guid();
    var container = $("<div style='position: rela1tive;'/>");
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

    this.wrap($("<div id='originalLocationWrapper' style='display: inline;'/>"));
    form = $("<form action='" + opts.url + "' method='post' target='" + iframeGuid + "'/>");
    form.append(this).submit();
    this.appendTo($('#originalLocationWrapper')).unwrap();
  }
})