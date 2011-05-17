<!--- ------------------------------------------------------------------------- ----
	
	File:		PlacementInfoSheet.cfm
	Author:		Josh Rahl
	Date:		April 4th, 2011
	Desc:		Web Version of Placement Info Sheet

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <!--- CHECK SESSIONS --->
    <cfinclude template="../check_sessions.cfm">
	
    <!--- Param URL Variables --->    
    <cfparam name="uniqueID" default="#url.studentid#">
    <cfparam name="profileType" default="">

    <!--- Param FORM Variables --->    
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.isIncludeLetters" default="0">
    <cfparam name="FORM.isIncludePicture" default="0">
    <cfparam name="FORM.emailTo" default="">

    <cfscript>	
		// Get Student by uniqueID
		qGetStudentInfo = APPCFC.STUDENT.getStudentByID(uniqueID=uniqueID);
		
		// Get Region
		qGetRegion = APPCFC.REGION.getRegions(regionID=qGetStudentInfo.regionassigned);

		// Get Region Guaranteed
		//GetRegionGuaranteed = APPCFC.REGION.getRegions(regionID=qGetStudentInfo.regionalguarantee);
		
		// Get International Representative
		qIntlRep = APPCFC.USER.getUserByID(userID=qGetStudentInfo.intrep);
		
		// Get Company
		qGetCompany = APPCFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
		
		// Get Program
		qGetProgram = APPCFC.PROGRAM.getPrograms(programID=qGetStudentInfo.programid);
		
		// Get Countries
		///getCountryBirth = APPCFC.LOOKUPTABLES.getCountry(countryID=qGetStudentInfo.countrybirth).countryName;
		//getCountryCitizen = APPCFC.LOOKUPTABLES.getCountry(countryID=qGetStudentInfo.countrycitizen).countryName;
		/////////////getCountryResident = APPCFC.LOOKUPTABLES.getCountry(countryID=qGetStudentInfo.countryresident).countryName;
		
		// Get State Guarantee
		//////////getStateGuranteed = APPCFC.LOOKUPTABLES.getState(stateID=qGetStudentInfo.state_guarantee).stateName;
		
		// Get Private School Range
		qPrivateSchool = APPCFC.LOOKUPTABLES.getPrivateSchool(privateSchoolID=qGetStudentInfo.privateschool);
		
		// Get Interests
		qGetInterests = APPCFC.LOOKUPTABLES.getInterest(interestID=qGetStudentInfo.interests);
		
		// set Interest List
		interestList = ValueList(qGetInterests.interest, ", &nbsp; ");
		
		/*** These are used for the email template ***/

		// Variables to store letters
		/////studentLetterContent = '';
		////////////parentLetterContent = '';
		
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);
		
		// FORM SUBMITTED
		if ( VAL(FORM.submitted) ) {

			// Data Validation
			if ( NOT IsValid("email", FORM.emailTo) ) {
				ArrayAppend(Errors.Messages, "Please enter a valid email address");
			}

		}
	</cfscript>


</cfsilent><head>
<script language="javascript">
function enableButtons()
{
window.opener.showIt('hideapp');
window.opener.showIt('hidedis');
window.close();
}
</script>
</head>

<title>Placement Info</title>
<!-----Student Info----->
<cfquery name="get_student_info" datasource="mysql">
	SELECT *
	FROM smg_students
	WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.studentid#">
</cfquery>
<!-----Area Rep----->
<cfquery name="get_area_rep" datasource="MySQL">
	Select userid, firstname, lastname, phone, address, address2, city, state, zip, email
	From smg_users
	Where userid = '#get_student_info.arearepid#'
</cfquery>
<!-----Host Family----->
<cfquery name="get_host_family" datasource="MySQL">
	Select *
	From smg_hosts
	Where hostid = '#get_student_info.hostid#'
</cfquery>
 <!--- Siblings --->
