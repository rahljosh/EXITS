<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Book a Student Trip</title>
<link href="STB.css" rel="stylesheet" type="text/css" />

<style type="text/css">
<!--
.wrapper {
	width: 700px;
	margin-right: auto;
	margin-left: auto;
}
.info2 {
	width: 600px;
	margin-right: auto;
	margin-left: auto;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 13px;
}
.infoBold {
	font-weight: bold;
	font-family: Arial, Helvetica, sans-serif;
}
.infoItalic {
	font-style: italic;
	font-family: Arial, Helvetica, sans-serif;
}
.clear {
	display: block;
	clear: both;
	height: 10px;
}
.boxTile2 {
	background-image: url(images/loginTile.png);
	background-repeat: repeat-y;
	width: 700px;
}
.topColor {
	
	height: 60px;
	width: 580px;
	float: left;
	margin-top: 25px;
}
#tripLogo {
	background-color: #FFF;
	height: 100px;
	width: 125px;
	position: absolute;
	z-index: 200;
}
.signatureLine{border-bottom:thin;}
.title {
	color:#999;
	padding:0px 3px 3px 0px;
}
-->
</style>
</head>

<body>

<!----Retrieve required Student Information---->
<cfquery name="student_info" datasource="mysql">
select s.familylastname, s.firstname, s.studentid, s.med_allergies, s.other_allergies, s.dob, s.email, s.cell_phone, s.sex, s.regionassigned,  s.countrybirth, s.countrycitizen, s.med_allergies, s.other_allergies, s.countryresident, h.airport_city, h.airport_state, h.local_air_code, h.major_air_code, 
h.hostid, h.familylastname hostlast, h.motherfirstname, h.fatherfirstname, h.motherlastname, h.fatherlastname, h.address, h.address2, h.city, h.state, h.zip, h.email as hostemail, h.phone as hostphone, h.mother_cell, h.father_cell, h.fatherworkphone, h.motherworkphone,
u.firstname as areaRep_first, u.lastname as areaRep_last, u.phone as areaRep_phone,
school.schoolname
from smg_students s 
left join smg_hosts h on h.hostid = s.hostid
left join smg_users u on u.userid = s.arearepid
left join smg_schools school on school.schoolid = s.schoolid
where s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#"> 
</cfquery>

<Cfquery name="regionalManager" datasource="mysql">
select firstname, lastname, phone
from smg_users
left join user_access_rights on user_access_rights.userid = smg_users.userid
where user_access_rights.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.regionassigned#"> 
and user_access_rights.usertype = 5
</Cfquery>
<Cfquery name="thisTripInfo" datasource="mysql">
select * 
from student_tours
where tripid  = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetTourDetails.tour_id#">  and studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#"> 
limit 1
</Cfquery>

<cfoutput>

<div class="wrapper">
      <div class="boxTop"></div>
      <div class="boxTile2">
</div>

