
<cfloop list = "#FORM.question_list#" Index = "x">
<cfset question = #Evaluate("FORM." & x & "_answer")#>
<cfset question2 = #PreserveSingleQuotes(question)#>
		<Cfquery name="add_question_Details" datasource="mySQL">
		 update smg_prquestions
		 	set text = '#question2#',
			 yn = 'no',
			 companyid=#client.companyid#,
			 month =#form.month#,
			 active = #Evaluate("FORM." & x & "_active")#
		 	where id = #x#
		 </Cfquery>

</cfloop>
<cfif isdefined('form.newq')>

<cfset newq2 = #PreserveSingleQuotes(form.new_question)#>
	<cfquery name="insert_new_question" datasource="MySQL">
	insert into smg_prquestions(text, yn, companyid, month)
		values('#newq2#', 'yes', #client.companyid#, #form.month#)
	</cfquery>
</cfif>
<cflocation url="../index.cfm?curdoc=tools/progress_report_questions&u&month=#form.month#">