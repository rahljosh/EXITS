<cfsetting requesttimeout="300">
	
	<!----Arrival Information---->
<cfoutput>
	<Cfquery name="qStudentsMissingArrival" datasource="mysql">
		SELECT DISTINCT s.firstname, s.studentid, s.intrep, s.familylastname, s.uniqueid, s.host_fam_approved, 
			p.programname, p.startdate, p.enddate, p.type,
			h.familylastname, h.fatherlastname, h.motherlastname, h.state,
			finfo.studentid as stu_flight, finfo.flight_type
		FROM smg_students s
		INNER JOIN smg_programs p ON s.programid = p.programid
		INNER JOIN smg_hosts h ON s.hostid = h.hostid
		LEFT JOIN smg_flight_info finfo ON s.studentid = finfo.studentid
		WHERE 
			<cfif CLIENT.userType EQ 8>
                <!--- Intl Rep --->
                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">            
			<cfelseif CLIENT.userType EQ 11>
            	<!--- Branch --->
                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.parentCompany#">
            AND    
                s.branchID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            </cfif>    
            AND 
                s.active = 1
            AND 
                s.companyid != 0
            AND 
                s.hostid != '0'
            AND 
                s.host_fam_approved <= 4
            AND 
                s.studentid NOT IN (SELECT studentid FROM smg_flight_info WHERE flight_type =  'arrival')	
	</Cfquery>
    
<cfif ListFind("20,21,28,109,115,628,701,6584,7199,7502,8913,9106,11480,11565,12038,12201", CLIENT.userID)>
	<br>
		<table width=100%>
	<tr><td bgcolor="##e2efc7" colspan=2><span class="get_attention"><b>:: </b></span>Upload flight info in an XML file.</td></tr>
	<tr>
				<tr>
				
					<td style="line-height:20px;" valign="top" width="100%"><br>
					<form action="?curdoc=xml/get_flight_info" method="post" enctype="multipart/form-data">
					Select your XML file: 
				<input type="file" name="flights" size=50 required="yes" enctype="multipart/form-data">
			<br><br>
			Options:<br>
			<input type="checkbox" name="display_results" checked>Display results on screen<br>
			<input type="checkbox" name="receive_xml" checked> I'd like to receive back an XML file for verification.
			<br><br>
			Upload file and process: <input type="submit" value="Process" alt="Upload File to Server">
			
					</form>
					</td>
				</tr>
			</table>
</cfif>
	<table width=100%>
	<tr><td bgcolor="##e2efc7" colspan=2><span class="get_attention"><b>:: </b></span>Placed students without ARRIVING flight information</td></tr>
	<tr>
		<td valign="top" colspan=2>
		<cfif qStudentsMissingArrival.recordcount EQ 0>
		<br><div align="center">You currently have no active students placed in the United States.</div>
		<cfelse>
		<div class="int_scroll">
		<table width=90% align="center" cellspacing="0" cellpadding=2 border=0>
			<tr bgcolor="ABADFC"><td width=30%>Student Name (id)</td><td>Placed </td><td>Host </td><td>Program</td><td>Flight Info</td><td></td></tr>
			<Cfloop query="qStudentsMissingArrival">
			<tr bgcolor="#iif(qStudentsMissingArrival.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
				<td><a href="index.cfm?curdoc=intrep/int_student_info&unqid=#qStudentsMissingArrival.uniqueid#">#firstname# #familylastname# (#studentid#)</a></td>
				<td><Cfif host_fam_approved LTE 4> Yes <cfelse> Pending Approval </Cfif></td>
				<td><cfif #fatherlastname# EQ #motherlastname#>
						#fatherlastname# (#state#) 
					<cfelse>
						#familylastname# (#state#) 
					</cfif>
				</td>
				<td>#programname#</td>
				<td><a class=nav_bar href="" onClick="javascript: win=window.open('intrep/int_flight_info.cfm?unqid=#qStudentsMissingArrival.uniqueid#', 'Settings', 'height=600, width=850, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">
						<font color="Red">NEEDED - click to submit</font></a>
				</td>
			</tr>
			</cfloop>
		</table>
		</div>
		</cfif>
		</td>
	</tr>
	</table>
	<br /><br />
	
	<!----Departure Information---->
		<Cfquery name="qStudentsMissingDeparture" datasource="mysql">
		SELECT DISTINCT s.firstname, s.studentid, s.intrep, s.familylastname, s.uniqueid, s.host_fam_approved, 
			p.programname, p.startdate, p.enddate, p.type,
			h.familylastname, h.fatherlastname, h.motherlastname, h.state,
			finfo.studentid as stu_flight, finfo.flight_type
		FROM smg_students s
		INNER JOIN smg_programs p ON s.programid = p.programid
		INNER JOIN smg_hosts h ON s.hostid = h.hostid
		LEFT JOIN smg_flight_info finfo ON s.studentid = finfo.studentid
		WHERE 
			<cfif CLIENT.userType EQ 8>
                <!--- Intl Rep --->
                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">            
			<cfelseif CLIENT.userType EQ 11>
            	<!--- Branch --->
                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.parentCompany#">
            AND    
                s.branchID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            </cfif>    
			AND 
            	s.active = 1
			AND 
            	s.companyid != 0
			AND 
            	s.hostid != '0'
			AND 
            	s.host_fam_approved <= 4
			AND 
            	s.studentid NOT IN (SELECT studentid FROM smg_flight_info WHERE flight_type =  'departure')	
	</Cfquery>
	<table width=100%>
	<tr><td bgcolor="##e2efc7" colspan=2><span class="get_attention"><b>:: </b></span>Placed students without DEPARTING flight information</td></tr>
	<tr>
		<td valign="top" colspan=2>
		<cfif qStudentsMissingDeparture.recordcount EQ 0>
		<br><div align="center">You currently have no active students placed in the United States.</div>
		<cfelse>
		<div class="int_scroll">
		<table width=90% align="center" cellspacing="0" cellpadding=2 border=0>
			<tr bgcolor="ABADFC"><td width=30%>Student Name (id)</td><td>Placed </td><td>Host </td><td>Program</td><td>Flight Info</td><td></td></tr>
			<Cfloop query="qStudentsMissingDeparture">
			<tr bgcolor="#iif(qStudentsMissingDeparture.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
				<td><a href="index.cfm?curdoc=intrep/int_student_info&unqid=#qStudentsMissingDeparture.uniqueid#">#firstname# #familylastname# (#studentid#)</a></td>
				<td><Cfif host_fam_approved LTE 4> Yes <cfelse> Pending Approval </Cfif></td>
				<td><cfif #fatherlastname# EQ #motherlastname#>
						#fatherlastname# (#state#) 
					<cfelse>
						#familylastname# (#state#) 
					</cfif>
				</td>
				<td>#programname#</td>
				<td><a class=nav_bar href="" onClick="javascript: win=window.open('intrep/int_flight_info.cfm?unqid=#qStudentsMissingDeparture.uniqueid#', 'Settings', 'height=600, width=850, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">
						<font color="Red">NEEDED - click to submit</font></a>
				</td>
			</tr>
			</cfloop>
		</table>
		</div>
		</cfif>
		</td>
	</tr>
	</table>
	</cfoutput>
