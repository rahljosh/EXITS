<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>HostCompany Profile</title>
<link href="../style.css" rel="stylesheet" type="text/css">

<script language="JavaScript"> 
function OpenHistory(url) {
	newwindow=window.open(url, 'Application', 'height=400, width=600, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
function OpenFax(url) {
	newwindow=window.open(url, 'Application', 'height=600, width=750, location=no, scrollbars=yes, menubar=yes, toolbars=yes, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
</script>

</head>
	<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="f4f4f4">
		<tr>
			<td bordercolor="FFFFFF">
<cfinclude template="qr_hostcompany.cfm"> 
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
	AND smg_programs.companyid = #client..companyid#
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

<cfquery name="housing" datasource="mysql">
	SELECT type, id
	FROM extra_housing							
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
										<tr>
											<td width="135">
					
												<cfoutput>
								
												<cfif '#FileExists("c:/websites/extra/internal/uploadedfiles/web-hostlogo/#url.hostcompanyid#.#get_extrahostcompany.picture_type#")#'>
												<img src="../uploadedfiles/web-hostlogo/#url.hostcompanyid#.#get_extrahostcompany.picture_type#" width="135" /><br>
												<a class=nav_bar href="" onClick="javascript: win=window.open('hostcompany/upload_picture.cfm?hostcompanyid=#url.hostcompanyid#', 'Settings', 'height=305, width=636, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Change Picture</a>
												
												<cfelse>
							
												<a class=nav_bar href="" onClick="javascript: win=window.open('hostcompany/upload_picture.cfm?hostcompanyid=#url.hostcompanyid#', 'Settings', 'height=305, width=636, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="../pics/no_logo.jpg" width="135" border=0></a>
												
												</cfif>
												</cfoutput>
											</td>
										</tr> 
									</table>
						
								</td>
								<td valign="top">
					
				
									<table width="100%" cellpadding="2">
										<tr>
											<td width="561" align="center">   <span class="title1"> 
												<cfoutput>#get_extrahostcompany.name#<br /> 
												#get_extrahostcompany.phone#</cfoutput></span><br />
												<br />
												<font size=2 face="Verdana, Arial, Helvetica, sans-serif"><span class="edit_link">
												<!----   [  <a href='company_profile.cfm?companyid=#client.companyid#'>profile</a><a href='company_profile_pdf.cfm?companyid=#client.companyid#'><img src="../pics/pdficon_small.gif" border=0 /></a>]</span>---->

												<table width="85%" cellpadding=2 cellspacing=2 border=0 bordercolor="C7CFDC" >
													<tr>
														<td width="107" class="style1"><div align="right"><b>Business:</b></div></td>
														<td width="352" class="style1" valign="top"><cfoutput>#hostcompanies.typebusiness#</cfoutput></td>
													</tr>
													<tr>
														<td width="107" class="style1"><div align="right"><b>Contact:</b></div></td>
														<td valign="top" class="style1"><cfoutput>#get_extrahostcompany.supervisor#</cfoutput></td>
													</tr>
													<tr>
														<td width="107" class="style1"><div align="right"><b>Date of Entry:</b></div></td>
														<td valign="top" class="style1"><cfoutput>#DateFormat(get_extrahostcompany.entrydate, "mm/dd/yyyy")#</cfoutput></td>
													</tr>
													<tr>
														<td width="107" class="style1"><div align="right"><b>Entered by:</b></div></td>
														<td valign="top" class="style1"><cfoutput>#get_smguser.firstname# #get_smguser.lastname#</cfoutput></td>
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

		</td>
	</tr>
</table>

<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
	  <td width="386" align="left" valign="top">
			<!--- address --->
            
			<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">

						<table width="98%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
							<tr class="style1" bordercolor="#FFFFFF" bgcolor="#C2D1EF">
								<td height="16" bgcolor="#8FB6C9" colspan="2" class="style2" >&nbsp; :: Address</td>
							</tr>
							<tr>
								<td height="32" class="style1"><cfoutput>#get_extrahostcompany.address#<br />
								#get_extrahostcompany.city#
								#get_extrahostcompany.s#,
								#get_extrahostcompany.zip#<br />
								</cfoutput>								</td>
							</tr>
						</table>					</td>
				</tr>
			</table>
			
            <br />
			
			<!---- Dunn & Bradstreet Number  ---->
            <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
              <tr>
                <td bordercolor="FFFFFF"><table width="98%" border="0" align="center" cellpadding="3" cellspacing="0" bordercolor="#C7CFDC" bgcolor="#ffffff">
                    <tr class="style1" bordercolor="#FFFFFF" bgcolor="#C2D1EF">
                      <td height="16" bgcolor="#8FB6C9" colspan="2" class="style2" >&nbsp; :: Dunn &amp; Bradstreet Number </td>
                    </tr>
                    <tr>
                      <td height="32" class="style1"><cfoutput>#get_extrahostcompany.db_number#<br />
                      </cfoutput> </td>
                    </tr>
                </table></td>
              </tr>
            </table>
			
            <br />
			
			<!---- Worker's Compensation Policy  ---->
            <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
              <tr>
                <td bordercolor="FFFFFF"><table width="98%" border="0" align="center" cellpadding="3" cellspacing="0" bordercolor="#C7CFDC" bgcolor="#ffffff">
                    <tr class="style1" bordercolor="#FFFFFF" bgcolor="#C2D1EF">
                      <td height="16" bgcolor="#8FB6C9" colspan="2" class="style2" >&nbsp; :: Worker's Compensation Policy</td>
                    </tr>
                    <tr>
                      <td height="32" class="style1"><cfoutput>
					   <input type="checkbox" name="comp_received" value="1" disabled="disabled"
						<cfif get_extrahostcompany.comp_received EQ 1>checked="checked"<cfelse></cfif> /> <span class="style1"> Received</span><br />
                      </cfoutput> </td>
                    </tr>
                </table></td>
              </tr>
            </table>
			
            <br />	
        	
		  <!---- Housing --->
          <table cellpadding=5 cellspacing=5 border=1 align="center" width="98%" bordercolor="C7CFDC" bgcolor="ffffff">
			  <tr>
				  <td bordercolor="FFFFFF">
                             
                   	  <table width="98%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                       	  <tr class="style1" bordercolor="#FFFFFF" bgcolor="#C2D1EF">
                           	  <td height="16" bgcolor="#8FB6C9" class="style2" colspan=4>&nbsp; :: Housing</td>
                          </tr>
                          <tr>
							  <cfoutput>
                            	<cfloop query="housing">
								<td height="32" class="style1"> 
								  <input type="checkbox" name="housing" value="#id#" disabled="disabled"
									     <cfif ListFind(get_extrahostcompany.housing_options, id , ",")>checked<cfelse></cfif> />								 </td>
								 <td class="style1">#type#</td>
								  
								 	<cfif (housing.currentrow MOD 2) is 0></tr><tr></cfif>
								   </cfloop> 	 	
							  </cfoutput>                           	
							  </tr>
                   	  </table>                    
					  
					</td>
			  </tr>
		  </table>
          <!--- close housing ---->
                            
		  <br />		</td>             
        <td width="384" align="right" valign="top">
				         
			<!--- Contact Info --->
			<table cellpadding=5 cellspacing=5 border=1 align="center" width="98%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
								
						<table width="98%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
							<tr bgcolor="#C2D1EF">
								<td height="16" colspan="2" bgcolor="#8FB6C9" class="style2">&nbsp; :: Contact Info</td>
							</tr>
								<cfoutput query="get_extrahostcompany">
							<tr >
								<td width="23%"  class="style1"><div align="right"><strong>Phone:</strong></div></td>
								<td width="77%"  class="style1">#phone# </td>
							</tr>
							<tr >
								<td  class="style1"><div align="right"><strong>Fax:</strong></div></td>
								<td  class="style1">#fax# - <a href="javascript:OpenFax('hostcompany/fax_cover.cfm?hostcompanyid=#url.hostcompanyid#');"><img src="../pics/fax-cover.gif" alt="Fax Cover Page" border="0" /></a></td>
							</tr>
							<tr >
								<td  class="style1"><div align="right"><strong>Email:</strong></div></td>
							  <td  class="style1">#email# </td>
							</tr>
							</cfoutput>
						</table>                  </td>
   				</tr>
			</table>
			
			<!--- close Contact Info ---->
			<br />


			<!---- jobs ---->
			<table cellpadding=5 cellspacing=5 border=1 align="center" width="98%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
                            
                            
						<table width="98%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                        	<tr bgcolor="#C2D1EF">
                            	<td height="16" bgcolor="#8FB6C9" class="style2">&nbsp; :: Jobs</td>
                            </tr>
                            <tr>
                                <td height="48">
								
								<table width="100%" border="0" >
                                	<tr>
                                    	<td class="style1"> <u>Job Title</u> </td>
                                    	<td class="style1"> <u>Wage</u></td>
                                  	</tr>
								  	<cfoutput query="get_extrajobs">
                                  	<tr>
                                    	<td class="style1"><b><a href="" class="style4Big" onClick="javascript: win=window.open('hostcompany/edit_newjob.cfm?jobid=#id#', 'Edit Job', 'height=400, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#title#</a></b><br /></td>
                                    	<td class="style1">#wage# / #wage_type#<br /></td>
                                 	</tr>
								  	</cfoutput>
								  	<cfoutput>
                                  	<tr>
                                    	<td colspan="2" class="style1"><div align="center"><cfif client..usertype LTE 4 >
										<a href="javascript:OpenHistory('hostcompany/add_newjob.cfm?hostcompanyid=#url.hostcompanyid#');" > <img src="../pics/add-job.gif" width="64" height="20" border="0" /></a></cfif></div></td>
                                  	</tr>
								  	</cfoutput>
                                </table>								</td>
                            </tr>
                      	</table>                    </td>
				</tr>
			</table>
			<!--- close jobs --->
            
        	<br />		</td>
	</tr>                
    
    <tr>
		<br />
    	<td colspan="2" valign="top">
                            
			<!--- Current Trainee ---->
            <table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
                            
                            
							<table width="100%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                            	<tr bgcolor="#C2D1EF">
                                	<td bgcolor="#8FB6C9" class="style2">:: Current Trainee</td>
                              	</tr>
                              	<tr>
                                	<td height="64" class="style1"><cfif (get_currenttrainee9.RecordCount) eq 0>
									There are currently no trainees with this company. 
                                	<cfelse>
								
                                    	<table width="100%" border="0">
                                      		<tr>
                                        		<td class="style1"><u>Program</u></td>
                                        		<td class="style1"><u>Trainee</u></td>
                                        		<td class="style1"><u>End Date</u></td>
											</tr>
											<cfoutput query="get_currenttrainee9">
                                      		<tr>
                                      			<td class="style1">#programname#</td>
                                        		<td class="style1"><b><a href="index.cfm?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4Big">#get_currenttrainee9.firstname# #get_currenttrainee9.lastname# </a></b></td>
                                        		<td class="style1">#dateformat (enddate, 'mm/dd/yyyy')#</td>                                    
											</tr>
											</cfoutput> 
                                    	</table>
										
                                  	<br />
                               		</cfif>									</td>
                             	</tr>
                            </table>                    </td>
				</tr>
			</table>
            <!--- close Current Trainee ---->
                        
			<br />		</td>
    </tr>
    <tr>
    	<td colspan="2" valign="top">
                            
        	<!--- UpComing Trainee ----> 
            <table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
                            
						<table width="100%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                        	<tr bgcolor="#C2D1EF">
								<td height="16" bgcolor="#8FB6C9" class="style2">:: Upcoming Trainee</td>
                            </tr>
                            <tr>
                                <td class="style1"><CFIF (get_upcomingtrainee.RecordCount) eq 0 ><br />
									There are no upcoming trainees for this company. 
									<br /><br />

									<cfelse> 
									<cfoutput query="get_upcomingtrainee">
								  
									<table width="100%" border="0">
										<tr>
											<td class="style1"><u>Program</u></td>
											<td class="style1"><u>Trainee</u></td>
											<td class="style1"><u>Start Date</u></td>
										</tr>
										<tr>
											<td class="style1">#programname#</td>
											<td class="style1">#firstname# #lastname#</td>
											<td class="style1">#dateformat (startdate, 'mm/dd/yyyy')#</td>
										</tr>
									</table>
                                  
                                </td>
							</tr>
						</table>
						</cfoutput>
                        </cfif>					</td>
                 </tr>
            </table>
            <!--- botao estava aqui--->		</td>
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
