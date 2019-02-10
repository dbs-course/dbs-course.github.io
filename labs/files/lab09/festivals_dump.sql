CREATE TABLE artists (
id serial PRIMARY KEY, 
name VARCHAR(50)
);

CREATE TABLE festivals (
id serial PRIMARY KEY,
name VARCHAR(30)
);

CREATE TABLE stages (
id SERIAL PRIMARY KEY,
name VARCHAR(30),
festival_id BIGINT REFERENCES festivals(id)
 );

 CREATE TABLE festival_editions (
 id SERIAL PRIMARY KEY, 
 year INTEGER, 
 visitors_count INTEGER,
 festival_id BIGINT REFERENCES festivals(id)
 );
 
CREATE TABLE shows (
id SERIAL PRIMARY KEY, 
artist_id BIGINT REFERENCES artists(id), 
festival_edition_id BIGINT REFERENCES festival_editions(id), 
stage_id BIGINT REFERENCES stages(id), 
costs INTEGER
);

INSERT INTO artists (name) VALUES
('Midi Lidi'),
('Kraftwerk'),
('Gogol Bordello'),
('Kaiser Chiefs'),
('Manu Chao'),
('Korben Dallas'),
('Franz Ferdinand'),
('Sparks'),
('Deep Purple'),
('Led Zeppelin'),
('Mogwai'),
('The Beatles');

INSERT INTO festivals(name) VALUES 
('Pohoda');

INSERT INTO stages(name, festival_id) VALUES
 ('Bazant stage',1),
 ('Europa stage',1),
 ('Orange stage',1);

INSERT INTO festival_editions(festival_id, year, visitors_count) VALUES
(1, 2015, 40000),
(1, 2014, 37000),
(1, 2013, 33000);

INSERT INTO shows(artist_id, festival_edition_id, stage_id, costs) VALUES
(1,1,1,20000),
(1,2,1,18000),
(2,1,1,70000),
(3,1,3,50000),
(11,3,3,50000),
(4,2,1,30000),
(5,3,2,19000),
(6,3,2,25000),
(4,3,2,19000),
(10,1,2,15000),
(6,2,2,14000),
(12,3,1,100000),
(9,3,3,5000),
(9,3,2,5000);
