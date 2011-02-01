<cftransaction action="begin" isolation="SERIALIZABLE">

<cfloop list="#form.countrylist#" Index = "x">
<Cfif client.userid eq 1>
	
    <cfif #Evaluate("form." & x & "_picture")# is not ''> 
			<cffile action="upload" 
            		destination="C:\websites\student-management\nsmg\uploadedfiles\profileFactPics\" 
                    filefield="form.#x#_picture" nameconflict="makeunique">
           
            <Cfimage action="convert" 
            		destination="C:\websites\student-management\nsmg\uploadedfiles\profileFactPics\#x#.png" 
                    isbase64="false" overwrite="true" source="C:\websites\student-management\nsmg\uploadedfiles\profileFactPics\#file.serverfile#">
                    
            <cffile action="delete" 
            		file="C:\websites\student-management\nsmg\uploadedfiles\profileFactPics\#file.serverfile#">
                    
	</cfif>
 </Cfif>   
	<Cfquery name="update_assignments" datasource="mySQL">
	UPDATE  smg_countrylist 
		SET  countrycode = '#UCASE(Evaluate("form." & x & "_code"))#',
		     seviscode = '#UCASE(Evaluate("form." & x & "_sevis"))#',
			 <!----continent = '#Evaluate("form." & x & "_continent")#',---->
             funFact = '#Evaluate("form." & x & "_funFact")#'
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
<cflocation url="?curdoc=tools/countries&message=Countries Updated Successfully!!">
