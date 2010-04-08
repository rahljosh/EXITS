<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="update_double_docs" datasource="caseusa">
update smg_students
	set 
		<cfif #form.dblplace_doc_stu# is ''>
			dblplace_doc_stu = null,
		<cfelse>
			dblplace_doc_stu = #CreateODBCDate(form.dblplace_doc_stu)#,
		</cfif>
		
		<cfif #form.dblplace_doc_fam# is ''>
			dblplace_doc_fam = null,
		<cfelse>
			dblplace_doc_fam = #CreateODBCDate(form.dblplace_doc_fam)#,
		</cfif>
		
		<cfif #form.dblplace_doc_host# is ''>
			dblplace_doc_host = null,
		<cfelse>
			dblplace_doc_host = #CreateODBCDate(form.dblplace_doc_host)#,
		</cfif>
		
		<cfif #form.dblplace_doc_school# is ''>
			dblplace_doc_school = null,
		<cfelse>
			dblplace_doc_school = #CreateODBCDate(form.dblplace_doc_school)#,
		</cfif>
		
		<cfif #form.dblplace_doc_dpt# is ''>
			dblplace_doc_dpt = null
		<cfelse>
			dblplace_doc_dpt = #CreateODBCDate(form.dblplace_doc_dpt)#
		</cfif>
		WHERE studentid = #client.studentid#
</cfquery>
</cftransaction>

<cflocation url="../forms/double_place_docs.cfm" addtoken="no">

</body>
</html>
