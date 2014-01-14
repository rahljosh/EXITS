<!---
	Placement Payments Query
	Creates payment records for all placement payments and bonuses
	Paul McLaughlin - January 8, 2014
	Changes:
--->

<!--- Do not run on a weekend --->
<cfif ListFind("1,7", DayOfWeek(Now()))>
	<cfabort>
</cfif>

<cfquery datasource="#APPLICATION.DSN#">
INSERT INTO smg_users_payments (agentID,companyID,studentID,programID,old_programID,hostID,reportID,
							paymenttype,transtype,amount,comment,date,inputby,dateCreated,dateUpdated,isPaid)

SELECT
	st.placerepID, <!---agentID--->
	st.companyID, <!---companyID--->
	st.studentID, <!---studentID--->
	st.programID, <!---programID--->
	0, <!---old_programID--->
	st.hostID, <!---hostID--->
	0,<!---reportID--->
	pmtrng.fk_paymentType, <!---paymentType - placement--->
	"Placement", <!---transtype--->
	CASE <!--- amount - calculations for amount of payment--->
		WHEN pmtrng.fk_paymenttype = 1 and sppmt.specialPaymentID is Null or sppmt.receivesPlacementFee then pmtrng.paymentAmount
		WHEN pmtrng.fk_paymenttype = 1 and sppmt.receivesPlacementFee = 0 then 0
		WHEN pmtrng.fk_paymenttype IN (18,19,20) AND (sppmt.specialPaymentId IS NULL OR sppmt.receivesPreAYPBonus) THEN pmtrng.paymentAmount
		WHEN pmtrng.fk_paymenttype IN (18,19,20) AND NOT sppmt.receivesPreAYPBonus THEN 0
		WHEN pmtrng.fk_paymenttype =  24 AND (sppmt.specialPaymentId IS NULL OR sppmt.receivesPreAYPBonus) THEN pmtrng.paymentAmount
		WHEN pmtrng.fk_paymenttype =  24 AND NOT sppmt.receivesPreAYPBonus THEN 0
		WHEN pmtrng.fk_paymenttype =  14 AND (sppmt.specialPaymentId IS NULL OR sppmt.receivesStateGuarantee) THEN pmtrng.paymentAmount
		WHEN pmtrng.fk_paymenttype =  14 AND NOT sppmt.receivesStateGuarantee THEN 0
		WHEN pmtrng.fk_paymenttype =  25 AND (sppmt.specialPaymentId IS NULL OR sppmt.receivesCEOBonus) THEN pmtrng.paymentAmount
		WHEN pmtrng.fk_paymenttype =  25 AND NOT sppmt.receivesCEOBonus THEN 0
	END, <!--- amount--->
	"Auto-processed", <!---comment--->
	CASE 
		WHEN DAYOFWEEK(CURDATE()) = 3 THEN DATE_ADD(CURDATE(), INTERVAL 2 DAY)           
		WHEN DAYOFWEEK(CURDATE()) = 4 THEN DATE_ADD(CURDATE(), INTERVAL 1 DAY)           
		WHEN DAYOFWEEK(CURDATE()) = 5 THEN DATE_ADD(CURDATE(), INTERVAL 0 DAY)
		WHEN DAYOFWEEK(CURDATE()) = 6 THEN DATE_ADD(CURDATE(), INTERVAL 3 DAY)  
		WHEN DAYOFWEEK(CURDATE()) = 7 THEN DATE_ADD(CURDATE(), INTERVAL 2 DAY)  
		WHEN DAYOFWEEK(CURDATE()) = 1 THEN DATE_ADD(CURDATE(), INTERVAL 1 DAY)  
		WHEN DAYOFWEEK(CURDATE()) = 2 THEN DATE_ADD(CURDATE(), INTERVAL 0 DAY)
	END, <!---date - need to change to following Monday and Thursday--->
	"9999999", <!---inputby--->
	CURRENT_DATE, <!---dateCreated--->
	CURRENT_DATE, <!---dateUpdated--->
	1 <!---ispaid--->
	
FROM
	smg_students st
		INNER JOIN smg_hosthistory hh ON st.studentID = hh.studentID AND hh.isactive
		INNER JOIN smg_hosts hst ON hh.hostID = hst.hostID
		LEFT OUTER JOIN (SELECT hostID, count(childID) AS numChildren FROM smg_host_children WHERE liveathome = "yes" GROUP BY hostID) ctCh ON hst.hostid = ctch.hostID
		LEFT OUTER JOIN smg_hosthistorytracking hhtr ON hh.historyID = hhtr.historyID AND fieldname = "doublePlacementID"
		INNER JOIN smg_users_payments_ranges pmtrng ON st.programID = pmtrng.fk_programID
		LEFT OUTER JOIN smg_users_payments pmt ON
						st.studentID = pmt.studentID AND pmt.paymenttype = pmtrng.fk_paymentType AND st.arearepID = pmt.agentID
		LEFT OUTER JOIN smg_user_payment_special sppmt ON st.placeRepID = sppmt.fk_userID AND sppmt.specialPaymentType = "draw"
		LEFT OUTER JOIN smg_states states ON st.state_guarantee = states.id AND st.state_guarantee > 0

WHERE
	st.programID > 365 <!---starting with 2014/15 placement year --->
	AND st.companyid IN (1,2,3,4,5,12)
	AND NOT EXISTS(select * from smg_users_payments pmt2 where pmt2.agentID = st.placerepID and pmt2.studentID = st.studentID
					and pmt2.paymenttype = pmtrng.fk_paymentType)
	AND hh.compliance_review IS NOT NULL
	AND hh.datePISEmailed IS NOT NULL
	AND (
		((hst.motherlastname <> "" AND fatherlastname <> "") OR (ctch.numChildren IS NOT NULL)) <!---not a single parent placment--->
		OR ((hh.doc_single_parents_sign_date IS NOT NULL) AND (hh.doc_single_student_sign_date IS NOT NULL) 
		AND (hh.dateplaced IS NOT NULL)) <!--- if SPP, then we have spp sign off docs and placement approved--->
		)
	AND st.programID = pmtrng.fk_programID
	AND (
		pmtrng.fk_paymentType = 1<!--- Regular placement payment--->
		OR (st.aypEnglish > 0 AND pmtrng.fk_paymentType IN (18,19,20) AND 
			hh.datePISEmailed >= pmtrng.paymentStartDate AND hh.datePISEmailed <= pmtrng.paymentEndDate) <!---pre-AYP Bonus--->
		OR (st.aypEnglish > 0 AND st.intrep = 11878 AND pmtrng.fk_paymentType = 24 AND hh.datePISEmailed <= pmtrng.paymentEndDate) <!--- LAB pre-AYP extra - LAB intep 11878--->
		OR (states.state = hst.state and pmtrng.fk_paymentType = 14) <!---state guarantee--->
		OR (pmtrng.fk_paymenttype = 25 AND hh.datePISEmailed >= pmtrng.paymentStartDate AND hh.datePISEmailed <= pmtrng.paymentEndDate) <!---CEO Bonus--->
		)

</cfquery>