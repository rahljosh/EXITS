<!---
	Supervision payments query
	Creates records in smg_users_payments for completed supervision.  Note that application must be complete in order for supervision
	payments to be processes
	Paul McLaughlin - October 1, 2013
	Changes:
--->

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
    SELECT DISTINCT
    	pr.fk_sr_user, <!---agentID--->
		st.companyID, <!---companyID--->
        st.studentID, <!---studentID--->
        st.programID, <!---programID--->
        0, <!---old_programID--->
        st.hostID, <!---hostID--->
		(CASE
            WHEN pr.pr_month_of_report = 1 THEN 31
            WHEN pr.pr_month_of_report = 2 THEN 5
            WHEN pr.pr_month_of_report = 3 THEN 32
            WHEN pr.pr_month_of_report = 4 THEN 6
            WHEN pr.pr_month_of_report = 5 THEN 33
            WHEN pr.pr_month_of_report = 6 THEN 7
            WHEN pr.pr_month_of_report = 7 THEN 34
            WHEN pr.pr_month_of_report = 8 THEN 8
            WHEN pr.pr_month_of_report = 9 THEN 29
            WHEN pr.pr_month_of_report = 10 THEN 3
            WHEN pr.pr_month_of_report = 11 THEN 30
            WHEN pr.pr_month_of_report = 12 THEN 4
			END), <!---paymenttype--->
        "Supervision", <!---transtype--->
        IF(prog.type = 1,40,IF(prog.type = 2,42.5,50)), <!---amount depends on program--->
        "Auto-created psm",<!---comment--->
        CURRENT_DATE, <!---date--->
        "999999", <!---inputby--->
        1 <!---ispaid--->
  	FROM smg_students st
    INNER JOIN progress_reports pr ON st.studentID = pr.fk_student AND pr.fk_reporttype = 1
    INNER JOIN smg_programs prog ON st.programID = prog.programID
    INNER JOIN smg_hosthistory hh ON st.studentID = hh.studentID
    LEFT OUTER JOIN smg_user_payment_special sppmt ON pr.fk_sr_user = sppmt.fk_userID <!---and sppmt.specialpaymenttype = "Draw"--->
	WHERE st.programID > 339
	AND st.companyid in (1,2,3,4,5,12)
	AND pr.pr_ny_approved_date is not null
	AND pr.fk_reportType = 1
	AND hh.isactive
	AND hh.dateplaced is not null
	AND hh.compliance_stu_arrival_orientation is not null
	AND hh.compliance_host_arrival_orientation is not null
	AND sppmt.fk_userID is null
	AND(
		(pr.pr_month_of_report in (1,2) and (not EXISTS(select * from smg_users_payments pmt where pmt.paymenttype = 5 and st.studentID = pmt.studentID)) and
        EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 1 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null) and
        EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 2 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))
        or
        (pr.pr_month_of_report in (3,4) and (not EXISTS(select * from smg_users_payments pmt where paymenttype = 6 and st.studentID = pmt.studentID)) and
        EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 3 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null) and
        EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 4 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))
        or
        (pr.pr_month_of_report in (5,6) and(not EXISTS(select * from smg_users_payments pmt where paymenttype = 7 and st.studentID = pmt.studentID)) and
        EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 5 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null) and
        EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 6 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))
        or
        (pr.pr_month_of_report in (7,8) and (not EXISTS(select * from smg_users_payments pmt where paymenttype = 8 and st.studentID = pmt.studentID)) and
        EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 7 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null) and
        EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 8 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))
        or
        (pr.pr_month_of_report in (9,10) and (not EXISTS(select * from smg_users_payments pmt where paymenttype = 3 and st.studentID = pmt.studentID)) and 
        EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 9 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null) and
        EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 10 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))
        or
        (pr.pr_month_of_report in (11,12) and (not EXISTS(select * from smg_users_payments pmt where paymenttype = 4 and st.studentID = pmt.studentID)) and
        EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 11 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null) and
        EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 12 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))
        )

	ORDER BY st.placerepID
</cfquery>