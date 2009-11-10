<cfif NOT isDefined('url.fieldstudyid')> 

<select name="subfieldid">
<option value="0">Choose a Category First ...</option>
</select>
	
<cfelse>

	<cfquery name="subfieldstudy" datasource="mysql">
		SELECT *
		FROM extra_sevis_sub_fieldstudy
		WHERE fieldstudyid = '#url.fieldstudyid#'
		ORDER BY subfield
	</cfquery>
	
	<cfoutput>
<select name="subfieldid">
<option value="0">Select...</option>
	<cfloop query="subfieldstudy">
		<option value="#subfieldid#"><cfif len(subfield) gt 30>#Left(subfield,28)#...<cfelse>#subfield#</cfif></option>
	</cfloop>
</select>
	</cfoutput>
	
</cfif>



