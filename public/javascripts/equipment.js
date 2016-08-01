$(function() {

	var currEquipCat = null, currMenuItem = null;
	$('#equipmentList ul.categories a').click(function(e) {
		if(currEquipCat) {
			currMenuItem.removeClass('selected');
			currEquipCat.hide();
		}

		currMenuItem = $(this).parent();
		currMenuItem.addClass('selected');

		currEquipCat = $(this.hash);
		currEquipCat.show();
	}).filter(':first').click();
	
	if(window.location.hash) {
		console.log(window.location.hash);
		$('#equipmentList ul.categories a[href="' + window.location.hash + '"]').click();
	}
});