<cfloop list=#form.student# index=i>
<cfoutput>#i#
	<cfloop list="#form.student#" index=x >
		#x#
	</cfloop>
	</cfoutput>
</cfloop>
