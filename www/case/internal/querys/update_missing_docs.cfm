<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="update_missing_docs" datasource="caseusa">
update smg_students
	set transcript = "#form.transcript#",
		language_eval = "#form.language_eval#",
		social_skills = "#form.social_skills#",
		health = "#form.health#",
		immunization = "#form.immunization#",
		minorauthorization = "#form.minorauthorization#",
		other_missing_docs = '#form.other_missing#'
	where studentid = "#client.studentid#"
</cfquery>
</cftransaction>

<cflocation url="../forms/missing_documents.cfm" addtoken="no">

</body>
</html>