<p></p>
<Table width=700 cellpadding=2 cellspacing=0 align="Center">
	<Tr>
    	<td align="Center"><img src="https://ise.exitsapplication.com/nsmg/pics/1_short_profile_header.jpg" />
         <span class="title"><font size=+1>Trip Permission Form</font></span></td>
    </Tr>

 </Table>
 
 <!--- Student Information #qGetStudentInfo.countryresident# --->
                <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=5 align="center"><img src="http://ise.exitsapplication.com/nsmg/pics/student.jpg" /></Td>
                    </td>
                    <tr>
                        <td valign="top" width="45%">
    
							<!---Host Family Information---->
                            <table>
								
	                                <tr>
                                    	<td width="100"><span class="title">Name:</span></td>
                                        <td width="250">
                                           #student_info.firstname# #student_info.familylastname#, 
                                           
                                        </td>
                                    </tr>
                                     <tr>
                                    	<td width="100"><span class="title">Sex:</span></td>
    	                            	<td width="250">
                                        	#UCase(student_info.sex)#
										
                                        </td>
									</tr>
                                    <tr>
                                    	<td><span class="title">Age:</span></td>
                                        
                                        <td>#DateDiff('yyyy', '#student_info.dob#','#now()#')#</td>
                                    </tr>
								    <tr>
                                    	<td><span class="title">Nationality:</span></td>
                                        
                                        <td>#thisTripInfo.stunationality#</td>
                                    </tr>
                                                              
                                
	                               
                                	
								
                            </table>
    				
                    	</td>
    
                        <td valign="top">
                        
							<!----Contact Info----> 
                            <Table>
                                <tr>
                                	<td width="100" valign="top"><span class="title">Cell Phone:</td>
	                                <td>
                                    	<cfif student_info.cell_phone is ''><em>None on File</em><cfelse> #student_info.cell_phone#</cfif>
									</td>
                                </tr>
                                
                                <tr>
                                	<td width="100" valign="top"><span class="title">Email: </span></td>
                                    <td>#student_info.email#</td>
                                </tr>
                               
                               <tr>
                                    	<td><span class="title">Airport (pref/alt):</span></td>
		                                <td>
                                        <cfif #student_info.local_air_code# is ''><em>None on File</em><cfelse>#student_info.local_air_code#</cfif> / #student_info.major_air_code#</td>
                                    </tr>
								
                            </table>
    				<tr>
                    	<td colspan=2><span class="title">Roommate Preference:</span>#thisTripInfo.nationality#  - <cfif thisTripInfo.person1 is not ''>#thisTripInfo.person1#,</cfif>
		 <cfif thisTripInfo.person2 is not ''>#thisTripInfo.person2#,</cfif>
         <cfif thisTripInfo.person3 is not ''>#thisTripInfo.person3#</cfif>
                        </td>
                    </tr>                
				</table>
 
 
  <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=5 align="center"><img src="https://ise.exitsapplication.com/nsmg/pics/HFbanner.png" /></Td>
                    </td>
                    <tr>
                        <td valign="top">
    							<!---Host Family Information---->
                            <table>
								
	                                <tr>
                                    	<td width="100"><span class="title">Host Father:</span></td>
                                        <td width="250">
                                           #student_info.fatherfirstname# #student_info.fatherlastname#
                                        </td>
                                    </tr>
                                    	<tr>
                                    	<td><span class="title">Cell Phone:</span></td>
		                                <td> <Cfif student_info.father_cell is ''>N/A<cfelse>#student_info.father_cell#</Cfif></td>
                                    </tr>
                                    <tr>
                                    	<td><span class="title">Work Phone:</span></td>
		                                <td><Cfif student_info.fatherworkphone is ''><em>Not on File</em><cfelse>#student_info.fatherworkphone#</Cfif></td>
                                    </tr>
								
                                
                                <tr><td>&nbsp;</td></tr>
                                
                                
	                                <tr>
                                    	<td width="100"><span class="title">Host Mother:</span></td>
    	                            	<td width="250">
                                        	#student_info.motherfirstname# #student_info.motherlastname#
											
                                        </td>
									</tr>
                                	<tr>
                                    	<td><span class="title">Cell Phone:</span></td>
		                                <td> <Cfif student_info.mother_cell is ''>N/A<cfelse>#student_info.mother_cell#</Cfif></td>
                                    </tr>
                                    <tr>
                                    	<td><span class="title">Work Phone:</span></td>
		                                <td><Cfif student_info.motherworkphone is ''><em>Not on File</em><cfelse>#student_info.motherworkphone#</Cfif></td>
                                    </tr>
								
                            </table>
    				
                    	</td>
    
                        <td valign="top">
                        
							<!----Address & Contact Info----> 
                            <Table>
                                <tr>
                                	<td width="100" valign="top"><span class="title">Address:</td>
	                                <td>
                                    	#student_info.address#<br />
										<cfif student_info.address2 is not ''>#student_info.address2#</br></cfif>
    		                           #student_info.city# #student_info.state# #student_info.zip#
									</td>
                                </tr>
                                <tr>
	                                <td width="100" valign="top"><span class="title">Phone: </span></td>
                                    <td>#student_info.hostphone#</td>
                                </tr>
                                <tr>
                                	<td width="100" valign="top"><span class="title">Email: </span></td>
                                    <td>#student_info.hostemail#</td>
                                </tr>
                               
                              
								
                            </table>
    
                        </td>
                    </tr>                
				</table>
 
  		 <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
         			<tr>
                    	<td width=50% valign="top">
                        
                        	<Table>
                                <tr>           
                                    <td colspan=5 align="center"><img src="https://ise.exitsapplication.com/nsmg/pics/medicalAllergysm.jpg" /></Td>
                                </tr>
                                <tr>           
                                    <td colspan=5 align="center"><img src="https://ise.exitsapplication.com/nsmg/pics/remembersm.jpg" /></Td>
                                </tr>
                                <tr>
                    			    <td valign="top">
 									<!---Medical Information---->
                         				   <table width=100%>
								
	                                <tr>
                                    	<td><span class="title">Medical Allergies:</span></td>
                                        <td >
                                           <cfif student_info.med_allergies is ''>no<cfelse>#student_info.med_allergies#</cfif>
                                        </td>
                                    </tr>
                                    	<tr>
                                    	<td><span class="title">Other:</span></td>
		                                <td> <cfif student_info.other_allergies is ''>no<cfelse>#student_info.other_allergies#</cfif></td>
                                    </tr>
                                    <tr>
                                    	<td><span class="title">Any Thing Else:</span></td>
		                                <td>#thisTripInfo.med#</td>
                                    </tr>
								</table>
                                </td>
                            </table>
              </td>
           		<Td valign="top">
           <table>
                    <tr>           
                        <td colspan=5 align="center"><img src="https://ise.exitsapplication.com/nsmg/pics/detailssm.jpg" /></Td>
                    </tr>

                    <tr>
                        <td valign="top">
 									<!---Tour Information---->
                                        <cfquery name="trip_info" datasource="mysql">
                                        select smgt.tour_start, smgt.tour_end, smgt.tour_name, smgt.tour_price
                                        from smg_tours smgt
                                        where smgt.tour_id = #thisTripInfo.tripid# 
                                        </cfquery>
                                     
                            <table>
								
	                                <tr>
                                    	<td><span class="title">Tour Name:</span></td>
                                        <td >
                                            #trip_info.tour_name#
                                        </td>
                                    </tr>
                                    	<tr>
                                    	<td><span class="title">Dates:</span></td>
		                                <td>#DateFormat(trip_info.tour_start, 'mmm. d, yyyy')# - #DateFormat(trip_info.tour_end, 'mmm. d, yyyy')#</td>
                                    </tr>
                                    <tr>
                                    	<td><span class="title">Price:</span></td>
		                                <td>$#trip_info.tour_price#</td>
                                    </tr>
								</table>
                          </td>
                        </tr>
                      </table>   
          </Td>
            </tr>
          </table>
    		
          <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=5 align="center"><img src="https://ise.exitsapplication.com/nsmg/pics/signatures.jpg" /></Td>
                    </tr>
                    <tr>
                    	<td colspan="5">I have read and understand all the Terms and Conditions either on website or attached form.  All parties acknowledge that while on tour, ISE and MPD Tour America, Inc. or its representatives may take any action deemed necessary to protect student safety and well being, including medical treatment at the student's expense and transportaion home at student's expense.</td>
                    </tr>
                    <tr>
                      <td valign="top">
 									<!---Signatures Boxes---->
                        <Table width=80% cellpadding=2 cellspacing=0>

 	 <tr>
    	<td width="244" class="signatureLine" valign="bottom"><br /><br />_______________________________</td><td width="3">&nbsp;</td><td width="497" class="signatureLine" valign="bottom">_______________________________</td>
    	<td width="3">&nbsp;</td><td width="497" class="signatureLine" valign="bottom">_______________________________</td>
    </tr>
    <tr>
    	<td valign="top">#student_info.firstname# #student_info.familylastname#</td><td></td><td valign="top"> #student_info.fatherfirstname# #student_info.fatherlastname# <Cfif student_info.fatherfirstname is not '' and student_info.motherfirstname is not ''> or </Cfif> #student_info.motherfirstname# #student_info.motherlastname#</td><Td></Td><td>#student_info.areaRep_first# #student_info.areaRep_last#<Br /><font size=-1><em>Area Representative - #student_Info.areaRep_phone#</em></font></td>
        </tr>
         
    	<td class="signatureLine" valign="bottom"><br /><Br />_______________________________</td><td>&nbsp;</td>
    	<td class="signatureLine" valign="bottom">_______________________________</td>
    </tr>
    <tr>
    	<td><Cfif student_info.schoolname is ''>School<cfelse> #student_info.schoolname#</Cfif> Representative<br /><font size=-2><em>Students may not miss school without school permission and must make up any missed work.</td><td></td><td valign="top"> Printed Name & Position</td>
        </tr>

</table>
   
              </td>
            </tr>
          </table>




<span class="infoItalic">

<!-- end info --></div>
<div class="clear"></div>
<!-- end boxTile --></div>
      <div class="boxBot"></div>
  <!-- end wrapper --></div>
 
</cfoutput>