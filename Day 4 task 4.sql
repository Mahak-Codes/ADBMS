/*
Our objective is to identify the top 5 artist whose song appears most frequently in top 10 of global ranking 
Note: if multiple songs from the same artist are in top 10 ,they should all cnt towards that artists total appaerence ,
we want to rank these artists based on no of time their songs have appeared in top 10
if there are ties they should have the same ranking ,but overall ranking no should remains same 
*/
CREATE TABLE ARTISTS (
    ARTIST_ID INT PRIMARY KEY,
    ARTIST_NAME VARCHAR(50),
    LABEL_OWNER VARCHAR(50)
);

INSERT INTO ARTISTS VALUES 
(101, 'ED SHEERAN', 'WARNER MUSIC GROUP'),
(120, 'DRAKE', 'WARNER MUSIC GROUP'),
(125, 'BAD BUNNY', 'RIMAS ENTERTAINMENT'),
(130, 'LADY GAGA', 'INTERSCOPE RECORDS'),
(140, 'KATY PERRY', 'CAPITOL RECORDS');

CREATE TABLE SONGS (
    SONG_ID INT PRIMARY KEY,
    ARTIST_ID INT,
    NAME VARCHAR(50),
    FOREIGN KEY (ARTIST_ID) REFERENCES ARTISTS(ARTIST_ID)
);

INSERT INTO SONGS VALUES 
(55511, 101, 'PERFECT'),
(45202, 101, 'SHAPE OF YOU'),
(22222, 120, 'ONE DANCE'),
(19960, 120, 'HOTLINE BLING'),
(33333, 125, 'DAKITI'),
(44444, 125, 'YONAGUNI'),
(55555, 130, 'BAD ROMANCE'),
(66666, 130, 'POKER FACE'),
(99999, 140, 'ROAR'),
(101010, 140, 'FIREWORK');

CREATE TABLE GLOBAL_SONG_RANK (
    DAY INT,
    SONG_ID INT,
    RANKs INT,
    FOREIGN KEY (SONG_ID) REFERENCES SONGS(SONG_ID)
);

INSERT INTO GLOBAL_SONG_RANK VALUES 
(1, 45202, 5),
(3, 45202, 2),
(1, 19960, 3),
(9, 19960, 6), 
(1, 55511, 8),
(2, 33333, 4),
(4, 44444, 8),
(6, 55555, 1),
(7, 66666, 10),
(5, 99999, 5);

SELECT
  RANK() OVER (ORDER BY COUNT(*) DESC) AS ArtistRank,
  ARTIST_NAME,
  COUNT(*) AS Total_Appearances
FROM (
  SELECT
    a.ARTIST_NAME,
    gr.RANKs
  FROM
    ARTISTS a
  JOIN SONGS s ON a.ARTIST_ID = s.ARTIST_ID
  JOIN GLOBAL_SONG_RANK gr ON s.SONG_ID = gr.SONG_ID
  WHERE
    gr.RANKs <= 10  
) AS ArtistSongRanks
GROUP BY
  ARTIST_NAME
ORDER BY
  ArtistRank
LIMIT 5;


/*
1	ED SHEERAN	3
2	DRAKE	2
2	BAD BUNNY	2
2	LADY GAGA	2
5	KATY PERRY	1
*/
