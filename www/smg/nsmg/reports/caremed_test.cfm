<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- get student info --->
<cfquery name="get_students" datasource="MySQL">
  SELECT * 
  FROM smg_students
  WHERE active = '1' and companyid = #client.companyid#
  ORDER BY firstname
</cfquery>

<!--- set vars for special chars --->
<cfset TabChar = Chr(9)>
<cfset NewLine = Chr(13) & Chr(10)><br>
<!--- set content type to invoke Excel --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<!--- use "Content-Disposition" in cfheader for Internet Explorer  --->
<cfheader name="Content-Disposition" value="filename=caremed_template.xls">
 <!--- output data using cfloop & cfoutput --->
<cfoutput>Transaction Type#TabChar#First Name#TabChar#Last Name#TabChar#Sex#TabChar#DOB#NewLine#</cfoutput>
<cfloop query="get_students">
  <cfoutput>New Application#TabChar##firstname##TabChar##familylastname##TabChar##sex##TabChar##DateFormat(dob, 'mm/dd/yyyy')##NewLine#</cfoutput>
</cfloop>
