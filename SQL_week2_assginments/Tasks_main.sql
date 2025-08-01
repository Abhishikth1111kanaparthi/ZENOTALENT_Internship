-- TASK 1 
WITH TaskSummary AS ( -- USING A CTE
    SELECT
        ProjectID,
        COUNT(*) AS total_tasks, -- COUNTING TOTAL TASKS 
        SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS completed_tasks -- COUNTING HOW OF THOSE TASKS ARE COMPLETE
    FROM Tasks
    GROUP BY ProjectID   -- GROUP THE TASKS BY THERE PROJECT ID 
)
SELECT
    P.ProjectName,
    TS.total_tasks,
    TS.completed_tasks
FROM Projects P
JOIN TaskSummary TS ON P.ProjectID = TS.ProjectID; -- JOINS CTE WITH THE PROJECT TABLE TO GET THE PROJECT NAMES
-- TASK 1 END 



-- TASK 2
WITH TaskCount AS ( --  CTE 
    SELECT
        AssignedTo,
        COUNT(*) AS task_count
    FROM Tasks
    GROUP BY AssignedTo -- GROUPING TASKS BY ASSIGNEDTO  AND COUNTS THE NUM  TASKS EACH TEAM MEMBER HAS 
),
RankedMembers AS ( -- CTE 
    SELECT
        T.AssignedTo,
        TC.task_count,
        TM.Name,
        RANK() OVER (ORDER BY TC.task_count DESC) AS rnk -- RANK() IS USED FOR RANKING THE MEMBERS 
    FROM TaskCount TC
    JOIN Teams TM ON TC.AssignedTo = TM.TeamMemberID  -- JOINING WITH TEAMS TABLE TO GET NAMES 
    JOIN Tasks T ON TC.AssignedTo = T.AssignedTo
    GROUP BY T.AssignedTo, TC.task_count, TM.Name     
)
SELECT AssignedTo,Name,task_count
FROM RankedMembers WHERE rnk <= 2; -- FILTERING THE DATA TO SHOW ONLY THE TOP 2 RANKED MEMBERS
-- TASK 2 END 



-- TASK 3 
SELECT T.TaskID,T.TaskName,T.ProjectID,T.DueDate,
-- TO_DAYS COVNERTS A DATE TO THE NUM OF  DAYS SINCE YEAR 0
--  USEFUL FOR CALCULATING THE AVG DATE 
--  FROM_DAYS CONVERTS THE AVG  BACK TO READABLE DATE 
    FROM_DAYS(( 
        SELECT AVG(TO_DAYS(T2.DueDate)) 
        FROM Tasks T2                    
        WHERE T2.ProjectID = T.ProjectID
    )) AS Avg_DueDate
FROM Tasks T WHERE TO_DAYS(T.DueDate) < (
    SELECT AVG(TO_DAYS(T2.DueDate)) -- CALCULATING THE AVG 
    FROM Tasks T2
    WHERE T2.ProjectID = T.ProjectID
);
-- TASKS 3 END 



-- TASKS 4 
SELECT * FROM Projects -- ADD A EXTRA COLUMN FOR BUDGET  
WHERE Budget = (SELECT MAX(Budget)FROM Projects); -- USE MAX() TO GET HIGHEST BUDGET 
-- TASK 4 END



-- TASK 5 
SELECT
    P.ProjectID,
    P.ProjectName,
    COUNT(T.TaskID) AS total_tasks, -- COUNTING THE TOTAL TASKS 
    SUM(CASE WHEN T.Status = 'Completed' THEN 1 ELSE 0 END) AS completed_tasks, -- CALCULATING COMPLETED  TASKS  
    ROUND(           -- USING ROUND() TO ROUND UP THE PERCENTAGE MAKING IT ONLY 2 DECIMALS
        (SUM(CASE WHEN T.Status = 'Completed' THEN 1 ELSE 0 END) / COUNT(T.TaskID)) * 100, 2  -- CALCULATING THE PERCENTAGE
    ) AS completion_percentage
FROM Projects P
LEFT JOIN Tasks T ON P.ProjectID = T.ProjectID -- TO ENSURE PROJECTS WITH ZEROS TASKS ARE STILL  SHOWN 
GROUP BY P.ProjectID, P.ProjectName;
-- TASK 5 END 



-- TASK 6 
SELECT
    AssignedTo,TaskName, 
    -- COUNTING NUM OF TASKS EACH TEAM MEMBER 
    COUNT(*) OVER (PARTITION BY AssignedTo) AS task_count -- PARTITION BY ENSURE THE COUNT IS CALCULATED PER PERSON
FROM Tasks ORDER BY AssignedTo;  					
-- TASK 6 END 



-- TASK 7
SELECT 
    T.TaskID,
    T.TaskName,
    T.AssignedTo,
    TM.Name AS TeamMemberName,
    T.DueDate,
    T.Status
FROM Tasks T
JOIN Teams TM ON T.AssignedTo = TM.TeamMemberID
WHERE 
    TM.Role = 'Team Lead' -- REQUIRED ROLE 
    AND T.Status != 'Completed' -- CHECKING FOR ONLY INCOMPLETE TASKS
    AND T.DueDate BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 15 DAY); -- ENSURES THE DUE DATE WITHIN 15 DAYS FORM TODAY
-- TASK 7 END 



-- TASK 8 
SELECT P.ProjectID, P.ProjectName
FROM Projects P
WHERE NOT EXISTS ( -- CHECKING IF ANY PROJECT HAS NO EXSITING TASKS 
    SELECT 1 FROM Tasks T 
    WHERE T.ProjectID = P.ProjectID -- WILL RETURN NULL BECAUSE ALL PROJECTS HAVE TASKS ASSIGNED --
);
-- TASK 8 END 



-- TASK 9
WITH RankedModels AS (
    SELECT 
        project_id,
        model_name,
        accuracy,
        ROW_NUMBER() OVER (PARTITION BY project_id ORDER BY accuracy DESC) AS rnk -- RANKING MODEL IN DESCENDING ORDER 
    FROM Model_Training
)
SELECT 
    P.ProjectID,
    P.ProjectName,
    R.model_name AS Best_Model,
    R.accuracy AS Best_Accuracy
FROM Projects P
JOIN RankedModels R ON P.ProjectID = R.project_id  -- JOINING THE RAMKED MODELS TO THERE PROJECT IDS 
WHERE R.rnk = 1; -- GIVES THE OUTPUT OF THE 1 RANKING MODEL 
-- TASK 9 END 



-- TASK 10
SELECT 
    P.ProjectID,
    P.ProjectName,
    D.dataset_name,
    D.size_gb,
    D.last_updated
FROM Projects P
JOIN Data_Sets D ON P.ProjectID = D.project_id
WHERE 
    D.size_gb > 10 -- CHECKING IF SIZE IS GREATER THAN 10 GB 
    AND D.last_updated >= CURDATE() - INTERVAL 30 DAY; -- CHECKING IF THE LAST UPDATE IS WITHIN 30 DAYS 
-- TASK 10 END 

