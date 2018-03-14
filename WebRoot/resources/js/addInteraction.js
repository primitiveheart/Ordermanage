var draw ;
var old_feature;
function addInteraction(value, vector, source, map) {
	if (value !== 'None') {
      if (value === 'LineString') {
	       	draw = new ol.interaction.Draw({
		     	source:source,
		     	type:'LineString',
		     	style:draw_style,
		     	maxPoints:2,
		     	snapTolerance:100,
		     	geometryFunction:function(coordinates,geometry){
		     		if(!geometry){
		     			geometry = new ol.geom.Polygon(null);
		     		}
		     		var start = coordinates[0];
		     		var end = coordinates[1];
		     		geometry.setCoordinates([
		     			[start, [start[0], end[1]], end, [end[0], start[1]]]
		     		]);
		     		return geometry;
	    	    }
     		})
      	}else {
 			draw = new ol.interaction.Draw({
	            source: source,
	            type: (value),
	            style:draw_style
	        });
 		}
      	//画图开始之前先删除之前画的图形
	  draw.on('drawstart', function(e){
	  	if(old_feature != null && old_feature != undefined){
	  		source.removeFeature(old_feature);
	  	}
	  	old_feature = e.feature;
	  },this);
    }
    map.addInteraction(draw);
}