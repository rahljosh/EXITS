<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Tour FAQs</title>
<link href="../css/maincss.css" rel="stylesheet" type="text/css" />

<style type="text/css">
<!--
a:link {
	color: #003;
	text-decoration: none;
}
a:visited {
	color: #003;
	text-decoration: none;
}
a:hover {
	color: #003;
	text-decoration: none;
}
a:active {
	color: #003;
	text-decoration: none;
}
a {
	font-weight: bold;
}
.lightGreen {
	color: #000;
	
	background-repeat: repeat;
	text-align: center;
	background-color: #a5aac7;
}
-->
</style></head>
 <script type="text/javascript">
//<![CDATA[
	function ShowHide(){
	$("#slidingDiv").animate({"height": "toggle"}, { duration: 1000 });
	}
//]]>
</script>
<Cfset verified = 0>
<cfsilent>
	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    <cfparam name="form.otherTravelers" default="">
</cfsilent>
<!---_Check if student has already registred for this trip---->
<Cfquery name="checkTrip" datasource="mysql">
select studentid, tripid
from student_tours
where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.verifiedStudent#"> 
and tripid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.selectedTrip#"> 
</cfquery>
<Cfquery name="HostInfo" datasource="mysql">
select h.familylastname, h.email, h.address, h.address2, h.city, h.state, h.zip, h.email, h.phone
from smg_hosts h
where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.verifiedHost#"> 
</cfquery>
<Cfquery name="studentInfo" datasource="mysql">
select s.firstname, s.familylastname, s.studentid, s.email, s.uniqueid, s.randid, s.regionassigned, sch.schoolname, sch.address, sch.address2, sch.city, sch.state, sch.zip, sch.principal, sch.phone, sch.phone_ext,
u.firstname as repfirst, u.lastname as replast, u.email as repemail, u.phone as repphone
from smg_students s
left join smg_schools sch on sch.schoolid = s.schoolid
left join smg_users u on u.userid = s.arearepid
where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.verifiedStudent#"> 
</cfquery>
<cfquery name="RegionalMan" datasource="mysql">
select u.email
from user_access_Rights uar
left join smg_users u on u.userid = uar.userid
where regionid = #studentInfo.regionassigned#
and uar.usertype = 5 
</cfquery>
<Cfquery name="tripDetails" datasource="mysql">
select *
from smg_tours
where tour_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.selectedTrip#"> 
</cfquery>

<script language="javascript"> 
function toggle(showHideDiv, switchImgTag) {
        var ele = document.getElementById(showHideDiv);
        var imageEle = document.getElementById(switchImgTag);
        if(ele.style.display == "block") {
                ele.style.display = "none";
		imageEle.innerHTML = '<img src="../images/buttons/noInfo.png">';
        }
        else {
                ele.style.display = "block";
                imageEle.innerHTML = '<img src="../images/buttons/noInfo.png">';
        }
}
</script>
</head>
<Cfif isDefined('form.correct')>


