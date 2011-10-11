<!--- ------------------------------------------------------------------------- ----
	
	File:		header.cfm
	Author:		Marcus Melo
	Date:		October 10, 2011
	Desc:		Student Trip Header
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param Variables --->
    <cfparam name="submitted" default="0">
    <cfparam name="keyword" default="">
    <cfparam name="paid" default="1">
    <cfparam name="permissionForm" default="">
    <cfparam name="tour_id" default="0">
    <cfparam name="orderby" default="paid">
    <cfparam name="recordsToShow" default="500">

	<!--- Get Tours --->
    <cfquery name="qGetTours" datasource="#application.dsn#">
        SELECT 
            * 
        FROM 
            smg_tours
        ORDER BY 
            tour_name
    </cfquery>

	<!--- Get Total Registrations --->
    <cfquery name="qGetTotalRegistrations" datasource="#application.dsn#">
        SELECT 
            t.tour_ID,
            t.tour_name,
            t.availableSpots,
            COUNT(st.studentID) AS total 
        FROM 
            smg_tours t
        LEFT OUTER JOIN
        	student_tours st ON st.tripID = t.tour_ID
            	AND
                	st.paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                AND
                	st.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">

        GROUP BY
        	t.tour_ID
        
        UNION
        
        SELECT 
            t.tour_ID,
            t.tour_name,
            t.availableSpots,
            COUNT(sts.fk_studentID) AS total 
        FROM 
            smg_tours t
        INNER JOIN
        	student_tours st ON st.tripID = t.tour_ID
            	AND
                	st.paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                AND
                	st.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        INNER JOIN	
        	student_tours_siblings sts ON sts.tripID = t.tour_ID
            	AND
                	sts.fk_studentID = st.studentID
                AND
                	sts.paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
        GROUP BY
        	t.tour_ID
		
        ORDER BY
        	tour_name
    </cfquery>
    
	<!--- FORM submitted --->
    <cfif submitted>

        <cfquery name="qGetResults" datasource="#application.dsn#">
           	SELECT 
            	st.*, 
                smg_tours.tour_name,
                stu.familylastname, 
                stu.firstname, 
                stu.studentID, 
                stu.uniqueID, 
                c.companyshort_nocolor,
                ap.authTransactionID,
                ap.amount
            FROM 
            	student_tours st
            INNER JOIN
            	smg_students stu on stu.studentID = st.studentID
            INNER JOIN
            	applicationPayment ap ON ap.foreignID = st.ID
                	AND
                    	foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="student_tours">
                    AND	
                    	authIsSuccess = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            INNER JOIN
            	smg_tours on smg_tours.tour_id = st.tripid
            LEFT JOIN 
            	smg_companies c on c.companyid = st.companyid
            WHERE
            	st.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">

			<CFif VAL(tour_id)>
            	AND 
                	st.tripid = <cfqueryparam cfsqltype="cf_sql_integer" value="#tour_id#">
            </CFif>
            
            <cfif LEN(TRIM(keyword))>
                AND (
               			st.studentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(keyword)#">
        	        OR 
                    	stu.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
		            OR 
                    	stu.firstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                	)
            </cfif>
            
            <cfif paid EQ 1>
            	AND 
                	st.paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
            <cfelseif paid EQ 0>
            	AND 
                	st.paid IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
            </cfif>
            
            <cfif permissionForm EQ 1>
            	AND 
                	st.permissionForm IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
            <cfelseif permissionForm EQ 0>
            	AND 
                	st.permissionForm IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
            </cfif>

       		ORDER BY 
            	#orderby#, 
                stu.studentID,
                tour_name
        </cfquery>

        <cfif qGetResults.recordCount>
    
            <cfparam name="url.startPage" default="1">
            
            <cfset totalPages = ceiling(qGetResults.recordCount / recordsToShow)>
            
            <cfset startrow = 1 + ((url.startPage - 1) * recordsToShow)>
            
            <cfif qGetResults.recordCount GT url.startPage * recordsToShow>
                <cfset isNextPage = 1>
                <cfset endrow = url.startPage * recordsToShow>
            <cfelse>
                <cfset isNextPage = 0>
                <cfset endrow = qGetResults.recordCount>
            </cfif>
            
            <cfset urlVariables = "submitted=1&tour_id=#tour_id#&keyword=#urlEncodedFormat(keyword)#&paid=#paid#&permissionForm=#permissionForm#&orderby=#orderby#&recordsToShow=#recordsToShow#">
		
        </cfif>
    
    </cfif>
    
</cfsilent>

