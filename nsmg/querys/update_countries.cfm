<cftransaction action="begin" isolation="SERIALIZABLE">

<cfloop From = "1" To = "#form.count#" Index = "x">
 
	<Cfquery name="update_assignments" datasource="mySQL">
	UPDATE  smg_countrylist 
		SET  countrycode = '#UCASE(Evaluate("form." & x & "_code"))#',
		     seviscode = '#UCASE(Evaluate("form." & x & "_sevis"))#',
			 continent = '#Evaluate("form." & x & "_continent")#'
	WHERE countryid = '#Evaluate("form." & x & "_countryid")#'
	</Cfquery>
	
	<cfif IsDefined('form.delete#x#')> 
			<cfquery name="delete_country" datasource="MySQL">
				DELETE FROM smg_countrylist
				WHERE countryid = '#Evaluate("form." & x & "_countryid")#'
			</cfquery>
	</cfif>
	
</cfloop> 
</cftransaction>
<cflocation url="?curdoc=tools/countries&message=Countries Updated Succesfully!!">