<cfquery name="get_host_children" datasource="MySQL">
Select *
From smg_host_children
Where hostid = '#get_student_info.hostid#'
Order by birthdate
</cfquery>
<!-----Get Host Family Pets----->
<cfquery name="get_host_pets" datasource="MySQL">
select hostid, animaltype, number, indoor
from smg_host_animals
Where hostid = '#get_student_info.hostid#'
</cfquery>
<!-----Get School----->
<cfquery name="get_school" datasource="MySQL">
	select *
	from smg_schools
	Where schoolid = '#get_student_info.schoolid#'
</cfquery>

<cfquery name="get_school_dates" datasource="MySql">
	SELECT schooldateid, schoolid, smg_school_dates.seasonid, enrollment, year_begins, semester_ends, semester_begins, year_ends,
			p.programid
	FROM smg_school_dates
	INNER JOIN smg_programs p ON p.seasonid = smg_school_dates.seasonid
	WHERE schoolid = <cfqueryparam value="#get_student_info.schoolid#" cfsqltype="cf_sql_integer">
	AND p.programid = <cfqueryparam value="#get_student_info.programid#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- get history to check if this is a relocation --->
<cfquery name="get_history" datasource="MySql">
	SELECT historyid, relocation
	FROM smg_hosthistory
	WHERE studentid = '#get_student_info.studentid#' and relocation  = 'yes'
	ORDER BY historyid DESC
</cfquery>

<!-----Facilitator----->
<cfif #get_student_info.regionassigned# is not 0>
	<cfquery name="get_facilitator" datasource="MySQL">
	select firstname, lastname, email
	from smg_users
	where userid = '#qGetRegion.regionfacilitator#' 
	</cfquery>
</cfif>
<cfif NOT LEN(uniqueID)>
	You have not specified a valid studentID.
	<cfabort>
</cfif>

<cfoutput>
<!----Approve Link---->
<cfsavecontent variable="approveLink">
<table width="800" border="0" cellpadding="2" cellspacing="2" class="section"  align="Center" bgcolor="##D6F9D5">
	<tr>
    	<Td>
<center><a href="javascript:enableButtons()">I have read and checked the Placement Letter Above and am ready to Approve or Deny. <br /> Clicking continue will close this window and enable the Approve/Deny button on the placement menu.<br><img src="../pics/continue.gif" border="0"></a></center><br>
		</td>
    </tr>
</table>

</cfsavecontent>


<!--- Save Email Option as Link --->
<cfsavecontent variable="emailLink">

			 <form name="PlacementInfoSheet.cfm" method="post">
            <input type="hidden" name="submitted" value="1" />
            <input type="hidden" name="uniqueID" value="#uniqueID#" />
            <input type="hidden" name="profileType" value="email" />
            
            <table width="800" border="0" cellpadding="2" cellspacing="2" class="section"  align="Center" bgcolor="##D6F9D5">
              <!--- Display Errors --->
                <cfif VAL(ArrayLen(Errors.Messages))>
                    <tr>
                        <td >
                            <font color="##FF0000">Please review the following items:</font> <br />
                
                            <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                                #Errors.Messages[i]#    	
                            </cfloop> <br />
                        </td>
                    </tr>
                </cfif>	
               <tr>	
                    <td align="Center" valign="center">
                       Send this profile to: &nbsp; <input type="text" name="emailTo" value="#qIntlRep.email#" size="30" maxlength="100" />			
                    </td>
                    <td calign="Center">
                        <input name="Submit" type="image" src="../pics/submit.gif" border=0 alt=" Send Email ">
                        &nbsp; &nbsp; &nbsp;
                        <input type="image" value="close window" src="../pics/close.gif" alt=" Close this Screen " onClick="javascript:window.close()">
                        &nbsp; &nbsp; &nbsp;
                        <a href="PlacementInfoSheet.cfm?studentid=#uniqueid#&print"><img src="../pics/print.png"  border=0 alt=" Print "></a>
                    </td>
                </tr>
                  <tr>
        <td align="right">Do you want to add a message?</td>
        <td>
            <label>
            <input type="radio" name="showAddInfo" value="1"
            checked="no" onClick="document.getElementById('showAddInfo').style.display='table-row';" 
             />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <input type="radio" name="showAddInfo" value="0"
           checked='yes' onClick="document.getElementById('showAddInfo').style.display='none';" 
           />
            No
            </label>
		 </td>
	</tr>

                <tr>	
                    <td valign="top" id="showAddInfo"  style="display: none;" colspan=4>
                      Additional Info: &nbsp; <textarea name="addInfo" cols="48" rows="5"></textarea>
                    </td>
                </tr>
                <tr>	
                   
                </tr>
