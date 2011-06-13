<link rel="stylesheet" href="../smg.css" type="text/css">

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<cfif IsDefined('url.studentid')>
	
	<cfif form.reason is ''> 
		
		<!--- include template page header --->
		<cfinclude template="../forms/placement_status_header.cfm">
		<table width="480" align="center">
		<tr><td align="center"><h3>You Must Include a Reason for Changing the Second Visit Rep</h3></td></tr>
		</table><br>
		<table width="480" align="center">
		<tr><td align="center">
				<cfoutput>
				<A HREF="../forms/place_change_secondVisitRep.cfm?studentid=#client.studentid#"><img border="0" src="../pics/back.gif"></A>
				<!--- <input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()"> --->
				</cfoutput>
			</td></tr>
		</table>
		
	 <cfelse>
	   
	    <cftransaction action="BEGIN" isolation="SERIALIZABLE">
			<cfquery name="change_placerep" datasource="MySQL">
				update smg_students
				set secondVisitRepID = '#form.placerepid#'
						
				where studentid = '#get_student_info.studentid#'
			</cfquery>						
			 <cfquery name="school_history" datasource="MySQL"> <!--- school history --->
				INSERT INTO smg_hosthistory	(hostid, studentid, schoolid, reason, dateofchange, arearepid, secondVisitRepID, changedby)
				values('0', '#get_student_info.studentid#', '0', '#form.reason#',
				 #CreateODBCDateTime(now())#, '0', '#get_student_info.placerepid#', '#client.userid#')
			</cfquery>
		</cftransaction>
		<cflocation url="../forms/place_menu.cfm?studentid=#client.studentid#" addtoken="no">	
<!--- 		<cflocation url="../forms/place_placerep.cfm?studentid=#client.studentid#" addtoken="no"> --->
		
	</cfif> <!--- reason ---->
</cfif> <!--- url.student ---> 