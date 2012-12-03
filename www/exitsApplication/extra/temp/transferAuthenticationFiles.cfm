<cfdirectory name="secretaryOfState" directory="#APPLICATION.PATH.businessLicense#">
<cfdirectory name="departmentOfLabor" directory="#APPLICATION.PATH.departmentOfLabor#">
<cfdirectory name="googleEarth" directory="#APPLICATION.PATH.googleEarth#">
<cfdirectory name="workmensCompensation" directory="#APPLICATION.PATH.workmensCompensation#">

<cfloop query="secretaryOfState">
	<cfset hostID = ListGetAt(#name#,1,'.')>
    <cfset ext = ListGetAt(#name#,2,'.')>
    <cfset time = NOW()>
    <cffile action="move" source="#APPLICATION.PATH.businessLicense##name#" destination="#APPLICATION.PATH.authentications##hostID#_secretaryOfState_#DateFormat(time,'mm-dd-yyyy')#.#ext#">
    <cfquery name="qGetExpiration" datasource="MySql">
    	SELECT authentication_secretaryOfStateExpiration AS exp
        FROM extra_hostCompany
        WHERE hostcompanyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostID#">
    </cfquery>
    <cfquery datasource="MySql">
    	INSERT INTO extra_hostauthenticationfiles (
        	hostID, 
            authenticationType, 
            dateAdded, 
            dateExpires, 
            fullPath, 
            fileType )
        VALUES (
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(hostID)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="secretaryOfState">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#qGetExpiration.exp#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.PATH.authentications##hostID#_secretaryOfState_#DateFormat(time,'mm-dd-yyyy')#.#ext#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ext#"> )
    </cfquery>
</cfloop>

<cfloop query="departmentOfLabor">
	<cfset hostID = ListGetAt(#name#,1,'.')>
    <cfset ext = ListGetAt(#name#,2,'.')>
    <cfset time = NOW()>
    <cffile action="move" source="#APPLICATION.PATH.departmentOfLabor##name#" destination="#APPLICATION.PATH.authentications##hostID#_departmentOfLabor_#DateFormat(time,'mm-dd-yyyy')#.#ext#">
    <cfquery name="qGetExpiration" datasource="MySql">
    	SELECT authentication_departmentOfLaborExpiration AS exp
        FROM extra_hostCompany
        WHERE hostcompanyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostID#">
    </cfquery>
    <cfquery datasource="MySql">
    	INSERT INTO extra_hostauthenticationfiles (
        	hostID, 
            authenticationType, 
            dateAdded, 
            dateExpires, 
            fullPath, 
            fileType )
        VALUES (
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(hostID)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="departmentOfLabor">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#qGetExpiration.exp#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.PATH.authentications##hostID#_departmentOfLabor_#DateFormat(time,'mm-dd-yyyy')#.#ext#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ext#"> )
    </cfquery>
</cfloop>

<cfloop query="googleEarth">
	<cfset hostID = ListGetAt(#name#,1,'.')>
    <cfset ext = ListGetAt(#name#,2,'.')>
    <cfset time = NOW()>
    <cffile action="move" source="#APPLICATION.PATH.googleEarth##name#" destination="#APPLICATION.PATH.authentications##hostID#_googleEarth_#DateFormat(time,'mm-dd-yyyy')#.#ext#">
    <cfquery name="qGetExpiration" datasource="MySql">
    	SELECT authentication_googleEarthExpiration AS exp
        FROM extra_hostCompany
        WHERE hostcompanyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostID#">
    </cfquery>
    <cfquery datasource="MySql">
    	INSERT INTO extra_hostauthenticationfiles (
        	hostID, 
            authenticationType, 
            dateAdded, 
            dateExpires, 
            fullPath, 
            fileType )
        VALUES (
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(hostID)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="googleEarth">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#qGetExpiration.exp#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.PATH.authentications##hostID#_googleEarth_#DateFormat(time,'mm-dd-yyyy')#.#ext#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ext#"> )
    </cfquery>
</cfloop>

<cfloop query="workmensCompensation">
	<cfset hostID = ListGetAt(#name#,1,'.')>
    <cfset ext = ListGetAt(#name#,2,'.')>
    <cfset time = NOW()>
    <cffile action="move" source="#APPLICATION.PATH.workmensCompensation##name#" destination="#APPLICATION.PATH.authentications##hostID#_workmensCompensation_#DateFormat(time,'mm-dd-yyyy')#.#ext#">
    <cfquery name="qGetExpiration" datasource="MySql">
    	SELECT WCDateExpired AS exp
        FROM extra_hostCompany
        WHERE hostcompanyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostID#">
    </cfquery>
    <cfquery datasource="MySql">
    	INSERT INTO extra_hostauthenticationfiles (
        	hostID, 
            authenticationType, 
            dateAdded, 
            dateExpires, 
            fullPath, 
            fileType )
        VALUES (
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(hostID)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="workmensCompensation">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#qGetExpiration.exp#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.PATH.authentications##hostID#_workmensCompensation_#DateFormat(time,'mm-dd-yyyy')#.#ext#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ext#"> )
    </cfquery>
</cfloop>