</div>
            </table>
        
        </form>
       
</cfsavecontent>
<cfsavecontent variable="openPrint">
 <body onLoad="print();">
 <table width="800" border="0" cellpadding="2" cellspacing="2" class="section"  align="Center" bgcolor="##D6F9D5">
     
               
                    <tr>
                        <td width=50%>PRINTED: #DateFormat(now(), 'mmm. d, yyyy')# at #TimeFormat(now(), 'HH:mm')# by #client.name#</td>
                    	<td align="right"><a href="PlacementInfoSheet.cfm?studentid=#uniqueid#&showemail"><img src="../pics/email.gif" border=0 alt=" Email "></a>
                    </tr>
 </table>

</cfsavecontent>
<!----Save profile as variable---->
<cfsavecontent variable="PlacementInfo">
    <head>

    </head>
    <link rel="stylesheet" href="../linked/css/student_profile.css" type="text/css">

     <table class="profileTable" align="center">
     	<Tr>
        	<Td>
     
    <!--- Header --->
    <table align="center">
        <tr>
            
            <td class="bottom_center" width=800  valign="top">
            <img src="../pics/#client.companyid#_short_profile_header.jpg" />
           <!---     <h1>#qGetCompany.companyName#</h1>                
                <span class="title">Program:</span> #qGetProgram.programname#<br />
                <!---
                <span class="title">Region:</span> #qGetRegion.regionname# 
                <cfif qGetStudentInfo.regionguar EQ 'yes'><strong> - #qGetRegionGuaranteed.regionname# Guaranteed</strong> <br /></cfif>
                <cfif VAL(qGetStudentInfo.state_guarantee)><strong> - #getStateGuranteed# Guaranteed</strong> <br /></cfif>
                --->
                <cfif VAL(qGetStudentInfo.scholarship)>Participant of Scholarship Program</cfif>
				---->
                <span class="title"><font size=+1>Placement Information for</font></span><font size=+1>#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname#</font><font size=+1> (###qGetStudentInfo.studentID#)</font><br>
             <span class="title">Facilitator:</span>  #get_facilitator.firstname# #get_facilitator.lastname# 
            </td>
            <!----
            <td class="titleRight">
                <img src="pics/logos/#client.companyid#.gif" align="right" width="100px" height="100px"> <!--- Image is 144x144 --->
            </td>
			---->
        </tr>	
    </table>
   	<cfif get_student_info.doubleplace neq 0>
    <div class="alert" align="Center">
    <h3>Double Placement: Two exchange students will be living with this host family. </h3>
    </div>
	</cfif>
    <cfif get_student_info.welcome_family EQ 1>	
    <div class="alert" align="Center">
    <h3>This is a welcome family.  Permanent family information will be sent shortly.</h3>
    </div>

   	</cfif>
    <cfif get_history.recordcount NEQ '0'>
	<div class="alert" align="Center">
    <h3>This is a relocation. The student will be moving to this host family and/or school shortly.</h3>
    </div>
	</cfif>
    
    <!--- Student Information #qGetStudentInfo.countryresident# --->
    <table  align="center" border=0 cellpadding="4" cellspacing=0 width=800>
        <tr>           
        	<Td colspan=5 align="center" ><img src="../pics/HFBanner.png" /></Td>
        </Td>
        <tr>
            <td valign="top">
                
               <!---Host Family Information---->
               <table>
					<cfif #get_host_family.fatherfirstname# is ''><cfelse>
                    <tr><td width="100"><span class="title">Host Father:</td>
                    <td width="250">#get_host_family.fatherfirstname# #get_host_family.fatherlastname#, 
                        <cfif #get_host_family.fatherbirth# is '0'><cfelse>
                            <cfset calc_age_father = #CreateDate(get_host_family.fatherbirth,01,01)#> (#DateDiff('yyyy', calc_age_father, now())#)
                        </cfif> &nbsp;</td></tr>
                    <tr><td><span class="title">Occupation:</td>
                    <td>#get_host_family.fatherworktype#</td></tr></cfif>
                    <tr><td> </td></tr>
                    <cfif #get_host_family.motherfirstname# is ''><cfelse>
                    <tr><td> <span class="title">Host Mother:</td>
                    <td>#get_host_family.motherfirstname# #get_host_family.motherlastname#, 
                        <cfif #get_host_family.motherbirth# is '0'><cfelse>
                            <cfset calc_age_mom = #CreateDate(get_host_family.motherbirth,01,01)#> (#DateDiff('yyyy', calc_age_mom, now())#)
                        </cfif> &nbsp;</td></tr>
                    <tr><td><span class="title">Occupation:</td>
                    <td>#get_host_family.motherworktype#</td></tr></cfif>
                </table>
             </td>
             <td valign="top">
                <!----Address & Contact Info---->
                <Table>
                	<Tr>
                    	<tr><td width="100" valign="top"><span class="title">Address:</td>
                    	<td>#get_host_family.address#<br />
                    	<a href="http://en.wikipedia.org/wiki/#get_host_family.city#,_#get_host_family.state#" target="_blank" class="wiki">#get_host_family.city# #get_host_family.state# </a>, #get_host_family.zip#</td>
                    </tr>
                    <tr>
                    	<td width="100" valign="top"><span class="title">Phone: </span></td><td>#get_host_family.phone#</td>
                    </tr>
                    <tr>
                    	<td width="100" valign="top"><span class="title">Email: </span></td><td>#get_host_family.email#</td>
                    </tr>
				</table>
                        
            </td>
        </tr>                
    </table>
