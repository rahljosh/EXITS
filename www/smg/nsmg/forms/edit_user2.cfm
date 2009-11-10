
<cfset form.userid = 1965>

<cfquery name="rep_info" datasource="MySQL">
select *
from smg_users
where userid = #form.userid#
</cfquery>


<Cfquery name="regions" datasource="MySQL">
select companyshort, regionname, regionid, companyid
from smg_regions INNER JOIN smg_companies 
where (subofregion = 0) and company = companyid
order by companyshort, regionname
</Cfquery>
<cfquery name="user_Regions" datasource="MySQL">
select regions
from smg_users 
where userid=#form.userid# 
</cfquery>
<span class="application_section_header">User Profile</span> <br>

<cfform action="?curdoc=querys/update_user" method="post">
<cfoutput query="rep_info">
<input type="hidden" value=#usertype# name="usertype">
<table width=90%>
	<tr>
		<td width=33%  bgcolor="CCCCCC"><span class="get_attention"><b>></b></span><u>Personal Information</u></td><td width=33%  bgcolor="CCCCCC"><span class="get_attention"><b>></b></span><u>Contact Info</u></td>
	</tr>
	<tr>
		<td valign="top" border=0>
			<table>
				<tr>
					<td align="right">First: </td><td><input type="text" name="firstname" value='#firstname#'></td>
				</tr>
				<tr>
					<td align="right">Last:</td><Td> <input type="text" name="lastname" value="#lastname#"></Td>
				</tr>
				<tr>
					<td align="right">Address:</td><td><input type="text" name="address" value="#address#"></td>
				</tr>
				<tr>
					<td align="right"></td><td><input type="text" name="address2" value="#address2#"></td>
				</tr>
				<tr>
					<td align="right">City:</td><td><input type="text" name="city" value="#city#"></td>
				</tr>
				<tr>
					<td align="right"><cfif #usertype# is 8>Country<cfelse>State</cfif>:</td><td><input name="<cfif #usertype# is 8>country<cfelse>state</cfif>" type="text" value="<cfif #usertype# is 8>#country#<cfelse>#state#</cfif>"></td>
				</tr>
				<tr>
					<td align="right"> Zip:</td><td><input name="zip" type="text" value=#zip# size=5></td>
				</tr>
				</tr>
				<tr>
					<td align="right">Social:</td><td><input type="text" name="ssn" value="#ssn#" size=9></td>
				</tr>
			</table>
		</td>
		
		
		<td valign="top">
			<table border="0">
			  <tr>
				<td align="right">Phone:</td>
				<td><input type="text" value="#phone#" name="phone"></td>
			  </tr>
			  <tr>
				<td align="right">Fax:</td>
				<td><input type="text" value="#fax#" name="fax"></td>
			  </tr>
			  <tr>
				<td align="right">Email:</td>
				<td><input type="text" value="#email#" name="email"></td>
			  </tr>
			  <tr>
				<td align="right">Alt. Email:</td>
				<td><input type="text" name="email2" value="#email2#"></td>
			  </tr>
			  <tr>
			  	<td colspan=2 bgcolor="CCCCCC"><span class="get_attention"><b>></b></span><u>Login Information</u></td>
			</tr>
			<tr>
				<td align="right">Username:</td><td><input type="text" value="#username#" name="username"></td>
			</tr>
			<tr>
				<td align="right">Password:</td><td><input type="text" value="#password#" name="password"></td>
			</tr>
			
			
						  <tr>
			  	<td colspan=2 bgcolor="CCCCCC"><span class="get_attention"><b>></b></span><u></u>Regional Advisor</u></td>
			</tr>
				<td colspan=2><cfquery name="ra" datasource="mysql">
				select userid, firstname, lastname
				from smg_users
				where (usertype = 6) and (regions like '%#rep_info.regions#%') and active = 1
				order by lastname
				</cfquery>
				<cfif listfindnocase("6, 7", #usertype#)>
				#ra.firstname# #ra.lastname# <input type="hidden" name="arearep_id" value="#userid#">
				<cfelse>
				 <select name="arearep_id">
		<option value="0">Reports directly to Director</option>
		
		<cfloop query="ra">
		<cfif #ra.userid# is #rep_info.advisor_id#><option value="#ra.userid#" selected>#ra.userid# #ra.firstname# #ra.lastname#</option><cfelse>
		<option value="#ra.userid#">#ra.userid# #ra.firstname# #ra.lastname#</option></cfif>
		</cfloop>
				</td>
				</cfif> 
				
				</tr>
			</table>

			 </td>
		</tr>
		
</table>
<br><br>
<table width=90%>
	<tr>
		<td width=33%  bgcolor="CCCCCC"><span class="get_attention"><b>></b></span><u>Employment Info</u></td><td width=33%  bgcolor="CCCCCC"><span class="get_attention"><b>></b></span><u>Contract Info</u></td>
	</tr>
		
		<td valign="top">
			<table border="0">
			  <tr>
				<td align="right">Occupation:</td>
				<td> <input type="text" value="#occupation#" name="occupation"> </td>
			  </tr>
			  <tr>
				<td align="right">Employer:</td>
				<td><input type="text" value="#businessname#" name="businessname"></td>
			  </tr>
			  <tr>
				<td align="right">Work Phone:</td>
				<td> <input type="text" value="#businessphone#" name="businessphone"></td>
			  </tr>
			</table>
		<td valign="top">
				<table border="0">
			  <tr>
				<td align="right">User Entered:</td>
				<td> #DateFormat(datecreated, 'mm/dd/yyyy')#</td>
			  </tr>
			  <tr>
				<td align="right">Contract Rec.:</td>
				<td>
				<cfif listfindnocase("5,6,7", #usertype#)>#date_contract_received#<cfelse><input type="text" value="#date_Contract_received#" name="date_Contract_received"></cfif></td>
			  </tr>
			  <tr>
				<td align="right">Active:</td>
				<td><cfif #active# is 1><input name="active" type="radio" <cfif listfindnocase("5,6,7", #usertype#)>disabled="true"</cfif> value=1 checked>yes <input type="radio" name="active"  <cfif listfindnocase("5,6,7", #usertype#)>disabled="true"</cfif> value=0>no<cfelse><input type="radio" name="active"  <cfif listfindnocase("5,6,7", #usertype#)>disabled="true"</cfif> value=1>yes <input type="radio" name="active"  <cfif listfindnocase("5,6,7", #usertype#)>disabled="true"</cfif> value=0 checked>no </cfif></td>
			  </tr>
			  <tr>
			  	<td>Date Cancelled:</td><td>
				<cfif listfindnocase("5,6,7", #usertype#)>#datecancelled#<cfelse><input type="text" value="#datecancelled#" name="datecancelled"></cfif></td>
			  </tr>
			</table>
		</tr>
</table>
<table width=90%>
</cfoutput>

	<tr bgcolor="CCCCCC">
		<td colspan=2><span class="get_attention"><b>></b></span><u>Region Assignment</u></td>
	</tr>


<cfoutput query="regions">
<cfif ListFindNoCase(#rep_info.companyid#, #companyid# , ',' )>

<Td valign="top" width=220 class="region" border=0>

<!---	<input type="checkbox" name="regions" value="#regions.regionid#" <cfif #regions.regionid# is 25>checked</cfif>>#regionname#<cfif #regions.regionid# is 25> (All users have access)</cfif><BR> --->

	<input type="checkbox" name="regions" value="#regions.regionid#" <cfif ListFind(user_regions.regions, regionid , ",") GT 0>checked</cfif>>#companyshort# - #regionname#<cfif #regions.regionname# is 'office'> (All users have access)</cfif><BR>
		
	</td>
	<cfif (regions.currentrow mod 2) is 0></tr><tr></cfif>
	<cfelse>
</cfif>
</cfoutput>

<cfif #client.usertype# is 1>

	<tr bgcolor="CCCCCC">
		<td colspan=2><span class="get_attention"><b>></b></span><u>User Type</u></td>
	</tr>
		<Tr>
		<td>
		<cfquery name="usertype" datasource="MySQL">
		select *
		from smg_usertype
		</cfquery>
		<cfoutput query="usertype">
		<cfif usertype.currentrow mod 2>
			<tr>
			</cfif>
<td>

 <cfif #rep_info.usertype# is #usertypeid#><cfinput type="radio" name="newusertype" value=#usertypeid# checked><cfelse><cfinput type="radio" name="newusertype" value=#usertypeid#></cfif>#usertype#
</td>
</cfoutput>
		</td>
	</Tr>
	<Cfif client.usertype lt 3>
	<tr>
		<td colspan=2 align="Center"><input type="checkbox" name="invoiceaccess" <cfif rep_info.invoice_access is 1>checked</cfif>>User has Invoicing Access</td>
	</tr>
	</Cfif>
	<tr bgcolor="CCCCCC">
		<td colspan=2><span class="get_attention"><b>></b></span><u>Company Assignment</u></td>
	</tr>

	<Tr>
		<td>
		<cfquery name="company_names" datasource="MySQL">
		select companyid, companyname, companyshort
		from smg_companies
		</cfquery>
				<cfoutput query="company_names">
		<input type="checkbox" name="companyaccess" value='#companyid#' <cfif ListFind(rep_info.companyid, companyid , ",")>checked<cfelse></cfif>>#Companyshort#
		</cfoutput>
		</td>
	</Tr>
		
	
</cfif>
</tr>

</table>
<cfif client.usertype lt 5>

<Cfoutput query="rep_info">
<br>

<Table width=90%>
	<tr bgcolor="CCCCCC">
		<td><span class="get_attention"><b>></b></span><u>Notes / Misc Info</u></td>
	</tr>
	<tr>
		<td>
		<cfif client.usertype lt #rep_info.usertype# or client.usertype is 1 or client.usertype is 2 or client.usertype is 3 or client.usertype is 4 >
	<textarea cols="45" rows="10" name="comments">
</cfif><Cfif #comments# is ''>No additional information available.<cfelse>#comments#</cfif>
	

</textarea>
<br>
<cfif client.usertype is 1><input type="checkbox" name="delete" value=#form.userid# <cfif #form.userid# is 1>disabled</cfif>> Delete User Account - You can not undelete accounts.</cfif>
</td>
	</tr>

</Table>
</cfoutput>
</cfif>
<cfoutput>
<input type="hidden" name="userid" value=#userid#></cfoutput>
<div class="button"><input name="Submit" type="image" src="pics/next.gif" align="right" border=0></div>

</cfform>


