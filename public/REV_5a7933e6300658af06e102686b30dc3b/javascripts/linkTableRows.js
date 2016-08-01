/**
  * @type  jQuery
  * @param Hash    settings             settings 
  * @param String  settings[selector]   selector to use
  * @param String  settings[hoverClass] class to apply to items that the mouse is over an item
  * @param String  settings[cursorType] cursor type to change to when the mouse is over an item
  * @param Bool    settings[hideLink]   whether or not to hide the link
  */
(function($) {
	$.fn.linkTableRows = function(settings) {
		settings = $.extend({
			hoverClass: "hover",
			cursorType: "pointer",
			selector: "tbody tr",
			hideLink: false
		}, settings);
		$(settings.selector, this).each(function() {
			var anchor = $("a", this);
			if (anchor.length == 1) {
				anchor = $(anchor.get(0));
				var link = anchor.attr("href");
				if (link) {
					if (settings.hideLink) {
						var text = anchor.html();
						anchor.after(text).hide();	
					}
					$(this)
						.css("cursor", settings.cursorType)
						.hover(
							function() { $(this).addClass(settings.hoverClass) },
							function() { $(this).removeClass(settings.hoverClass) }
						)
						.click(function() {
							window.location.href = link;
						});
				}
			}
		});
		return this;
	}
})(jQuery);

$(document).ready(function(){ $("table.pretty").linkTableRows(); });