<!----Siblings and Pets---->
 <table  align="center" border=0 cellpadding="4" cellspacing=0 width=800>
        <tr>           
        	<Td><img src="../pics/sib.png" /></Td>
            <td><img src="../pics/pets.png" /></td>
            <td><img src="../pics/interest.png" /></td>
           
        <tr>
            <td valign="top" width=40%>
                
               <!---Siblings---->
               <table width=100% align="Center">
               		<tr>
					<td><span class="title">Name</span><br></td>
                    <td align="center"><span class="title">Age</span><br></td>
                    <td align="center"><span class="title">Sex</span><br></td>
                    <td align="center"><span class="title">At home</span><br></td>
                   <td align="center"><span class="title">Relation</span><br></td>
                    </tr>
                    <cfloop query="get_host_children">
                  
                    <tr>
                    <td>
                    
						<cfset str = "#name#">
                        <cfset maxwords = 1>
                         <cfoutput>
                         #REReplace(str,"^(#RepeatString('[^ ]* ',maxwords)#).*","\1")#
                        </cfoutput>   
                        <Cfif shared is 'yes'><img src="https://ise.exitsapplication.com/nsmg/pics/share.jpg" height="20" border=0/></Cfif>
                    </td>
                    <td align="center"><cfif get_host_children.birthdate is ''><cfelse>#DateDiff('yyyy', get_host_children.birthdate, now())#</cfif></td>
                    <td align="center">#get_host_children.sex#</td>
                    <td align="center">#get_host_children.liveathome#</td>
                    <td align="center">#get_host_children.membertype#</td>
                    </tr>
                    </cfloop>
                    
                </table>
             </td>
         
        
             <td valign="top">
                <!----Animals---->
                <Table align="Center">
                	<tr>
                        <td align="center"><span class="title">Type</span></td>
                        <td align="center"><span class="title">Number</span></td>
                        <td align="center"><span class="title">Indoor</span></td>
                    </tr>
                    <cfloop query="get_host_pets">
                    <tr>		
                    <td>#get_host_pets.animaltype#</td>
                    <td align="center">#get_host_pets.number#</td>
                    <td align="center">#get_host_pets.indoor#</td>
                    </tr>
                    </cfloop>
				</table>
                   
                        
            </td>
                <td valign="top">
                <!----Animals---->
                <Table align="Center">
                	<tr>
                   		<td>
							<cfset count = 0>
                            <cfloop list=#get_host_family.interests# index=i> <!--- take all the interests from a list --->
                                <cfset count = count + 1>
                                <cfif count lt 7> <!---it shows up to 6 interests --->
                                    <cfquery name="get_interests" datasource="MySQL">
                                        Select interest 
                                        from smg_interests 
                                        where interestid = #i#
                                    </cfquery>					
                                #LCASE(get_interests.interest)#<br>
                                </cfif>
                            </cfloop>
                            
                        </td>
                    </tr>
				</table>
                   
                        
            </td>
        </tr>                
    </table>

    <!--- Community Information --->
    <table align="center" class="profileTable2" width=100%>
        <tr bgcolor="##0854a0" align="center" ><img src="../pics/CIinfo.png" /></td></tr>     
        <tr>
           	<td>
            <cfif get_host_family.community is ''><cfelse>The community is #get_host_family.community#</cfif><cfif get_host_family.community is 'small'> town</cfif>.		<cfif get_host_family.nearbigcity is ''><cfelse>The nearest big city is <a href="http://en.wikipedia.org/wiki/#get_host_family.nearbigcity#" target="_blank" class="wiki">#get_host_family.nearbigcity# </a> is #get_host_family.near_city_dist# miles away.</cfif>
		<cfif get_host_family.major_air_code is ''><cfelse>The Closest arrival airport is <a href="http://www.airnav.com/airport/K#get_host_family.major_air_code#" target="_blank" class="airport">#get_host_family.major_air_code#</A>
		<cfif get_host_family.airport_city is ''><cfelse>, in the city of  <a href="http://en.wikipedia.org/wiki/#get_host_family.airport_city#" target="_blank" class="wiki">#get_host_family.airport_city# </a> </cfif>
			
		</cfif><br /><br />
		<cfif get_host_family.pert_info is ''><cfelse>Points of interest in the community: #get_host_family.pert_info#</cfif>
            </td>
        </tr>
    </table>
    
    <table align="center" class="profileTable2" width=100%>
        <tr bgcolor="##0854a0" align="center" ><img src="../pics/schoolinfo.png" /></td></tr>            
        <tr>
           <td valign="top">
             <!---School Dates---->
               <table>
               <cfif get_school_dates.enrollment is not ''>
					<Tr>
                    	<td> <span class="title">Orientation</td><td><cfif get_school_dates.enrollment is ''><span class="title"><em>Not Available</em></span><cfelse>#DateFormat(get_school_dates.enrollment, 'mmmm d, yyyy')#</cfif></td>
                    </Tr>
               </cfif>
                    <Tr>
                    	<td> <span class="title">1<sup>st</sup> Semester Begins:</td><td><cfif get_school_dates.year_begins is ''><span class="title"><em>Not Available</em></span><cfelse>#DateFormat(get_school_dates.year_begins, 'mmmm d, yyyy')#</cfif></td>
                    </Tr>
                     <Tr>
                    	<td> <span class="title">1<sup>st</sup> Semester Ends:</td><td><cfif get_school_dates.semester_ends is ''><span class="title"><em>Not Available</em></span><cfelse>#DateFormat(get_school_dates.semester_ends, 'mmmm d, yyyy')#</cfif></td>
                    </Tr>
                    <Tr>
                    	<td> <span class="title">2<sup>nd</sup> Semester Begins:</td><td><cfif get_school_dates.semester_begins is ''><span class="title"><em>Not Available</em></span><cfelse>#DateFormat(get_school_dates.semester_begins, 'mmmm d, yyyy')#</cfif></td>
                    </Tr>
                    <Tr>
                    	<td> <span class="title">Year Ends:</td><td><cfif get_school_dates.year_ends is ''><span class="title"><em>Not Available</em></span><cfelse>#DateFormat(get_school_dates.year_ends, 'mmmm d, yyyy')#</cfif></td>
                    </Tr>
                   
                    

                </table>
             </td>
             <td valign="top">
                <!---- School Address & Contact Info---->
                 <Table>
                <Tr>
                    
                    	<tr><td valign="top"><span class="title">Name:</td>
                    	<td><a href="#get_school.url#">#get_school.schoolname#</a></td>
                    </tr>
                	<Tr>
                    
                    	<tr><td width="100" valign="top"><span class="title">Address:</td>
                    	<td>#get_school.address#<cfif get_school.address is not''><br />#get_school.address2#</cfif>
                        
                    	<a href="http://en.wikipedia.org/wiki/#get_school.city#,_#get_school.state#" target="_blank" class="wiki">#get_school.city#, 
			#get_school.state# </a>, #get_school.zip#</td>
                    </tr>
                    <tr>
                    	<td width="100" valign="top"><span class="title">Phone: </span></td><td>#get_school.phone#</td>
                    </tr>
                    <tr>
                    	<td width="100" valign="top"><span class="title">Contact: </span></td><td><a href="#get_school.url#">#get_school.principal#</td>
                    </tr>
                   
                  
				</table>
                   
               
           </td>
        </tr>
        <cfif get_host_family.schoolcosts is not ''>
        <Tr>
        	<Td colspan=2>The student is responsible for the following expenses: #get_host_family.schoolcosts#</Td>
        </Tr>
        </cfif>
    </table>
    
    <table width=800>
    	<Tr>
        	<Td width=100% valign="top">
    
                <table align="center" width=100%>
                    <tr bgcolor="##0854a0"><td colspan=10 align="center" ><img src="../pics/ARbanner.png" /></td></tr>     
                    <tr>
                        <td valign="top"><span class="title">Name:</span></td><Td valign="top">#get_area_rep.firstname# #get_area_rep.lastname#</Td>
                
                        <td  valign="top"><span class="title">Address:</span></td>
                        <Td valign="top">#get_area_rep.address#<Br />
                        <Cfif #get_area_rep.address2# is not ''>#get_area_rep.address2#<br /></Cfif>
                        #get_area_rep.city# #get_area_rep.state#, #get_area_rep.zip#</Td>
               
                        <td valign="top" valign="top"><span class="title">Phone:</span></td><Td valign="top">#get_area_rep.phone#</Td>
                    </tr>
                </table>
  			</Td>
         </Tr>
         <tr>
    		<td  valign="top">
     			<table align="center" width=100%  >
        <tr bgcolor="##0854a0"><td colspan=10 align="center" ><img src="../pics/addinfo.png" /></td></tr>     
        <tr>
            <td>
				<cfif get_student_info.placement_notes NEQ ''>#get_student_info.placement_notes#<br><Br /></cfif>		
        
              
                <cfif get_history.recordcount EQ '0' OR get_history.relocation EQ 'no'>
              
                    The student should plan to arrive within five days from start of school. Please advise us of 
                    #get_student_info.firstname#'s arrival information as soon as possible. Please upload flight information through EXITS.
                </cfif><br>
		              
            </td>
        </tr>
    </table>
    		</td>
     	 </tr>
   	 </table>
    		</td>
     	 </tr>
   	 </table>