<cfoutput>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="plane.png"
        tableTitle="Trips"
    />

    <cfform action="?curdoc=tours/mpdtours" method="post">
        <input name="submitted" type="hidden" value="1">
        
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
            <tr>
                <td><input name="send" type="submit" value="Submit" /></td>
                <td>
                    Trips<br />
                    <cfselect name="tour_id" query="qGetTours" value="tour_id" display="tour_name" selected="#tour_id#" queryPosition="below">
                        <option value="0">All</option>
                    </cfselect>
                </td>
                <td>
                    Keyword / ID<br />
                    <cfinput type="text" name="keyword" value="#keyword#" size="20" maxlength="50">         
                </td>
                <td>
                    Paid<br />
                    <select name="paid">
                        <option value="">All</option>
                        <option value="1" <cfif paid EQ 1>selected</cfif>>Yes</option>
                        <option value="0" <cfif paid EQ 0>selected</cfif>>No</option>
                    </select>
                </td>
                <td>
                    Permission<br />
                    <select name="permissionForm">
                        <option value="">All</option>
                        <option value="1" <cfif permissionForm EQ 1>selected</cfif>>Yes</option>
                        <option value="0" <cfif permissionForm EQ 0>selected</cfif>>No</option>
                    </select>            
                </td>
                <td>
                    Order By<br />
                    <select name="orderby">
                        <option value="stu.studentID" <cfif orderby EQ 'studentID'>selected</cfif>>ID</option>
                        <option value="familylastname" <cfif orderby EQ 'familylastname'>selected</cfif>>Last Name</option>
                        <option value="tour_name" <cfif orderby EQ 'Trip'>selected</cfif>>Tour</option>
                        <option value="Paid" <cfif orderby EQ 'Paid'>selected</cfif>>Paid</option>
                        <option value="Permission" <cfif orderby EQ 'Permission'>selected</cfif>>Permission</option>
                        
                    </select>            
                </td>
                <td>
                    Records Per Page<br />
                    <select name="recordsToShow">
                        <option <cfif recordsToShow EQ 25>selected</cfif>>25</option>
                        <option <cfif recordsToShow EQ 50>selected</cfif>>50</option>
                        <option <cfif recordsToShow EQ 100>selected</cfif>>100</option>
                        <option <cfif recordsToShow EQ 250>selected</cfif>>250</option>
                        <option <cfif recordsToShow EQ 500>selected</cfif>>500</option>
                    </select>            
                </td>
            </tr>
        </table>
    </cfform>
    
    <cfif submitted>
    
        <cfif qGetResults.recordCount GT 0>

            <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
                <tr>
                    <td align="center">
                        <cfif totalPages GT 1>
                            <cfif url.startPage NEQ 1>
                                <a href="?curdoc=host_fam&startPage=#url.startPage - 1#&#urlVariables#">< PREV</a> &nbsp;
                            </cfif>
                            <cfloop from="1" to="#totalPages#" index="i">
                                <cfif i is url.startPage>#i#<cfelse><a href="?curdoc=host_fam&startPage=#i#&#urlVariables#">#i#</a></cfif>
                            </cfloop>
                            <cfif isNextPage>
                                &nbsp; <a href="?curdoc=host_fam&startPage=#url.startPage + 1#&#urlVariables#">NEXT ></a>
                            </cfif>
                            <br>
                        </cfif>
                        Displaying #startrow# to #endrow# of #qGetResults.recordCount#
                    </td>
                </tr>
            </table>
                
            <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
                <tr align="left" style="font-weight:bold;">
                    <td>ID</td>
                    <td>Last Name</td>
                    <td>First Name</td>
                    <td align="center">Host Siblings</td>
                    <td>Tour</td>
                    <td>Paid</td> 
                    <td>Total</td>                   
                    <td>Transaction ID</td>
                    <td>Permission</td>
                    <td>Flights</td>
                    <td>Company</td>
                </tr>
                <cfloop query="qGetResults" startrow="#startrow#" endrow="#endrow#">
                
					<!--- Get Total Siblings --->
                    <cfquery name="qGetTotalSiblings" datasource="#application.dsn#">
                        SELECT 
                            ID 
                        FROM 
                            student_tours_siblings
                        WHERE
                            fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.studentID#">
                        AND
                            tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.tripID#">
                        AND 
                        	paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    </cfquery>
            
                    <tr bgcolor="#iif(qGetResults.currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                        <td><a href="?curdoc=tours/profile&studentID=#qGetResults.studentID#">#studentID#</a></td>
                        <td>#qGetResults.familylastname#</td>
                        <td>#qGetResults.firstname#</td>
                        <td align="center">#qGetTotalSiblings.recordCount#</td>
                        <td>#qGetResults.tour_name#</td>
                        <td><cfif IsDate(qGetResults.paid)>#DateFormat(qGetResults.paid)#</cfif></td>
                        <td>#DollarFormat(qGetResults.amount)#</td>
                        <td>#qGetResults.authTransactionID#</td>
                        <td><cfif IsDate(qGetResults.permissionForm)>#DateFormat(qGetResults.permissionForm)#</cfif></td>
                        <td><cfif LEN(qGetResults.flightInfo)>#DateFormat(qGetResults.permissionForm)#<cfelse>No</cfif></td>
                        <td>#qGetResults.companyshort_nocolor#</td>
                    </tr>
                </cfloop>
            </table>
        
        <cfelse>
        
            <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
                <tr>
                    <td>No students matched your criteria.</td>
                </tr>
            </table>
            
        </cfif>
        
    <!--- FORM Not Submitted --->
    <cfelse>

        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
            <tr>
            	<td>
                
                    <table border="0" cellpadding="4" cellspacing="0" width="50%" align="center">
                        <tr style="font-weight:bold;">
                            <td>Trip</td>
                            <td align="center">Number of Spots</td>
                            <td align="center">Total of Registrations</td>
                        </tr>
                        <cfset vTotalStudents = 0>
                        <cfloop query="qGetTotalRegistrations">
                            <tr bgcolor="#iif(qGetTotalRegistrations.currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                                <td>#qGetTotalRegistrations.tour_name#</td>
                                <td align="center">#qGetTotalRegistrations.availableSpots#</td>
                                <td align="center">#qGetTotalRegistrations.total#</td>
                            </tr>
                            <cfset vTotalStudents = vTotalStudents + qGetTotalRegistrations.total>
                        </cfloop>
                        <tr>
                            <th colspan="2" align="right">
                                Total of registrations: 
                            </th>
                            <td align="center">#vTotalStudents#</td>
                        </tr>            
                    </table>   
                    
				</td>
			</tr>
		</table>                                                     
        
    </cfif>

    <!--- Table Footer --->
    <gui:tableFooter />

</cfoutput>
