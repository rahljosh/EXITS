<!--- revised by Marcus Melo on 06/24/2005 --->
<cfoutput>
<cfif not IsDefined('url.schoolid')>
	<table border="0" align="left" width="85%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="0">
	<tr bgcolor="D5DCE5"><td align="center"><a href="http://www.student-management.com"><img src="pics/logos/5.gif" border="0"></a></td>	
		<td><b>STUDENT MANAGEMENT GROUP</b><br>http://www.student-management.com</td></tr>
	<tr bgcolor="D5DCE5"><td colspan="2">An error has occured and it was not possible to complete the process requested.<br>
		Please go back and try again.</td></tr>
	<tr bgcolor="D5DCE5"><td align="center" colspan="2"><font size=-1><Br>&nbsp;&nbsp;
					<input type="image" value="close window" src="pics/back.gif" onClick="javascript:history.go(-1)"></td></tr>
	</table>
<cfelse>
	<cfquery name="check_students" datasource="#application.dsn#">
        SELECT studentid, firstname, familylastname, smg_students.companyid, companyshort
        FROM smg_students
        INNER JOIN smg_companies ON smg_students.companyid = smg_companies.companyid
        WHERE smg_students.schoolid = <cfqueryparam value="#url.schoolid#" cfsqltype="cf_sql_integer">
        ORDER BY companyshort, familylastname
	</cfquery>
	
	<cfquery name="get_school" datasource="#application.dsn#">
        SELECT schoolname, schoolid
        FROM smg_schools
        WHERE schoolid = <cfqueryparam value="#url.schoolid#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- THERE ARE STUDENTS ASSIGNED TO THIS SCHOOL --->
	<cfif check_students.recordcount> 
		<table border="0" align="left" width="85%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="0">
		<tr bgcolor="D5DCE5"><td align="center"><a href="http://www.student-management.com"><img src="pics/logos/5.gif" border="0"></a></td>	
			<td align="left"><b>STUDENT MANAGEMENT GROUP</b><br>http://www.student-management.com</td></tr>
		<tr bgcolor="D5DCE5"><td colspan="2">In order to delete a school its must not be assigned to a student.</td></tr>
		<tr bgcolor="D5DCE5"><td colspan="2">The school you are trying to delete has been assigned to #check_students.recordcount# student(s).</td></tr>
		<tr bgcolor="D5DCE5"><td colspan="2">
			<cfloop query="check_students">
			&nbsp; &nbsp; &nbsp; &nbsp; #firstname# #familylastname# (#studentid#) - #companyshort#<br>
			</cfloop>
		</td></tr>
		<tr bgcolor="D5DCE5"><td colspan="2">If for any reason you would like to delete this school, please move the student(s) above to another school.</td></tr>
		<tr bgcolor="D5DCE5"><td align="center" colspan="2"><font size=-1><Br>&nbsp;&nbsp;
						<input type="image" value="close window" src="pics/back.gif" onClick="javascript:history.go(-1)"></td></tr>
		</table>
	<!--- none students are assigned to the school, - DELETE SCHOOL --->
	<cfelse>
    	<cftransaction>
        <!--- delete school dates --->
 		<cfquery datasource="#application.dsn#">
			DELETE FROM smg_school_dates
			WHERE schoolid = <cfqueryparam value="#url.schoolid#" cfsqltype="cf_sql_integer">
		</cfquery>
        <!--- delete school --->
 		<cfquery datasource="#application.dsn#">
			DELETE FROM smg_schools
			WHERE schoolid = <cfqueryparam value="#url.schoolid#" cfsqltype="cf_sql_integer">
		</cfquery>
        </cftransaction>
		<table border="0" align="left" width="85%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="0">
		<tr bgcolor="D5DCE5"><td colspan="2"><br>
			The school #get_school.schoolname# (#get_school.schoolid#) was successfully deleted from the system.</td></tr>
		<tr bgcolor="D5DCE5"><td align="center" colspan="2"><font size=-1><Br>&nbsp;&nbsp;
						<input type="image" value="close window" src="pics/back.gif" onClick="javascript:history.go(-2)"></td></tr>
		</table>
		<!--- <cflocation url="?curdoc=schools"> --->
	</cfif>
</cfif>
</cfoutput>