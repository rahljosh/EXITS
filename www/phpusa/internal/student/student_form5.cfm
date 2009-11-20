<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Student Information - Page 5</title>

<script language="JavaScript">
<!--
function CheckLink()
{
  if (document.form5.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on next to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.form5.CheckChanged.value = 1
}
//  End -->
</script>

</head>

<body>
<!----
<cftry>
---->
<!--- Get Student Info by UniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

<cfquery name="get_religions" datasource="mysql">
	SELECT *
	FROM smg_religions
	ORDER BY religionname
</cfquery>

<cfoutput query="get_student_unqid">
<cfform method="post" name="form5" action="?curdoc=student/qr_student_form5"><br>
<cfinput type="hidden" name="studentid" value="#get_student_unqid.studentid#">

<table width="95%" align="center">
	<tr><td><h2>S t u d e n t  &nbsp;&nbsp; I n f o r m a t i o n &nbsp;&nbsp; P a g e &nbsp;&nbsp; 5</h2></td></tr>
</table>

<table  width="95%" class="box" bgcolor="ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr>
		<td width="70%" valign="top">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr><td colspan="8" bgcolor="C2D1EF"><b>Religious Participation</b></td></tr>
				<tr><td>How often do you attend church?</td></tr>					
				<tr>
					<td>
						<cfselect name="religious_participation" onchange="DataChanged();">
						<option value=""></option>
						<option value="active" <cfif religious_participation is 'active'>selected</cfif>>Active (1-2x times a week)</option>
						<option value="average" <cfif religious_participation is 'average'>selected</cfif>>Average (1x a week)</option>
						<option value="little interest" <cfif religious_participation is 'little interest'>selected</cfif>>Little Interest (occasionally)</option>
						<option value="inactive" <cfif religious_participation is 'inactive'>selected</cfif>>Inactive (Never attend)</option>
						<option value="no interest" <cfif religious_participation is 'no interest'>selected</cfif>>No Interest</option>
						</cfselect> 
					</td>
				</tr>
				<tr><td>Religious Affiliation:</td></tr>					
					<tr>
						<td> 
						<cfselect name="religiousaffiliation" onchange="DataChanged();">
							<cfloop query="get_religions">
							<option value="#religionid#" <cfif get_student_unqid.religiousaffiliation EQ religionid>selected</cfif>>#religionname#
							</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr><td>Church groups that you are active in, if any:</td></tr>
				<tr><td><textarea cols="50" rows="1" name="churchgroup">#churchgroup#</textarea></td></tr>
				<tr><td>Would you be willing to attend church with his/her host family?</td></tr>
				<tr><td><cfif churchfam EQ 'yes'><cfinput type="radio" name="churchfam" value="yes" checked> <cfelse> <cfinput type="radio" name="churchfam" value="yes"> </cfif>Yes 
						<cfif churchfam EQ 'no'><cfinput type="radio" name="churchfam" value="no" checked> <cfelse> <cfinput type="radio" name="churchfam" value="no"> </cfif>No 
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>			
		</td>
		<td width="30%" valign="top">
			<table border=0 cellpadding=3 cellspacing=0 align="right">
				<tr><td align="right"><cfinclude template="student_menu.cfm"></td></tr>
			</table> 		
		</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><br><input name="Submit" type="image" value="  next  " src="pics/next.gif" alt="Next" border="0"><br></td></tr>
</table>

</cfform>
</cfoutput>
<!----
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>
---->
</body>
</html>