<cfsetting requesttimeout="300">
	
	<!----Arrival Information---->
<cfoutput>
	<Cfquery name="qStudentsMissingArrival" datasource="mysql">
		SELECT DISTINCT s.firstname, s.studentid, s.intrep, s.familylastname, s.uniqueid, s.host_fam_approved, s.dateplaced,
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
            <Cfif client.companyid lte 5>
                (s.companyid != 0 and s.companyid < 6)
            <cfelse>
             	(s.companyid != 0 and s.companyid = #client.companyid#)
            </Cfif>
            AND 
                s.hostid != '0'
            AND 
                s.host_fam_approved <= 4
            AND 
                s.studentid NOT IN (SELECT studentid FROM smg_flight_info WHERE flight_type =  'arrival')	
	</Cfquery>
    <!----PHP flight info---->
    	<Cfquery name="qStudentsMissingArrival_php" datasource="mysql">
		SELECT DISTINCT s.firstname, s.studentid, s.intrep, s.familylastname, s.uniqueid,  s.dateplaced,
			p.programname, p.startdate, p.enddate, p.type,
			finfo.studentid as stu_flight, finfo.flight_type
		FROM smg_students s
		LEFT JOIN php_students_in_program psip on psip.studentid = s.studentid
        INNER JOIN smg_programs p ON psip.programid = p.programid
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
            	p.active = 1
            AND
         		p.enddate > now()
            AND
                (s.companyid != 0 and s.companyid = 6)
            AND 
                s.studentid NOT IN (SELECT studentid FROM smg_flight_info WHERE flight_type =  'arrival')	
	</Cfquery>
   
<Cfquery name="qStudentsMissingDeparture_php" datasource="mysql">
		SELECT DISTINCT s.firstname, s.studentid, s.intrep, s.familylastname, s.uniqueid,  s.dateplaced,
			p.programname, p.startdate, p.enddate, p.type,
			finfo.studentid as stu_flight, finfo.flight_type
		FROM smg_students s
		LEFT JOIN php_students_in_program psip on psip.studentid = s.studentid
        INNER JOIN smg_programs p ON psip.programid = p.programid
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
            	p.active = 1
            AND
         		p.enddate > now()
            AND
                (s.companyid != 0 and s.companyid = 6)
            AND 
                s.studentid NOT IN (SELECT studentid FROM smg_flight_info WHERE flight_type =  'arrival')	
	</Cfquery>

<script language="javascript">	
    // Document Ready!
    $(document).ready(function() {

		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"60%", 
			height:"90%", 
			iframe:true,
			overlayClose:false,
			escKey:false 
		});		

	});
</script>    
    
<!--- Upload XML --->
<cfif ListFind("20,21,28,109,115,628,701,6584,7199,7502,8913,9106,11480,11565,12038,12201", CLIENT.userID)>
    <br>
    <table width=100%>
        <tr><td bgcolor="##e2efc7" colspan=2><span class="get_attention"><b>:: </b></span>Upload flight info in an XML file.</td></tr>
        <tr>
            <td style="line-height:20px;" valign="top" width="100%">
                <form action="?curdoc=xml/get_flight_info" method="post" enctype="multipart/form-data">
                    Select your XML file: 
                    <input type="file" name="flights" size=50 required="yes" enctype="multipart/form-data">
                    <br><br>
                    Options:<br>
                    <input type="checkbox" name="displayResults" value="1" checked>Display results on screen<br>
                    <input type="checkbox" name="receiveXML" value="1" checked> I'd like to receive back an XML file for verification.
                    <br><br>
                    Upload file and process: <input type="submit" value="Process" alt="Upload File to Server">
                </form>
            </td>
        </tr>
    </table>
