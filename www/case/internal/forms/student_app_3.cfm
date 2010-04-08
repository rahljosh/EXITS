<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="siblings" datasource="caseusa">
select *
from smg_student_siblings
where studentid = #client.studentid#
</cfquery>

<script>
function areYouSure() { 
   if(confirm("You are about to delete this record. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
</script>

<cfform method="post" action="querys/insert_student_siblings.cfm">
<cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Brother / Sister Information</h2></td>
		<td align="right" background="pics/header_background.gif"> Student: #get_student_info.firstname# #get_student_info.familylastname# (#get_student_info.studentid#) &nbsp; <span class="edit_link">[ <a href="?curdoc=student_info&studentid=#get_student_info.studentid#">overview</a> ]</span></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfif #siblings.recordcount# is 0> <!--- no siblings have been entered --->
	<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td width="80%">
			<table border=0 cellpadding=3 cellspacing=0 align="left" width="100%">
			<cfloop from="1" to="5" index="i">
				<tr bgcolor="#iif(i MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label">Name:</td>
					<td class="form_text"> <cfinput type="text" name="name#i#" size="20"> <cfinput type="radio" name="sex#i#" value="male">Male <cfinput type="radio" name="sex#i#" value="female">Female</span>
				</tr>
				<tr bgcolor="#iif(i MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label">Date of Birth: </td>
					<td class="form_text"> <cfinput type="text" name="dob#i#" maxlength="10"> mm-dd-yyyy</span>
				</tr>
				<tr bgcolor="#iif(i MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label">Living at Home: </td>
					<td class="form_text"><cfinput type="radio" name="athome#i#" value="yes">Yes <cfinput type="radio" name="athome#i#" value="no">No
				</tr>
			</cfloop>
			</table>
		</td>
		<td width="20%" align="right" valign="top">
			<table border=0 cellpadding=3 cellspacing=0 align="left">
				<tr><td align="right"><cfinclude template="../student_app_menu.cfm"></td></tr>
			</table> 		
		</td>		
		</tr>
	</table>
<cfelse> <!--- with kids --->
	<input type="hidden" name="update" value='update'>
	<input type="hidden" name="count" value='#siblings.recordcount#'>
	<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td width="80%">
			<table border=0 cellpadding=3 cellspacing=0 align="left" width="100%">
			<cfloop query="siblings">
				<tr bgcolor="#iif(siblings.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label"><input type="hidden" name="childid#siblings.currentrow#" value="#childid#">Name:</td>
					<td class="form_text"><cfinput type="text" name="name#siblings.currentrow#" size="20" value="#name#"> 
										  <Cfif sex is 'male'><cfinput type="radio" name="sex#siblings.currentrow#" value="male" checked>Male 
															  <cfinput type="radio" name="sex#siblings.currentrow#" value="female">Female
										  <cfelseif sex is 'female'><cfinput type="radio" name="sex#siblings.currentrow#" value="male">Male <cfinput type="radio" name="sex#siblings.currentrow#" value="female" checked>Female
										  <cfelse><cfinput type="radio" name="sex#siblings.currentrow#" value="male">Male <cfinput type="radio" name="sex#siblings.currentrow#" value="female">Female</cfif></td></tr>
				<tr bgcolor="#iif(siblings.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label">Date of Birth: </td>
					<td class="form_text"> <cfinput type="text" name="dob#siblings.currentrow#" size="20" value="#DateFormat(birthdate,'mm-dd-yyyy')#" maxlength="10"> mm-dd-yyyy</td></tr>
				<tr bgcolor="#iif(siblings.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label">Living at Home: </td>
					<td class="form_text"><cfif liveathome is 'yes'>
						<cfinput type="radio" name="athome#siblings.currentrow#" value="yes" checked>Yes <cfinput type="radio" name="athome#siblings.currentrow#" value="no">No
						<cfelseif liveathome is 'no'><cfinput type="radio" name="athome#siblings.currentrow#" value="yes">Yes <cfinput type="radio" name="athome#siblings.currentrow#" value="no" checked>No
						<cfelse><cfinput type="radio" name="athome#siblings.currentrow#" value="yes">Yes <cfinput type="radio" name="athome#siblings.currentrow#" value="no">No</cfif></td></tr>
				<tr bgcolor="#iif(siblings.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label">Delete? </td>
					<td><a href="?curdoc=querys/delete_student_siblings&childid=#childid#" onClick="return areYouSure(this);"><img src="pics/deletex.gif" border="0"></img></a></td></tr>
				<tr><td>&nbsp;</td></tr>
			</cfloop>
			</table>		
		</td>
		<td width="20%" align="right" valign="top">
			<table border=0 cellpadding=3 cellspacing=0 align="right">
				<tr><td align="right"><cfinclude template="../student_app_menu.cfm"></td></tr>
			</table> 		
		</td>		
		</tr>
	</table>			
</cfif>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="left">
			<cfif #siblings.recordcount# is not 0>
				<a href="?curdoc=forms/student_app_3_new"><img src="pics/add-siblings.gif" border="0" align="middle"></img></a>
			</cfif></td>
		<td align="left"><input name="Submit" type="image" src="pics/next.gif" align="left" border=0></td>
	</tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfoutput>
</cfform>