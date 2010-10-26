<head>
<!----Script for greybox---->
<script type="text/javascript" language="JavaScript">
    var GB_ROOT_DIR = "https://ise.exitsapplication.com/nsmg/greybox/";
</script>
<script type="text/javascript" src="greybox/AJS.js"></script>
<script type="text/javascript" src="greybox/AJS_fx.js"></script>
<script type="text/javascript" src="greybox/gb_scripts.js"></script>
<link href="greybox/gb_styles.css" rel="stylesheet" type="text/css" />
</head>
<script type="text/javascript">
  function DoNav(theUrl)
  {
  document.location.href = theUrl;
  }
</script>


<!----Set Default Search Parametes---->
<cfparam name="keyword" default="">
<cfparam name="orderby" default="tour_name">
<cfparam name="form.tourStatus" default="0">
<cfparam name="paid" default="0">
<cfparam name="recordsToShow" default="25">
<cfparam name="tripSelected" default ="0">
<Cfif isDefined('form.delete')>
	<cfquery datasource="#application.dsn#">
    delete from student_tours
    where id = #form.delete#
    limit 1
    </cfquery>
    <cfquery datasource="#application.dsn#">
    delete from student_tours_siblings
    where  mastertripid = #form.delete#
  
    </cfquery>
</Cfif>

<cfif isDefined('url.permission')>
    <cfquery datasource="#application.dsn#">
    update student_tours
    set permissionForm = #now()#
    where id = #url.permission#
    </cfquery>	
    
    <Cfquery name="tourInfo" datasource="#application.dsn#">
    select *, smg_tours.tour_name, smg_tours.tour_date, smg_tours.tour_price, smg_tours.tour_flightDetails
    from student_tours
    left join smg_tours on smg_tours.tour_id = student_tours.tripid
    where id = #url.permission#
    </cfquery>
    
    <cfquery name="student_info" datasource="#application.dsn#">
        select s.familylastname, s.firstname, s.middlename, s.studentid, s.med_allergies, s.other_allergies, s.dob, s.email, s.cell_phone, s.sex, s.regionassigned,  s.dob, s.countrybirth, s.countrycitizen, s.med_allergies, s.other_allergies, s.countryresident, h.airport_city, h.airport_state, h.local_air_code, h.major_air_code, 
        h.hostid, h.familylastname hostlast, h.motherfirstname, h.fatherfirstname, h.motherlastname, h.fatherlastname, h.address, h.address2, h.city, h.state, h.zip, h.email as hostemail, h.phone as hostphone, h.mother_cell, h.father_cell, h.fatherworkphone, h.motherworkphone,
        u.firstname as areaRep_first, u.lastname as areaRep_last, u.phone as areaRep_phone,
        school.schoolname
        from smg_students s 
        left join smg_hosts h on h.hostid = s.hostid
        left join smg_users u on u.userid = s.arearepid
        left join smg_schools school on school.schoolid = h.schoolid
        where s.studentid = #url.studentid# 
    </cfquery>
      <cfsavecontent variable="email_message">
        <cfoutput>	
        	<strong>STUDENT IS CONFIRMED, READY TO BOOK</strong><br />			
            <h3>Trip Request</h3>
            
            <p>Tour: #tourInfo.tour_name#<br />
            Dates: #tourInfo.tour_date#<br />
            Local Airport: #student_info.local_air_code#<br />
			Major Airport: #student_info.major_air_code#<br />
            Additional Notes: #tourInfo.tour_flightDetails#
            </p>
			<p>
            First Name: #student_info.firstname#<br />
            Middle Name: #student_info.middlename#<Br />
            Last Name: #student_info.familylastname#<br />
            Email: #student_info.email#<br />
            DOB: #student_info.dob#
            </p>
        </cfoutput>
        </cfsavecontent>
        
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="dees626@verizon.net">
            <cfinvokeargument name="email_cc" value="brendan@iseusa.com">
            <cfinvokeargument name="email_replyto" value="#student_info.email#">
            <cfinvokeargument name="email_subject" value="Trip Request">
            <cfinvokeargument name="email_message" value="#email_message#">
        </cfinvoke>	
