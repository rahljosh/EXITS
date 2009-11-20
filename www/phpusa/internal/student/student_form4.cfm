<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Student Information - Page 4</title>
</head>

<script language="JavaScript">
<!--
function CheckLink()
{
  if (document.form4.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on next to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.form4.CheckChanged.value = 1
}
//  End -->
</script>


<body>

<cftry>

<!--- Get Student Info by UniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

<cfquery name="get_interests" datasource="mysql">
	SELECT interestid, interest
	FROM smg_interests
	WHERE student_app = 'yes'
	ORDER BY interest
</cfquery>

<cfoutput query="get_student_unqid">
<cfform method="post" name="form4" action="?curdoc=student/qr_student_form4"><br>
<cfinput type="hidden" name="studentid" value="#get_student_unqid.studentid#">

<table width="95%" align="center">
	<tr><td><h2>S t u d e n t  &nbsp;&nbsp; I n f o r m a t i o n &nbsp;&nbsp; P a g e &nbsp;&nbsp; 4</h2></td></tr>
</table>

<table  width="95%" class="box" bgcolor="ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr>
		<td width="70%">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr><td colspan="8" bgcolor="C2D1EF"><b>Interests</b></td></tr>
				<tr><cfloop query="get_interests">	
					<td><input type="checkbox" name="interests" value='#interestid#' onchange="DataChanged();" <cfif ListFind(get_student_unqid.interests, interestid , ",")>checked<cfelse></cfif>></td>
					<td>#interest#</td>
						<cfif (get_interests.currentrow MOD 4 ) is 0></tr><tr></cfif>
					</cfloop>
				</tr>
			</table>
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr><td colspan="2" bgcolor="C2D1EF"><b>Activities</b></td></tr>
				<tr><td>Do you Play in a band?</td>
					<td>
						<cfif band is 'yes'><cfinput type="radio" name="band" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="band" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
						<cfif band is 'no'><cfinput type="radio" name="band" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="band" value="No" onchange="DataChanged();">No</cfif>	
					</td>
				</tr>
				<tr><td>Do you play in an orchestra?</td>
					<td>
						<cfif orchestra is 'yes'><cfinput type="radio" name="orchestra" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="orchestra" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
						<cfif orchestra is 'no'><cfinput type="radio" name="orchestra" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="orchestra" value="No" onchange="DataChanged();">No</cfif>	
					</td>
				</tr>
				<tr><td>Do you participate in any competitive sports?</td>
					<td>
						<cfif comp_sports is 'yes'><cfinput type="radio" name="comp_sports" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="comp_sports" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
						<cfif comp_sports is 'no'><cfinput type="radio" name="comp_sports" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="comp_sports" value="No" onchange="DataChanged();">No</cfif>													
					</td>
				</tr>
			</table>
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr><td bgcolor="C2D1EF"><b>Narrative</b></td></tr>
				<tr><td>Please list any specific interests, hobbies, activities and any awards or commendations: <br>(It will be printed on the student's profile)</td></tr>
				<tr><td><textarea cols="80" rows="5" name="specific_interests" wrap="VIRTUAL">#interests_other#</textarea><br><br></td></tr>
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
	<tr><td align="center"><br><cfinput name="Submit" type="image" value="  next  " src="pics/next.gif" alt="Next" border="0"><br></td></tr>
</table>

</cfform>
</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>