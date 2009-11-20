<cfquery name="schools" datasource="mysql">
	SELECT schools.schoolid, schools.name, schools.address, schools.city, schools.zip, schools.email, schools.phone, schools.fax,
		schools.website, schools.exact_tuition, schools.website, schools.focus_gender, schools.misc_notes,  schools.contact, 
		schools.contact_title, schools.focus_gender,
		states.state, sports.name as sport, 
		tuition.range,
		tuition_notes.notes
	FROM php_schools
	LEFT JOIN smg_states ON smg_states.id = php_schools.state
	LEFT JOIN smg_sports ON smg_sports.sportid = php_schools.focus_sport
	LEFT JOIN smg_tuition ON smg_tuition.tuitionid = php_schools.tuition_range
	LEFT JOIN smg_tuition_notes ON smg_tuition_notes.notesid = php_schools.tuition_notes
	ORDER BY states.state, schools.city
</cfquery>

<cfdocument format="pdf" pagetype="letter" marginbottom="0.4" marginleft="0.4" marginright="0.4" margintop="0.75" orientation="landscape" unit="in">

<cfoutput>

<cfdocumentsection>
   <cfdocumentitem type="header">
      <font size="-1"><i>UPI - Universal Programs &nbsp; | &nbsp; School Contact List</i></font>
   </cfdocumentitem>

    <cfdocumentitem type="footer"> 
    	<font size="-3">Page #cfdocument.currentpagenumber# &nbsp; | &nbsp; Total of #schools.recordcount# school(s).</font>
    </cfdocumentitem>
	<table width="95%" align="center" cellpadding=2 cellspacing="0" frame="below">
		<cfif #schools.recordcount# eq 0>
		<Tr><td colspan="6" align="center">No schools have been entered into the system or match the criteria you have specified.</td></tr>
		<cfelse>
		<cfloop query="schools">
		<tr bgcolor="#iif(schools.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td width="20%" align="left"><b><font size="-3">School Name</font></b></td> 
			<th width="16%" align="left"><font size="-3">Address</font></th>
			<th width="16%" align="left"><font size="-3">City</font></th>
			<th width="16%" align="left"><font size="-3">State</font></th>
			<th width="16%" align="left"><font size="-3">Phone No.</font></th>
			<th width="16" align="left"><font size="-3">Fax No.</font></th>
		</tr>
		<tr bgcolor="#iif(schools.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td><font size="-3">#name#</font></td> 
			<td><font size="-3">#address#</font></td>
			<td><font size="-3">#city#</font></td>
			<td><font size="-3">#state#</font></td>
			<td><font size="-3">#phone#</font></td>
			<td><font size="-3">#fax#</font></td>
		</tr>
		<tr bgcolor="#iif(schools.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<th align="left"><font size="-3">Website</font></th>
			<th align="left"><font size="-3">Sport</font></th>
			<th align="left"><font size="-3">Gender</font></th>
			<th align="left"><font size="-3">Tuition Range</font></th>
			<th align="left" colspan="2"><font size="-3">Tuition Notes</font></th>
		</tr>		
		<tr bgcolor="#iif(schools.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td><font size="-3">#website#</font></td>
			<td><font size="-3">#sport#</font></td>
			<td><font size="-3">#focus_gender#</font></td>
			<td><font size="-3"><cfif range is ''>#exact_tuition#<cfelse>#range#</cfif></font></td>
			<td colspan="2"><font size="-3">#notes#</font></td>
		</tr>
		<tr bgcolor="#iif(schools.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td colspan="6"><font size="-3"><b>Contact:</b>: &nbsp; #contact# &nbsp; <b>Title:</b> &nbsp; <cfif contact_title EQ ''>N/A<cfelse>#contact_title#</cfif> &nbsp; <b>E-mail:</b> &nbsp; #email# </font></td>
		</tr>
		<tr bgcolor="#iif(schools.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td colspan="6"><font size="-3"><b>Notes:</b> &nbsp; #misc_notes#</font></td>
		</tr>
		</cfloop>
		</cfif>
	</table><br>	
</cfdocumentsection>

</cfoutput>

</cfdocument>
