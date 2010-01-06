<br>
<cfif not isDefined('url.insudate')>
	<table align="center" width="90%" frame="box">
	<tr><th colspan="2">An error has ocurred. Please go back and try again.</th></tr>
	</table>
	<cfabort>
</cfif>
	
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_batches" datasource="MySql">
	SELECT sevis_batchid
	FROM smg_students
	WHERE insurance = #CreateODBCDate(url.insudate)# 
		AND companyid = '#client.companyid#'
	GROUP BY sevis_batchid
	ORDER BY sevis_batchid
</cfquery>

<!-- get student list -->
<cfquery name="get_students" datasource="MySql"> 
	SELECT 	s.studentid, s.firstname, s.familylastname, s.middlename, s.programid, s.sevis_batchid,
			p.programname,
			u.businessname
	FROM smg_students s
	INNER JOIN smg_programs p ON s.programid = p.programid
	INNER JOIN smg_users u ON s.intrep = u.userid
	WHERE insurance = #CreateODBCDate(url.insudate)# 
		AND s.companyid = '#client.companyid#'
	ORDER BY s.sevis_batchid, u.businessname, s.firstname
</cfquery>
	
<cfoutput>
	
	<table align="center" width="90%" frame="box">
	<tr><th colspan="4">#companyshort.companyshort# &nbsp; &nbsp; - &nbsp; &nbsp; List of Students Insured on &nbsp; #DateFormat(url.insudate)# &nbsp; &nbsp; - 
	&nbsp; &nbsp; Batch ID(s) &nbsp; <cfloop query="get_batches">#sevis_batchid# &nbsp;</cfloop></th></tr>
	<tr><th colspan="4">Total of students: #get_students.recordcount#</th></tr>	
	<cfif get_students.recordcount is 0>
		<tr><td colspan="4" align="center">0 students found.</td></tr>
	<cfelse>	
		<tr><td>Intl. Rep.</td><td>Student</td><td>Program</td><td>Batch ID</td></tr>
		<cfloop query="get_students">
		<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td width="30%">#businessname#</td>
			<td width="40%">#firstname# #familylastname# (#studentid#)</td>
			<td width="20%">#programname#</td>				
			<td width="10%">#sevis_batchid#</td>
		</tr>
		</cfloop>
	</cfif>
	</table>

</cfoutput>

<br>
<div align="center">
		<!--- <A HREF="index.cfm?curdoc=sevis/menu"><img border="0" src="pics/back.gif"></A> --->
		<input type="image" value="back" src="../pics/close.gif" onClick="javascript:window.close()">
</div><br>