<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Erase SITE Records</title>
</head>

<body>

<cfoutput>

<cfquery name="get_students_insured" datasource="MySql">
	SELECT studentid, firstname, familylastname, insurance
	FROM smg_students
	WHERE insurance > '2007-06-01'
	ORDER BY insurance
</cfquery>

<cfloop query="get_students_insured">

	<cfquery name="get_insurance" datasource="MySql">
		SELECT studentid
		FROM smg_insurance
		WHERE studentid = '#studentid#'
	</cfquery>

	<cfif get_insurance.recordcount EQ 1>
		DELETE AND ERASE INSURANCE RECORD #studentid# - #firstname# #familylastname# <br />
		
		<cfquery name="update1" datasource="MySql">
			DELETE FROM smg_insurance
			WHERE studentid = '#studentid#'
				AND org_code = ''
			LIMIT 1
		</cfquery>
		
		<cfquery name="update2" datasource="MySql">
			UPDATE smg_students
			SET insurance = NULL
			WHERE studentid = '#studentid#'
		</cfquery>	
		
	<cfelse>
		<b> REVIEW </b> #studentid# - #firstname# #familylastname#<br />

	</cfif>	
	
</cfloop>
<br />Total of #get_students_insured.recordcount# students.<br />

</cfoutput>

</body>
</html>
