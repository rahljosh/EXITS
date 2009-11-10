<cfif NOT IsDefined('url.doc') OR NOT IsDefined('url.student')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">
<!----
<cftry>
---->
<cfdirectory directory="/var/www/smg_upload_files/online_app/#url.doc#" name="file" filter="#url.student#.*">	
	<cfset ftype = '#Right(file.name, 3)#'>	

	<cffile action="delete" file="/var/www/smg_upload_files/online_app/#url.doc#/#file.name#">
	
	<html>
	<head>
	<cfoutput>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully deleted the uploaded file.");
		location.replace("http://www.student-management.com/nsmg/student_app/index.cfm?curdoc=#url.ref#&id=#url.id#&p=#url.p#");
	//-->
	</script>
	
	</cfoutput>
	</head>
	</html>	
	
<!----
	<cfcatch type="any">
		<cfinclude template="../email_error.cfm">
	</cfcatch>
</cftry>
---->
</cftransaction>