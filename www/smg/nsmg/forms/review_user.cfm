<cfinclude template="../querys/all_rep_info.cfm">
<cfquery name="usertype" datasource="MySQL">
select usertype
from smg_usertype
where usertypeid = #all_rep_info.usertype#
</cfquery>

<style type="text/css">
<!--
/* region table */

table.dash { font-size: 12px; border: 1px solid #202020; }
tr.dash {  font-size: 12px; border-bottom: dashed #201D3E; }
td.dash {  font-size: 12px; border-bottom: 1px dashed #201D3E;}
-->
</style> 
<div class="form_section_title"><h3>New User Successfully Added!</h3></div><p>
The following information was successfully  added to the system for <cfoutput>#all_rep_info.firstname# #all_rep_info.lastname#</cfoutput>.  They have immediate access to the information under their company/region that their account status will
 allow.
 <p>Information has been emailed to them with their user ID, password and  additional information based on their account type.  Upon logging in the first time, all account passwords 
 must be changed from the assigned password to one of the users choosing.  They will also be required to verify that their account information is correct.
 
<p>If any of this information is wrong, you can update this users profile under 'Users' and clicking on there information.
</span>

<div class="form_section_title"><h3>User Information </h3></div>

<cfoutput query="all_rep_info">
User Type: <b>#usertype.usertype#</b>
<p><table width=95% border="0">
<tr>
    <td rowspan="2" valign="top" width=5><span class="get_attention"><b>></b></span></td>
    <td class="dash" width=33%>Contact Info</td>
    <td rowspan="4" valign="top"><span class="get_attention"><b>></b></span></td>
    <td class="dash">Company Access</td>
    <td rowspan="4" valign="top"><span class="get_attention"><b>></b></span></td>
    <td class="dash">Regions</td>
</tr>
<tr>
    <td valign="top"><b>#firstname# #lastname#</b><br>
#address#<br>
<cfif address2 is not ''>#address2#<br></cfif>
#city# #state# #zip# <br><br>
#phone# - voice<br>
<cfif #fax# is ''><cfelse>#fax# - fax</cfif><br>
<a href="mailto:#email#">#email#</a>
<br><Br></td>
    <td rowspan="3" valign="top"><cfloop list="#companyid#" index=i>
		<cfquery name="company_name" datasource="MySQL">
		select companyname,companyshort
		from smg_companies
		where companyid = #i#
		</cfquery>
		
		<cfif all_Rep_info.defaultcompany is #i#><span class="get_attention"></cfif>#company_name.companyshort# - #company_name.companyname#<br></span><br>
		</cfloop>
		<div align="center">--------<br>
		<font size=-3><span class="get_attention">* default company</span></font></div></td>
    <td rowspan="3" valign="top"><cfloop list="#regions#" index=i>
		<cfquery name="regions" datasource="MySQL">
		select regionname
		from smg_regions
		where regionid= #i#
		</cfquery>
		#regions.regionname#<br>
		
		</cfloop></td>
</tr>
<tr>
    <td rowspan="2" valign="top"><span class="get_attention"><b>></b></span></td>
    <td class="dash">Login Info</td>

</tr>
<tr>
    <td valign="Top">U: #username#<br>
		P: #password#<br>
		
				</td>
</tr>
</table>

</cfoutput>


