<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Update Evaluations / Grades</title>
</head>

<body>
<!----
<cftry>
---->
<table align="center" width="100%" cellpadding=0 cellspacing=0  border=0 bgcolor="##e9ecf1"> 
<tr><td width="100%">&nbsp;</td></tr>
<tr><td>

<Cfquery name="update" datasource="mysql">
	UPDATE php_students_in_program
		SET doc_evaluation9 = <cfif form.doc_evaluation9 NEQ ''>#CreateODBCDate(form.doc_evaluation9)#<cfelse>NULL</cfif>,
			doc_evaluation12 = <cfif form.doc_evaluation12 NEQ ''>#CreateODBCDate(form.doc_evaluation12)#<cfelse>NULL</cfif>,
			doc_evaluation2 = <cfif form.doc_evaluation2 NEQ ''>#CreateODBCDate(form.doc_evaluation2)#<cfelse>NULL</cfif>,
			doc_evaluation4 = <cfif form.doc_evaluation4 NEQ ''>#CreateODBCDate(form.doc_evaluation4)#<cfelse>NULL</cfif>,
			doc_evaluation6 = <cfif form.doc_evaluation6 NEQ ''>#CreateODBCDate(form.doc_evaluation6)#<cfelse>NULL</cfif>,
			doc_grade1 = <cfif form.doc_grade1 NEQ ''>#CreateODBCDate(form.doc_grade1)#<cfelse>NULL</cfif>,
			doc_grade2 = <cfif form.doc_grade2 NEQ ''>#CreateODBCDate(form.doc_grade2)#<cfelse>NULL</cfif>,
			doc_grade3 = <cfif form.doc_grade3 NEQ ''>#CreateODBCDate(form.doc_grade3)#<cfelse>NULL</cfif>,
			doc_grade4 = <cfif form.doc_grade4 NEQ ''>#CreateODBCDate(form.doc_grade4)#<cfelse>NULL</cfif>
	WHERE assignedid = '#form.assignedid#'
	LIMIT 1
</cfquery>

<cflocation url="evaluations.cfm?unqid=#form.uniqueid#" addtoken="no">	

</td></tr>
</table>
<!----
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>
---->
</body>
</html>