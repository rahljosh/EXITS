<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<html>
	<head>
		<script type="text/javascript">
			alert("You have successfully updated this page. Thank You.");
			<cfif NOT IsDefined('url.next')>
				location.replace("?curdoc=section3/page14&id=3&p=14");
			<cfelse>
				location.replace("?curdoc=section4&id=4");
			</cfif>
		</script>
	</head>
</html>