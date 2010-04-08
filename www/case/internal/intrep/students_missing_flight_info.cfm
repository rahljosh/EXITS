<cfsetting requesttimeout="300">

	<cfoutput>
	<Cfquery name="current_students_status" datasource="caseusa">
		SELECT DISTINCT s.firstname, s.studentid, s.intrep, s.familylastname, s.uniqueid, s.host_fam_approved, 
			p.programname, p.startdate, p.enddate, p.type,
			h.familylastname, h.fatherlastname, h.motherlastname, h.state,
			finfo.studentid as stu_flight, finfo.flight_type
		FROM smg_students s
		INNER JOIN smg_programs p ON s.programid = p.programid
		INNER JOIN smg_hosts h ON s.hostid = h.hostid
		LEFT JOIN smg_flight_info finfo ON s.studentid = finfo.studentid
		WHERE s.intrep = '#client.userid#'
			AND s.active = 1
			AND s.companyid != 0
			AND s.hostid != '0'
			AND s.host_fam_approved <= 4
			AND s.studentid NOT IN (SELECT studentid FROM smg_flight_info WHERE flight_type =  'arrival')	
	</Cfquery>
	<table width=100%>
	<tr><td bgcolor="##e2efc7" colspan=2><span class="get_attention"><b>:: </b></span>Placed students without arriving flight information</td></tr>
	<tr>
		<td valign="top" colspan=2>
		<cfif current_students_status.recordcount EQ 0>
		<br><div align="center">You currently have no active students placed in the United States.</div>
		<cfelse>
		<div class="int_scroll">
		<table width=90% align="center" cellspacing="0" cellpadding=2 border=0>
			<tr bgcolor="ABADFC"><td width=30%>Student Name (id)</td><td>Placed </td><td>Host </td><td>Program</td><td>Flight Info</td><td></td></tr>
			<Cfloop query="current_Students_Status">
			<tr bgcolor="#iif(current_students_status.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
				<td><a href="index.cfm?curdoc=intrep/int_student_info&unqid=#current_students_status.uniqueid#">#firstname# #familylastname# (#studentid#)</a></td>
				<td><Cfif host_fam_approved LTE 4> Yes <cfelse> Pending Approval </Cfif></td>
				<td><cfif #fatherlastname# EQ #motherlastname#>
						#fatherlastname# (#state#) 
					<cfelse>
						#familylastname# (#state#) 
					</cfif>
				</td>
				<td>#programname#</td>
				<td><a class=nav_bar href="" onClick="javascript: win=window.open('intrep/int_flight_info.cfm?unqid=#current_students_status.uniqueid#', 'Settings', 'height=500, width=740, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">
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