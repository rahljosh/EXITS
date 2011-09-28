<cfparam name="submitted" default="0">
<cfparam name="keyword" default="">
<cfparam name="paid" default="">
<cfparam name="permissionForm" default="">
<cfparam name="tour_id" default="0">
<cfparam name="orderby" default="paid">
<cfparam name="recordsToShow" default="500">

<br>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 bgcolor="#ffffff">
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=30 background="pics/header_background.gif"><img src="pics/plane.png"></td>
        <td background="pics/header_background.gif"><h2>Trips</h2></td>
        <td background="pics/header_background.gif" align="right"></td>
    	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="?curdoc=tours/mpdtours" method="post">
<input name="submitted" type="hidden" value="1">
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>

        <td>
			<!--- GET ALL REGIONS --->
            <Cfquery name="allTrips" datasource="#application.dsn#">
            select * 
            from smg_tours
            <!----
            where tour_status <> 'Inactive'
            ---->
            order by tour_name
            </Cfquery>
            Trips<br />
			<cfselect NAME="tour_id" query="allTrips" value="tour_id" display="tour_name" selected="#tour_id#" queryPosition="below">
				<option value="0">All</option>
			</cfselect>
        </td>

        <td>
            Keyword / ID<br />
			<cfinput type="text" name="keyword" value="#keyword#" size="10" maxlength="50">         
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
                <option value="stu.studentid" <cfif orderby EQ 'studentid'>selected</cfif>>ID</option>
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

		
        
        <cfquery name="getResults" datasource="#application.dsn#">
           select *, stu.familylastname, stu.firstname, stu.studentid, stu.UNIQUEID, c.companyshort_nocolor
            from student_tours 
            left join smg_students stu on stu.studentid = student_tours.studentid
            left join smg_tours on smg_tours.tour_id = student_tours.tripid
            left join smg_companies c on c.companyid = student_tours.companyid
            where 1=1 
            <CFif tour_id gt 0>
            AND student_tours.tripid = #tour_id#
            </CFif>
			 <cfif trim(keyword) NEQ ''>
                AND (
                	student_tours.studentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(keyword)#">
                	OR stu.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR stu.firstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	
                )
            </cfif>
		    <CFif paid eq 1>
                AND student_tours.paid <> ''
            </CFif>
            <CFif paid eq 0>
                AND student_tours.paid = ''
            </CFif>
            <CFif permissionForm eq 1>
                AND student_tours.permissionForm <> ''
            </CFif>
            <CFif permissionForm eq 0>
                AND student_tours.permissionForm = ''
            </CFif>
            and student_tours.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
       	ORDER BY #orderby#, stu.studentid
        </cfquery>
    
 

	<cfif getResults.recordCount GT 0>

		<cfparam name="url.startPage" default="1">
		<cfset totalPages = ceiling(getResults.recordCount / recordsToShow)>
		<cfset startrow = 1 + ((url.startPage - 1) * recordsToShow)>
		<cfif getResults.recordCount GT url.startPage * recordsToShow>
			<cfset isNextPage = 1>
			<cfset endrow = url.startPage * recordsToShow>
		<cfelse>
			<cfset isNextPage = 0>
			<cfset endrow = getResults.recordCount>
		</cfif>
		<cfset urlVariables = "submitted=1&tour_id=#tour_id#&keyword=#urlEncodedFormat(keyword)#&paid=#paid#&permissionForm=#permissionForm#&orderby=#orderby#&recordsToShow=#recordsToShow#">
    
        <cfoutput>
    
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr align="center">
                <td>
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
                    Displaying #startrow# to #endrow# of #getResults.recordCount#
                </td>
            </tr>
        </table>
            
        <table width=100% class="section">
            <tr align="left">
                <th>ID</th>
                <th>Last Name</th>
                <th>First Name</th>
                <th>Tour</th>
                <th>Paid</th>
                <th>Permission</th>
                <th>Flights</th>
                <th>Company</th>
            </tr>
            <Cfset currentTour = 0>
            <Cfset currentStudentCount = 0>
            <cfloop query="getResults" startrow="#startrow#" endrow="#endrow#">
             
         
            <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                <td><a href="?curdoc=tours/profile&studentid=#studentid#">#studentid#</a></td>
                <td>#familylastname#</td>
                <td>#firstname#</td>
                <td>#tour_name# - Total <!----(#totalStudent.totalStudents#)----></td>
                <td><cfif paid is not ''>#DateFormat(paid)#</cfif></td>
                <td><cfif permissionForm is not ''>#DateFormat(permissionForm)#</cfif></td>
                <td><cfif flightInfo is not ''>#DateFormat(permissionForm)#<cfelse>No</cfif></td>
                <td>#companyshort_nocolor#</td>
            </tr>
            </cfloop>
        </table>
    
        </cfoutput>
	<cfelse>
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr>
                <td>No students matched your criteria.</td>
            </tr>
        </table>
    </cfif>
    
</cfif>
   
<cfinclude template="../table_footer.cfm">