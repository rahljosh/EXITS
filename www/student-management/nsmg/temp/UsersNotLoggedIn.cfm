SELECT
      c.companyShort,
      r.regionName, 
      ut.userType,     
      u.userID, u.firstName, u.lastName,    
           (
                CASE                     
                    WHEN 
                        u.accountCreationVerified > 0 
                    THEN 
                        "Fully Enabled"                                     
                END
            ) AS fullyEnabled,                    
      u.dateAccountVerified,      
      u.active,
      u.lastLogin     
FROM
    smg_users u    
INNER JOIN user_access_rights uar ON uar.userID = u.userID
      AND      
      uar.companyID IN (1,2,3,4,5,12)      
      AND      
      uar.userType IN (5,6,7)      
INNER JOIN
      smg_regions r ON r.regionID = uar.regionID            
INNER JOIN
      smg_companies c ON c.companyID = r.company            
INNER JOIN
      smg_usertype ut ON ut.userTypeID = uar.userType
WHERE
     u.active = 1  
AND
     u.lastLogin <=  '2011-09-10' 
ORDER BY
      companyShort,
      lastLogin DESC