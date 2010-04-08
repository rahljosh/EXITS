<cfif form.region is 0>
<br>
There is no Region assigned. Please go back and assign a region.<br>
<div class="button"><input name="back" type="image" src="pics/back.gif" align="right" border=0 onClick="history.back()"></div>
<br>
<cfelse>

<cfif NOT isdefined("form.community")>
<br>
You must select "Would you describe the community as". Please go back and try again.<br>
<div class="button"><input name="back" type="image" src="pics/back.gif" align="right" border=0 onClick="history.back()"></div>
<br>
<cfelse>

<cftransaction action="BEGIN" isolation="SERIALIZABLE">

<cfquery name="insert_community_info" datasource="caseusa">
update smg_hosts
	set 
		nearbigCity="#form.near_City#",
		near_City_Dist="#form.near_City_Dist#",
		community="#form.community#",
		pert_info ="#form.pert_info#",
		major_air_code="#form.major_air_code#",
		airport_city="#form.airport_city#",
		airport_state="#form.airport_state#",
		regionid = #form.region#
  where hostid=#client.hostid#
		
</cfquery>

</cftransaction>
<cflocation url="index.cfm?curdoc=forms/double_placement" addtoken="no">
 
</cfif> 
</cfif> 