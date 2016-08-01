/** A helper class for adding CSS rules via javascript */ 
var CSSRules = function() { 
	var headElement = document.getElementsByTagName("head")[0], 
		styleElement = document.createElement("style"); 
	
	styleElement.type = "text/css"; 
	headElement.appendChild(styleElement); 
	// memoize the browser-dependent add function 
	var add = function() { // IE doesn't allow you to append text nodes to <style> elements 
		if (styleElement.styleSheet) { 
			return function(selector, rule) { 
				if (styleElement.styleSheet.cssText == '') { 
					styleElement.styleSheet.cssText = ''; 
				} 
				styleElement.styleSheet.cssText += selector + " { " + rule + " }"; 
			} 
		} else { 
			return function(selector, rule) { 
				styleElement.appendChild(document.createTextNode(selector + " { " + rule + " }")); 
			} 
		} 
	}(); 
	return { add : add } 
}();

/** Initially hide elements with the .jsHide class */
CSSRules.add('.jsHide', 'display: none');