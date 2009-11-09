<cfinclude template="../querys/all_rep_info.cfm">
<cfinclude template="../querys/user_types.cfm">
<cfinclude template="../querys/all_regions_name_id.cfm">


<div class="form_section_title"><h3>Position & Region Assignment</h3></div>
<cfoutput query="all_rep_info">
#firstname# #lastname# (#userid#)<br> 
<table>
	<Tr>
		<td>
			Login: #username# <br>
			Password: #password#
		</td>
	</tr>
</table>
</cfoutput>

<cfform action="../querys/add_rep_details.cfm?userid=#url.userid#" method="post">

<table>
	<tr>
		<td valign="top">
<div class="tab">Status</div>
<div class=box>
<cfoutput query="user_types">
<cfinput type="radio" name=usertype value=#usertype#> #usertype#<br>
</cfoutput>
</div>
		</td>
		<td>
<div class="tab">Region</div>
<div class=box>
<cfoutput query="all_regions_name_id">
<cfinput type="checkbox" name=regionname value=#regionid#> #regionname#<br>
</cfoutput>
</div>
			
</table>
<div class="button"><input type="submit" name="next"></div>
</cfform>

