<br>
<cfif not isDefined('url.batchid')>
	<table align="center" width="90%" frame="box">
	<tr><th colspan="2">It was not possible to print out your report. One error has ocurred. Please go back and re-submit it.</th></tr>
	</table>
<cfelse>
	<!-- get company info -->
	<cfquery name="get_company" datasource="MySql">
		SELECT s.companyid, c.companyshort
		FROM smg_sevis s
		INNER JOIN smg_companies c ON s.companyid = c.companyid
		WHERE  s.batchid  = <cfqueryparam value="#url.batchid#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfquery name="get_students" datasource="MySql"> 
		SELECT 	s.studentid, s.firstname, s.familylastname, s.middlename,
				p.programname,
				u.businessname
		FROM smg_students s
		INNER JOIN smg_sevis_history hist ON hist.studentid = s.studentid
		INNER JOIN smg_programs p ON s.programid = p.programid
		INNER JOIN smg_users u ON s.intrep = u.userid
		WHERE hist.batchid = <cfqueryparam value="#url.batchid#" cfsqltype="cf_sql_integer"> 
		ORDER BY u.businessname, s.familylastname, s.firstname
	</cfquery>

	<table align="center" width="95%" frame="box">
	<tr><th colspan="3"><cfoutput>#get_company.companyshort_nocolor# &nbsp; - &nbsp; H O S T &nbsp; F A M I L I E S &nbsp; - Update &nbsp; - &nbsp; Batch ID &nbsp; 0#url.batchid#</cfoutput></th></tr>
	<tr><th colspan="3"><cfoutput>Total of students: #get_students.recordcount#</cfoutput></th></tr>	
	<cfif get_students.recordcount is 0>
		<tr>
		<td colspan="3" align="center">No students were successfull created in this batch.</td>
		</tr>
	<cfelse>	
		<cfoutput query="get_students">
		<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
		<td width="30%">#businessname#</td><td width="50%">#firstname# #familylastname# (#studentid#)</td><td width="20%">#programname#</td>				
		</tr>
		</cfoutput>
	</cfif>
	</table>
</cfif>
<br>
<div align="center">
		<input type="image" value="back" src="../pics/close.gif" onClick="javascript:window.close()">
</div><br>