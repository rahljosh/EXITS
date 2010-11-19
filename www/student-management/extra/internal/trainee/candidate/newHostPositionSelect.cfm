<cfparam name="URL.field" default="">
<cfparam name="URL.companyID" default="0">

<cfoutput>

<cfswitch expression="#URL.field#">

	<cfcase value="jobID">
    
		<cfquery name="qGetPosition" datasource="MySql">
			SELECT 
            	id, 
                title
			FROM 
           		extra_jobs
            WHERE 
            	hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.companyID#">
			AND				
            	title != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
			ORDER BY 
            	title
		</cfquery>       
		
        
        
		<script language="JavaScript"> 
			var r = [];
			<cfif NOT VAL(qGetPosition.recordcount)>
				r[r.length] = ["No Position", "0"];
				r[r.length] = ["----------------", "0"];
			<cfelse>
				r[r.length] = ["Select a Position", "0"];
				r[r.length] = ["----------------", "0"];
				<cfloop query="qGetPosition">
				r[r.length] = ["<cfif LEN(title) GT 35>#Left(title,32)#...<cfelse>#title#</cfif>", "#id#"];
				</cfloop>
			</cfif>
			parent.oGatewayHostPosition.receivePacket(["#URL.field#", r]);
		</script>
	
    </cfcase>

	<!---// if no matching option, pass null back to the browser //--->
	<cfdefaultcase>
    
		<script language="JavaScript"> 
			// this passes the packet back to the client
			parent.oGatewayHostPosition.receivePacket(null);
		</script>
        
	</cfdefaultcase>
    
</cfswitch>

</cfoutput>