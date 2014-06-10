<cfquery datasource="#APPLICATION.DSN#">
INSERT INTO smg_users_payments (
       agentID,       
       companyID,       
       studentID,       
       programID,       
       hostID,       
       paymentType,       
       transType,       
       amount,       
       comment,       
       date,       
       inputBy,       
       dateCreated )
       
SELECT DISTINCT
       s.placeRepID,       
       s.companyID,       
       s.studentID,       
       s.programID,       
       s.hostID,       
       27,       
       "Placement",      
       175,       
       "Auto Uploaded",     
       CURDATE(),       
       99999999,       
       CURDATE()
FROM smg_students s
INNER JOIN smg_hosts h ON s.hostID = h.hostID
INNER JOIN smg_hosthistory hh ON s.studentID = hh.studentID
      AND hh.isActive = 1
INNER JOIN smg_hosthistorytracking hht ON hh.historyID = hht.historyID     
INNER JOIN smg_host_app_season shas ON shas.hostID = s.hostID
      AND shas.applicationStatusID <= 3
INNER JOIN smg_programs p ON p.programID = s.programID
      AND p.type IN(1,2)      
      AND p.programID >= 340
WHERE s.companyID = 10
AND (
    CURDATE() > (SELECT MAX(dep_date) FROM smg_flight_info WHERE studentID = s.studentID AND isDeleted = 0 AND flight_type = "departure")
    OR (s.schoolID IN (SELECT schoolID FROM smg_school_dates WHERE seasonID IN (SELECT seasonID FROM smg_programs WHERE programID = s.programID) AND year_ends <= CURDATE()) AND p.type = 1)
    OR (s.schoolID IN (SELECT schoolID FROM smg_school_dates WHERE seasonID IN (SELECT seasonID FROM smg_programs WHERE programID = s.programID) AND semester_ends <= CURDATE()) AND p.type = 2) )    
AND NOT EXISTS (SELECT agentID FROM smg_users_payments WHERE studentID = s.studentID AND paymentType IN (12,27))
AND ( 
    (p.type = 1 AND MONTH(CURDATE()) IN (4,5,6,7,8)) 
    OR ( p.type = 2 AND ( (MONTH(CURDATE()) IN (1,2,3,4)) OR (MONTH(CURDATE()) = 12 AND DAY(CURDATE()) >= 15) ) )
    )
AND s.placeRepID NOT IN (SELECT fk_userID FROM smg_user_payment_special WHERE isActive = 1 AND receivesDeparturePayment = 0)        
AND hh.host_arrival_orientation IS NOT NULL
AND hh.stu_arrival_orientation IS NOT NULL
AND hh.doc_school_sign_date IS NOT NULL
AND (
    (h.hostID NOT IN (SELECT hostID FROM smg_host_children WHERE hostID = h.hostID AND liveathome = "yes") 
              AND (h.motherLastName = "" OR h.fatherLastName = "") 
              AND hh.compliance_single_place_auth IS NOT NULL
              AND hh.compliance_single_parents_sign_date IS NOT NULL
              AND hh.compliance_single_student_sign_date IS NOT NULL)
    OR h.hostID IN (SELECT hostID FROM smg_host_children WHERE hostID = h.hostID AND liveathome = "yes") 
    OR (h.motherLastName != "" AND h.fatherLastName != "")  
    )    
AND (
    (hht.isDoublePlacementPaperworkRequired = 0 OR hht.isDoublePlacementPaperworkRequired IS NULL) 
    OR (hht.isDoublePlacementPaperworkRequired = 1 AND hht.doublePlacementStudentDateCompliance IS NOT NULL AND hht.doublePlacementHostFamilyDateCompliance IS NOT NULL)
    )
AND s.studentID NOT IN (SELECT `student ID` FROM v_all_missing_progress_reports)
</cfquery>