<!-------------------->
<Cfquery name="insertInfo" datasource="mysql">
insert into student_tours (studentid, tripid, date, nationality, med, person1, person2, person3,stuNationality, companyid)
					values(#client.verifiedstudent#, #client.selectedTrip#, #now()#, '#client.nationality#', '#client.medical#','#client.person1#', '#client.person2#', '#client.person3#','#client.stuNationality#', 10)
</cfquery>
<cfquery name="getMasterTripID" datasource="mysql">
select id 
from student_tours
where tripid = #client.selectedTrip# and studentid = #client.verifiedstudent#
</Cfquery>

 <Cfloop list="#client.otherTravelers#" index="i">
	 <cfif #i# gt 0>
    <Cfquery name="insertSibs" datasource="mysql">
    insert into student_tours_siblings (mastertripid, fk_studentid, siblingid, tripid)
                        values(#getMasterTripID.id#, #client.verifiedstudent#, #i#, #client.selectedTrip#)
    </cfquery>
    </cfif>
</Cfloop>

    <cfdocument format="PDF" filename="C:/websites/student-management/nsmg/uploadedfiles/temp/permissionForm_#client.verifiedStudent#.pdf" overwrite="yes">
			<style type="text/css">
            <!--
        	<cfinclude template="smg.css">            
            -->
            </style>
			<!--- form.pr_id and form.report_mode are required for the progress report in print mode.
			form.pdf is used to not display the logo which isn't working on the PDF. --->
            <cfset form.report_mode = 'print'>
            <cfset form.pdf = 1>
            <cfinclude template="tripPermission.cfm">
        </cfdocument>
    <!----Email to Student---->    
    <cfsavecontent variable="stuEmailMessage">
        <cfoutput>				
        <h3>A spot has been reserved for you 
         <Cfif client.otherTravelers is ''>
                    <cfelse>
                    and 
                        <Cfloop list="#client.otherTravelers#" index="i">
                            <Cfquery name="kids" datasource="MySQL">
                            select name, childid
                            from smg_host_children
                            where childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">  
                            </cfquery>
                            #kids.name#<cfif kids.currentrow neq kids.recordcount>, </cfif>      
                        </Cfloop>
                    </Cfif>
         on the <Strong>#tripDetails.tour_name#</Strong> tour.</h3>
		<font color="red">* * Your spot will not be confirmed until payment and permission forms have been received by MPD Tours America.Please work on getting these completed as soon as possible * *</font> 
        </p>
		<p><strong>IMPORTANT:</strong>  On the MPD Payment form, enter <strong>#studentInfo.studentid#</strong> in the STUDENT ID field.
        <Cfif client.otherTravelers is not ''>If you are paying with multiple credit cards, please submit a seperate payment for each credit card.</Cfif>
        </p>
        
        <p>Attached is a Student Packet with hotel, airport arrival instructions, emergency numbers, etc.  Please keep this handy for your trip and leave a copy with your host family while you are on the trip.</p>
          <p>Please return the MPD Payment Form and Permission Form by:<br />
            <ul>
            <li>email: info@mpdtoursamerica.com
            <li>fax:   +1 718 439 8565  
            <li>mail:  9101 Shore Road, ##203 - Brooklyn, NY 11209 </p>
        <p>Please visit ISE's website for additional questions. http://www.iseusa.com/trips/questions.cfm</p>
        <p>If you have any questions that are not answerd please don't hesitate to contact us at info@mpdtoursamerica.com. </p>
        <p>See you soon!</p>
        <p>MPD Tour America, Inc.<br />
        9101 Shore Road ##203- Brooklyn, NY 11209<Br />
        Email: Info@Mpdtoursamerica.com<br />
        TOLL FREE: 1-800-983-7780<br />
        Fax: 1-(718)-439-8565</p>
	    </cfoutput>
        </cfsavecontent>
        
        <cfinvoke component="cfc.email" method="send_mail">
       
        	<cfinvokeargument name="email_to" value="#studentInfo.email#,#hostInfo.email#"> 
	
			
            <cfinvokeargument name="email_cc" value="trips@iseusa.com">     
            <cfinvokeargument name="email_from" value="""Trip Support"" <trips@iseusa.com>">
            <cfinvokeargument name="email_subject" value="Your Trip Details">
            <cfinvokeargument name="email_message" value="#stuEmailMessage#">
            <cfinvokeargument name="email_file" value="C:/websites/student-management/nsmg/uploadedfiles/tours/#tripDetails.packetfile#">
            <cfinvokeargument name="email_file2" value="C:/websites/student-management/nsmg/uploadedfiles/tours/MPD_PaymentForm.pdf">
            <cfinvokeargument name="email_file3" value="C:/websites/student-management/nsmg/uploadedfiles/temp/permissionForm_#client.verifiedStudent#.pdf">
      </cfinvoke>	
<!----Email to Rep---->
<cfsavecontent variable="repEmailMessage">
        <cfoutput>				
       #studentInfo.firstname# #studentInfo.familylastname# (#studentInfo.studentid#) has registered to go on the #tripDetails.tour_name# tour.<br /><br />
       
       Dates: #DateFormat(tripDetails.tour_start, 'mmm d, yyyy')# - #DateFormat(tripDetails.tour_end, 'mmm d, yyyy')#
       
       If you feel that #studentInfo.firstname# should NOT be going on this trip, please notify us by using this <a href="http://ise.exitsapplication.com/nsmg/index.cfm?curdoc=tours/hold&student=#studentInfo.studentid#&trip=#CLIENT.selectedTrip#">form</a> (you will need to be logged into follow the link)
	    </cfoutput>
        </cfsavecontent>
        
        <cfinvoke component="cfc.email" method="send_mail">

            <cfinvokeargument name="email_to" value="#RegionalMan.email#">   
        	<cfinvokeargument name="email_cc" value="trips@iseusa.com">       
            <cfinvokeargument name="email_from" value="""Trip Support"" <trips@iseusa.com>">
            <cfinvokeargument name="email_subject" value="Student Trip Registration">
            <cfinvokeargument name="email_message" value="#repEmailMessage#">
	 </cfinvoke>	
<!----Email to Brian & MPD---->
<cfsavecontent variable="repEmailMessage">
        <cfoutput>				
       FYI<br />
       
       #studentInfo.firstname# #studentInfo.familylastname# (#studentInfo.studentid#) has registered to go on the #tripDetails.tour_name# tour.<br /><br />
       
	    </cfoutput>
        </cfsavecontent>
        
        <cfinvoke component="cfc.email" method="send_mail">
         
        	<cfinvokeargument name="email_to" value="trips@iseusa.com,info@mpdtoursamerica.com">       
            <cfinvokeargument name="email_from" value="""Trip Support"" <trips@iseusa.com>">
            <cfinvokeargument name="email_subject" value="Student Trip Registration">
            <cfinvokeargument name="email_message" value="#repEmailMessage#">
	 </cfinvoke>	
     
     <cflocation url="finished.cfm" addtoken="no">
	
</Cfif>
<body>

<div id="wrapper">
<cfinclude template="../includes/header.cfm">
<div id="mainbody">
<cfinclude template="../includes/leftsidebar.cfm">
<div id="trip">
   <Cfif checkTrip.recordcount gt 0>
<h1>Already Registered</h1>
<p>A spot is already on hold for you for this trip.  If you would like to change any of your details please contact MPD:</p>
<p>MPD Tour America, Inc.<br />
        9101 Shore Road #203- Brooklyn, NY 11209<Br />
        Email: Info@Mpdtoursamerica.com<br />
        TOLL FREE: 1-800-983-7780<br />
        Fax: 1-(718)-439-8565</p>
<cfelse>
<cfoutput>
<h2>Please confirm that these details are correct:</h2>
<Table cellpadding=8 cellspacing=0 width=95% align="Center">
    <tr>
       	<th><h3>Traveler & Contact Info</h3></th>
    </tr>
	<Tr bgcolor="##F7F7F7">
    	<Td valign="top">
            <table cellpadding=4 cellspacing=4>
            	
                <Tr>
                    <td valign="top"><span class="greyText"><strong>Student</strong></span></td>
                    <td> #studentInfo.firstname# #studentInfo.familylastname#<Br />
                        #studentInfo.email#
                    </td>
                </Tr>
                <Tr>
                    <td valign="top"><span class="greyText"><strong>Trip </strong></span></td>
                    <td> #tripDetails.tour_name#<br />
                    #DateFormat(tripDetails.tour_start,'mmm d, yyyy')# -  #DateFormat(tripDetails.tour_end,'mmm d, yyyy')#<Br />
                    #LSCurrencyFormat(tripDetails.tour_price, 'local')#<br />
                    </td>
                </Tr>
                <Tr>
                    <td valign="top"><span class="greyText"><strong>Other Travelers</strong></span></td>
                    <td>
                    <Cfif client.otherTravelers is ''>
                    None
                    <cfelse>
                        <Cfloop list="#client.otherTravelers#" index="i">
                            <Cfquery name="kids" datasource="MySQL">
                            select name, childid
                            from smg_host_children
                            where childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">  
                            </cfquery>
                            #kids.name#<cfif kids.currentrow neq kids.recordcount>, </cfif>      
                        </Cfloop>
                    </Cfif>
                    </td>
                </Tr>
            </table>
		</Td>
        <td valign="top">
            <Table>
                <tr>
                    <td valign="top"><span class="greyText"><strong>Host Family</strong></span></td>
                    <td valign="top">
                    #HostInfo.familylastname#<br />
                    #HostInfo.address#<Br />
                    <cfif HostInfo.address2 is not ''>#HostInfo.address2#<br /></cfif>
                    #HostInfo.city# #HostInfo.state# #HostInfo.zip#<br />
                    #HostInfo.phone#
                    </td>
                </tr>
                <tr>
                    <td valign="top"><span class="greyText"><strong>School</strong></span></td>
                    <td valign="top">
                    #studentInfo.schoolname#<br />
                    #studentInfo.principal#<br />
                    #studentInfo.address#<Br />
                    <cfif studentInfo.address2 is not ''>#studentInfo.address2#<br /></cfif>
                    #studentInfo.city# #studentInfo.state# #studentInfo.zip#<br />
                    #studentInfo.phone#
                    </td>
               </Tr>
            </Table>
		</td>
       </Tr>
       <Tr>
       		<Th><h3>Preferences</h3></Th>
        </Tr>
		<Tr  bgcolor="##F7F7F7">
        	<td>
            	<table cellpadding=4 cellspacing=4>
            	
                <Tr>
                    <td valign="top"><span class="greyText"><strong>Roomate Nationality</strong></span></td>
                    <td> #client.nationality#</td>
                </Tr>
                <Tr>
                    <td valign="top"><span class="greyText"><strong>Your Nationality </strong></span></td>
                    <td> #client.stunationality#
                    </td>
                </Tr>
                <Tr>
                    <td valign="top"><span class="greyText"><strong>Roommate Requests</strong></span></td>
                    <td>
                    <Cfif client.person1 is '' AND client.person2 is '' AND client.person3 is ''>
                    None
                    <cfelse>
                      <Cfif client.person1 is not ''>#client.person1#<br /></Cfif> 
                      <Cfif client.person2 is not ''>#client.person2#<br /></Cfif> 
                      <Cfif client.person3 is not ''>#client.person3#<br /></Cfif> 
                    </Cfif>
                    </td>
                </Tr>
            </table>
		</Td>
        <td valign="top">
        
            	<table cellpadding=4 cellspacing=4>
            	
                <Tr>
                    <td valign="top"><span class="greyText"><strong>Medical / Allergy</strong></span></td>
                    <td> #client.medical#</td>
                </Tr>
                
            </table>
			</td>
        </Tr>

     	<tr>
        	<td align="center"><form method="post" action="step5.cfm">
            <input type="hidden" name="correct" />
            <input type="image" src="../images/buttons/yesInfo.png" border=0/></form></td><td>
            <div id="headerDivImg">
           <a id="imageDivLink" href="javascript:toggle('contentDivImg', 'imageDivLink');"><img src="../images/buttons/noInfo.png" border=0/></a>
           </div></td>
        </tr>
     </Table>
	<div id="contentDivImg" style="display: none;">
         <table align="center" cellpadding=8>
            <tr>
                <Td>Selected the wrong trip?</Td>
                <td> <a href="step3.cfm?verify=#StudentInfo.uniqueid#&email=#StudentInfo.email#" class="button">Change the Trip</a></Td>
            <tr>
            <Tr>
                <td>Need to add another traveler or remove one?</td>
                <td><a href="step3.cfm?verify=#StudentInfo.uniqueid#&email=#StudentInfo.email#" class="button">Switch Traveles</a></td>
            </Tr>
            <Tr>
                <td>Need to change anything under Preferences?</td>
                <Td><a href="step4.cfm?c" class="button">Change Preferences</a></td>
            </Tr>
            <Tr>
                <Td colspan=2>If you host family information or school information is wrong, please contact your advisor:<Br />
                <strong>
                 #studentInfo.repfirst#  #studentInfo.replast#<br />
                 #studentInfo.repphone#<br />
                 #studentInfo.repemail#
                 </strong><br /><br />
                 Once the information has been corrected, #studentInfo.repfirst# will let you know to register again for the trip.
                 </Td>
             
             </Tr>
       </table>
   </div>
   
</cfoutput>
</cfif>
 
      
    <!-- trips --></div>
    <!-- mainbody --> </div>
    <div class="clearfix"></div>
<cfinclude template="../includes/footer.cfm">
<!-- wrapper --></div>



</body>
</html>
