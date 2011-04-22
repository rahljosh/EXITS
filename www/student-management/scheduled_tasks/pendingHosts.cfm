    <cfdump var="#Application#">
<cfquery name="pending_hosts" datasource="MySQL">
		SELECT 
        	s.host_fam_approved, 
            s.studentid, 
            s.hostid, 
            s.firstname, 
            s.familylastname as student_lastname, 
            s.regionassigned, 
            s.dateplaced,
            s.arearepid,
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
        	s.host_fam_approved between  5 and 98		
		
            AND
                s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes"> )
   
		ORDER BY 
        	host_fam_approved
	</cfquery>

<cfabort>
    <cfoutput>
    <Cfloop query="pending_hosts">
    <cfset DisplayEndDate = #DateAdd('d', 4, '#dateplaced#')#>
   			
	<cfif #DisplayEndDate# lt #now()#>
		Reject
        <!----
        <cfquery datasource="mysql">
        update smg_students
        set host_fam_approved = 99
        where studentid = #studentid#
        </cfquery>
        <!----Email Area Rep so they know---->
		 		<cfquery name="company_info" datasource="mysql">
                select *
                from smg_companies
                where companyid = #i#
                </cfquery>
                <Cfset CLIENT.exits_url = #company_info.url_ref#>
                <cfset client.companyname = #company_info.companyname#>
            
                <cfquery name="areaRepEmail" datasource="mysql">
                select firstname, lastname, email
                from smg_users
                where userid = #pending_hosts.hostid#
                </cfquery>
               
            
            <cfmail to="#areaRepEmail.email#" from="support@iseusa.com" subject="Placement for #pending_hosts.firstname# #pending_hosts.student_lastname# has been rejected." cc="josh@iseusa.com">
            #areaRepEmail.firstname# #areaRepEmail.lastname#-<br /><br />
            The pending placement for <strong>#pending_hosts.firstname# #pending_hosts.student_lastname#</strong> with the <Strong>pending_hosts.familylastname</Strong> has
            been automatically rejected by EXITS due to the fact that it has been a pending placement for at least 96 hours.<br /><br />
            <br /><br />
            <font size=-1>
            This information is accurate as of <strong>#DateFormat(now(),'mmm d, yyyy')# at #TimeFormat(now(),'h:m tt')#</strong>.<br />
            Once the student is removed from the Rejected Placement list, they will be available for placement with another family. <br />
            This information is also available on initial welcome page when you login under Pending Placements.
            </font> 
            
            </cfmail>
                ---->
              
            <!----End of Email---->
                    
     
    <cfelse>
    	<!---- Leave as is---->
    </cfif>
    </Cfloop>  
   
    </cfoutput>