<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>DMD SPONSORED PRIVATE HIGH SCHOOL PROGRAM</title>
</head>

<body>

<cfquery name="get_school_list" datasource="MySql">
	SELECT schoolid, schoolname, city, tuition_semester, tuition_year, boarding_school,
		smg_states.statename
	FROM php_schools
	LEFT JOIN smg_states ON smg_states.id = php_schools.state 
	<!--- WHERE active = '1' --->
	ORDER BY schoolname
</cfquery>

<cfoutput>

<br /><br />

<cfform action="?curdoc=invoice/school_tuition_qr" method="post">

<cfinput type="hidden" name="count" value="#get_school_list.recordcount#">

<table width="90%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr><th colspan="2"> DMD SPONSORED PRIVATE HIGH SCHOOL PROGRAM </th></tr>
	<tr>
		<td width="100%" valign="top">
			<table border="0" cellpadding="5" cellspacing="0" width="90%" align="center">
				<tr bgcolor="##C2D1EF">
					<td><b>School Name</b></td>
					<td><b>Year Price</b></td>
					<td><b>Sem. Price</b></td>
					<td><b>Location</b></td>
					<td><b>Day/Board</b></td>
				</tr>
				<cfloop query="get_school_list">
					<tr  bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
						<td>	
							#schoolname#
							<cfinput type="hidden" name="#currentrow#_schoolid" value="#schoolid#">
						</td>
						<td><cfinput type="text" name="#currentrow#_tuition_year" value="#tuition_year#" size="6"></td>
						<td><cfinput type="text" name="#currentrow#_tuition_semester" value="#tuition_semester#" size="6"></td>
						<td>#city#, #statename#</td>
						<td>
							<cfselect name="#currentrow#_boarding_school">
								<option value="0" <cfif boarding_school EQ 0>selected</cfif> >Day</option>
								<option value="1" <cfif boarding_school EQ 1>selected</cfif> >Board</option>
								<option value="2" <cfif boarding_school EQ 2>selected</cfif> >Day/Board</option>
								<option value="3" <cfif boarding_school EQ 3>selected</cfif>></option>
							</cfselect>
						</td>
					</tr>
				</cfloop>
				<tr bgcolor="##C2D1EF"><th colspan="5"><cfinput type="image" name="next" value=" Update " src="pics/update.gif" align="middle" submitOnce></th></tr>
			</table>
		</td>
	</tr>
</table>
<br /><br />

</cfform>

</cfoutput>
</body>
</html>