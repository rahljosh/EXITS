<cfquery datasource="#APPLICATION.DSN#">
CREATE TEMPORARY TABLE IF NOT EXISTS bonusReps (
       SELECT bonus.placerepID, hhx.studentid, hhx.datePISEmailed, st.programID, hhx.hostID
       FROM (
         SELECT DISTINCT hh.placerepID
         FROM smg_students st 
         INNER JOIN smg_hosthistory hh ON st.studentID = hh.studentID AND hh.isactive AND hh.datePlaced IS NOT NULL
         INNER JOIN smg_programs prog ON st.programID = prog.programID
		 INNER JOIN smg_seasons seas ON prog.seasonID = seas.seasonID and CURRENT_DATE >= seas.datePaperworkStarted and CURRENT_DATE <=seas.datePaperWorkEnded
         WHERE st.programID > 360
		 AND st.companyID in (1,2,3,4,5,12)
		 AND NOT hh.isRelocation
		 AND st.direct_placement = 0
         AND prog.fk_smg_student_app_programID IN (1,2)
         AND (
             SELECT count(st2.studentID)
             FROM smg_students st2
             INNER JOIN smg_hosthistory hh2 ON st2.studentID = hh2.studentID 
                   AND hh2.isactive
                   AND hh2.dateplaced IS NOT NULL 
             INNER JOIN smg_programs prog2 ON st2.programID = prog2.programID
			 INNER JOIN smg_seasons seas2 ON prog2.seasonID = seas2.seasonID and CURRENT_DATE >= seas2.datePaperworkStarted and CURRENT_DATE <=seas2.datePaperWorkEnded
             WHERE hh.placerepID = st2.placerepID
             AND st2.programID > 360
			 AND st2.companyID IN (1,2,3,4,5,12)
			 AND NOT hh2.isRelocation
			 AND st2.direct_placement = 0
             AND prog2.fk_smg_student_app_programID IN (1,2)
             AND NOT EXISTS (
                 SELECT * 
                 FROM smg_users_payments pmt2
                 WHERE st2.studentID = pmt2.studentID 
                 AND hh2.placeRepID = pmt2.agentID
    			 AND pmt2.paymentType IN (9,15,17))) >= 5) AS bonus 
    INNER JOIN (
          SELECT hh3.placerepID, hh3.studentID, hh3.datePISEmailed, hh3.isactive, hh3.hostID
    	  FROM smg_hosthistory hh3 
    	  INNER JOIN smg_students st3 ON hh3.studentID = st3.studentID
    	  INNER JOIN smg_programs prog3 ON st3.programID = prog3.programID
		  INNER JOIN smg_seasons seas3 ON prog3.seasonID = seas3.seasonID and CURRENT_DATE >= seas3.datePaperworkStarted and CURRENT_DATE <=seas3.datePaperWorkEnded
    	  WHERE st3.programID > 360
		  AND st3.companyID in (1,2,3,4,5,12)
		  AND st3.direct_placement = 0
          AND NOT hh3.isRelocation          
          AND hh3.datePlaced IS NOT NULL
    	  AND prog3.fk_smg_student_app_programID IN (1,2)
    	  AND NOT EXISTS (
              SELECT * 
              FROM smg_users_payments pmt3
    		  WHERE st3.studentID = pmt3.studentID 
              AND hh3.placeRepID = pmt3.agentID
    		  AND pmt3.paymentType IN (9,15,17))
              
              ) AS hhX ON bonus.placerepID = hhX.placerepID
	INNER JOIN smg_students st on hhX.studentID = st.studentID and hhX.isactive
      ORDER BY bonus.placerepID, hhx.datePISEmailed)
</cfquery>

<cfquery datasource="#APPLICATION.DSN#">
SET @i = 0
</cfquery>

<cfquery datasource="#APPLICATION.DSN#">
SET @previousRep = 0
</cfquery>

<cfquery datasource="#APPLICATION.DSN#">
CREATE TEMPORARY TABLE IF NOT EXISTS numberedBonusReps (
SELECT br.*, CASE WHEN br.placerepID = @previousRep OR @previousRep = 0 THEN @i := @i+1 ELSE @i := 1 END AS repCount, @previousRep := br.placerepID
FROM bonusReps br )
</cfquery>

<cfquery datasource="#APPLICATION.DSN#">
CREATE TEMPORARY TABLE IF NOT EXISTS PISDate (
SELECT placerepID,max(datePISEmailed) AS maxPISDate from numberedBonusReps where repCount < 6 group by placeRepID)
</cfquery>

<cfquery datasource="#APPLICATION.DSN#">
INSERT INTO smg_users_payments (agentID,companyID,studentID,programID,oldID,hostID,
						paymenttype,transtype,amount,comment,date,inputby,dateCreated,dateUpdated,isPaid)

SELECT distinct
	nbr.placerepID,
	1, 
	nbr.studentID,
	nbr.programID,
	0, 
	nbr.hostID,
	pmtrng.fk_paymenttype,
	"Placement", 
	pmtrng.paymentAmount,
	"Auto processed - ISE",
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
	1 

FROM 
	numberedBonusReps nbr
	INNER JOIN PISDate PIS ON nbr.placerepID = PIS.placeRepID
	INNER JOIN smg_users_payments_ranges pmtrng ON nbr.programID = pmtrng.fk_programID and pmtrng.fk_paymenttype in (9,15,17)
WHERE nbr.repcount < 6
	  and PIS.maxPISDate >= pmtrng.paymentStartDate and PIS.maxPISDate <= pmtrng.paymentEndDate
</cfquery>

<cfquery datasource="#APPLICATION.DSN#">
DROP TEMPORARY TABLE IF EXISTS bonusReps
</cfquery>

<cfquery datasource="#APPLICATION.DSN#">
DROP TEMPORARY TABLE IF EXISTS numberedBonusReps
</cfquery>

<cfquery datasource="#APPLICATION.DSN#">
DROP TEMPORARY TABLE IF EXISTS PISDate
</cfquery>