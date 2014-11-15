$(function() { //onload
	// if element has classname, splice it
	// else push it onto class string
	function toggle(element, className) {
		var classes = element.className.split(/\s+/),
			length = classes.length,
			i = 0;

		for(; i < length; i++) {
			if (classes[i] === className) {
				classes.splice(i, 1);
				break;
			}
		}
		if (length === classes.length)	// classname is not found
			classes.push(className);

		element.className = classes.join(' ');
	}

	// show bookmark after 3 seconds
	var bookmark = $('#bookmark')[0];
	if (bookmark)
		setTimeout( function() { toggle(bookmark, 'noshow') } , 3000);

});
