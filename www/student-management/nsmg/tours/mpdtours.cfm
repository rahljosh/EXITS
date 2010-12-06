<head>
<!----Script for greybox---->
<script type="text/javascript" language="JavaScript">
    var GB_ROOT_DIR = "http://smg.local/nsmg/greybox/";
</script>
<script type="text/javascript" src="greybox/AJS.js"></script>
<script type="text/javascript" src="greybox/AJS_fx.js"></script>
<script type="text/javascript" src="greybox/gb_scripts.js"></script>
<link href="greybox/gb_styles.css" rel="stylesheet" type="text/css" />
 <style type="text/css">
        body { font-family:Arial, Helvetica, Sans-Serif; font-size:0.8em;}
        #report { border-collapse:collapse;}
        #report h4 { margin:0px; padding:0px;}
        #report img { float:right;}
        #report ul { margin:10px 0 10px 40px; padding:0px;}
        #report th { background:#7CB8E2 url(images/header_bkg.png) repeat-x scroll center left; color:#fff; padding:7px 15px; text-align:left;}
        #report td { background:#C7DDEE none repeat-x scroll center left; color:#000; padding:7px 15px; }
        #report tr.odd td { background:#fff url(tours/images/row_bkg.png) repeat-x scroll center left; cursor:pointer; }
        #report div.arrow { background:transparent url(tours/images/arrows.png) no-repeat scroll 0px -16px; width:16px; height:16px; display:block;}
        #report div.up { background-position:0px 0px;}
		li { display: inline-block; }
		li { _display: inline; }
		#table_row     
		{width: 100%;
		 margin-left:1px; 
		 margin-bottom:1px; 
		 margin-right:1px; 
		 margin-top:1px;  
		 margin-left:0px; 
		 margin-right:0px; 		
		 background-color:#ddeaf3;
		}
		#table_title {
			width: 100%; 
			margin-left:0px; 
			margin-bottom:0px; 
			margin-right:0px;
			margin-top:0px; 
			background-color:#1573bd;
			font-weight:bold;
			color:#FFF;}
		#table_row li {
			padding: 5px;
			margin-left:0px;
			margin-bottom:0px;
			margin-right:0px;
			margin-top:0px;
			list-style-type:none;
			line-height:25px;}
		#table_title li {
			padding: 5px;	
			margin-left:0px; 
			margin-bottom:0px; 
			margin-right:0px; 
			margin-top:0px; 
			list-style-type: none; 
			line-height:25px; 
			}
		.idnumber {width:50px;}
		.fname {width:150px; }
		.lname {width:150px; }
		.sex {width:60px; }
		.registered {width:90px;}
		.verified {width:90px;}
		.paid {width:90px; }
		.permission {width:80px; text-align:center;  vertical-align:bottom;}
		.flights {width:80px; text-align:center;vertical-align:bottom;}
		.profile {width:80px; text-align:center; vertical-align:bottom;}
		.forms {width:80px; text-align:center;vertical-align:bottom;}
		.company {width:80px;}
		.delete {width:80px;vertical-align:bottom;}
    </style>

<style type="text/css">
.table_row li{display:inline}
.table_title li{display:inline}
</style>

    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js" type="text/javascript"></script>
    <script type="text/javascript">  
        $(document).ready(function(){
            $("#report tr:odd").addClass("odd");
            $("#report tr:not(.odd)").hide();
            $("#report tr:first-child").show();
            
            $("#report tr.odd").click(function(){
                $(this).next("tr").toggle();
                $(this).find(".arrow").toggleClass("up");
            });
            //$("#report").jExpand();
        });
    </script>        
</head>
<script type="text/javascript">
  function DoNav(theUrl)
  {
  document.location.href = theUrl;
  }
</script>


<!----Set Default Search Parametes---->
<cfparam name="keyword" default="">


<cfparam name="paid" default="0">

<cfparam name="tripSelected" default ="0">
<Cfif isDefined('form.delete')>
	<cfquery datasource="#application.dsn#">
    delete from student_tours
    where id = #form.delete#
    limit 1
    </cfquery>
</Cfif>

<cfif isDefined('url.permission')>
    <cfquery datasource="#application.dsn#">
    update student_tours
    set permissionForm = #now()#
    where id = #url.permission#
    </cfquery>	
    
    <Cfquery name="tourInfo" datasource="#application.dsn#">
    select *, smg_tours.tour_name, smg_tours.tour_date, smg_tours.tour_start, smg_tours.tour_end, smg_tours.tour_price, smg_tours.tour_flightDetails
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
where tour_status <> 'Inactive'
order by tour_start
</Cfquery>

<cfquery name="tours" datasource="#application.dsn#">
select *, stu.familylastname, stu.firstname, stu.studentid, stu.UNIQUEID
from student_tours 
left join smg_students stu on stu.studentid = student_tours.studentid
left join smg_tours on smg_tours.tour_id = student_tours.tripid
where 1=1 

        order by tour_start
        
        
</cfquery>

