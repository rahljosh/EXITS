<!---<cfparam name="url." default="">--->
<cfparam name="url.id" default="">

<cfswitch expression="#lCase(url.id)#">
	<cfcase value="listsubcat">
		<!----<cfquery name="getSubCategory" datasource="MySql">
			SELECT DISTINCT subfieldid, subfield as subfieldName
			FROM extra_sevis_sub_fieldstudy
			WHERE fieldstudyid = '<cfoutput>#url.fieldstudyid#</cfoutput>'
			ORDER BY subfieldName
		</cfquery>---->
		
		
		<cfquery name="get_position" datasource="mysql">
			SELECT extra_jobs.id, extra_jobs.title, extra_jobs.wage, extra_jobs.hours
			FROM extra_jobs
			INNER JOIN extra_candidate_place_company ON extra_candidate_place_company.candcompid = extra_jobs.id
			WHERE extra_jobs.hostcompanyid = #client.companyid#
			
		</cfquery>
		
		
		<script>
		var r = [];
		<cfif get_position.recordcount EQ '0'>
		r[r.length] = ["No Position", "0"];
		r[r.length] = ["----------------", "0"];
		<cfelse>
		r[r.length] = ["Select a Position", "0"];
		r[r.length] = ["----------------", "0"];
		<cfloop query="get_position">
		r[r.length] = ["<cfoutput><cfif LEN(title) GT 33>#Left(title,30)#...<cfelse>#title#</cfif></cfoutput>", "<cfoutput>#jobid#</cfoutput>"];

<!---- // get_position.id EQ candidate_place_company.jobid><option value="#id#" selected>#title# </option><cfelse> --->

		</cfloop>
		</cfif>
		// this passes the packet back to the client
		parent.oGateway.receivePacket(["<cfoutput>#url.id#</cfoutput>", r]);
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