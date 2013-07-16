<cfparam name="URL.userID" default="0">
<cfparam name="URL.familyID" default="0">

<!--- Check if directory exists and create it if it does not --->
<cfif NOT DirectoryExists('#APPLICATION.PATH.cbcXML#')>
	<cfdirectory action="create" directory="#APPLICATION.PATH.cbcXML#">
</cfif>

<!----Upload File---->
<cffile action = "upload"
    destination = "#APPLICATION.PATH.cbcXML#"
    fileField = "file_upload"
    nameConflict = "overwrite">

<!----Check Image Size--->
<cffile	action="Move" 
    source="#APPLICATION.PATH.cbcXML##CFFILE.ServerFile#" 
    destination="#APPLICATION.PATH.cbcXML##URL.userID#_#URL.familyID#.#cffile.clientfileext#">
	 
<!----Check if file has been uploaded---->
<cfquery name="check_file" datasource="#APPLICATION.DSN#">
	UPDATE smg_user_family
    SET auth_received = 1,
    	auth_received_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFFILE.CLIENTFILEEXT#">
  	WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.userID)#">
    AND ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.familyID)#">
</cfquery>

<cflocation url="../index.cfm?curdoc=user_info&userid=#URL.userID#">