<!----
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
---->
<cfoutput>
Below are all trips in the system. Click on a row to view students that have registerd for the tour.  To view the Flight Report, click on View under Flight Report.  You will then have the option to generate the Arrival or Departure Report.<br /><Br />
Students are ordered by Registration Date.  You can always search a list by simply pressing CTRL-F and typing in your searh term. (Name, ID, Search anything displayed the screen)<br /><br />

 <table id="report" width=100%>
        <tr>
            <th>Trip</th>
            <th>Date</th>
            <th>Status</th>
            <th>Total Reg</th>
            <th>M/F</th>
            <th>Flight Report</th>
            <th></th>
        </tr>
        <cfloop query="allTrips">
        <cfquery name="tours" datasource="#application.dsn#">
        select *, stu.familylastname, stu.firstname, stu.studentid, stu.UNIQUEID, stu.sex
        from student_tours 
        left join smg_students stu on stu.studentid = student_tours.studentid
        left join smg_tours on smg_tours.tour_id = student_tours.tripid
        where 1=1 
		
        and tripid = #tour_id#
        order by date desc 
        </cfquery>
        <!----m/f stats---->

        <Cfset male = 0>
        <cfset female =0>
        <cfif tours.recordcount gt 0>
            <cfquery name=mstats dbtype="query">
            select count(sex) as nom
            from tours
            where sex = 'male'
             and tripid = #tour_id#
            </cfquery>
				<cfif mstats.nom is ''>
                    	<Cfset male = 0>
                 <cfelse>
                 		<cfset male = #mstats.nom#>
                </cfif>
            <cfquery name=fstats dbtype="query">
            select count(sex) as nof
            from tours
            where sex = 'female'
            and tripid = #tour_id#
            </cfquery>
            	
            	<cfif fstats.nof is ''>
                    	<Cfset female = 0>
                 <cfelse>
                 		<cfset female = #fstats.nof#>
				</cfif>
        </cfif>
        <tr>
            <td>#tour_name#</td>
            <td>#DateFormat(tour_start, 'mmmm d')# - #DateFormat(tour_end, 'mmmm d, yyyy')#</td>
            <td>#tour_status#</td>
            <td><cfset totreg = #male# + #female#>#totreg#</td>
            <td>#male# / #female#</td>
            <td><a href="tours/arrival_report.cfm?tripid=#tour_id#">Arr.</a> :: Dep.</td>
            <td><div class="arrow"></div></td>
        </tr>
        <tr>
            <td colspan="7">
            <div id="table_title">
         
              <li class="idnumber">ID</li>
              <li class="fname">First Name</li>
              <li class="lname">Last Name</li>
              <li class="sex">Sex </li>
              <li class="Registered">Registered </li>
              <li class="Verified">Verified</li>
              <li class="Paid">Paid</li>
              <li class="Permission">Permission</li>
              <li class="Flights">Flights</li>
              <li class="Profile">Profile</li>
              <li class="Forms">Forms</li>
              <li class="Company">Company</li>
              <li class="delete">Delete</li>
             
         
              </div>
              
                
                
                    <cfif tours.recordcount eq 0>
                        <strong>No students are registered for this trip yet</strong>
                    <cfelse>
                    
                        <cfloop query="tours">
              
              <div id="table_row">   
              
              <li class="idnumber"><a href='http://ise.exitsapplication.com/nsmg/tours/details.cfm?id=#id#&student=#studentid#' title='Payment Details' rel='gb_page_center[675,600]'>#studentid#</a></li>
              <li class="fname"><a href='tours/details.cfm?id=#id#&student=#studentid#' title="Payment Details" rel="gb_page_center[675,600]">#firstname#</a></li>
              <li class="lname"><a href="tours/details.cfm?id=#id#&student=#studentid#" title="Payment Details" rel="gb_page_center[675,600]">#familylastname#</a></li>
              <li class="sex"> <a href="tours/details.cfm?id=#id#&student=#studentid#" title="Payment Details" rel="gb_page_center[675,600]">#sex#</a> </li>
              <li class="Registered">#DateFormat(date,'mm/dd/yyyy')# </li>
              <li class="Verified"><cfif verified is ''>----</a><cfelse>#DateFormat(verified,'mm/dd/yyyy')#</cfif></li>
              <li class="Paid"><cfif paid is ''>-----</a><cfelse>#DateFormat(paid,'mm/dd/yyyy')#</cfif></li>
              <li class="Permission" align="left"><Cfif permissionForm is ''><a href="?curdoc=tours/mpdtours&permission=#id#&studentid=#tours.studentid#"><img src="pics/confirm_03.png" border=0  /><cfelse>#DateFormat(permissionForm, 'mm/dd/yyyy')#</Cfif></li>
              <li class="Flights"><a href='tours/flights.cfm?id=#id#' title="Flight Details" rel="gb_page_center[675,600]"><cfif flightinfo is ''><img src="pics/submitBlue.png" border=0 />
              <cfelse><img src="pics/view.png" border=0/></cfif></a></li>
              <li class="Profile"><a href="tours/tripsProfile.cfm?uniqueid=#uniqueid#&id=#id#"><img src="pics/view.png" border=0  /></a></li>
              <li class="Forms"> <a href="" onClick="javascript: win=window.open('student_app/section4/page22print.cfm?unqid=#uniqueid#', 'Settings', 'height=450, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="pics/view.png" border=0  /></a></li>
              <li class="Company"><cfif companyid eq 1>ISE<cfelseif companyid eq 10>CASE</cfif></li>
              <li class="delete"> <input type="hidden" name="delete" value="#id#" /><input type="image" src="pics/deletex.gif" /></form></li>
              
              </div>
              

                        </cfloop>
                         
                    </cfif>
                
 			</td>
        </cfloop>

    </table>


<!----
 <cfinclude template="../table_footer.cfm">
 ---->
 </cfoutput>
<br />
</body>
</html>