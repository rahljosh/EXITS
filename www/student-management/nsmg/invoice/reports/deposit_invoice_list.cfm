<!--- Use cfsetting to block output of HTML outside cfoutput tags. ---> 
<cfsetting enablecfoutputonly="Yes"> 

<!--- Get Missing Deposit Invoices --->
<cfquery name="final_invoices" datasource="#APPLICATION.DSN#">
	SELECT
		smg_companies.companyshort AS 'Company',
		smg_users.businessname AS 'Agent',
		smg_programs.programName AS 'Program',
		CONCAT(smg_students.firstname,' ',smg_students.familylastname,' (',smg_students.studentID,')') AS 'Student'
	FROM smg_students
	INNER JOIN smg_programs ON smg_students.programID = smg_programs.programID
	INNER JOIN smg_companies ON smg_students.companyID = smg_companies.companyID
	INNER JOIN smg_users ON smg_students.intrep = smg_users.userID
	WHERE smg_students.active = 1
	AND smg_students.app_current_status = 11
	AND smg_students.canceldate IS NULL
	AND smg_students.programID > 424
	AND smg_students.studentID NOT IN (
		SELECT stuid
		FROM smg_charges
		WHERE type IN ('deposit')
		AND invoice_sent = 1
	)
	ORDER BY 
		smg_students.companyID,
		smg_users.businessname,
		smg_programs.programname,
		smg_students.familylastname,
		smg_students.firstname
</cfquery>

<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=missing_deposit_invoices.xls">

<cfoutput>
	<table cols='4'>
		<tr>
			<th>Company</th>
			<th>International Agent</th>
			<th>Program</th>
			<th>Student</th>
		</tr>
		<cfloop query="final_invoices">
			<tr>
				<td>#Company#</td>
				<td>#Agent#</td>
				<td>#Program#</td>
				<td>#Student#</td>
			</tr>
		</cfloop>	
	</table>
</cfoutput>