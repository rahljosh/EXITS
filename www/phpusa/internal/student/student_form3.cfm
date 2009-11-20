<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Student Information - Page 3</title>
</head>

<cftry>

<script language="JavaScript">
<!--
function areYouSure() { 
   if(confirm("You are about to delete this record. Click OK to continue")) { 
     form3.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
//  End -->
</script>

<body>
<!--- Get Student Info by UniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

<cfquery name="get_siblings" datasource="mysql">
	SELECT *
	FROM smg_student_siblings
	WHERE studentid = '#get_student_unqid.studentid#'
</cfquery>

<cfoutput query="get_student_unqid">
<cfform method="post" name="form" action="?curdoc=student/qr_student_form3"><br>
<cfinput type="hidden" name="studentid" value="#get_student_unqid.studentid#">

<table width="95%" align="center">
	<tr><td><h3>S t u d e n t  &nbsp;&nbsp; I n f o r m a t i o n &nbsp;&nbsp; P a g e &nbsp;&nbsp; 3</h3></td>
		<td align="right"><h3>Student: #firstname# #familylastname# (###studentid#)</h3></td>
	</tr>
</table>

<table  width="95%" class="box" bgcolor="ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr>
		<td width="70%">
			<table border="0" cellpadding="2" cellspacing="0" width="100%">
				<tr><td colspan="5" bgcolor="C2D1EF"><b>Siblings Information</b></td></tr>
				<tr>
					<td width="210">Name</td>
					<td width="145">Date of Birth <font size="-5">(mm/dd/yyyy)</font></td>
					<td width="150">Sex</td>
					<td width="150">Living at home?</td>
					<td width="30">&nbsp;</td>
				</tr>
				<!--- load siblings ---> 
				<cfif get_siblings.recordcount NEQ 0>	
					<cfinput type="hidden" name="count" value='#get_siblings.recordcount#'>
					<cfloop query="get_siblings">
					<tr bgcolor="#iif(get_siblings.currentrow MOD 2 ,DE("ffffff") ,DE("C2D1EF") )#">
						<cfinput type="hidden" name="childid#get_siblings.currentrow#" value="#get_siblings.childid#">
						<td valign="top"><cfinput type="text" name="name#get_siblings.currentrow#" size="30" value="#name#" onchange="DataChanged();"><br><br></td>
						<td valign="top"><cfinput type="text" name="birthdate#get_siblings.currentrow#" size="14" maxlength="10" value="#DateFormat(birthdate, 'mm/dd/yyyy')#" onchange="DataChanged();" validate="date" message="Please re-check the date of birth for the #name#. The format must be mm/dd/yyyy."><br><br></td>
						<td valign="top">
							<cfif sex is 'male'><cfinput type="radio" name="sex#get_siblings.currentrow#" value="male" checked="yes" onchange="DataChanged();">Male<cfelse><cfinput type="radio" name="sex#get_siblings.currentrow#" value="male" onchange="DataChanged();">Male</cfif>&nbsp; &nbsp;
							<cfif sex is 'female'><cfinput type="radio" name="sex#get_siblings.currentrow#" value="female" checked="yes" onchange="DataChanged();">Female<cfelse><cfinput type="radio" name="sex#get_siblings.currentrow#" value="female" onchange="DataChanged();">Female</cfif>
						</td>
						<td valign="top">
							<cfif liveathome is 'yes'><cfinput type="radio" name="liveathome#get_siblings.currentrow#" value="Yes" checked="yes" onchange="DataChanged();">Yes<cfelse><cfinput type="radio" name="liveathome#get_siblings.currentrow#" value="Yes" onchange="DataChanged();">Yes</cfif>&nbsp; &nbsp;
							<cfif liveathome is 'no'><cfinput type="radio" name="liveathome#get_siblings.currentrow#" value="No" checked="yes" onchange="DataChanged();">No<cfelse><cfinput type="radio" name="liveathome#get_siblings.currentrow#" value="No" onchange="DataChanged();">No</cfif>
						</td>
						<td width="45" align="center" valign="top"><a href="?curdoc=student/qr_student_form3del&childid=#get_siblings.childid#&unqid=#get_student_unqid.uniqueid#" onClick="return areYouSure(this);"><img src="pics/delete.gif" border="0" alt="Delete sibling #name#"></img></a></td>
					</tr>
					</cfloop>
				</cfif>
				<!--- new siblings --->
				<cfset newsiblings = 5 - get_siblings.recordcount>
				<cfinput type="hidden" name="newcount" value="#newsiblings#">
				<cfloop from="1" to="#newsiblings#" index="i">
				<tr>
					<td valign="top"><cfinput type="text" name="newname#i#" size="30" onchange="DataChanged();"><br><br></td>
					<td valign="top"><cfinput type="text" name="newbirthdate#i#" size="14" maxlength="10" onchange="DataChanged();" validate="date" message="Please re-check the date of birth for the sibling #i#. The format must be mm/dd/yyyy."><br><br></td>
					<td valign="top"><cfinput type="radio" name="newsex#i#" value="male">Male &nbsp; &nbsp;<cfinput type="radio" name="newsex#i#" value="female" onchange="DataChanged();">Female<br><br></td>
					<td valign="top"><cfinput type="radio" name="newliveathome#i#" value="Yes">Yes &nbsp; &nbsp;<cfinput type="radio" name="newliveathome#i#" value="no" onchange="DataChanged();">No</em><br></td>	
					<td>&nbsp;</td>
				</tr>
				</cfloop>		
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

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>