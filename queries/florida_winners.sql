SELECT name,
         wins,
         years,
         classes,
         cars
FROM 
    (SELECT name,
         array_sort(array_distinct(array_agg(class))) AS classes,
         array_sort(array_agg(year)) AS years,
         array_sort(array_distinct(array_agg(car))) AS cars,
         count(name) AS wins
    FROM "korrelate_test"."national_results"
    WHERE city LIKE '%FL%'
    GROUP BY  name)
ORDER BY  wins DESC
