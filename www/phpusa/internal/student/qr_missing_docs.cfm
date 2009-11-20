<cfif NOT IsDefined('form.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="update_missing_docs" datasource="mysql">
	UPDATE smg_students
	SET transcript = "#form.transcript#",
		language_eval = "#form.language_eval#",
		social_skills = "#form.social_skills#",
		health = "#form.health#",
		immunization = "#form.immunization#",
		minorauthorization = "#form.minorauthorization#",
		other_missing_docs = '#form.other_missing#',
		php_passport_copy = '#form.php_passport_copy#'
	WHERE studentid = "#form.unqid#"
	LIMIT 1
</cfquery>
</cftransaction>
<!----	
<cflocation url="missing_documents.cfm?unqid=#form.unqid#" addtoken="no">
---->
</body>
</html>
