-- SELECT * result in a sequential scan
SELECT * 
FROM title_basics;
-- Predicates involving an index can be more efficient (also pay attention to the width)
SELECT * 
FROM title_basics 
WHERE "tconst" = 368226;
-- Selecting fewer attributes reduces the width
SELECT "originalTitle", "runtimeMinutes" 
FROM title_basics 
WHERE "tconst" = 368226;

-- drop some indices to make queries slow
DROP INDEX "ix_title_basics_titleType";
-- drop some indices to make queries slow
DROP INDEX "ix_title_basics_runtimeMinutes";

-- Create an index to show how it changes the query (w/o index)
SELECT * 
FROM title_basics 
WHERE "titleType" = 'movie';
-- Create an index to show how it changes the query
CREATE INDEX "ix_title_basics_titleType" on title_basics("titleType");
-- Create an index to show how it changes the query (now with index)
SELECT * 
FROM title_basics 
WHERE "titleType" = 'movie';

-- Sorting on an attribute w/o an index
SELECT "originalTitle", "runtimeMinutes" 
FROM title_basics 
WHERE "runtimeMinutes" is not null 
    AND "titleType" = 'movie' 
ORDER BY "runtimeMinutes" DESC
LIMIT 10;

-- Create index on that attribute
CREATE INDEX "ix_title_basics_runtimeMinutes" on title_basics("runtimeMinutes");
-- Sorting on an attribute w/ an index
SELECT "originalTitle", "runtimeMinutes" 
FROM title_basics 
WHERE "runtimeMinutes" is not null 
    AND "titleType" = 'movie' 
ORDER BY "runtimeMinutes" DESC 
LIMIT 10;

-- Simple query plan for an aggregation + join (group by on non-indexed attribute)
SELECT "originalTitle", COUNT(*)
FROM title_basics RIGHT JOIN title_episode USING (tconst)
GROUP BY "originalTitle";

-- Simple query plan for an aggregation + several joins (group by on indexed attribute)
SELECT "originalTitle", counts.c
FROM title_basics INNER JOIN (
    SELECT tconst, COUNT(*) as c
    FROM title_basics RIGHT JOIN title_episode USING (tconst)
    GROUP BY tconst
) counts ON title_basics.tconst = counts.tconst;

-- actors in The Room (2003)
SELECT n."primaryName"
FROM title_principals p, name_basics n
WHERE p.nconst = n.nconst
    AND p.tconst = 368226;

-- other movies that actors in The Room appeared in
SELECT n."primaryName", t."originalTitle"
FROM title_principals p1, title_principals p2, name_basics n, title_basics t
WHERE p1.nconst = n.nconst AND p2.nconst = n.nconst
    AND p1.tconst = 368226
    AND p2.tconst = t.tconst
    AND t."titleType" = 'movie';

-- films kevin bacon has been in
SELECT p1.tconst
FROM title_principals p1
INNER JOIN name_basics n ON n.nconst = p1.nconst
WHERE n."primaryName" = 'Kevin Bacon' AND p1."category" = 'actor';

-- actors who have been in films with kevin bacon (bacon number = 1)
SELECT DISTINCT p2.nconst, p2.tconst
FROM title_principals p2 INNER JOIN 
(
    SELECT p1.tconst
    FROM title_principals p1
    INNER JOIN name_basics n ON n.nconst = p1.nconst
    WHERE n."primaryName" = 'Kevin Bacon' AND p1."category" = 'actor'
) p1 ON p2.tconst = p1.tconst;


-- bacon number = 2
SELECT DISTINCT p3.nconst, p3.tconst
FROM title_principals p3 INNER JOIN
(
    SELECT p2.tconst
    FROM title_principals p2 INNER JOIN 
    (
        SELECT p1.tconst
        FROM title_principals p1
        INNER JOIN name_basics n ON n.nconst = p1.nconst
        WHERE n."primaryName" = 'Kevin Bacon' AND p1."category" = 'actor'
    ) p1 ON p2.tconst = p1.tconst
    WHERE p2.nconst != 102
) p2 ON p3.tconst = p2.tconst
WHERE p3.nconst != 102;

-- bacon number = 3
SELECT DISTINCT p4.nconst, p4.tconst
FROM title_principals p4 INNER JOIN (
    SELECT p3.tconst
    FROM title_principals p3 INNER JOIN
    (
        SELECT p2.tconst
        FROM title_principals p2 INNER JOIN 
        (
            SELECT p1.tconst
            FROM title_principals p1
            INNER JOIN name_basics n ON n.nconst = p1.nconst
            WHERE n."primaryName" = 'Kevin Bacon' AND p1."category" = 'actor'
        ) p1 ON p2.tconst = p1.tconst
        WHERE p2.nconst != 102
    ) p2 ON p3.tconst = p2.tconst
    WHERE p3.nconst != 102
) p3 ON p4.tconst = p3.tconst
WHERE p4.nconst != 102;

-- bacon number = 4
SELECT DISTINCT p5.nconst, p5.tconst
FROM title_principals p5 INNER JOIN (
    SELECT p4.tconst
    FROM title_principals p4 INNER JOIN (
        SELECT p3.tconst
        FROM title_principals p3 INNER JOIN
        (
            SELECT p2.tconst
            FROM title_principals p2 INNER JOIN 
            (
                SELECT p1.tconst
                FROM title_principals p1
                INNER JOIN name_basics n ON n.nconst = p1.nconst
                WHERE n."primaryName" = 'Kevin Bacon' AND p1."category" = 'actor'
            ) p1 ON p2.tconst = p1.tconst
            WHERE p2.nconst != 102
        ) p2 ON p3.tconst = p2.tconst
        WHERE p3.nconst != 102
    ) p3 ON p4.tconst = p3.tconst
    WHERE p4.nconst != 102
) p4 ON p5.tconst = p4.tconst
WHERE p5.nconst != 102;


-- that's the end!
