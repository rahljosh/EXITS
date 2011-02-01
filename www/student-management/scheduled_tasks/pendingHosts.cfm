<cfquery name="pending_hosts" datasource="MySQL">
		SELECT 
        	s.host_fam_approved, 
            s.studentid, 
            s.hostid, 
            s.firstname, 
            s.familylastname as student_lastname, 
            s.regionassigned, 
            s.dateplaced,
			h.familylastname, 
            h.fatherfirstname, 
            h.fatherlastname, 
            h.motherlastname, 
            h.motherfirstname, 
            h.city, 
            h.state,  
			p.programname,
            c.companyShort,
            r.regionName
		FROM 
        	smg_students s
		INNER JOIN 
        	smg_hosts h ON s.hostid = h.hostid
		INNER JOIN 
        	smg_programs p ON p.programid = s.programid
		LEFT OUTER JOIN
        	smg_companies c ON c.companyID = s.companyID            
		LEFT OUTER JOIN
        	smg_regions r ON r.regionID = s.regionAssigned
        WHERE 
        	s.active = '1'		
        AND 
        	s.host_fam_approved > 4			
		
            AND
                s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes"> )
   
		ORDER BY 
        	host_fam_approved
	</cfquery>
    <cfoutput>
    <Cfloop query="pending_hosts">
    <cfset DisplayEndDate = #DateAdd('d', 4, '#dateplaced#')#>
    #studentid# #student_lastname# #DateFormat(dateplaced, 'mm/dd/yy')# #TimeFormat(dateplaced, 'hh:mm:ss')# 
	<cfif DateDiff('d', '#DisplayEndDate#', '#now()#') gt 4>
    	<cfquery datasource="mysql">
        update smg_students
        set host_fam_approved = 99
        where studentid = #studentid#
        </cfquery>
        Reset 
    <cfelse>
    	Leave
    </cfif><Br />
    </Cfloop>  
    </cfoutput>