function updateLocationCoordinates(glatlng){
	lat_field = document.getElementById("location_lat");
	lng_field = document.getElementById("location_lng");
	
	if(lat_field) {
		lat_field.value = glatlng.lat();
	}
	if(lng_field) {
		lng_field.value = glatlng.lng();
	}
}