<!---
	Second visit payments query
	Creates records in smg_users_payments for completed second visits.  Note that application must be complete in order for second visit
	payments to be processes
	Paul McLaughlin - August 12, 2013
	Changes:
--->

<!--- Do not run on a weekend --->
<cfif ListFind("1,7", DayOfWeek(Now()))>
	<cfabort>
</cfif>

<cfquery datasource="#APPLICATION.DSN#">
	INSERT INTO smg_users_payments(
    	agentID,
        companyID,
        studentID,
        programID,
        old_programID,
        hostID,
        paymenttype,
        transtype,
        amount,
        comment,
        date,
        inputby,
        ispaid )
  	SELECT
        pr.fk_secondVisitrep, <!---agentID--->
        st.companyID, <!---companyID--->
        st.studentID, <!---studentID--->
        st.programID, <!---programID--->
        0, <!---old_programID--->
        hh.hostID, <!---hostID--->
        22, <!---paymentType - placement--->
        "SecondVisit", <!---transtype--->
        50, <!---amount--->
        "Auto-created psm", <!---comment--->
        CURRENT_DATE, <!---date--->
        "999999", <!---inputby--->
        1 <!---ispaid--->
  	FROM smg_students st
    INNER JOIN smg_hosthistory hh ON st.studentID = hh.studentID
    INNER JOIN smg_hosts hst ON hh.hostID = hst.hostID
    LEFT OUTER JOIN smg_users_payments pmt ON st.studentID = pmt.studentID AND pmt.paymenttype = 22 
    INNER JOIN progress_reports pr ON st.studentID = pr.fk_student AND hh.hostid = pr.fk_host AND pr.fk_reporttype = 2 
	WHERE hh.isActive = 1
	AND st.programID > 339
	AND st.companyid IN (1,2,3,4,5,12)
	AND hh.isactive
	AND not EXISTS(
    	SELECT * 
        FROM smg_users_payments pmt 
		WHERE pmt.paymenttype = 22
        AND st.studentID = pmt.studentID
        AND hh.hostID = pmt.hostID )
	AND hh.datePISEmailed IS NOT NULL
	AND pr.pr_ny_approved_date IS NOT NULL
	ORDER BY st.placerepID
</cfquery>