</cfif>




<Cfquery name="allTrips" datasource="#application.dsn#">
select * 
from smg_tours
order by tour_name
</Cfquery>

<cfquery name="tours" datasource="#application.dsn#">
select *, stu.familylastname, stu.firstname, stu.studentid, stu.UNIQUEID
from student_tours 
left join smg_students stu on stu.studentid = student_tours.studentid
left join smg_tours on smg_tours.tour_id = student_tours.tripid
where 1=1 
		<!----Keyword---->
  		<cfif trim(keyword) NEQ ''>
            AND (
                stu.studentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(keyword)#">
                OR stu.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                OR stu.firstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
            )
        </cfif>
        <!----Tour Name---->
        <Cfif tripSelected NEQ 0>
        AND smg_tours.tour_id = #tripSelected#
        </Cfif>
        <!----Tour Status---->
       	<cfif form.tourStatus is not ''>
        AND smg_tours.tour_status = '#form.tourStatus#'
        </cfif>
        <Cfif paid neq 0>
        AND student_tours.paid <> ''
        </Cfif>
        order by #orderby#
        
        
</cfquery>


<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 bgcolor="#ffffff">
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=30 background="pics/header_background.gif"><img src="pics/students.gif"></td>
        <td background="pics/header_background.gif"><h2>Tours</h2></td>
        <td background="pics/header_background.gif" align="right">
        
        </td>
    	<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
<cfoutput>
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td>
        <Cfform>
<table border=0 cellpadding=4 cellspacing=0 width=100% >
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
	
        <td>
		
            Tour Names<br />
           
                <cfselect name="tripSelected" query="allTrips" value="tour_id" display="tour_name" selected="#tripSelected#" queryPosition="below">
                    <option value="0" >All</option>
                </cfselect>
        	
        </td>


        <td>
            Student Name / ID<br />
			<cfinput type="text" name="keyword" value="#keyword#" size="20" maxlength="50">         
        </td>

        <td>
            Tour Status<br />
			<cfquery name="tripStatus" datasource="#application.dsn#">
            select distinct tour_status
            from smg_tours
            </cfquery>
            
          
			  <cfselect name="tourStatus"  query="tripStatus" value="tour_status" display="tour_status" selected="#form.tourStatus#" queryPosition="below">
            		<option value="">All</option>
              </cfselect>
			       
        </td>

       <td>
            Paid in Full<br />
			<select name="paid">
				<option value="0" <cfif #paid# is 0> selected </cfif>>No</option>
                <option value="1" <cfif #paid# is 1>selected</cfif>>Yes</option>
			
			</select>            
        </td>
<!----
        <td>
            Order By<br />
            <select name="orderby">
                <option value="studentid" <cfif orderby EQ 'studentid'>selected</cfif>>ID</option>
                <option value="familylastname" <cfif orderby EQ 'familylastname'>selected</cfif>>Last Name</option>
                <option value="firstname" <cfif orderby EQ 'firstname'>selected</cfif>>First Name</option>
                <option value="sex" <cfif orderby EQ 'sex'>selected</cfif>>Sex</option>
                <option value="country" <cfif orderby EQ 'country'>selected</cfif>>Country</option>
                <option value="regionname" <cfif orderby EQ 'regionname'>selected</cfif>>Region</option>
                <option value="s.programID" <cfif orderby EQ 's.programID'>selected</cfif>>Program</option>
                <option value="hostid" <cfif orderby EQ 'hostid'>selected</cfif>>Family</option>
                <cfif client.companyid EQ 5>
	                <option value="companyshort" <cfif orderby EQ 'companyshort'>selected</cfif>>Company</option>
                </cfif>
            </select>            
        </td>
		---->
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
</Cfform>
<Br />
</td>
</tr>
</table>

