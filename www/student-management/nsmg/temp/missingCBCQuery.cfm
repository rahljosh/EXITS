<!--- Missing User SSN --->
SELECT
      c.companyShort,
      r.regionName,
      u.userID,      
      u.firstName,      
      u.lastName, 
      u.ssn, 
      u.dateAccountVerified          
FROM
    smg_users u    
INNER JOIN
      user_access_rights uar ON uar.userID = u.userID
      AND uar.companyID IN (1,2,3,4,5,12)      
      AND uar.userType > 4
INNER JOIN              
      smg_regions r ON r.regionID = uar.regionID            
INNER JOIN
      smg_companies c ON c.companyID = r.company            
WHERE
     u.active = 1     
AND
     u.accountCreationVerified > 0
AND
     u.ssn = ''
GROUP BY
      u.userID     
ORDER BY
      c.companyShort,
      r.regionName,
      u.lastName   


<!--- Missing User Member SSN --->
SELECT
      c.companyShort,
      r.regionName,
      u.userID,      
      u.firstName,      
      u.lastName,
      u.dateAccountVerified, 
      suf.ID AS memberID,
      suf.firstName AS memberFirstName,      
      suf.lastName AS memberLastName,      
      suf.SSN,
      suf.dob            
FROM
    smg_users u    
INNER JOIN
      user_access_rights uar ON uar.userID = u.userID
      AND uar.companyID IN (1,2,3,4,5,12)      
      AND uar.userType > 4
INNER JOIN              
      smg_regions r ON r.regionID = uar.regionID            
INNER JOIN
      smg_companies c ON c.companyID = r.company 
INNER JOIN
      smg_user_family suf ON suf.userID = u.userID 
      AND
         FLOOR(DATEDIFF(now(), suf.dob)/365) >= 18 
      AND
         suf.ssn = ''               
WHERE
     u.active = 1     
AND
     u.accountCreationVerified > 0
GROUP BY
      u.userID     
ORDER BY
      c.companyShort,
      r.regionName,
      u.lastName   
      
      
<!--- Missing Host Family SSN --->
SELECT  
        c.companyShort,        
        r.regionName,   
        h.hostID,     
        h.familyLastname,        
        h.fatherFirstName,        
        h.fatherLastName,
        h.fatherSSN,        
        h.motherFirstName,   
        h.motherLastName,        
        h.motherSSN        
FROM
    smg_hosts h               
INNER JOIN
      smg_regions r ON r.regionID = h.regionID   
INNER JOIN
      smg_companies c ON c.companyID = r.company       
      AND r.company IN (1,2,3,4,5,12) 
INNER JOIN          
      smg_students s ON s.hostID = h.hostID
      AND
         s.active = 1 
WHERE
    (
     h.fatherFirstName != ''
AND
     h.fatherSSN = ''      
)
OR 
(
     h.motherFirstName != ''
AND
     h.motherSSN = ''   
)     
GROUP BY
      h.hostID      
ORDER BY
      c.companyShort,
      r.regionName,
      h.familyLastName       
      
<!--- Missing Host Family Member SSN --->
SELECT  
        c.companyShort,        
        r.regionName,   
        h.hostID,     
        h.familyLastname,
        sch.name,
        sch.lastName,
        sch.ssn   
FROM
    smg_hosts h   
INNER JOIN
      smg_host_children sch ON sch.hostID = h.hostID 
      AND
         FLOOR(DATEDIFF(now(), sch.birthDate)/365) >= 18  
      AND
         sch.ssn = '' 
      AND
         sch.liveAtHome = 'yes'                   
INNER JOIN
      smg_regions r ON r.regionID = h.regionID   
INNER JOIN
      smg_companies c ON c.companyID = r.company       
      AND r.company IN (1,2,3,4,5,12) 
INNER JOIN          
      smg_students s ON s.hostID = h.hostID
      AND
         s.active = 1 
GROUP BY
      h.hostID      
ORDER BY
      c.companyShort,
      r.regionName,
      h.familyLastName 