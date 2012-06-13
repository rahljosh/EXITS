<Cfquery name="DateRange" datasource="mysql">
SELECT seasonid, startDate, endDate
FROM smg_seasons
WHERE #now()# >= startdate and #now()# <= endDate
</cfquery>
<Cfset client.pr_rmonth = 1>
<Cfset  arrivalInfo.dep_date = '2011-08-30'>
<Cfset  departureInfo.dep_date = '2011-07-15'>
<Cfoutput>
       <Cfloop from="#DateRange.startDate#" to="#DateRange.endDate#" index=i step="#CreateTimeSpan(31,0,0,0)#">
            <Cfif client.pr_rmonth eq "#DatePart('m', '#i#')#">
                <Cfset client.pr_rmonth = '#DatePart('m', '#i#')#'>
                <Cfset startDate = '#DateAdd("d", "-7", "#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01")#"'>
                <Cfset endDate = '#DateAdd("d", "21", "#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01")#"'>
                <cfset prevRepMonth = "#DatePart('m','#startDate#')#">
                <cfset repReqDate = '#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01'>
           	</Cfif>
       </Cfloop>
Arrival Date: #arrivalInfo.dep_Date# <Br />
Departure Date: #departureInfo.dep_date#<br />
Report Required: #repReqDate# <br />
<Cfif client.pr_rmonth eq 8>
	<Cfif #datePart('m', '#arrivalInfo.dep_Date#')# gt #datePart('m', '#repReqDate#')#>
    Report does not need to be filled out.
    <cfelse>
    Fill it out.
    </Cfif> 
</Cfif>

<Cfif client.pr_rmonth eq 6>
	<Cfif #datePart('m', '#departureInfo.dep_Date#')# lt #datePart('m', '#repReqDate#')#>
   Dep Report does not need to be filled out.
    <cfelse>
    Dep Fill it out.
    </Cfif> 
</Cfif>
<Cfif client.pr_rmonth eq 1>
	<Cfif #datePart('m', '#departureInfo.dep_Date#')# eq 12 or #datePart('m', '#departureInfo.dep_Date#')# eq 1 >
   Jan Report does not need to be filled out.
    <cfelse>
    Jan Fill it out.
    </Cfif> 
</Cfif>
</Cfoutput>