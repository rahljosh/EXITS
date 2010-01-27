<br>
<cfif not isDefined('url.bulkid')>
	<table align="center" width="90%" frame="box">
	<tr><th colspan="2">It was not possible to print out your report. One error has ocurred. Please go back and re-submit it.</th></tr>
	</table>
	<cfabort>
</cfif>

<!-- get company info -->
<cfquery name="get_company" datasource="MySql">
	SELECT f.companyid, c.companyshort, datecreated
	FROM smg_sevisfee f
	INNER JOIN smg_companies c ON f.companyid = c.companyid
	WHERE f.bulkid = #url.bulkid#
</cfquery>

<!--- Query the database and get students --->
<cfquery name="get_students" datasource="MySql"> 
	SELECT 	s.studentid, s.sevis_batchid, s.firstname, s.familylastname, s.middlename, 
			p.programname, p.programid, 
			c.companyname, c.usbank_iap_aut,
			u.accepts_sevis_fee, u.businessname
	FROM smg_students s 
	INNER JOIN smg_programs p ON s.programid = p.programid
	INNER JOIN smg_companies c ON s.companyid = c.companyid
	INNER JOIN smg_users u ON s.intrep = u.userid
	WHERE sevis_bulkid = #url.bulkid# 
	ORDER BY s.sevis_batchid, u.businessname, s.firstname
</cfquery>
 
<cfoutput> 
<table align="center" width="95%" frame="box">
<tr><th colspan="3">#get_company.companyshort_nocolor# &nbsp; - &nbsp; S E V I S &nbsp; F E E &nbsp; - &nbsp; Bulk ID &nbsp; 0#url.bulkid# &nbsp; - &nbsp; Sent on: #DateFormat(get_company.datecreated, 'mm/dd/yyyy')#</th></tr>
<tr><th colspan="3">Total of students: #get_students.recordcount#</th></tr>	
<tr>
	<td width="45%">Intl. Representative</td>
	<td width="45%">Student</td>
	<td width="10%" align="center">Batch ID</td>
</tr>
	<cfloop query="get_students">
		<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td>#businessname#</td>
			<td>#firstname# #familylastname# &nbsp; (#studentid#)</td>
			<td align="center">#sevis_batchid#</td>
		</tr>
	</cfloop>
</table>

</cfoutput>
<br>
<div align="center">
		<!--- <A HREF="index.cfm?curdoc=sevis/menu"><img border="0" src="pics/back.gif"></A> --->
		<input type="image" value="back" src="../pics/close.gif" onClick="javascript:window.close()">
</div><br>