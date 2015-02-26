<!---
	Placement Payments Query
	Creates payment records for all placement payments and bonuses
	Paul McLaughlin - January 8, 2014
	Changes:
--->

<cfquery datasource="#APPLICATION.DSN#">
	INSERT INTO smg_users_payments (
 		agentID,
        companyID,
        studentID,
        programID,
        oldID,
        hostID,
        reportID,
		paymenttype,
        transtype,
        amount,
        comment,
        date,
        inputby,
        dateCreated,
        dateUpdated,
        isPaid)
    SELECT DISTINCT
        smg_students.placerepID,
        smg_students.companyID,
        smg_students.studentID,
        smg_students.programID,
        0,
        smg_students.hostID,
        0,
        smg_users_payments_ranges.fk_paymentType,
        "Placement",
        smg_users_payments_ranges.paymentAmount,
        "Auto-processed - ESI",
        CASE 
            WHEN DAYOFWEEK(CURDATE()) = 3 THEN DATE_ADD(CURDATE(), INTERVAL 2 DAY)           
            WHEN DAYOFWEEK(CURDATE()) = 4 THEN DATE_ADD(CURDATE(), INTERVAL 1 DAY)           
            WHEN DAYOFWEEK(CURDATE()) = 5 THEN DATE_ADD(CURDATE(), INTERVAL 0 DAY)
            WHEN DAYOFWEEK(CURDATE()) = 6 THEN DATE_ADD(CURDATE(), INTERVAL 3 DAY)  
            WHEN DAYOFWEEK(CURDATE()) = 7 THEN DATE_ADD(CURDATE(), INTERVAL 2 DAY)  
            WHEN DAYOFWEEK(CURDATE()) = 1 THEN DATE_ADD(CURDATE(), INTERVAL 1 DAY)  
            WHEN DAYOFWEEK(CURDATE()) = 2 THEN DATE_ADD(CURDATE(), INTERVAL 0 DAY)
            END,
        "9999999",
        CURRENT_DATE,
        CURRENT_DATE,
        0    
    FROM smg_students
    INNER JOIN smg_hosthistory ON smg_hosthistory.studentID = smg_students.studentID
          AND smg_hosthistory.isActive      
          AND NOT smg_hosthistory.isRelocation
          AND smg_hosthistory.compliance_review IS NOT NULL
          AND smg_hosthistory.datePISEmailed IS NOT NULL
          AND smg_hosthistory.compliance_school_accept_date IS NOT NULL    
    INNER JOIN smg_hosts ON smg_hosts.hostID = smg_students.hostID
    INNER JOIN smg_users_payments_ranges ON smg_users_payments_ranges.fk_programID = smg_students.programID
          AND smg_users_payments_ranges.companyID = 14      
          AND smg_users_payments_ranges.fk_paymentType = 1     
    WHERE smg_students.programID > 400
    AND smg_students.companyID = 14
    AND smg_students.canceldate IS NULL
    AND NOT EXISTS (
        SELECT * 
        FROM smg_users_payments 
        WHERE studentID = smg_students.studentID 
        AND paymentType = smg_users_payments_ranges.fk_paymentType 
        AND isDeleted = 0 
        AND (agentID = smg_students.placeRepID OR hostID = smg_students.hostID))    
</cfquery>