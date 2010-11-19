                SELECT DISTINCT
                    s.studentID, 
                    s.firstname, 
                    s.familyLastName, 
                    s.dob, 
                    MIN(fi.dep_date) as dep_date,            
                    p.startDate,
                    p.endDate,
                    p.insurance_startdate, 
                    p.insurance_enddate
                FROM
                    smg_flight_info fi
                INNER JOIN
                    smg_students s ON fi.studentID = s.studentID 
                        AND
                            s.active = 1
                        AND 
                            s.programID IN ('300,278,264,254')
                        AND          
                            s.companyid IN ('1,2,3,4,12')
                INNER JOIN  
                    smg_programs p ON p.programID = s.programID
                WHERE 
                    fi.flight_type like "%departure%"          
                GROUP BY 
                    fi.studentID
                ORDER BY 
                    dep_date
