<cfform action="?curdoc=querys/assign_reps" method="post">

<cfquery name="family" datasource="caseusa">
select regionid 
from smg_hosts
where hostid = #client.hostid#
</cfquery>

<cfquery name="get_students" datasource="caseusa">
select firstname, familylastname, studentid, hostid, arearepid, placerepid, doubleplace
from smg_students
where hostid = #client.hostid# and active =1
</cfquery>

<cfquery name="get_place_reps" datasource="caseusa">
Select * from smg_users 
where companyid like #client.companyid# 
and regions like #family.regionid#
order by lastname
</cfquery>

<cfquery name="following_info" datasource="caseusa">
select *
from smg_students
where hostid = #client.hostid#
</cfquery>
<Cfif following_info.recordcount is 0>
<cfset student_reps.arearepid = 0>
<cfset student_reps.placerepid=0>
<cfset following_info.placerepid = 0> 

<Cfelse>
<cfquery name=student_reps datasource="caseusa">
select arearepid, placerepid
from smg_students
where studentid = #following_info.studentid#
</cfquery>
</Cfif>

<!----
<Cfif following_info.doubleplace is 0>
<cfset doubleplacecheck = 0>
<cfelse>
<Cfset doubleplacecheck = 1>
</cfif>
---->

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
		<td background="pics/header_background.gif"><h2>Rep, Student, and Placement Info</h2></td>
		<td align="right" background="pics/header_background.gif"><span class="edit_link">[ <cfoutput> <a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a> </cfoutput> ]</span></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td width="80%" valign="top">
		<table border=0 cellpadding=4 cellspacing=0 align="left" width="100%">
			<tr><td width="35%">Student family will be hosting:</td><td>
				<cfif get_students.recordcount is 0>No student assigned.
				<cfelse><cfoutput query="get_students">#studentid# - #firstname# #familylastname# </cfoutput></cfif>	
			</td></tr>
		<tr><td>Rep who made the placement:</td>
			<td> <!----None Assigned---->
				<cfif get_students.recordcount is 0>No rep assigned.
				<cfelse><cfquery name="place_rep" datasource="caseusa">
							select firstname, lastname, userid
							from smg_users
							where userid = #following_info.placerepid# 
						</cfquery>
						<cfoutput>#place_rep.firstname# #place_rep.lastname# (#place_rep.userid#)</cfoutput>
				</cfif>
			</td></tr>
		<tr><td>Rep supervising the student:</td>
			<Td><cfif get_students.recordcount is 0>No rep assigned.
				<cfelse>
					<cfquery name="sup_rep" datasource="caseusa">
						select firstname, lastname, userid
						from smg_users
						where userid = #following_info.arearepid# 
					</cfquery>
					<cfoutput>#sup_rep.firstname# #sup_rep.lastname# (#sup_rep.userid#)</cfoutput>
				</cfif>
			</Td></tr>
		<tr><td>Double Placement with student:</td>
			<td>
				<cfif get_students.recordcount is 0>
					No placement yet
				<cfelse>
					<cfquery name="double_placed" datasource="caseusa">
						select studentid, firstname, familylastname
						from smg_students
						where studentid =#get_students.doubleplace#
					</cfquery>
					<cfoutput query="double_placed">#firstname# #familylastname# (#studentid#)</cfoutput>
					</cfif>
			</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>			
		<tr><td colspan="2">
			<cfif get_students.recordcount is 0>
			 This screen is for informational puposes only.<Br><br> 
			 <b>To place a student, please visit the students profile and click on Placement Management.</b>
			<Cfelse>
			 This screen is for informational puposes only.<Br><br>
			 <b>All tracking information should be changed through the student screen. To change the information on this student, <Cfoutput><a href="?curdoc=student_info&studentid=#get_students.studentid#">click here</a>, then on Placement Management.</b> </Cfoutput>
			</cfif>
			</td></tr>	
		</table>
	</td>
	<td width="20%" align="right" valign="top">
		<table border=0 cellpadding=4 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
		</table> 		
	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center">&nbsp; <!--- <div class="button"><input name="Submit" type="image" src="pics/next.gif" align="right" border=0></div> ---></td></tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfform>