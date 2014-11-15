$(function() { //onload

	var noshow = "noshow";

	// highlight first day
	var firstday = $('.weekday')[0];
	if (firstday) {
		firstday.className += " pure-menu-selected";

		// make day1 chooser visible
		// th '3' in 'd3'
		var firstdayid = firstday.firstElementChild.id.charAt(1);
		toggle($("#c" + firstdayid)[0], noshow);
	}

	// side bar select day
	$('#d1, #d2, #d3, #d4, #d5').click( function(e) {
		e.preventDefault();
		
		var active = "pure-menu-selected";
		// currently selected
		var that = $(".weekday." + active)[0].firstElementChild;
		if (this === that)
			return; // don't change selction

		toggle( $(that).parent()[0], active);				// remove active
		toggle( $("#c" + that.id.charAt(1))[0], noshow);	// hide old chooser

		toggle( $(this).parent()[0], active);				// make active
		toggle( $("#c" + this.id.charAt(1))[0], noshow);	// show new chooser
	});

	// click on button, then style toggled and input val toggled
	$('.button-time, .button-place').click( function(e) {
		var active = "pure-button-active";
		// toggle whether button looks selected
		toggle( this, active);
		childinput = $(this.firstElementChild);
		// toggle checked
		childinput.prop('checked', !childinput.prop('checked'));
	});

	// click on button-places, then button-place's all on or all off
	$('.button-places').click( function(e) {
		var active = "pure-button-active";
		var placesId = this.id.charAt(3);
		var members; // each of the button-place's to toggle

		var pre = "#" + this.id.substring(0,3).toLowerCase(); // #d_p
		if (placesId == 0) // double equals bc one char one int
			members = $(pre + 0 +","+ pre + 1);
		else if (placesId == 1)
			members = $(pre + 2 +","+ pre + 3 +","+ pre + 4);
		else if (placesId == 2)
			members = $(pre + 5 +","+ pre + 6 +","+ pre + 7 +","+ pre + 8);
		else if (placesId == 3)
			members = $(pre + 9 +","+ pre + 10 +","+ pre + 11 +","+ pre + 12);

		var allChecked = true;
		$(members).each( function() {
			if (!$(this).prop('checked')) { // if one element not checked
				allChecked = false;
				return;
			}
		});

		if (allChecked)
			$(members).parent().trigger('click'); // turn all off
		else {
			$(members).each( function() {
				if (!$(this).prop('checked')) // turn on if not checked
					$(this).parent().trigger('click');
			});
		}
	});

	// click on existing openings
	var eo = $('.eo');
	if (eo.length)
		$(eo[0].id).parent().trigger('click');

	// side bar pop out
	var pick_layout = $('#pick-layout')[0],
		pick_menu     = $('#pick-menu')[0],
		pick_menuLink = $('#pick-menuLink')[0];

	if (pick_menuLink) {
		pick_menuLink.onclick = function (e) {
			var active = 'active';
			e.preventDefault();
			toggle(pick_layout, active);
			toggle(pick_menu, active);
			toggle(pick_menuLink, active);
		};
	}

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
});