<div align="center">
<img src="https://ise.exitsapplication.com/nsmg/pics/share.jpg" height="20"> Sharing a Room &nbsp;&middot;&nbsp; 
<img src="https://ise.exitsapplication.com/nsmg/pics/Airport-icon.png" height="16"> Airport Information &nbsp;&middot;&nbsp;
<img src="https://ise.exitsapplication.com/nsmg/pics/Wikipedia-Globe-icon.png" height="16"> Wikipedia Information 
</div>
</cfsavecontent>


<!--- Display Profile / Email Form --->
<cfswitch expression="#profileType#">
	
    <!--- Web Profile --->
	<cfcase value="web">
		
		<!--- Include Profile Template --->
        #PlacementInfo#

    </cfcase>


    <!--- PDF Profile 
	<cfcase value="pdf">
       <cfdocument format="pdf">
            <!--- Include Profile Template --->
            #PlacementInfo#
        </cfdocument>
    </cfcase>
	--->
    
    <!--- Email Profile --->
	<cfcase value="email">
		
        <!--- Email FORM --->
        <link rel="stylesheet" type="text/css" href="../smg.css">
        
     
        
        
		<!--- FORM Submitted --->
        <cfif FORM.submitted AND NOT VAL(ArrayLen(Errors.Messages))>
        
            <!--- Student Profile --->
            <cfsavecontent variable="PlacementInfo">
                <!---  #emailLink#
				 Include Profile Template --->
                #PlacementInfo#
                    
            </cfsavecontent>
            <!--- End of Student Profile --->
            
            
        
            
            
            <cfsavecontent variable="emailMessage">
                
               
              	
                <p>We are pleased to give you the placement information and ID Card for  #qGetStudentInfo.firstName# #qGetStudentInfo.familylastName# (###qGetStudentInfo.studentid#).  Both files are attached. </p>
                <p>If, for any reason, you are unable to view the files, you can reprint them by logging into EXITS, navigate to the Students Profile and look under the section "Letters".   </p>
                
              
                 
                <Cfif form.addInfo is not''>
                <p>Additional Info: #form.addInfo#</p>
                </Cfif>
                <p>
                    Thank you, <br />
                    #qGetCompany.companyName#   
                </p>        
            </cfsavecontent>
            
            
            <!--- Create PDF File - Include Profile and Letters --->
            <cfdocument name="profile" format="pdf">
	              <!--- Student Profile --->
                #PlacementInfo#	
            </cfdocument>
            <!--- Save PDF File --->
            <cffile action="write" file="#AppPath.temp##qGetStudentInfo.studentID#-placementInfo.pdf" output="#profile#" nameconflict="overwrite">    
            
            <cfdocument filename="#AppPath.temp##client.studentid#-idCard.pdf" format="PDF" backgroundvisible="yes" overwrite="yes" fontembed="yes" localurl="no">
			<style type="text/css">
            <!--
        	<cfinclude template="../smg.css">            
            -->
            </style>
			<!--- form.pr_id and form.report_mode are required for the progress report in print mode.
			form.pdf is used to not display the logo which isn't working on the PDF. --->
            <cfset form.report_mode = 'print'>
            <cfset form.pdf = 1>
            <cfinclude template="../reports/labels_student_idcards.cfm">
       	 </cfdocument>
            
            
            <!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#FORM.emailTo#">
            <cfinvokeargument name="email_cc" value="#client.email#">
            <cfinvokeargument name="email_subject" value="Placement Information for #qGetStudentInfo.firstName# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)">
            <cfinvokeargument name="email_message" value="#emailMessage#">
             <cfinvokeargument name="email_from" value="""#qGetCompany.companyshort_nocolor# - #get_facilitator.firstname# #get_facilitator.lastname#"" <#get_facilitator.email#>">
        
  
        
                <!--- Attach Students Profile --->
               
                <!--- Attach Students Profile --->
                <cfinvokeargument name="email_file" value="#AppPath.temp##qGetStudentInfo.studentID#-placementInfo.pdf">
              
         		<cfinvokeargument name="email_file2" value="#AppPath.temp##qGetStudentInfo.studentID#-idCard.pdf">
			
               	
                
            </cfinvoke>
        
            <script language="JavaScript">
            // Close Window
            <!--
              window.close();
            //-->
            </script>
        
        </cfif>
    
	</cfcase>    
	
    
    <!--- Web Profile --->
    <cfdefaultcase>
		<!----Include Email Link at top---->
        <Cfif not isDefined('url.print')>
        <cfif client.usertype lte 4>
        #emailLink#
        </cfif>
        <cfelse>
        #openPrint#
      
        </Cfif>
		<!--- Include Profile Template --->
        #PlacementInfo#
    	<Cfif isDefined ('url.approve')>
         #approveLink#
    	</Cfif>
    </cfdefaultcase>

</cfswitch>

</cfoutput>
