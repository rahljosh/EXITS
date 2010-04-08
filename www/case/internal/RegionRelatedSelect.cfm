<cfparam name="url.field" default="">
<cfparam name="url.region" default="">

<cfswitch expression="#lCase(url.field)#">
	<cfcase value="rguarantee">
		<cfquery name="getRGuarantee" datasource="caseusa" dbtype="ODBC">
			SELECT DISTINCT regionname as rguaranteeName, regionid
			FROM smg_regions
			WHERE subofregion = '<cfoutput>#url.region#</cfoutput>'
			ORDER BY rguaranteeName
		</cfquery>
		<script>
		var r = [];
		<cfif getRGuarantee.recordcount EQ '0'>
		r[r.length] = ["No Region Guarantee", "0"];
		r[r.length] = ["----------------", "0"];
		<cfelse>
		r[r.length] = ["Select a Guarantee", "0"];
		r[r.length] = ["----------------", "0"];
		<cfloop query="getRGuarantee">
		r[r.length] = ["<cfoutput>#getRGuarantee.rguaranteeName#</cfoutput>", "<cfoutput>#getRGuarantee.regionid#</cfoutput>"];
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

