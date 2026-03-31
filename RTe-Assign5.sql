-- 1 -- 
SELECT item.quantityOnHand
FROM item
WHERE itemDescription LIKE '%antibiotics%';

-- 2 --
SELECT volunteer.volunteerName
FROM volunteer
WHERE volunteerTelephone NOT LIKE '2%' 
    AND volunteerName NOT LIKE '%Jones';

-- 3 -- 
SELECT volunteer.volunteerName
FROM volunteer
JOIN assignment
    ON volunteer.volunteerId = assignment.volunteerId
JOIN task
    ON assignment.taskCode = task.taskCode
JOIN task_type
    ON task.taskTypeId = task_type.taskTypeId
WHERE task_type.taskTypeName LIKE '%transport%';

-- 4 -- 
SELECT task.taskDescription
FROM task
LEFT JOIN assignment 
    ON task.taskCode = assignment.taskCode
WHERE assignment.taskCode IS NULL;

-- 5 --
SELECT DISTINCT package_type.packageTypeName
FROM package_type
JOIN package
    ON package_type.packageTypeId = package.packageTypeId
JOIN package_contents
    ON package.packageId = package_contents.packageId
JOIN item 
    ON package_contents.itemId = item.itemId
WHERE item.itemDescription LIKE '%bottle%';

-- 6 -- 
SELECT item.itemDescription
FROM item
LEFT JOIN package_contents
    ON item.itemId = package_contents.itemId
WHERE package_contents.itemId IS NULL;

-- 7 -- 
SELECT task.taskDescription
FROM task
JOIN assignment
    ON task.taskCode = assignment.taskCode
JOIN volunteer
    ON assignment.volunteerId = volunteer.volunteerId
WHERE volunteer.volunteerAddress LIKE '%NJ';

-- 8 -- 
SELECT volunteer.volunteerName
FROM volunteer
JOIN assignment
    ON volunteer.volunteerId = assignment.volunteerId
WHERE startDateTime >= '2021-01-01 00:00:00' AND startDateTime < '2021-07-01 00:00:00';

-- 9 -- 
SELECT DISTINCT volunteer.volunteerName
FROM volunteer
JOIN assignment 
	ON volunteer.volunteerId = assignment.volunteerId
JOIN package
    ON assignment.taskCode = package.taskCode
JOIN package_contents
    ON package.packageId = package_contents.packageId
JOIN item
    ON package_contents.itemId = item.itemId
WHERE item.itemDescription LIKE '%spam%';

-- 10 -- 
SELECT item.itemDescription
FROM item
JOIN package_contents
    ON item.itemId = package_contents.itemId
WHERE package_contents.packageId IN (
    SELECT package_contents.packageId
    FROM package_contents
    JOIN item 
        ON package_contents.itemId = item.itemId
    GROUP BY package_contents.packageId
    HAVING SUM(item.itemValue * package_contents.itemQuantity) = 100);

-- 11 -- 
SELECT task.taskCode, task_status.taskStatusName, COUNT(assignment.volunteerId) AS volunteerCount
FROM task_status
JOIN task
    ON task_status.taskStatusId = task.taskStatusId
JOIN assignment
    ON task.taskCode = assignment.taskCode
GROUP BY task_status.taskStatusName
ORDER BY COUNT(assignment.volunteerId) DESC;

-- 12 -- 
SELECT task.taskCode, 
       SUM(package.packageWeight) AS totalWeight
FROM task
JOIN package
    ON task.taskCode = package.taskCode
GROUP BY task.taskCode
ORDER BY totalWeight DESC
LIMIT 1;

-- 13 --
SELECT COUNT(*)
FROM task
JOIN task_type 
    ON task.taskTypeId = task_type.taskTypeId
WHERE task_type.taskTypeName NOT LIKE '%pack%';

-- 14 -- 
SELECT item.itemDescription, 
       COUNT(DISTINCT assignment.volunteerId) AS volunteersWorked
FROM item
JOIN package_contents
    ON item.itemId = package_contents.itemId
JOIN package
    ON package_contents.packageId = package.packageId
JOIN assignment
    ON package.taskCode = assignment.taskCode
GROUP BY item.itemId, item.itemDescription
HAVING volunteersWorked < 3;

-- 15 -- 
SELECT package_contents.packageId,
    SUM(item.itemValue * package_contents.itemQuantity) AS packageValue
FROM package_contents 
JOIN item
    ON package_contents.itemId = item.itemId
GROUP BY package_contents.packageId
HAVING packageValue > 100
ORDER BY packageValue ASC;

