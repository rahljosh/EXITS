<cfquery name="tourInfo" datasource="#application.dsn#">
select tour_name, tour_date
from smg_tours
where tour_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tour_id#"> 
</cfquery>
<cfquery name="femaleStudentsOnTour" datasource="#application.dsn#">
    SELECT st.studentid, s.sex, s.familylastname, s.firstname,
    sts.siblingID, (CONCAT(hc.name, ' ', hc.lastname)) as siblingName, hc.sex as siblingSex
    FROM student_tours st
    LEFT JOIN smg_students s on s.studentid = st.studentid
    LEFT JOIN student_tours_siblings sts on sts.fk_StudentID = st.studentID
   	LEFT JOIN  smg_host_children hc on hc.childid = sts.siblingID
    WHERE st.tripid =<cfqueryparam cfsqltype="cf_sql_integer" value="#url.tour_id#">  and st.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
    and s.sex = 'female'
    ORDER BY s.sex
    
</cfquery>
<cfquery name="maleStudentsOnTour" datasource="#application.dsn#">
    SELECT st.studentid, s.sex,s.familylastname, s.firstname,
    sts.siblingID, (CONCAT(hc.name, ' ', hc.lastname)) as siblingName, hc.sex as siblingSex
    FROM student_tours st
    LEFT JOIN smg_students s on s.studentid = st.studentid
    LEFT JOIN student_tours_siblings sts on sts.fk_StudentID = st.studentID
   	LEFT JOIN  smg_host_children hc on hc.childid = sts.siblingID
    WHERE st.tripid =<cfqueryparam cfsqltype="cf_sql_integer" value="#url.tour_id#">  and st.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
    and s.sex = 'male'
    ORDER BY s.sex
    
</cfquery>
<cfoutput>

<cfset roomNumber = 1>
<cfset curRoom = 1>
<cfset roomCount = 1>
<cfset curSex = 'male'>


<table border="0" cellpadding="8" cellspacing="0">

	<tr>
    	<td colspan=10><h2>Trip: #tourInfo.tour_name# (#tourInfo.tour_date#)</h2></td>
    </tr>
    <tr>
    	<td colspan=3><strong>4 KEYS PER ROOM PACKETS*****</strong></td>
    </tr>
    <tr>
    	<td colspan=3><strong>ALL ROOMS ON SAME FLOOR</strong></td>
	<tr>

    	<td colspan=10><h2>Female</h2></td>
    </tr>
	
  	<tr>
    	<td><strong>Room #roomNumber#</strong></td>
    </tr>
    
<cfloop query="femaleStudentsOnTour">
	<cfif curRoom neq roomnumber>
    	<tr>
        	<td colspan=2><strong> Room #roomNumber#</strong></td>
       </tr>
       <cfset curRoom = #roomnumber#>
    </cfif>

	<tr>
    	<td>#roomcount#. <b>#familylastname#</b> #firstname#</Td><td>#siblingName#</td>
    </tr>
   <cfset roomcount = #roomcount# + 1>
	   <cfif roomcount eq 5 >
        <Cfset roomcount = 1>
        <cfset curRoom = #roomnumber#>
       <cfif femaleStudentsOnTour.currentrow neq femaleStudentsOnTour.recordcount>
        <cfset roomnumber = #roomnumber# + 1>
       </cfif>
      </cfif>
  </cfloop>
  
    <cfset roomnumber = #roomnumber# + 1>
	<cfset curRoom = #roomnumber#>
    <cfset roomCount = 1> 
  <tr>
  	<td colspan=10><br><br><br><h2>Male</h2></td>
  </tr>
 <tr>
        	<td> <strong> Room #roomNumber#</strong></td>
       </tr>
  <cfloop query="maleStudentsOnTour">
	<cfif curRoom neq roomnumber>
    	<tr>
        	<td> <strong> Room #roomNumber#</strong></td>
       </tr>
       <cfset curRoom = #roomnumber#>
    </cfif>

	<tr>
    	<Td>#roomcount#. <b>#familylastname#</b> #firstname#</Td><td>#siblingName#</td>
    </tr>
   <cfset roomcount = #roomcount# + 1>
   	<cfif roomcount eq 5 >
    <Cfset roomcount = 1>
   		<cfset curRoom = #roomnumber#>
        <cfif maleStudentsOnTour.currentrow neq maleStudentsOnTour.recordcount>
   			<cfset roomnumber = #roomnumber# + 1>
        </cfif>
   </cfif>
  </cfloop> 
  <Cfset roomnumber = #roomnumber# +1>
    <tr>
        	<td><strong> Room #roomNumber# - <em>Chaperone</em></strong></td>
       </tr
  ><tr>
    	<td>1. _______________</td>
    </tr>
    <tr>
    	<td>2. _______________</td>
    </tr>
    <tr>
    	<td>3. _______________</td>
    </tr>
    <tr>
    	<td>4. _______________</td>
    </tr>
    <cfset roomnumber = #roomnumber# + 1>
      <tr>
        	<td><strong> Room #roomNumber# - <em>Chaperone</em></strong></td>
       </tr
  ><tr>
    	<td>1. _______________</td>
    </tr>
    <tr>
    	<td>2. _______________</td>
    </tr>
    <tr>
    	<td>3. _______________</td>
    </tr>
    <tr>
    	<td>4. _______________</td>
    </tr>
    <cfset roomnumber = #roomnumber# + 1>
</cfoutput>
</table>