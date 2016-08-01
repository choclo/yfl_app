/* Execute on load */
$(function() {
	/* Collapsible map drawer */
	(function(){ 
		var drawer = $(".drawer"),
			initialHeight = drawer.css("height") || 300;
		
		drawer.append("<div class='collapseToggle'><a href='#'><span>Hide</span> map</a></div>")
			.find("a")
			.click(function() {
				var drawer = $(this).parent().parent().find(":first"),
					smallHeight = "120px",
					largeHeight = initialHeight,
					isSmall = (drawer.css("height") == smallHeight);
				
				$(this).find("span").text(!isSmall ? "Show" : "Hide");
				drawer.css("overflow", "hidden")
						.animate({height: (isSmall ? largeHeight : smallHeight)}, 500)
						.parent().toggleClass("closed");
			});
	})();
	
	/* Hide system messages and mark them as read */
	(function(){
		$('div.systemMessage a.close').click(function(){
			var msgDiv = $(this.parentNode);
			function markMessageAsRead() {
				var msgId = msgDiv.attr('id');
				$.ajax({ 
					url: "/system_messages/dismiss",
					type: "POST",
					data: "message_id=" + msgId
				});
			}
			msgDiv.fadeTo('fast', 0).slideUp('fast', markMessageAsRead);
		});
	})();
	
	(function(){
		$(".collapsible").each(function(i, region){
			region = $(region);
			var regionTitle = region.find("legend:first").text();
			var toggleContainer = $("<div class='collapseToggle'></div>")
			var toggle = $("<a href='#'></a>");
			
			// See if there is anything ticked within this group
			var inputs = region.find("input");
			for(var i=0; i<inputs.length; i++){
				var input = inputs[i];
				var hasInputWithValue = false;
				switch(input.type.toLowerCase()){
					case "checkbox": case "radio":
					hasInputWithValue = (input.checked);
					break;
					case "text":
					hasInputWithValue = (input.value != "");
					break;
				}
				if(hasInputWithValue) {
					region.addClass("expanded");
					break;
				}
			}
			
			// Initially show or hide based on current class
			if( region.hasClass("expanded") ){
				region.show();
				toggle.addClass("show");
			} else {
				region.hide();
				toggle.addClass("hide");
			}
			
			var setToggleText = function(){
				if( region.hasClass("expanded") ){
					toggle.text("Hide " + regionTitle);
					toggle.addClass("hide");
					toggle.removeClass("show");
				} else {
					toggle.text("Show " + regionTitle);
					toggle.addClass("show");
					toggle.removeClass("hide");
				}
			};
			
			setToggleText();
			
			toggle.click(function(e){
				region.slideToggle("fast").toggleClass("expanded");
				setToggleText();
				if(region.hasClass("expanded")){ 
					var els = region.find("textarea, input[text]");
					if(els.length) {
						els[0].focus();
					}
				}
				e.stopPropagation();
				e.target.blur();
				return false;
			});
			
			region.before( toggleContainer.append(toggle) );
		})
	})();
});