<table width=100% cellpadding=4 cellspacing=0 class="Section">
	<tr>
    	<Td>ID</Td><td>First Name</td><Td>Last Name</Td><Td>Tour</Td><Td>Registered</Td><td>Verified</td><td>Paid</td><td>Permission</td>
    	<td>Flights</td><td>Profile</td><td>Release Forms</td><td>Company</td><td></td>
    </tr>


    <cfif tours.recordcount eq 0>
        <tr>
            <Td colspan=5 align="Center">Please use the filters above to view students.</Td>
        </tr>
    <cfelse>
        <cfloop query="tours">
        <tr  <cfif tours.currentrow mod 2>bgcolor= '##CCCCCC' </cfif> onMouseOver="this.bgColor='##cfe5f9';" onMouseOut="this.bgColor='<cfif tours.currentrow mod 2>##CCCCCC<cfelse>##F7F7F7</cfif>';">
        	
   			<td><a href='http://ise.exitsapplication.com/nsmg/tours/details.cfm?id=#id#&student=#studentid#' title='Payment Details' rel='gb_page_center[675,600]'>#studentid#</a></td>
        	<td><a href='tours/details.cfm?id=#id#&student=#studentid#' title="Payment Details" rel="gb_page_center[675,600]">#firstname#</a></td>
            <td><a href="tours/details.cfm?id=#id#&student=#studentid#" title="Payment Details" rel="gb_page_center[675,600]">#familylastname#</a></td>
            <Td><a href="tours/details.cfm?id=#id#&student=#studentid#" title="Payment Details" rel="gb_page_center[675,600]">#tour_name#</a></Td>
            <Td>#DateFormat(date,'mm/dd/yyyy')#</Td>
            <td align="center"><cfif verified is ''>----</a><cfelse>#DateFormat(verified,'mm/dd/yyyy')#</cfif></td>
            <td align="center"><cfif paid is ''>-----</a><cfelse>#DateFormat(paid,'mm/dd/yyyy')#</cfif></td>
            <td align="Center"><Cfif permissionForm is ''><a href="?curdoc=tours/mpdtours&permission=#id#&studentid=#tours.studentid#"><img src="pics/confirm_03.png" /><cfelse>#DateFormat(permissionForm, 'mm/dd/yyyy')#</Cfif></td>
          <td align="Center"><a href='tours/flights.cfm?id=#id#' title="Flight Details" rel="gb_page_center[675,600]"><cfif flightinfo is ''><img src="pics/submitBlue.png" /><cfelse><img src="pics/view.png" /></cfif></a></td>
            <td><a href="tours/tripsProfile.cfm?uniqueid=#uniqueid#&id=#id#"><img src="pics/view.png" /></a></td>
            <td><a href="" onClick="javascript: win=window.open('student_app/section4/page22print.cfm?unqid=#uniqueid#', 'Settings', 'height=450, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">
          <img src="pics/view.png" /></a></td>
          <td><cfif companyid eq 1>ISE<cfelseif companyid eq 10>CASE</cfif></td>
          <td><form method="post" action="index.cfm?curdoc=tours/mpdtours"><input type="hidden" name="delete" value="#id#" /><input type="image" src="pics/deletex.gif" /></form></td>
        </tr>  
        <cfquery name="check_siblings" datasource="#application.dsn#">
        select sts.siblingid, smg_host_children.name, smg_host_children.lastname, smg_host_children.sex
        from student_tours_siblings sts
        left join smg_host_children on smg_host_children.childid = sts.siblingid
        where fk_studentID = #studentid# and mastertripid = #id#
        </cfquery>
        <cfif check_siblings.recordcount gt 0>
        	<cfloop query="check_siblings">
        <tr bgcolor="##ffe2ba">	
        	<td></td><td>#name#</td><td>#lastname#</td><td colspan=10>#sex#</td>
        </tr>
 			</cfloop>
         </cfif>       
    </cfloop>
</cfif>

 </table>

 <cfinclude template="../table_footer.cfm">
 </cfoutput>
<br />
</body>
</html>