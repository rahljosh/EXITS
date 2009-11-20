<table width="70%"  border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="C2D1EF" bgcolor="FFFFFF">
  <tr>
    <td class="box"><Cfif not isDefined('form.transportation')>
		<br>
		You must indicate how the student will be transported to school.  Click back to make a selection.<br><br>
		<div class="button"><input name="back" type="image" src="pics/back.gif" align="right" border=0 onClick="history.back()"></div><br>
		<cfabort>
		</Cfif>
	</td>
  </tr>
</table>

<table width="70%"  border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="C2D1EF" bgcolor="FFFFFF">
  <tr>
    <td class="box">
<Cfif #form.transportation# is "other" and #form.other_Desc# is ''>
You indicated 'Other' as the method of transportation to school, but didn't fill out the Other description box.<br>Use your browsers back button to enter the description.
<div class="button"><input name="back" type="image" src="pics/back.gif" align="right" border=0 onClick="history.back()"></div>
<cfabort>
<cfelseif #form.transportation# is not "other">
<Cfset form.other_desc = ''>
</cfif>
<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="insert_transportation" datasource="mysql">
update smg_hosts
set schooltransportation = "#form.transportation#",
	schooldistance = "#form.distance_school#",
	schoolcosts = "#form.school_costs#",
	other_trans = "#form.other_desc#"	
where hostid = #client.hostid#
</cfquery>
</cftransaction>
<Cflocation url="index.cfm?curdoc=host_fam_info&hostid=#client.hostid#" addtoken="no">
	</td>
  </tr>
</table>