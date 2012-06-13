						<cfquery name="placeDays" datasource="#application.dsn#">
                        select dateofchange, hostid
                        from smg_hosthistory
                        where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="24771">
                        order by dateofchange
                        </cfquery>
                      	<cfset hostDates = ArrayNew(1)>
                        <cfset list1 = ''>
                        <cfset list2 = ''>
                        <cfloop query="placeDays">
                        	
                        	<cfquery name="earliestDate" dbtype="query">
                            select max(dateofchange) as finalDate
                            from placedays
                            where hostid = #hostid#
                            </cfquery>
                            
                            <cfset ArrayAppend(hostDates, "#earliestDate.finalDate#")>
     
                        </cfloop>
                        <cfloop from="1" to="#ArrayLen(hostDates)#" index="i">
               
							<cfset list1 = #ListAppend(list1, #hostDates[i]#)#>
                              <cfif #i# neq 1>
                              	<cfset list2 = #ListAppend(list2, #hostDates[i]#)#>
                              </cfif>
						</cfloop>
                  
					<cfoutput>
					List 1: #list1#<br />
                    List 2: #list2#
                    </cfoutput>