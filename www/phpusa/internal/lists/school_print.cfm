
<cfquery name="schools" datasource="mysql">
	SELECT schools.name, schools.address, schools.address2, schools.city,schools.state,schools.zip,
		schools.dateadded, schools.lastupdated, schools.email,schools.phone, schools.fax, schools.website,
		schools.tuition_range, schools.tuition_notes,schools.exact_tuition, schools.contact, schools.contact_title,
		schools.focus_sport, schools.focus_gender, schools.misc_notes,
		tuition_notes.notes as tnotes, tuition.range,
		states.statename,
		sports.name as sportname
	FROM php_schools
	LEFT JOIN smg_tuition_notes ON smg_tuition_notes.notesid = php_schools.tuition_notes
	LEFT JOIN smg_tuition ON smg_tuition.tuitionid = php_schools.tuition_range
	LEFT JOIN smg_states ON smg_states.id = php_schools.state
	LEFT JOIN smg_sports ON smg_sports.sportid = php_schools.focus_sport
	where schoolid = <cfqueryparam value="#url.sc#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="sports" datasource="mysql">
	SELECT name, sportid
	FROM smg_sports
	ORDER BY name
</cfquery>



<cfoutput query="schools">
<table width=100%>
	<tr>
		<td><font size=+2><b>#name#</td><td rowspan=2 align="right" valign="bottom">Tuition: <b>#LSCurrencyFormat(exact_tuition, 'local')#</b><br>
		Tuition Range: <b>#range#</b> <br>
		#tnotes#
		</td>
	</tr>
	<tr>
		<td>#schools.address#<br>
			<cfif schools.address2 is not ''>#address2#<br></cfif>
			#city# #statename#, #zip# </td>
			<td></td>
	</tr>
</table>
<hr width=80%>
<Table width=100%>
	<tr>
		<td width=50%><b><u>Contact Information</u></b><br>
#contact# - #contact_title#<br>
Email: <cfif email is ''>N/A<cfelse>#email#</cfif> <br>
Phone: <cfif phone is ''>N/A<cfelse>#phone#</cfif><br>
Fax: <cfif fax is ''>N/A<cfelse>#fax#</cfif><br>
Website: <cfif website is ''>N/A<cfelse>#website#</cfif>
		</td>
		<td valign="top">
		Focus Gender: <cfif focus_gender is 'M'>Male<cfelseif focus_gender is 'F'>Female<cfelse>N/A</cfif><br>
		Focus Sport: #sportname#
		</td>
	</tr>
</Table>
<br>
<b><u>Misc Notes</u></b><br>
#misc_notes#

</cfoutput>


