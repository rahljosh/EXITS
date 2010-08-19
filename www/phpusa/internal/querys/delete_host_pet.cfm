<cfsilent>
	
    <!--- Param URL Variable --->
    <cfparam name="URL.petID" default="0">
    <cfparam name="URL.hostID" default="0">

</cfsilent>

<cfif VAL(URL.petID) AND VAL(URL.hostID)>

    <cfquery datasource="MySql">
        DELETE FROM 
            smg_host_animals
        WHERE 
            animalID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.petID#">
        AND 
            hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
        LIMIT 1
    </cfquery>    

	<script language="JavaScript">
    <!-- 
        alert("You have successfully updated this page. Thank You.");
        location.replace("?curdoc=forms/host_fam_pis_3");
    -->
    </script>

<cfelse>

	<script language="JavaScript">
    <!-- 
        alert("Error: Host pet could not be deleted.");
        location.replace("?curdoc=forms/host_fam_pis_3");
    -->
    </script>
        
</cfif>
