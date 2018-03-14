/*
 * 根据scope，shape来重构选择区域的地图，主要是显示地图范围
 * */
function bindMap(shape, scope){
	var ipAddress = getRootPath();
	var projection = ol.proj.get("EPSG:3857");
	var resolutions = [];
	for(var i=0; i<19; i++){
	    resolutions[i] = Math.pow(2, 18-i);
	}
	var tilegrid  = new ol.tilegrid.TileGrid({
	    origin: [0,0],
	    resolutions: resolutions
	});
	
	var baidu_source = new ol.source.TileImage({
	    projection: projection,
	    tileGrid: tilegrid,
	    tileUrlFunction: function(tileCoord, pixelRatio, proj){
	        if(!tileCoord){
	            return "";
	        }
	        var z = tileCoord[0];
	        var x = tileCoord[1];
	        var y = tileCoord[2];
	
	        if(x<0){
	            x = "M"+(-x);
	        }
	        if(y<0){
	            y = "M"+(-y);
	        }
	
	        return "http://online3.map.bdimg.com/onlinelabel/?qt=tile&x="+x+"&y="+y+"&z="+z+"&styles=pl&udt=20151021&scaler=1&p=1";
	        }
	    });
	
	
	  var layers = [
		new ol.layer.Tile({
	      source: baidu_source
	    }),
	    new ol.layer.Tile({
	      source: new ol.source.TileWMS({
		        url: "http://"+ipAddress+":8080/map/census_china/wms",
			    params: {'LAYERS': 'census_china:china_county', 'TILED': true},
			    serverType: 'geoserver'
	      })
	    }),
	    new ol.layer.Tile({
	    	source:new ol.source.TileWMS({
	    		url:"http://"+ipAddress+":8080/map/census_china/wms",
	    		params: {'LAYERS': 'census_china:census_china_grid', 
	    				'TILED': true,
	    				'projection':new ol.proj.Projection("EPSG:4326"),
	    				'displayProjection':projection
	    			},
	 		    serverType: 'geoserver'
	    	})
	    })
	  ];
	
	var draw_style = new ol.style.Style({
        fill:new ol.style.Fill({
            color:'rgba(255, 0, 0, 0.1)'
        }),
        stroke:new ol.style.Stroke({
            color:"#ffcc33",
            width:2
        }),
        image:new ol.style.Circle({
            radius:7,
            fill:new ol.style.Fill({
                color:'#ffcc33'
            })
        })
    })
    
	//地图显示的中心点
	var center;
	//设置feature
	var feature;
	var vector;
	var regionLayer;
	var regionId;
	if(shape=="adminRegion"){
		regionId = getRegionId(scope);
		var viewparams = "r_id:"+regionId;
		
		//设置行政区域的范围
		$.ajax({
			url:"home/getExtentByRegionId.html",
			data:{
				regionId:regionId
			},
			success:function(result){
				var temp = result.extent;
				center = getRegionExtent(temp);
				var level = getLevel(scope);
				regionLayer = new ol.layer.Tile({
					source:new ol.source.TileWMS({
						url:"http://"+ipAddress+":8080/map/census_china/wms",
						params:{
						'LAYERS': 'census_china:getRegionById', 
						'TILED': true,
						'projection':new ol.proj.Projection("EPSG:4326"),
						'displayProjection':new ol.proj.Projection("EPSG:3857"),
						'VIEWPARAMS':viewparams
						},
						serverType:"geoserver"
					})
				});
				var zoom = 8
				if(level != 1){
					zoom = 10;
				}
				
				 var map = new ol.Map({
		    	        layers: layers,
		    	        target: 'map',
		    	        view: new ol.View({
		    	           center:ol.extent.getCenter(center),
		    	           zoom: zoom
		    	        })
		    	    });
		    	map.addLayer(regionLayer);
				
			}
		});
		
		
	}else{
		if(shape == "Circle"){
			var coor = scope.split(";");
			var centerX = ol.proj.transform([coor[0].split(":")[1],coor[1].split(":")[1]], 'EPSG:4326', 'EPSG:3857')[0];
			var centerY = Math.abs(ol.proj.transform([coor[0].split(":")[1],-coor[1].split(":")[1]], 'EPSG:4326', 'EPSG:3857')[1]);
			var radius = coor[2].split(":")[1] * 1000;
			
			center = [centerX - radius, centerY - radius, centerX + radius, centerY + radius];
			
			feature = new ol.Feature({
				geometry:new ol.geom.Circle([centerX,centerY],radius)
			})	
		}else if(shape == "LineString"){
			var coor = scope.split(";")
			
			var min_lon = ol.proj.transform([coor[0].split(":")[1],coor[1].split(":")[1]], 'EPSG:4326', 'EPSG:3857')[0];
			var min_lat = Math.abs(ol.proj.transform([coor[0].split(":")[1],-coor[1].split(":")[1]], 'EPSG:4326', 'EPSG:3857')[1]);
			var max_lon = ol.proj.transform([coor[2].split(":")[1],coor[3].split(":")[1]], 'EPSG:4326', 'EPSG:3857')[0];
			var max_lat = Math.abs(ol.proj.transform([coor[2].split(":")[1],-coor[3].split(":")[1]], 'EPSG:4326', 'EPSG:3857')[1]);
			
			center = [min_lon, min_lat, max_lon, max_lat];
			
			feature = new ol.Feature({
				geometry:new ol.geom.Polygon([[[min_lon, min_lat],[min_lon, max_lat], [max_lon, max_lat], [max_lon, min_lat] ]])
			})
			
		}else{
			var coor = scope.split(":")[1].split("@@");
			var coorArray = [];
			for(var i =0; i < coor.length; i++){
				coorArray[i] = [];
				var middle = coor[i].split("@");
				coorArray[i][0] = ol.proj.transform([middle[0], middle[1]], 'EPSG:4326', 'EPSG:3857')[0];
				coorArray[i][1] = Math.abs(ol.proj.transform([middle[0], -middle[1]], 'EPSG:4326', 'EPSG:3857')[1]);
			}
			
			center = [coorArray[0][0], coorArray[0][1], coorArray[2][0], coorArray[2][1]];
			
			feature = new ol.Feature({
				geometry:new ol.geom.Polygon([coorArray])
			})
		}
		
		//设置样式
		feature.setStyle(draw_style);
		//传入source
		var source = new ol.source.Vector({
			features:[feature]
		});
		//传入vector
	    vector = new ol.layer.Vector({
	        source:source
	    });
	    
	    var map = new ol.Map({
	        layers: layers,
	        target: 'map',
	        view: new ol.View({
	           //center: [0,0],
	           center:ol.extent.getCenter(center),
	           zoom: 10
	        })
	    });
	    map.addLayer(vector);
	}
    
}

