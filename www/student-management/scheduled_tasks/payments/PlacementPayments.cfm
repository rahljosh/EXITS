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
		st.placerepID,
		st.companyID,
		st.studentID,
		st.programID,
		0,
		st.hostID,
		0,
		pmtrng.fk_paymentType,
		"Placement",
		CASE
            WHEN pmtrng.fk_paymenttype = 1 and sppmt.specialPaymentID is Null or sppmt.receivesPlacementFee then pmtrng.paymentAmount
            WHEN pmtrng.fk_paymenttype = 1 and sppmt.receivesPlacementFee = 0 then 0
            WHEN pmtrng.fk_paymenttype IN (18,19,20,38) AND (sppmt.specialPaymentId IS NULL OR sppmt.receivesPreAYPBonus) THEN pmtrng.paymentAmount
            WHEN pmtrng.fk_paymenttype IN (18,19,20,38) AND NOT sppmt.receivesPreAYPBonus THEN 0
            WHEN pmtrng.fk_paymenttype =  24 AND (sppmt.specialPaymentId IS NULL OR sppmt.receivesPreAYPBonus) THEN pmtrng.paymentAmount
            WHEN pmtrng.fk_paymenttype =  24 AND NOT sppmt.receivesPreAYPBonus THEN 0 
            WHEN pmtrng.fk_paymenttype =  14 AND (sppmt.specialPaymentId IS NULL OR sppmt.receivesStateGuarantee) THEN pmtrng.paymentAmount
            WHEN pmtrng.fk_paymenttype =  14 AND NOT sppmt.receivesStateGuarantee THEN 0
            WHEN pmtrng.fk_paymenttype =  23 AND (sppmt.specialPaymentId IS NULL OR sppmt.receivesCEOBonus) THEN pmtrng.paymentAmount
            WHEN pmtrng.fk_paymenttype =  23 AND NOT sppmt.receivesCEOBonus THEN 0
            WHEN pmtrng.fk_paymenttype =  25 AND (sppmt.specialPaymentId IS NULL OR sppmt.receivesCEOBonus) THEN pmtrng.paymentAmount
            WHEN pmtrng.fk_paymenttype =  25 AND NOT sppmt.receivesCEOBonus THEN 0
            WHEN pmtrng.fk_paymenttype =  35 AND (sppmt.receives12MOSBonus IS NULL OR sppmt.receives12MOSBonus) THEN pmtrng.paymentAmount
            WHEN pmtrng.fk_paymenttype =  35 AND NOT sppmt.receives12MOSBonus THEN 0
            WHEN pmtrng.fk_paymenttype = 39 AND sppmt.receivesSpecialBonus = 1 THEN pmtrng.paymentAmount
            WHEN pmtrng.fk_paymenttype = 39 AND (sppmt.receivesSpecialBonus = 0 OR sppmt.receivesSpecialBonus IS NULL) THEN 0
        END,
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
        "9999999",
        CURRENT_DATE,
        CURRENT_DATE,
        0
	FROM smg_students st
    INNER JOIN smg_hosthistory hh ON st.studentID = hh.studentID AND hh.isactive
    INNER JOIN smg_hosts hst ON st.hostID = hst.hostID
    LEFT OUTER JOIN (SELECT hostID, count(childID) AS numChildren FROM smg_host_children WHERE liveathome = "yes" GROUP BY hostID) ctch ON hst.hostid = ctch.hostID
    LEFT OUTER JOIN smg_hosthistorytracking hhtr ON hh.historyID = hhtr.historyID AND fieldname = "doublePlacementID"
    INNER JOIN smg_users_payments_ranges pmtrng ON st.programID = pmtrng.fk_programID
    LEFT OUTER JOIN smg_user_payment_special sppmt ON st.placeRepID = sppmt.fk_userID AND sppmt.specialPaymentType = "draw"
    LEFT OUTER JOIN smg_states states ON st.state_guarantee = states.id AND st.state_guarantee > 0
	WHERE st.programID > 365
	AND st.companyid IN (1,2,3,4,5,12)
	AND pmtrng.companyID = 1
	AND NOT EXISTS(
    	SELECT * 
        FROM smg_users_payments pmt2 
        WHERE pmt2.studentID = st.studentID 
        AND pmt2.paymenttype = pmtrng.fk_paymentType
		AND pmt2.isdeleted = 0 
        AND (pmt2.agentID = st.placerepID OR pmt2.hostID = st.hostID)
  	)
	AND hh.compliance_review IS NOT NULL
	AND hh.isActive
	AND st.canceldate IS NULL
	AND hh.datePISEmailed IS NOT NULL
	AND (
		(
        	(hst.motherlastname <> "" AND fatherlastname <> "") 
            OR (ctch.numChildren IS NOT NULL)
      	)
		OR (
        	(hh.doc_single_parents_sign_date IS NOT NULL) 
            AND (hh.doc_single_student_sign_date IS NOT NULL) 
			AND (hh.dateplaced IS NOT NULL)
      	)
	)
	AND st.programID = pmtrng.fk_programID
	AND NOT hh.isrelocation
	AND (
		pmtrng.fk_paymentType = 1
		OR (
        	hh.dateplaced IS NOT NULL
            AND (pmtrng.paymentEndDate IS NULL OR hh.datePISEMailed <= pmtrng.paymentEndDate)
            AND st.direct_placement = 0
        	AND (
                (st.aypEnglish > 0 AND pmtrng.fk_paymentType IN (18,19,20,38) AND hh.dateCreated >= pmtrng.paymentStartDate)
                OR (st.aypEnglish > 0 AND st.intrep = 11878 AND pmtrng.fk_paymentType = 24)
                OR (states.state = hst.state and pmtrng.fk_paymentType = 14)
                OR (pmtrng.fk_paymenttype = 23 AND hh.dateCreated >= pmtrng.paymentStartDate)
                OR (pmtrng.fk_paymenttype = 25 AND hh.dateCreated >= pmtrng.paymentStartDate AND st.aypenglish = 0)
                OR (pmtrng.fk_paymenttype = 39 AND hh.dateCreated >= pmtrng.paymentStartDate)
                OR (pmtrng.fk_paymenttype = 35 AND hh.dateCreated >= pmtrng.paymentStartDate)
     		)
            AND (hh.isWelcomeFamily = 0 OR pmtrng.fk_paymenttype = 35)
      	)
  	)
</cfquery>