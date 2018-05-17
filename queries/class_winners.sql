SELECT name,
         wins,
         class,
         cars,
         years
FROM 
    (SELECT name,
         class,
         array_sort(array_agg(year)) AS years,
         array_sort(array_distinct(array_agg(car))) AS cars,
         count(name) AS wins
    FROM "korrelate_test"."national_results"
    GROUP BY  name, class)
WHERE wins > 3
ORDER BY  wins DESC
