<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>HostCompany Profile</title>
<link href="../style.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style2 {
	font-size: 18px;
	font-weight: bold;
	color:#000000
}
-->
</style>

<script language="JavaScript"> 
//open program history
function OpenHistory(url) {
	newwindow=window.open(url, 'Application', 'height=400, width=600, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
</script>
<!----
 <script language="javascript1.2">
											  
								   function mypopup()
 {
   mywindow = window.open ("hostcompany/add_newjob.cfm?hostcompanyid=#url.hostcompanyid#",
  "mywindow","location=1,status=1,scrollbars=1,
  width=800,height=400");
  mywindow.moveTo(0,0);
 } 
								  </script>
------>

</head>
	<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="f4f4f4">
		<tr>
			<td bordercolor="FFFFFF">
<cfinclude template="qr_hostcompany.cfm"> 
<!--- <cfdump var="#client.auth#"> ---->
<cfquery name="get_extrahostcompany" datasource="MySql">
SELECT *, smg_states.state as s
FROM extra_hostcompany
INNER JOIN smg_states ON extra_hostcompany.state = smg_states.id
WHERE hostcompanyid = #url.hostcompanyid#
</cfquery>

<cfquery name="hostcompanies" datasource="MySql">
	SELECT extra_hostcompany.hostcompanyid, extra_hostcompany.name, extra_hostcompany.phone, extra_hostcompany.supervisor, extra_hostcompany.city, extra_hostcompany.state, extra_hostcompany.business_typeid, extra_typebusiness.business_type as typebusiness, smg_states.state as s

	FROM extra_hostcompany
    LEFT JOIN smg_states ON smg_states.id = extra_hostcompany.state
    LEFT JOIN extra_typebusiness ON extra_typebusiness.business_typeid = extra_hostcompany.business_typeid
 WHERE extra_hostcompany.hostcompanyid = #url.hostcompanyid#    
</cfquery>



<cfquery name="get_smguser" datasource="MySql">
SELECT firstname, middlename, lastname
FROM smg_users
INNER JOIN extra_hostcompany ON smg_users.userid = extra_hostcompany.enteredby
</cfquery>



<cfquery name="get_smgprograms" datasource="MySql">
SELECT smg_programs.programid, smg_programs.programname, smg_programs.startdate
FROM smg_programs
INNER JOIN extra_candidates ON smg_programs.programid = extra_candidates.programid
</cfquery>


<cfquery name="get_currenttrainee9" datasource="MySql">
SELECT extra_candidates.candidateid, extra_candidates.uniqueid, extra_candidates.firstname, extra_candidates.lastname, extra_candidates.active, smg_programs.programname, extra_candidates.enddate
FROM extra_candidates
LEFT JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
WHERE smg_programs.enddate > #now()#
AND extra_candidates.hostcompanyid = #url.hostcompanyid#
AND smg_programs.active = 1
AND extra_candidates.active = 1
ORDER BY smg_programs.programid
</cfquery>

<cfquery name="get_upcomingtrainee" datasource="MySql">
SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.active, smg_programs.programname, extra_candidates.startdate
FROM extra_candidates
INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
WHERE smg_programs.startdate > #now()#
AND smg_programs.companyid = #client.companyid#
AND smg_programs.active = 1
AND extra_candidates.active = 1
ORDER BY smg_programs.programid
</cfquery>
  
<cfquery name="get_extrajobs" datasource="MySql">
 SELECT extra_jobs.id, extra_jobs.title, extra_jobs.description, extra_jobs.wage, extra_jobs.wage_type
 FROM extra_jobs
 INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_jobs.hostcompanyid 
 WHERE extra_hostcompany.hostcompanyid = #url.hostcompanyid#
</cfquery> 


<cfquery name="hostcompanies" datasource="MySql">
	SELECT extra_hostcompany.hostcompanyid, extra_hostcompany.name, extra_hostcompany.phone, extra_hostcompany.supervisor, extra_hostcompany.city, extra_hostcompany.state, extra_hostcompany.business_typeid, extra_typebusiness.business_type as typebusiness, smg_states.state as s

	FROM extra_hostcompany
    LEFT JOIN smg_states ON smg_states.id = extra_hostcompany.state
    LEFT JOIN extra_typebusiness ON extra_typebusiness.business_typeid = extra_hostcompany.business_typeid
 WHERE extra_hostcompany.hostcompanyid = #url.hostcompanyid#    
</cfquery>
 
<body>
<link href="../phpusa.css" rel="stylesheet" type="text/css">
<div class="section">
<!----Header Table---->
<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
	<tr bgcolor="E4E4E4">
		<td class="title1">&nbsp; &nbsp; Host Company Information </td>
	</tr>
</table>

<br>


<table cellpadding=5 cellspacing=5 border=1 align="center" width="770" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
                                
<table width="770" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">	
	<tr>
		<td valign="top" width="770" class="box">
		
			<table width="98%" align="Center" cellpadding="2">				
	   		<tr>
					<td width="135">
					
					<table width="100%" border="0" align="center" cellpadding=8 cellspacing=8 bordercolor="#C7CFDC" >
										<tr><td width="135">
					
								<cfoutput>
								
									<cfif FileExists("#AppPath.hostLogo##url.hostcompanyid#.#get_extrahostcompany.picture_type#")>
									<img src="../uploadedfiles/web-hostlogo/#url.hostcompanyid#.#get_extrahostcompany.picture_type#" width="135" /><br>
								<a class=nav_bar href="" onClick="javascript: win=window.open('hostcompany/upload_picture.cfm?hostcompanyid=#url.hostcompanyid#', 'Settings', 'height=305, width=636, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Change Picture</a>
										<cfelse>
							<a class=nav_bar href="" onClick="javascript: win=window.open('hostcompany/upload_picture.cfm?hostcompanyid=#url.hostcompanyid#', 'Settings', 'height=305, width=636, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="../pics/no_logo.jpg" width="135" border=0></a>
						</cfif></cfoutput>
										</td>
										</tr> 
						</table>
						
					</td>
					<td valign="top">
					
				
						<table width="100%" cellpadding="2">
							<tr>
							  <td width="561" align="center"><font size="5" face="Verdana, Arial, Helvetica, sans-serif">    
						        <cfoutput><span class="style2">#get_extrahostcompany.name#<br /> 
						    #get_extrahostcompany.phone# </span></cfoutput></font><br />
						    <br />
						    <font size=2 face="Verdana, Arial, Helvetica, sans-serif"><span class="edit_link"><br />
						 <!----   [  <a href='company_profile.cfm?companyid=#client.companyid#'>profile</a><a href='company_profile_pdf.cfm?companyid=#client.companyid#'><img src="../pics/pdficon_small.gif" border=0 /></a>]</span></font>---->						    <table width="76%" cellpadding=2 cellspacing=2 border=0 bordercolor="C7CFDC" >
                              <tr>
                                <td width="100"><p><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Business:<br />
                                  Contact:<br />
                                  Date of Entry: <br />
                                  Entered by: </font></p></td>
                                <td width="325" valign="top"><cfoutput>
                                    <p><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
									#hostcompanies.typebusiness# 
									<br />
                                  #get_extrahostcompany.supervisor#<br />
                                      #DateFormat(get_extrahostcompany.entrydate, "mm/dd/yyyy")# <br />
                                  #get_smguser.firstname# #get_smguser.lastname# </font></p>
                                </cfoutput></td>
                              </tr>
                            </table></td>
							</tr>
						</table>
					</td>
				</tr>
		  </table>
			
		</td>		
	</tr>
</table>

</td>
							</tr>
						</table>
                        
<br>



<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
							
                          <tr>
                            <td width="386" align="left" valign="top">
					        <!--- address --->
                               <table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
                                
                              <table width="98%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                                <tr class="style1" bordercolor="#FFFFFF" bgcolor="#C2D1EF">
                                  <td height="16" bgcolor="#8FB6C9" colspan="2" class="style1" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF"><b>:: Address</b></font></td>
                                </tr>
                                <tr>
                                  <td height="32"><cfoutput> <font size="2" face="Verdana, Arial, Helvetica, sans-serif">#get_extrahostcompany.address#<br />
                                  #get_extrahostcompany.city#</font>
                                  <font size="2" face="Verdana, Arial, Helvetica, sans-serif">#get_extrahostcompany.s#</font>,
                                  <font size="2" face="Verdana, Arial, Helvetica, sans-serif">#get_extrahostcompany.zip#</font><br />
                                  </cfoutput></td>
                              </tr>
                            </table></td>
                            
                            </td>
							</tr>
						</table>
                        <!--- close address --->
                     
                            <td width="384" align="right" valign="top">
				         
                         <!--- Contact Info --->
                          <table cellpadding=5 cellspacing=5 border=1 align="center" width="98%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
							  <td bordercolor="FFFFFF">
                                
                       		    <table width="98%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                                <tr bgcolor="#C2D1EF">
                                  <td bgcolor="#8FB6C9" class="style1"><strong><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">:: Contact Info </font></strong></td>
                                  <td height="16" bgcolor="#8FB6C9" class="style1">&nbsp;</td>
                                </tr>
                                <tr >
                                  <td ><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Phone: </font><br />
                                   <font size="2" face="Verdana, Arial, Helvetica, sans-serif"> Fax: </font><br />
                                    <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Email:</font> 
                                  </td>
                                  <td ><cfoutput query="get_extrahostcompany"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#phone# </font><br />
                                    <font size="2" face="Verdana, Arial, Helvetica, sans-serif">#fax# </font><br />
                                    <font size="2" face="Verdana, Arial, Helvetica, sans-serif">#email# </font></cfoutput><br />
                                 </td>
                               </tr> 
							</table>
         
                          
                       
                          	   </td>
   						    </tr>

						</table><br />

                        </td>
                         <!--- close Contact Info ---->
                        <br />
             
                          <tr>
                            <td align="left" valign="top">
                            
                            <!---- Housing --->
                              <table cellpadding=5 cellspacing=5 border=1 align="center" width="98%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
                             
                              <table width="98%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                              <tr class="style1" bordercolor="#FFFFFF" bgcolor="#C2D1EF">
                                <td height="16" bgcolor="#8FB6C9" class="style1" colspan=4><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF"><b>:: Housing </b></font></td>
                              </tr>
                              <tr>
                                 
									<cfquery name="housing" datasource="mysql">
									  select type, id
									  from extra_housing							
									 </cfquery>
								  <cfoutput>
							
								 
                            
                            	<cfloop query="housing">
								<td height="32"> 
								  <input type="checkbox" name="housing" value="#id#" disabled="disabled"
									     <cfif ListFind(get_extrahostcompany.housing_options, id , ",")>checked<cfelse></cfif> />
                              
								 </td><td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#type#</font></td>
								  
								 	 <cfif (housing.currentrow MOD 2) is 0></tr><tr></cfif>
								</cfloop> 
								
							 
								</td>
                              </tr>
                            </table></td>
                            	</td>
							</tr>
						</table>
							</cfoutput>
                        <!--- close housing ---->
                            <br />
                            <td align="right" valign="top">
                            <!---- jobs ---->
                            
                            	<table cellpadding=5 cellspacing=5 border=1 align="center" width="98%" bordercolor="C7CFDC" bgcolor="ffffff">
						  <tr>
								<td bordercolor="FFFFFF">
                            
                            
							<table width="98%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                              <tr bgcolor="#C2D1EF">
                                <td height="16" bgcolor="#8FB6C9" class="style1"><strong><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">:: Jobs </font></strong></td>
                              </tr>
                              <tr>
                                <td height="48">
								<table width="100%" border="0" >
                                  <tr>
                                    <td> <font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>Job Title</u> </font></td>
                                    <td> <font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>Wage</u></font></td>
                                  </tr>
								  <cfoutput query="get_extrajobs">
                                  <tr>
                                    <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><a href="" class="style4" onClick="javascript: win=window.open('hostcompany/edit_newjob.cfm?jobid=#id#', 'Edit Job', 'height=400, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#title#</a></font><br /></td>
                                    <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#wage# / #wage_type#</font><br /></td>
                                  </tr>
								  </cfoutput>
								  <cfoutput>

                                 

                                  <tr>
                                    <td colspan="2"><div align="center"><cfif client.usertype LTE 4 >
									<a href="javascript:OpenHistory('hostcompany/add_newjob.cfm?hostcompanyid=#url.hostcompanyid#');" > <img src="../pics/add-job.gif" width="64" height="20" border="0" /></a></cfif></div></td>
                                  </tr>
								  </cfoutput>
                                </table></td>
                              </tr>
                            </table>
                            
                            </td>
							</tr>
						</table>
                        <!--- close jobs --->
                            <br />
                            <br /></td>
    </tr>
                          <tr><br />
                            <td colspan="2" valign="top">
                            <!--- Current Trainee ---->
                            <table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
                            
                            
							<table width="100%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                              <tr bgcolor="#C2D1EF">
                                <td bgcolor="#8FB6C9" class="style1"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif"><strong>:: Current Trainee </strong></font></td>
                              </tr>
                              <tr>
                                <td height="64"><cfif (get_currenttrainee9.RecordCount) eq 0>
								<font size="2" face="Verdana, Arial, Helvetica, sans-serif">There are currently no trainees with this company. </font>
                                <cfelse>
								
                                    <table width="100%" border="0">
                                      <tr>
                                        <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>Program</u></font></td>
                                        <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>Trainee</u></font></td>
                                        <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>End Date</u></font></td>
                                      </tr>
                                      <tr>
                                      <cfoutput query="get_currenttrainee9"><td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#programname#</font></td>
                                        <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><a href="index.cfm?curdoc=candidate/candidate_info&uniqueid=#uniqueid#">#get_currenttrainee9.firstname# #get_currenttrainee9.lastname# </a></font></td>
                                        <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#dateformat (enddate, 'mm/dd/yyyy')#</font></td>                                      </tr></cfoutput>
                                    </table>
                                  <font size="2" face="Verdana, Arial, Helvetica, sans-serif"><br />
                                </font></cfif></td>
                              </tr>
                            </table>
                            
                            </td>
							</tr>
						</table>
                        <!--- close Current Trainee ---->
                        
							<br /></td>
                          </tr>
                          <tr>
                            <td colspan="2" valign="top">
                            
                            <!--- UpComing Trainee ----> 
                            
                            <table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
                            
							<table width="100%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                              <tr bgcolor="#C2D1EF">
                                <td height="16" bgcolor="#8FB6C9" class="style1"><strong><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">:: Upcoming Trainee </font></strong></td>
                              </tr>
                              <tr>
                                <td><CFIF (get_upcomingtrainee.RecordCount) eq 0 ><br />
							<font size="2" face="Verdana, Arial, Helvetica, sans-serif">There are no upcoming trainees for this company.</font> 
							<br /><br />

								<cfelse> 
								<cfoutput query="get_upcomingtrainee">
								  <table width="100%" border="0">
                                    <tr>
                                      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>Program</u></font></td>
                                      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>Trainee</u></font></td>
                                      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>Start Date</u></font></td>
                                    </tr>
                                    <tr>
                                      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#programname#</font></td>
                                      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname#</font></td>
                                      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#dateformat (startdate, 'mm/dd/yyyy')#</font></td>
                                    </tr>
                                  </table>
                                  
                                  </td>
							</tr>
						</table>
                                  
								</cfoutput>
                                </cfif></td>
                              </tr>
                            </table>
                           <!--- botao estava aqui---></td>
                          </tr>
  </table>
	 <cfoutput><div align="center"><a href="index.cfm?curdoc=hostcompany/edit_hostcompany_profile&amp;hostcompanyid=#url.hostcompanyid#">
<div align="center"><img src="../pics/edit.gif" width="54" height="23" border="0" /><br />
                              </div>
                            </cfoutput>
		
                        
	</tr>
</table>
        <br />
      </div>
</body>
</html>
