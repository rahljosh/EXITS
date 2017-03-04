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
	SELECT
        smg_hosts.arearepID,    
        14,    
        0,    
        0,    
        0,    
        smg_hosts.hostID,    
        0,    
        36,    
        "Pre-Placement",
        CASE      
            WHEN CURDATE() <= '2017-05-01' THEN 150            
            WHEN CURDATE() <= '2017-06-01' THEN 100
            WHEN CURDATE() <= '2017-07-01' THEN 50
            END,  
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
        9999999,    
        CURRENT_DATE,    
        CURRENT_DATE,    
        0
    FROM smg_hosts
    INNER JOIN smg_host_app_season ON smg_host_app_season.hostID = smg_hosts.hostID 
          AND smg_host_app_season.applicationStatusID < 4  
          AND NOT EXISTS (SELECT * FROM smg_host_app_season WHERE hostID = smg_hosts.hostID AND applicationStatusID < 4 AND id != smg_host_app_season.id)      
    INNER JOIN smg_seasons ON smg_seasons.seasonID = smg_host_app_season.seasonID
    WHERE smg_hosts.companyID = 14
    AND smg_seasons.seasonID >= 12
    AND NOT EXISTS (SELECT * FROM smg_users_payments WHERE hostID = smg_hosts.hostID AND companyID = 14 AND paymenttype = 36)
    AND NOT EXISTS (SELECT * FROM smg_hosthistory WHERE hostID = smg_hosts.hostID AND studentID IN (SELECT studentID FROM smg_students WHERE programID IN (SELECT programID FROM smg_programs WHERE seasonID < smg_seasons.seasonID)))
</cfquery>