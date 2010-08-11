<!--- revised by Marcus Melo on 06/24/2005 --->

<cfif not IsDefined('url.flightid')>
	<br><br>
	<table border="0" align="center" width="97%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<tr bgcolor="D5DCE5"><td><a href="http://www.student-management.com"><img src="../pics/logos/5.gif" border="0" align="left"></a></td>	
		<td><b>STUDENT MANAGEMENT GROUP</b><br>
			http://www.student-management.com</td>
		</tr>
	<tr bgcolor="D5DCE5"><th>An error has occured and it was not possible to complete the process requested.
		Please go back and try again.</th></tr>
	<tr bgcolor="D5DCE5"><td align="center"><font size=-1><Br>&nbsp;&nbsp;
					<input type="image" value="close window" src="../pics/back.gif" onClick="javascript:history.go(-1)"></td></tr>
	</table>
<cfelse>
	<!--- <cfdump var="#url.flightid#"> --->
	    <cfquery name="Get_Student" datasource="#application.dsn#">
    select * 
    from smg_flight_info
    where flightid = <cfqueryparam value="#url.flightid#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfquery name="delete_flightid" datasource="MySql">
	DELETE 
	FROM smg_flight_info
	WHERE flightid = <cfqueryparam value="#url.flightid#" cfsqltype="cf_sql_integer">
	LIMIT 1
	</cfquery>
	
        <!---Send Out Email---->
    	<cfquery name="qCheckPHP" datasource="MySql">
            SELECT 
            	studentid
            FROM 
            	php_students_in_program
            WHERE 
            	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student.studentid#">
        </cfquery>
       
        <!--- EMAIL FACILITATORS TO LET THEM KNOW THERE IS A NEW FLIGHT INFORMATION ---->
        <cfif qCheckPHP.studentid eq #studentid#>
            <cfquery name="qGetEmailInfo" datasource="MySQL">
            SELECT 
            	s.studentID,
                s.firstName,
                s.familyLastName,
                s.regionassigned,
                s.intRep,
                s.uniqueid,

                intRep.businessName 
            FROM 
            	smg_students s 
            INNER JOIN
            	smg_users intRep ON s.intRep = intRep.userID

            WHERE 
            	s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student.studentid#">
        </cfquery>
        
           <cfset email_to = 'luke@phpusa.com'>

        <cfoutput>
        
           <cfsavecontent variable="email_message">
<cfif Get_Student.flight_type eq 'arrival'><strong>ARRIVAL INFORMATION HAS BEEN DELETED</strong><br /></cfif>
<cfif Get_Student.flight_type eq 'departure'><strong>DEPARTURE INFORMATION HAS BEEN DELETED</strong><Br /></cfif>
<Br />

What: The flight leg from <strong>#get_Student.dep_aircode#</strong> to <strong>#get_Student.arrival_aircode#</strong> on <strong>#DATEFORMAT(get_Student.dep_date, 'h:mm tt')#</strong> has been deleted.<br />
Student: #qGetEmailInfo.firstname# #qGetEmailInfo.familylastname# (###qGetEmailInfo.studentid#)<Br />
Submitted By: #qGetEmailInfo.businessname#.<br><br>
Please click <a href="http://www.phpusa.com/internal/index.cfm?curdoc=student/student_info&unqid=#qGetEmailInfo.uniqueid#">here</a> then click on Flight Information to see the student's flight information.<br><br>
        
            Sincerely,<br>
            EXITS Flight Info<br><br>
        </cfsavecontent>
        
   
                    
		<!--- send email --->
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#email_to#">
            <cfinvokeargument name="email_subject" value="DELTED Flight Information for #qGetEmailInfo.firstname# #qGetEmailInfo.familylastname# (#qGetEmailInfo.studentid#)">
            <cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
        </cfinvoke>
        </cfoutput>
      
     <cfelse>
        
        <cfquery name="qGetEmailInfo" datasource="MySQL">
            SELECT 
            	s.studentID,
                s.firstName,
                s.familyLastName,
                s.regionassigned,
                s.intRep,
                s.uniqueid,
             
                r.regionname, 
                r.regionfacilitator, 
                r.regionid, 
                r.company,
				
                u.firstname as ufirstname, 
                u.lastname ulastname, 
                u.email,
                intRep.businessName 
            FROM 
            	smg_students s 
            INNER JOIN 
            	smg_regions r ON s.regionassigned = r.regionid
				
            INNER JOIN
            	smg_users intRep ON s.intRep = intRep.userID
              
            LEFT JOIN 
            	smg_users u ON r.regionfacilitator = u.userid
			
            WHERE 
            	s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentid#">
        </cfquery>

        <cfif qGetEmailInfo.email EQ ''>
            <cfset email_to = 'support@student-management.com'>
        <cfelse>	
            <cfset email_to = '#qGetEmailInfo.email#'>
        </cfif>
        <cfoutput>
           <cfsavecontent variable="email_message">
           
<cfif Get_Student.flight_type eq 'arrival'><strong>ARRIVAL INFORMATION HAS BEEN DELETED</strong><br /></cfif>
<cfif Get_Student.flight_type eq 'departure'><strong>DEPARTURE INFORMATION HAS BEEN DELETED</strong><Br /></cfif>

What:The flight leg from <strong>#get_Student.dep_aircode#</strong> to <strong>#get_Student.arrival_aircode#</strong> on <strong>#DATEFORMAT(get_Student.dep_date, 'mm/dd/yyyy')#</strong> has been deleted.<BR />
Student: #qGetEmailInfo.firstname# #qGetEmailInfo.familylastname# (###qGetEmailInfo.studentid#)<Br />
Submitted By: #qGetEmailInfo.businessname#.<br><br>

            Please click <a href="http://#CLIENT.exits_url#/nsmg/forms/flight_info.cfm?unqid=#qGetEmailInfo.uniqueid#">here</a>
            to see the student's flight information.<br><br>
        
            Sincerely,<br>
            EXITS Flight Info<br><br>
        </cfsavecontent>
             
      
                    
		<!--- send email --->
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#email_to#">

            <cfinvokeargument name="email_subject" value="DELETED Flight Information for #qGetEmailInfo.firstname# #qGetEmailInfo.familylastname# (#qGetEmailInfo.studentid#)">
<cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
        </cfinvoke>
      
      	</cfoutput>  
        </cfif>
    
    
   


        <!----End of Email---->
    
    
    
    <cflocation url="int_flight_info.cfm"> 
    
</cfif>