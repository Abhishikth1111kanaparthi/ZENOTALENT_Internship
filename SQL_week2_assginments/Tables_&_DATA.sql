CREATE	 database assignment;
USE assignment;

CREATE TABLE Projects (
    ProjectID VARCHAR(10) PRIMARY KEY,
    ProjectName VARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(20)
    -- ALTERED THE TABLE AND ADDED A COLUMN OF BUDGET
);

CREATE TABLE Tasks (
    TaskID VARCHAR(10) PRIMARY KEY,
    TaskName VARCHAR(100),
    ProjectID VARCHAR(10),
    AssignedTo VARCHAR(10),
    DueDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);
CREATE TABLE Teams (
    TeamMemberID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(100),
    Role VARCHAR(50),
    JoinDate DATE,
    ContactEmail VARCHAR(100)
);

-- FOR TASK 9 
CREATE TABLE Model_Training (
    training_id INT PRIMARY KEY,
    project_id VARCHAR(10),
    model_name VARCHAR(100),
    accuracy DECIMAL(5,2),
    training_date DATE,
    FOREIGN KEY (project_id) REFERENCES Projects(ProjectID)
);

-- FOR TALSK 10
CREATE TABLE Data_Sets (
    dataset_id INT PRIMARY KEY,
    project_id VARCHAR(10),
    dataset_name VARCHAR(100),
    size_gb DECIMAL(6,2),
    last_updated DATE,
    FOREIGN KEY (project_id) REFERENCES Projects(ProjectID)
);

USE assignment;

INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate, Status) VALUES
('P001', 'AI Assistant', '2025-01-10', '2025-07-30', 'Completed'),
('P002', 'Web Redesign', '2025-03-15', '2025-08-15', 'Ongoing'),
('P003', 'Mobile App Dev', '2025-04-01', '2025-10-01', 'Ongoing'),
('P004', 'CRM Integration', '2025-02-20', '2025-06-30', 'Completed'),
('P005', 'Data Migration', '2025-05-05', '2025-09-30', 'On Hold');

ALTER TABLE Projects ADD Budget DECIMAL(12,2);
-- Update the budgets (example values)
UPDATE Projects SET Budget = 500000 WHERE ProjectID = 'P001';
UPDATE Projects SET Budget = 700000 WHERE ProjectID = 'P002';
UPDATE Projects SET Budget = 620000 WHERE ProjectID = 'P003';
UPDATE Projects SET Budget = 480000 WHERE ProjectID = 'P004';
UPDATE Projects SET Budget = 750000 WHERE ProjectID = 'P005';

INSERT INTO Tasks (TaskID, TaskName, ProjectID, AssignedTo, DueDate, Status) VALUES
('T001', 'UI Mockups', 'P002', 'TM001', '2025-04-10', 'Completed'),
('T002', 'Backend API Dev', 'P002', 'TM002', '2025-06-01', 'Ongoing'),
('T003', 'iOS Frontend Dev', 'P003', 'TM003', '2025-08-01', 'Ongoing'),
('T004', 'Database Backup', 'P005', 'TM004', '2025-06-15', 'Completed'),
('T005', 'AI Model Testing', 'P001', 'TM005', '2025-07-15', 'Completed'),
('T006', 'Login Page Integration', 'P003', 'TM001', '2025-08-15', 'Ongoing'),
('T007', 'Testing Module A', 'P003', 'TM002', '2025-08-10', 'Completed'),
('T008', 'Database Sync Script', 'P005', 'TM004', '2025-08-05', 'Ongoing'),
('T009', 'UI Review', 'P002', 'TM001', '2025-07-30', 'Completed'),
('T010', 'Push Notifications', 'P003', 'TM003', '2025-08-12', 'Ongoing'),
('T011', 'Error Logging Setup', 'P002', 'TM002', '2025-08-01', 'Ongoing'),
('T012', 'Performance Optimization', 'P001', 'TM005', '2025-07-25', 'Completed'),
('T013', 'Analytics Integration', 'P001', 'TM005', '2025-07-29', 'Completed'),
('T014', 'Security Audit', 'P004', 'TM004', '2025-07-20', 'Completed'),
('T015', 'API Rate Limiting', 'P002', 'TM002', '2025-08-18', 'Ongoing');


INSERT INTO Teams (TeamMemberID, Name, Role, JoinDate, ContactEmail) VALUES
('TM001', 'Abhishikth K', 'UI Designer', '2024-11-01', 'abhishikt@company.com'),
('TM002', 'Alex Kumer ', 'Backend Dev', '2024-10-10', 'alex@company.com'),
('TM003', 'Ravi Patel', 'Mobile Dev', '2025-01-15', 'ravi@company.com'),
('TM004', 'Leena George', 'Database Admin', '2023-12-20', 'leena@company.com'),
('TM005', 'Megha Singh', 'ML Engineer', '2025-03-25', 'megha@company.com');

UPDATE Teams SET Role = 'Team Lead' WHERE TeamMemberID IN ('TM001', 'TM005');

-- FOR TASK 9  DATA INSERTS 
INSERT INTO Model_Training (training_id, project_id, model_name, accuracy, training_date) VALUES
(1, 'P001', 'BERT_v2', 89.20, '2025-06-15'),
(2, 'P001', 'GPT-Lite', 87.50, '2025-06-10'),
(3, 'P001', 'ResNet50', 84.00, '2025-06-18'),
(4, 'P003', 'ResNet50', 82.00, '2025-07-10'),
(5, 'P003', 'MobileNet', 78.40, '2025-07-05'),
(6, 'P003', 'BERT_v2', 83.20, '2025-07-12'),
(7, 'P005', 'XGBoost', 80.00, '2025-07-20'),
(8, 'P005', 'RandomForest', 77.00, '2025-07-18'),
(9, 'P005', 'BERT_v2', 81.50, '2025-07-22');


-- FOR TASK 10 DATA INSERTS 
INSERT INTO Data_Sets (dataset_id, project_id, dataset_name, size_gb, last_updated) VALUES
(1, 'P001', 'AI_Text_Corpus', 12.50, CURDATE() - INTERVAL 10 DAY),
(2, 'P002', 'Website_Logs', 8.00, CURDATE() - INTERVAL 5 DAY),
(3, 'P003', 'Mobile_Usage_Data', 15.00, CURDATE() - INTERVAL 20 DAY),
(4, 'P004', 'CRM_Export', 9.50, CURDATE() - INTERVAL 40 DAY),
(5, 'P005', 'Migration_Backup', 11.00, CURDATE() - INTERVAL 28 DAY);
