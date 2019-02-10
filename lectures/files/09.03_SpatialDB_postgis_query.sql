SELECT osm_id, way, amenity FROM planet_osm_point poi
JOIN (SELECT ST_BUFFER(way, 1000) as buffer FROM planet_osm_polygon WHERE osm_id = 248120513) t 
ON ST_WITHIN(poi.way, t.buffer)
WHERE poi.amenity IS NOT NULL

--najdi vsetky sluzby v okoli jedneho kilometra od fakulty
SELECT amenity, name FROM planet_osm_point poi
JOIN (SELECT ST_BUFFER(way, 1000) as buffer FROM planet_osm_polygon WHERE osm_id = 248120513) t 
ON ST_WITHIN(poi.way, t.buffer)
WHERE amenity IS NOT NULL;

-- kolko m^2 zabera fakulta?
https://www.daftlogic.com/projects-google-maps-area-calculator-tool.htm

SELECT ST_AREA(way) FROM planet_osm_polygon WHERE osm_id = 183864748;
SELECT * FROM spatial_ref_sys WHERE srid = (SELECT ST_SRID(way) FROM planet_osm_polygon WHERE osm_id = 183864748);
SELECT ST_AREA(ST_Transform(way,4326)::geography) FROM planet_osm_polygon WHERE osm_id = 183864748;


