<cfparam name="url.field" default="">
<cfparam name="url.fieldstudyid" default="">

<cfswitch expression="#lCase(url.field)#">
	<cfcase value="listsubcat">
		<cfquery name="getSubCategory" datasource="MySql">
			SELECT DISTINCT subfieldid, subfield as subfieldName
			FROM extra_sevis_sub_fieldstudy
			WHERE fieldstudyid = '<cfoutput>#url.fieldstudyid#</cfoutput>'
			ORDER BY subfieldName
		</cfquery>
		<script>
		var r = [];
		<cfif getSubCategory.recordcount EQ '0'>
		r[r.length] = ["No Sub-Category", "0"];
		r[r.length] = ["----------------", "0"];
		<cfelse>
		r[r.length] = ["Select a Sub-Category", "0"];
		r[r.length] = ["----------------", "0"];
		<cfloop query="getSubCategory">
		r[r.length] = ["<cfoutput><cfif LEN(subfieldName) GT 33>#Left(subfieldName,30)#...<cfelse>#subfieldName#</cfif></cfoutput>", "<cfoutput>#subfieldid#</cfoutput>"];
		</cfloop>
		</cfif>
		// this passes the packet back to the client
		parent.oGateway.receivePacket(["<cfoutput>#url.field#</cfoutput>", r]);
		</script>
	</cfcase>

	<!---// if no matching option, pass null back to the browser //--->
	<cfdefaultcase>
		<script>
		// this passes the packet back to the client
		parent.oGateway.receivePacket(null);
		</script>
	</cfdefaultcase>
</cfswitch>