SET search_path = gas;
CREATE OR REPLACE VIEW prices AS SELECT y AS row,content AS price FROM data_3 AS price WHERE x=2 AND y >= 4;
CREATE OR REPLACE VIEW dates AS SELECT y AS row,content AS date FROM data_3 AS date WHERE x=1 AND y >= 4;
SELECT dates.date,prices.price FROM prices INNER JOIN dates ON prices.row = dates.row ORDER BY dates.row;
