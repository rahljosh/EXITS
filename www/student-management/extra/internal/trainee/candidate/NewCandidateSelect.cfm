<cfparam name="URL.field" default="">
<cfparam name="URL.fieldstudyid" default="0">

<cfoutput>

<cfswitch expression="#URL.field#">

	<cfcase value="listSubCat">
    
		<cfquery name="getSubCategory" datasource="MySql">
			SELECT DISTINCT 
            	subfieldid, 
                subfield as subfieldName
			FROM 
           		extra_sevis_sub_fieldstudy
			WHERE 
            	fieldstudyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fieldstudyid#">
			ORDER BY 
            	subfieldName
		</cfquery>
        
		<script language="JavaScript"> 
			var r = [];
			<cfif NOT VAL(getSubCategory.recordcount)>
				r[r.length] = ["No Sub-Category", "0"];
				r[r.length] = ["----------------", "0"];
			<cfelse>
				r[r.length] = ["Select a Sub-Category", "0"];
				r[r.length] = ["----------------", "0"];
				<cfloop query="getSubCategory">
				r[r.length] = ["<cfif LEN(subfieldName) GT 35>#Left(subfieldName,32)#...<cfelse>#subfieldName#</cfif>", "#subfieldid#"];
				</cfloop>
			</cfif>
			// this passes the packet back to the client
			parent.oGatewaySubCat.receivePacket(["#URL.field#", r]);
		</script>
	
    </cfcase>

	<!---// if no matching option, pass null back to the browser //--->
	<cfdefaultcase>
    
		<script language="JavaScript"> 
			// this passes the packet back to the client
			parent.oGatewaySubCat.receivePacket(null);
		</script>
        
	</cfdefaultcase>
    
</cfswitch>

</cfoutput>