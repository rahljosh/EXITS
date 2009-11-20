<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Delete Host Child</title>
</head>

<body>

<cfif not IsDefined('url.childid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">
	<cftry>
	
		<cfquery name="delete_host_child" datasource="MySql">
			DELETE 
			FROM smg_host_children
			WHERE childid = <cfqueryparam value="#url.childid#" cfsqltype="cf_sql_integer">
				AND hostid = <cfqueryparam value="#url.hostid#" cfsqltype="cf_sql_integer">
			LIMIT 1
		</cfquery>
		
		<html>
		<head>
		<script language="JavaScript">
		<!-- 
		alert("You have successfully updated this page. Thank You.");
		location.replace("?curdoc=forms/host_fam_pis_2");
		-->
		</script>
		</head>
		</html>

	<cfcatch type="any">
		<cfinclude template="../email_error.cfm">
	</cfcatch>
	</cftry>

</cftransaction>

</body>
</html>
