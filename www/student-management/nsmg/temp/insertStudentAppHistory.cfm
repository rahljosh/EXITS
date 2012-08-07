
<!--- Insert smg_student_app_status --->
INSERT 
	smg_student_app_status 
(
	studentID, 
    status, 
    approvedBy, 
    reason
)
SELECT 
    studentID, 
    5 AS status, 
    510 AS approvedBy, 
    "Intl. Rep. Request" AS reason
FROM  
    smg_students 
WHERE
    companyid = 13 
AND
    intrep = 13335
AND
    app_current_status = 2


<!--- Update smg_students --->
UPDATE
	smg_students
SET
	app_current_status = 5
WHERE
    companyid = 13 
AND
    intrep = 13335
AND
    app_current_status = 2

