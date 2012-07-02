<title>Trips</title>

<link href="../linked/css/baseStyle.css" rel="stylesheet" type="text/css" />

<cfquery name="qGetTours" datasource="#APPLICATION.DSN#">
	SELECT
    	st.studentID,
    	st.date,
        st.tripID,
        st.paid,
        smg.tour_name
  	FROM
    	student_tours st
  	LEFT JOIN
    	smg_tours smg ON smg.tour_id = st.tripID
   	WHERE
    	st.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentID#">
   	GROUP BY
    	st.tripID
</cfquery>

<cfquery name="qGetStudent" datasource="#APPLICATION.DSN#">
	SELECT
    	*
   	FROM
    	smg_students
   	WHERE
    	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentID#">
</cfquery>

<cfoutput>

	<table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
    	<tr>
        	<th>
            	#qGetStudent.firstName# #qGetStudent.familyLastName# (###qGetStudent.studentID#) -  Tours
            </th>
        </tr>
    </table>
    
    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
    	<tr class="on">
            <td class="subTitleLeft" align="left" width="20%">Tour</td>
            <td class="subTitleLeft" align="left" width="20%">Registered</td>
            <td class="subTitleLeft" align="left" width="20%">Paid</td>
            <td class="subTitleLeft" align="left" width="20%">Arrival Flight</span></td>
        	<td class="subTitleLeft" align="left" width="20%">Departure Flight</span></td>
        </tr>
        
        <cfscript>
			vCurrentRow = 0;			
		</cfscript>
        
    	<cfif VAL(qGetTours.recordCount)>
       
            <cfloop query="qGetTours">
                
                <cfscript>
                    vCurrentRow++;			
                </cfscript>
                
                <cfquery name="qGetArrivalFlight" datasource="#APPLICATION.DSN#">
                    SELECT
                        *
                    FROM
                        student_tours_flight_information
                    WHERE
                        studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetTours.studentID#">
                    AND
                        tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetTours.tripID#">
                    AND
                        flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
                    ORDER BY
                        departDate
                </cfquery>
                
                <cfquery name="qGetDepartureFlight" datasource="#APPLICATION.DSN#">
                    SELECT
                        *
                    FROM
                        student_tours_flight_information
                    WHERE
                        studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetTours.studentID#">
                    AND
                        tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetTours.tripID#">
                    AND
                        flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">
                    ORDER BY
                        departDate
                </cfquery>
            
                <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                    <td>#tour_name#</td>
                    <td>
                        <cfif IsDate(date)>
                            #DateFormat(date,'mm/dd/yyyy')#
                        <cfelse>
                            <span style="color:red;">Missing</span>
                        </cfif>
                    </td>
                    <td>
                        <cfif IsDate(paid)>
                            #DateFormat(paid,'mm/dd/yyyy')#
                        <cfelse>
                            <span style="color:red;">Missing</span>
                        </cfif>
                    </td>
                    <td>
                        <cfif IsDate(qGetArrivalFlight.departDate)>
                            #DateFormat(qGetArrivalFlight.departDate,'mm/dd/yyyy')#
                        <cfelse>
                            <span style="color:red;">Missing</span>
                        </cfif>
                    </td>
                    <td>
                        <cfif IsDate(qGetDepartureFlight.departDate)>
                            #DateFormat(qGetDepartureFlight.departDate,'mm/dd/yyyy')#
                        <cfelse>
                            <span style="color:red;">Missing</span>
                        </cfif>
                    </td>
                </tr>
                
            </cfloop>
            
     	<cfelse>
        
        	<tr class="off">
            	<td align="center" colspan="5">This student does not have any tours</td>
            </tr>
            
      	</cfif>
        
    </table> 

</cfoutput>