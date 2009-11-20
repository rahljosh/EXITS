<style type="text/css">
<!--
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: xx-small;
}
.style3 {font-size: x-small}
.style6 {font-size: 12px}
.style10 {font-size: 16px; font-weight: bold; color: #000066; }
underline{border-bottom: 1px}

-->
</style>

<script>
function areYouSure() { 
   if(confirm("You are about to delete this school. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
</script>

<cfif not IsDefined('url.order')>
	<cfset url.order = 'schoolname'>
</cfif>

<cfif not isDefined('url.boarding')>
	<cfset boarding = 2>
</cfif>

<Cfif client.usertype EQ 10>
	<cfquery name="schools" datasource="mysql"> <!--- STUDENT ONLINE APPLICATION --->
		select school_contacts.schoolid, school_contacts.userid, schools.schoolname, schools.city, schools.phone, schools.contact,
		schools.boarding_school,
		states.state as us_state
		from php_school_contacts school_contacts, php_schools schools, smg_states states
		where school_contacts.schoolid = schools.schoolid  
		and schools.state = states.id 
		and school_contacts.userid = #client.userid#
		<cfif boarding NEQ '2'>
				and schools.boarding_school = '#boarding#'
			</cfif>
		order by schools.schoolname
	</cfquery>

<cfelseif client.usertype EQ 12> <!--- Schools --->
	<cfquery name="schools" datasource="mysql">
		select schools.schoolname, schools.city, schools.phone, schools.contact, schools.schoolid,
		schools.boarding_school,
		states.state as us_state
		from php_schools schools, smg_states states
		where  schools.schoolid = '#client.userid#'
			AND Schools.state = states.id 
	</cfquery>

<cfelseif client.usertype EQ 8> <!--- INTL. REP. ---->
		<cfquery name="schools" datasource="MySql">
			SELECT DISTINCT sc.schoolid, sc.schoolname, sc.address, sc.city, sc.zip, sc.email, sc.phone, sc.fax,
				sc.website, sc.contact, sc.boarding_school,
				smg_states.state as us_state
			FROM php_schools sc
			INNER JOIN php_students_in_program php ON php.schoolid = sc.schoolid
			INNER JOIN smg_students s ON s.studentid = php.studentid
			LEFT JOIN smg_states ON smg_states.id = sc.state
			WHERE s.intrep = '#client.userid#'
			<cfif boarding NEQ 2>
				AND sc.boarding_school = '#boarding#'
			</cfif>
			ORDER BY #url.order#
		</cfquery>
<cfelse>
		<cfquery name="schools" datasource="MySql">
			SELECT sc.schoolid, sc.schoolname, sc.address, sc.city, sc.zip, sc.email, sc.phone, sc.fax,
				sc.website, sc.contact, sc.boarding_school,
				smg_states.state as us_state
			FROM php_schools sc
			LEFT JOIN smg_states ON smg_states.id = sc.state
			<cfif client.usertype eq 7>
			LEFT JOIN php_school_contacts psc ON psc.schoolid = sc.schoolid
			</cfif>
			WHERE 1=1 
			<cfif boarding NEQ 2>
				and sc.boarding_school = '#boarding#'
			</cfif>
			<cfif client.usertype eq 7>
				and psc.userid = #client.userid#
			</cfif>
			ORDER BY #url.order#
		</cfquery>
</Cfif>
<cfoutput>
<table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign=middle height=24>
		<td bgcolor="##e9ecf1" valign="bottom"><h2 align="left">&nbsp;&nbsp;S c h o o l s<br><font size=-2>&nbsp;&nbsp;&nbsp;#schools.recordcount# listed</font></h2> </td>
		<td bgcolor="##e9ecf1" align="right" valign="bottom">
		Filter: <a href="?curdoc=lists/schools&boarding=2">All</a> | <a href="?curdoc=lists/schools&boarding=1">Boarding</a> | <a href="?curdoc=lists/schools&boarding=0">Day</a> | <a href="?curdoc=lists/schools&boarding=3">Not Specified</a>
		</td>
		
	</tr>
</table>
</cfoutput>
<table width=90% align="center" cellpadding="1" bgcolor="#e9ecf1" border=0 cellpadding=0 cellspacing =0>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td width="10" background="images/back_menu2.gif"></td>
		<th width="26" background="images/back_menu2.gif" align="left"><a href="?curdoc=lists/schools&order=schoolid">ID</a></td>
		<th width="200" background="images/back_menu2.gif" align="left"><a href="?curdoc=lists/schools&order=schoolname">School Name</a></td>
		<th width="100" background="images/back_menu2.gif" align="left"><a href="?curdoc=lists/schools&order=city">City</a></td>
		<th width="50" background="images/back_menu2.gif" align="left"><a href="?curdoc=lists/schools&order=us_state">State</a></td>
		<th width="70" background="images/back_menu2.gif" align="left"><a href="?curdoc=lists/schools&order=phone">Phone</a></td>
		<th width="200" background="images/back_menu2.gif" align="left"><a href="?curdoc=lists/schools&order=contact">Contact</a></td>
		<th width="80" background="images/back_menu2.gif" align="left"><a href="?curdoc=lists/schools&order=boarding_school">Boarding?</a></Td>
		<td width="10" background="images/back_menu2.gif"></td>
	</tr>
	<tr><td colspan="9">&nbsp;</td></tr>
	<cfif #schools.recordcount# eq 0>
	<Tr>
		<td colspan="9" align="center">No schools have been entered into the system or match the criteria you have specified.</td>
	</tr>
	<cfelse>
	<cfoutput>
	<cfloop query="schools">
	<tr bgcolor="#iif(schools.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
		<td valign="top"></td>
		<td valign="top" class="style1">#schoolid# </td>
		<td valign="top" class="style1"><a href="?curdoc=forms/view_school&sc=#schoolid#">#schoolname#</a></td>
		<td valign="top" class="style1">#city#</td>
		<td valign="top" class="style1">#us_state#</td>
		<td valign="top" class="style1">#phone#</td>
		<td valign="top" class="style1">#contact#</td>
		<td valign="top" class="style1"><cfif boarding_school eq 1>Yes<cfelseif boarding_school eq 0>No<cfelseif boarding_school eq 2>Both<cfelse>Not Specified</cfif></td>
		<td valign="top"></td>
	</tr>
	</cfloop>
	</cfoutput>
	</cfif>
		<tr>
		<td colspan="9" align="center"><br>
		<cfif client.usertype eq 8 or client.usertype eq 5  or client.usertype eq 12>
	
	<cfelse>

			<a href="index.cfm?curdoc=forms/add_school"><img src="pics/add-school.gif" border="0"></a>
			</cfif>
		</td>
		<td align="center"></td>
	</tr>
	
</table>