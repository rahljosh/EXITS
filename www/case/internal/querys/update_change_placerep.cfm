<link rel="stylesheet" href="../smg.css" type="text/css">

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<cfif IsDefined('url.studentid')>
	
	<cfif form.reason is ''> 
		
		<!--- include template page header --->
		<cfinclude template="../forms/placement_status_header.cfm">
		<table width="480" align="center">
		<tr><td align="center"><h3>You Must Include a Reason for Changing the Placing Rep</h3></td></tr>
		</table><br>
		<table width="480" align="center">
		<tr><td align="center">
				<cfoutput>
				<A HREF="../forms/place_change_placerep.cfm?studentid=#client.studentid#"><img border="0" src="../pics/back.gif"></A>
				<!--- <input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()"> --->
				</cfoutput>
			</td></tr>
		</table>
		
	 <cfelse>
	   
	    <cftransaction action="BEGIN" isolation="SERIALIZABLE">
			<cfquery name="change_placerep" datasource="caseusa">
				update smg_students
				set placerepid = '#form.placerepid#'
				<cfif get_student_info.arearepid is not '0' and get_student_info.hostid is not '0' and get_student_info.schoolid is not '0'>
				, host_fam_approved = #client.usertype#
				, date_host_fam_approved = #CreateODBCDateTime(now())#	
				</cfif>			
				where studentid = '#get_student_info.studentid#'
			</cfquery>						
			 <cfquery name="school_history" datasource="caseusa"> <!--- school history --->
				INSERT INTO smg_hosthistory	(hostid, studentid, schoolid, reason, dateofchange, arearepid, placerepid, changedby)
				values('0', '#get_student_info.studentid#', '0', '#form.reason#',
				 #CreateODBCDateTime(now())#, '0', '#get_student_info.placerepid#', '#client.userid#')
			</cfquery>
		</cftransaction>
		<cflocation url="../forms/place_menu.cfm?studentid=#client.studentid#" addtoken="no">	
<!--- 		<cflocation url="../forms/place_placerep.cfm?studentid=#client.studentid#" addtoken="no"> --->
		
	</cfif> <!--- reason ---->
</cfif> <!--- url.student ---> 