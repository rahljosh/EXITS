<cfquery datasource="#APPLICATION.DSN#">
	INSERT INTO smg_users_payments (
    	agentID,
        companyID,
        studentID,
        programID,
        oldID,
        hostID,
        paymenttype,
        transtype,
        amount,
        comment,
        date,
        inputby,
        ispaid,
        dateCreated)
	SELECT DISTINCT
    	pr.fk_secondVisitrep,
    	st.companyID,
    	st.studentID,
    	st.programID,
    	0,
    	hh.hostID, 
    	22, 
    	"SecondVisit", 
    	50,  
    	"Auto-processed - ISE",
        CASE 
            WHEN DAYOFWEEK(CURDATE()) = 3 THEN DATE_ADD(CURDATE(), INTERVAL 2 DAY)           
            WHEN DAYOFWEEK(CURDATE()) = 4 THEN DATE_ADD(CURDATE(), INTERVAL 1 DAY)           
            WHEN DAYOFWEEK(CURDATE()) = 5 THEN DATE_ADD(CURDATE(), INTERVAL 0 DAY)
            WHEN DAYOFWEEK(CURDATE()) = 6 THEN DATE_ADD(CURDATE(), INTERVAL 3 DAY)  
            WHEN DAYOFWEEK(CURDATE()) = 7 THEN DATE_ADD(CURDATE(), INTERVAL 2 DAY)  
            WHEN DAYOFWEEK(CURDATE()) = 1 THEN DATE_ADD(CURDATE(), INTERVAL 1 DAY)  
            WHEN DAYOFWEEK(CURDATE()) = 2 THEN DATE_ADD(CURDATE(), INTERVAL 0 DAY)
        END, 
        "999999", 
        0,
        CURRENT_DATE
   	FROM smg_students st
    INNER JOIN smg_hosthistory hh on st.studentID = hh.studentID
    INNER JOIN smg_hosts hst on hh.hostID = hst.hostID
    LEFT OUTER JOIN smg_users_payments pmt on st.studentID = pmt.studentID 
    	AND pmt.paymenttype = 22 
    INNER JOIN progress_reports pr on st.studentID = pr.fk_student 
    	AND hh.hostid = pr.fk_host 
        AND pr.fk_reporttype = 2 
	WHERE hh.isActive = 1
    AND st.programID > 341
    AND st.companyid IN (1,2,3,4,5,12)
    AND hh.isactive
    AND not EXISTS(
    	SELECT * 
        FROM smg_users_payments pmt 
  		WHERE pmt.paymenttype = 22 
        AND st.studentID = pmt.studentID 
        AND hh.hostID = pmt.hostID)
    AND pr.pr_ny_approved_date IS NOT NULL
    ORDER BY st.placerepID
</cfquery>