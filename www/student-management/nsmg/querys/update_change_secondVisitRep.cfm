<link rel="stylesheet" href="../smg.css" type="text/css">

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<cfif IsDefined('url.studentid')>
	
	<cfif FORM.reason is ''> 
		
		<!--- include template page header --->
		<cfinclude template="../forms/placement_status_header.cfm">
		<table width="480" align="center">
		<tr><td align="center"><h3>You Must Include a Reason for Changing the Second Visit Rep</h3></td></tr>
		</table><br>
		<table width="480" align="center">
		<tr><td align="center">
				<input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()">
			</td></tr>
		</table>
		
	 <cfelse>
	   
	    <cftransaction action="BEGIN" isolation="SERIALIZABLE">

            <cfquery name="updateSuperRep" datasource="MySQL">
              update smg_students
				set secondVisitRepID = '#form.secondVisitRepID#'
								
				where studentid = '#get_student_info.studentid#'
			</cfquery>
			 
             <!--- Insert Place Rep History --->
             <cfquery datasource="MySQL"> 
				INSERT INTO smg_hosthistory	(hostid, studentid, schoolid, reason, dateofchange, arearepid, placeRepID,secondVisitRepID, changedby)
				values('0', '#get_student_info.studentid#', '0', '#FORM.reason#',
				 #CreateODBCDateTime(now())#, '0', 0, '#form.secondVisitRepId#', '#CLIENT.userid#')
			</cfquery>
            
		</cftransaction>
        
		<cflocation url="../forms/place_menu.cfm?studentid=#CLIENT.studentid#" addtoken="no">	
		
	</cfif> <!--- reason ---->
</cfif> <!--- url.student ---> 