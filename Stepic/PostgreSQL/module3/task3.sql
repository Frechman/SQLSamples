--https://stepik.org/lesson/50165/step/4

CREATE TABLE Conference(
    name TEXT PRIMARY KEY,
    description TEXT
);

CREATE TABLE Venue(
    id INTEGER PRIMARY KEY,
    name TEXT,
    city TEXT,
    country TEXT,
    lat NUMERIC(7,5),
    lon NUMERIC(8,5),
    UNIQUE(lat,lon)
);

CREATE TABLE PaperSubmission(
id INTEGER PRIMARY KEY,
conference TEXT,
year INTEGER,
title TEXT,
isbn TEXT,
page INTEGER,
venue_id INTEGER REFERENCES Venue(id),
FOREIGN KEY (conference) REFERENCES Conference(name),
UNIQUE(conference, year, title),
UNIQUE(isbn, page)
);