</cfif>

	<table width=100%>
	<tr>
	  <td bgcolor="##e2efc7" colspan=2><span class="get_attention"><b>:: </b></span><strong>Public School</strong>  placed students without ARRIVING flight information</td></tr>
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
				<td><Cfif host_fam_approved LTE 4> Yes - #DateFormat(dateplaced, 'mm/dd/yy')#<cfelse> Pending Approval </Cfif></td>
				<td><cfif #fatherlastname# EQ #motherlastname#>
						#fatherlastname# (#state#) 
					<cfelse>
						#familylastname# (#state#) 
					</cfif>
				</td>
				<td>#programname#</td>
				<td>
	                <a href="student/index.cfm?action=flightInformation&uniqueID=#qStudentsMissingArrival.uniqueID#" class="jQueryModal">
						<font color="Red">NEEDED - click to submit</font>
                    </a>
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
               <Cfif client.companyid lte 5>
                (s.companyid != 0 and s.companyid < 6)
           		 <cfelse>
             	(s.companyid != 0 and s.companyid = #client.companyid#)
          		  </Cfif>
			AND 
            	s.hostid != '0'
			AND 
            	s.host_fam_approved <= 4
			AND 
            	s.studentid NOT IN (SELECT studentid FROM smg_flight_info WHERE flight_type =  'departure')	
            ORDER BY s.familylastname
	</Cfquery>
	<table width=100%>
	<tr>
	  <td bgcolor="##e2efc7" colspan=2><span class="get_attention"><b>:: </b></span><strong>Public School</strong> placed students without DEPARTING flight information</td></tr>
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
				<td>
                	<a href="student/index.cfm?action=flightInformation&uniqueID=#qStudentsMissingDeparture.uniqueID#" class="jQueryModal">
						<font color="Red">NEEDED - click to submit</font>
                    </a>
				</td>
			</tr>
			</cfloop>
		</table>
		</div>
		</cfif>
		</td>
	</tr>
	</table>
<Br /><br />
	<table width=100%>
	<tr>
	  <td bgcolor="##e2efc7" colspan=2><span class="get_attention"><b>:: </b></span><strong>Private School</strong> students without ARRIVING flight information</td></tr>
	<tr>
		<td valign="top" colspan=2>
		<cfif qStudentsMissingArrival_php.recordcount EQ 0>
		<br><div align="center">You currently have no students in the Private High School program missing ARRIVING flight info.</div>
		<cfelse>
		<div class="int_scroll">
		<table width=90% align="center" cellspacing="0" cellpadding=2 border=0>
			<tr bgcolor="ABADFC"><td width=30%>Student Name (id)</td><td>Placed </td><td>Host </td><td>Program</td><td>Flight Info</td><td></td></tr>
			<Cfloop query="qStudentsMissingArrival_php">
			<tr bgcolor="#iif(qStudentsMissingArrival_php.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
				<td><a href="index.cfm?curdoc=intrep/int_student_info&unqid=#qStudentsMissingArrival_php.uniqueid#">#firstname# #familylastname# (#studentid#)</a></td>
				<td></td>
				<td>
				</td>
				<td>#programname#</td>
				<td>
                	<a href="student/index.cfm?action=flightInformation&uniqueID=#qStudentsMissingArrival_php.uniqueID#" class="jQueryModal">
						<font color="Red">NEEDED - click to submit</font>
                    </a>
				</td>
			</tr>
			</cfloop>
		</table>
		</div>
		</cfif>
		</td>
	</tr>
	</table>
<Br /><br />
	<table width=100%>
	<tr>
	  <td bgcolor="##e2efc7" colspan=2><span class="get_attention"><b>:: </b></span><strong>Private School</strong> students without DEPARTING flight information</td></tr>
	<tr>
		<td valign="top" colspan=2>
		<cfif qStudentsMissingDeparture_php.recordcount EQ 0>
		<br><div align="center">You currently have no students in the Private High School program missing DEPARTURE flight info.</div>
		<cfelse>
		<div class="int_scroll">
		<table width=90% align="center" cellspacing="0" cellpadding=2 border=0>
			<tr bgcolor="ABADFC"><td width=30%>Student Name (id)</td><td>Placed </td><td>Host </td><td>Program</td><td>Flight Info</td><td></td></tr>
			<Cfloop query="qStudentsMissingArrival_php">
			<tr bgcolor="#iif(qStudentsMissingDeparture_php.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
				<td><a href="index.cfm?curdoc=intrep/int_student_info&unqid=#qStudentsMissingDeparture_php.uniqueid#">#firstname# #familylastname# (#studentid#)</a></td>
				<td></td>
				<td>
				</td>
				<td>#programname#</td>
				<td>
                	<a href="student/index.cfm?action=flightInformation&uniqueID=#qStudentsMissingDeparture_php.uniqueID#" class="jQueryModal">
						<font color="Red">NEEDED - click to submit</font>
                    </a>
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
