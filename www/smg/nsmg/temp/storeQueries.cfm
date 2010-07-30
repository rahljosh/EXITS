<!--- ISSUED APPLICATIONS - INCLUDES ACTIVATION URL AND RAND ID --->
SELECT
	firstName AS "First Name",
	familyLastName AS "Last Name", 
	CONCAT('http://www.student-management.com/nsmg/student_app/verify.cfm?s=', uniqueID) AS "ACTIVATION URL",     
	email as "Email Address", randid AS ID
FROM 
	smg_students
WHERE
	intrep = 8318 
AND 
	app_current_status = 1 
AND 
	active = 1