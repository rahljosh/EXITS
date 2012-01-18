
<link rel="stylesheet" href="../linked/css/hostApp.css" type="text/css">
    <cfscript>
		// Host Family
		qGetHostFamily = APPLICATION.CFC.HOST.getHosts(hostID=url.hostID);
		
		// Host Family Children
		qGetHostChildren = APPLICATION.CFC.HOST.getHostMemberByID(hostID=url.hostID);
		

    </cfscript>
   <cfquery name="qPets" datasource="mysql">
    select *
    from smg_host_animals
    where hostid = <cfqueryparam cfsqltype="integer" value="#url.hostID#">
    </cfquery>
<cfquery name="region" datasource="#application.dsn#">
select r.regionname
from smg_regions r
where regionid = <cfqueryparam cfsqltype="integer" value="#qGetHostFamily.regionid#">
</cfquery>   
<cfquery name="rep" datasource="#application.dsn#">
select u.firstname, u.lastname
from smg_users u
where userid = <cfqueryparam cfsqltype="integer" value="#qGetHostFamily.arearepid#">
</cfquery>        
    <Cfquery name="current_photos" datasource="mysql">
        select filename, description, cat 
        from smg_host_picture_album
        where fk_hostid = <cfqueryparam cfsqltype="integer" value="#url.hostid#">
    </cfquery>
      <cfquery name="schoolInfo" datasource="#application.dsn#">
    select s.schoolname, s.principal, s.address, s.address2, s.city, s.state, s.zip, s.phone, s.phone_ext
    from smg_schools s
    where s.schoolid = <cfqueryparam cfsqltype="integer" value="#qGetHostFamily.schoolid#">
    </cfquery>

    <cfquery name="religionInfo" datasource="#application.dsn#">
    select c.churchname, c.address, c.address2, c.city, c.state, c.zip, c.phone, c.pastor
    from churches c
    where c.churchid = <cfqueryparam cfsqltype="integer" value="#qGetHostFamily.churchid#">
    </cfquery>

    <cfquery name="religion" datasource="#application.dsn#">
    select religionname
    from smg_religions 
    where religionid = <cfqueryparam cfsqltype="integer" value="#qGetHostFamily.religion#">
    </cfquery>
<cffunction name="CapFirst1" returntype="string" output="false">
    <cfargument name="str" type="string" required="true" />
    
    <cfset var newstr = "" />
    <cfset var word = "" />
    <cfset var separator = "" />
    
    <cfloop index="word" list="#arguments.str#" delimiters=" ">
        <cfset newstr = newstr & separator & UCase(left(word,1)) />
        <cfif len(word) gt 1>
            <cfset newstr = newstr & right(word,len(word)-1) />
        </cfif>
        <cfset separator = " " />
    </cfloop>

    <cfreturn newstr />
</cffunction>  

<body>
<cfoutput>
<!----Page 1---->
   <table class="profileTable" align="center" border=0>
        <tr>
            <td>
    
				<!--- Host Header --->
               <table width=800 align="Center">
                    <tr>
                        <td colspan=3><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/Pdf_Headers_02.jpg"></td>
                    </tr>
                    <tr>
                    	<td>
                         <span class="title">Region:</span> <cfif region.regionname is ''>No Region Assigned<cfelse>#region.regionname#</cfif><br />
                       	 <span class="title">Rep:</span> <cfif rep.firstname is ''>No Rep Assigned<cfelse>#rep.firstname# #rep.lastname# </cfif>
                    	
                        </td>
                        <Td valign="top" align="center">
                           <span class="title"><font size=+1> #qGetHostFamily.familyLastName# (#qGetHostFamily.hostid#)<br /> Host Family Application</font></span>
                        </Td>
                        <Td align="right">
                        <span class="title">Started:</span> #DateFormat(qGetHostFamily.applicationStarted, 'mmm, d, yyyy')#<br />
                        <span class="title">Approved:</span> <cfif qGetHostFamily.applicationapproved is ''>Not Approved<cfelse>#DateFormat(qGetHostFamily.applicationapproved, 'mmm, d, yyyy')#</cfif>
                        </Td>
                    </tr>
                </table>

				
    
				<!--- Student Information #qGetStudentInfo.countryresident# --->
                <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=5 align="center"><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/HPpdf_04.jpg"/></Td>
                    </tr>
                    <tr>
                        <td valign="top">
    
							<!---Host Family Information---->
                            <table>
								<cfif LEN(qGetHostFamily.fatherfirstname)>
	                                <tr>
                                    	<td width="100"><span class="title">Host Father:</span></td>
                                        <td width="250">
                                            #qGetHostFamily.fatherfirstname# #qGetHostFamily.fatherlastname#
                                            <cfif IsDate(qGetHostFamily.fatherDOB)>
                                                (#DateDiff('yyyy', qGetHostFamily.fatherDOB, now())#)
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr>
                                    	<td><span class="title">Occupation:</span></td>
                                        <td>#qGetHostFamily.fatherworktype# (<Cfif qGetHostFamily.fatherfullpart eq 1>Full Time<cfelse>Part Time</Cfif>)</td>
                                    </tr>
                                     <tr>
                                    	<td><span class="title">Cell:</span></td>
                                        <td><Cfif qGetHostFamily.father_cell is ''>None on File<cfelse>#qGetHostFamily.father_cell#</Cfif></td>
                                    </tr>
								</cfif>
                                
                                 
                                
                                <cfif LEN(qGetHostFamily.motherfirstname)>
	                                <tr>
                                    	<td width="100"><span class="title">Host Mother:</span></td>
    	                            	<td width="250">
                                        	#qGetHostFamily.motherfirstname# #qGetHostFamily.motherlastname#
											<cfif IsDate(qGetHostFamily.motherDOB)>
                                                (#DateDiff('yyyy', qGetHostFamily.motherDOB, now())#)
                                            </cfif>
                                        </td>
									</tr>
                                	<tr>
                                    	<td><span class="title">Occupation:</span></td>
		                                <td>#qGetHostFamily.motherworktype# (<Cfif qGetHostFamily.motherfullpart eq 1>Full Time<cfelse>Part Time</Cfif>)</td>
                                    </tr>
                                    <tr>
                                    	<td><span class="title">Cell:</span></td>
		                                <td><Cfif qGetHostFamily.mother_cell is ''>None on File<cfelse>
	                                    #qGetHostFamily.famDietRestDesc##qGetHostFamily.mother_cell#</Cfif> </td>
                                    </tr>
								</cfif>
                            </table>
    				
                    	</td>
    
                        <td valign="top">
                        
							<!----Address & Contact Info----> 
                            <Table>
                                <tr>
                                	<td width="100" valign="top"><span class="title">Home:</td>
	                                <td>
                                    	#qGetHostFamily.address#<br />
    		                            #qGetHostFamily.city# #qGetHostFamily.state#, #qGetHostFamily.zip#
									</td>
                                </tr>
                                  <tr>
                                	<td width="100" valign="top"><span class="title">Mailing:</span></td>
                                    <td>
                                   #qGetHostFamily.mailaddress#<br />
    		                            #qGetHostFamily.mailcity# #qGetHostFamily.mailstate#, #qGetHostFamily.mailzip#
                                    </td>
                                	
                                </tr>
                                <tr>
	                                <td width="100" valign="top"><span class="title">Home Phone: </span></td>
                                    <td>#qGetHostFamily.phone#</td>
                                </tr>
                                <tr>
                                	<td width="100" valign="top"><span class="title">Email: </span></td>
                                    <td>#qGetHostFamily.email#</td>
                                </tr>
                               
                              
								
                            </table>
    					<!-----Kids----->
                        </td>
                      </tr>
                    </table>
                        <br>
                        <!--- Kids Header --->
                    <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                        <tr>           
                            <td colspan=5 align="center"><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/HPpdf_06.jpg" /></Td>
                        </tr>
                        <tr>
                            <td valign="top">
                          <table  align="Center" width=800 cellpadding=4 cellspacing=0>
                                <tr>
                                    <td><span class="title">Name</td>
                                    <td align="center"><span class="title">Age</td>
                                    <td align="center"><span class="title">Sex</td>
                                    <td align="center"><span class="title">Lives @ Home</td>
                                    <td align="center"><span class="title">Shared Room</td>
                                    <td align="center"><span class="title">Relation</td>
                                    <td align="center"><span class="title">School</td>
                                </tr>
                          <cfif qGetHostChildren.recordcount eq 0>
                          		<Tr>
                                	<Td colspan=8 align="center">No family members are listed with this family. </Td>
                          </cfif>
                          <cfloop query="qGetHostChildren">
                                    <tr <cfif qGetHostChildren.currentrow MOD 2>bgcolor="##ddeaf3"</cfif> >
                                        <td>
                            				<cfset maxwords = 1>
                                            #REReplace(qGetHostChildren.name,"^(#RepeatString('[^ ]* ',maxwords)#).*","\1")#
											
                            			</td>
                                        <td align="center">
											<cfif IsDate(qGetHostChildren.birthdate)>
                                            	#DateDiff('yyyy', qGetHostChildren.birthdate, now())#
											<cfelse>
                                            	n/a
											</cfif>
                                        </td>
                                        <td align="center">#capFirst1(qGetHostChildren.sex)#</td>
                                        <td align="center">#capFirst1(qGetHostChildren.liveathome)#</td>
                                        <td align="center">#capFirst1(qGetHostChildren.shared)#</td>
                                        <td align="center">#capFirst1(qGetHostChildren.membertype)#</td>
                                        <td align="center">#qGetHostChildren.school#</td>
                                        <td align="center"></td>
                                    </tr>
                                </cfloop>
                            </table>
                            <br><br />
                       <!----Dietary and smoking---->
                       <table  align="left" border="0" cellpadding="4" cellspacing="0" width="100%">
                       	<Tr>
                      		 <td align="center"><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/dietary_38.jpg"></td>
                            	<td align="center"><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/HPpdf_10.jpg"></Td>
                       </Tr>
                        <tr>
                        	
                       		<td valign="top" rowspan=10>
                            	<table width=100% cellspacing=0 cellpadding=2 class="border">
                               		<Tr>
                               			<Td width=80%><span class="title">Our family follows dietary restrictions?</span></Td>
                                        <td align="Center"><Cfif qGetHostFamily.famDietRest eq 0>No<cfelse>Yes</Cfif></td>
                                    </Tr>
                                    <Tr>
                               			<Td colspan=2><span class="title">Restrictions: </span><br />
										<cfif qGetHostFamily.famDietRestDesc is ''>No Restrictions Noted<cfelse>#qGetHostFamily.famDietRestDesc#</cfif></td>
                              		<tr>
                              		<tr>
                                        <Td><span class="title">Student will follow dietary restrictions?</Td>
                                        <td align="Center"><Cfif qGetHostFamily.stuDietRest eq 0>No<cfelse>Yes</Cfif></td>
                                    </tr>
                                    <Tr>
                               			<Td colspan=2><span class="title">Restrictions: </span><br />
										<cfif qGetHostFamily.stuDietRestDesc is ''>No Restrictions Noted<cfelse>#qGetHostFamily.stuDietRestDesc#</cfif></td>
                              		<tr>
                                  	<Tr>
                                    	<td><span class="title">Are you prepared to provide three (3) quality meals per day?</span></td>
                                        <td align="Center"><cfif qGetHostFamily.threesquares eq 0>No<cfelse>Yes</cfif></td> 
                                    </Tr>

                               </table> 
                            </td>
                   	
                        <tr>
                       
                         
                        <Td width=50% valign="top">
                                                     
                            <table width=100% cellspacing=0 cellpadding=2 class="border">
                               <Tr>
                                <td><span class="title">Type</span></td><td><span class="title">Indoor / Outdoor</span></td><td><span class="title">How many?</span></td>
                                </Tr>
                               <Cfif qPets.recordcount eq 0>
                                <tr>
                                    <td>There are no pets in this home.</td>
                                </tr>
                                <cfelse>
                                <Cfloop query="qPets">
                                <tr <Cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
                                    <Td><p class=p_uppercase>#animaltype#</Td>
                                    <td><p class=p_uppercase>#indoor#</td>
                                    <Td>#number#</Td>
                                    
                                </tr>
                                </Cfloop>
                                </cfif>
                               </table>  
                                 <table width=100% cellspacing=0 cellpadding=2 class="border">
                                      <Tr>
                                                <Td width=90%><span class="title">
                                                Would you be willing to host a student who is allergic to animals?
                                                (controlled w/ medication)</span></Td>
                                                <Td valign="center"><cfif qGetHostFamily.pet_allergies eq 0>No<cfelse>Yes</cfif></td>
                                            <tr>
                              
                               </table>       
                         	</td>
                           
                     </tr>
                    <Tr>
                    	
                       <Td>
                     <img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/HPpdf_12.jpg" />
                        <Td>
                    </Tr>
                    <Tr>
                 
                        <Td><table width=100% cellspacing=0 cellpadding=2 class="border">
                               		<Tr>
                               			<Td width=80%><span class="title">Does anyone in your home smoke?</span></Td><td>#capFirst1(qGetHostFamily.hostsmokes)#</td>
                              		<tr>
                                    <Tr>
                               			<Td><span class="title">Would you host a student who smokes?</span></Td><td>#capFirst1(qGetHostFamily.acceptsmoking)#</td>
                              		<tr>
                                    <Tr>
                               			<Td colspan=2><span class="title">Conditions:</span> #qGetHostFamily.smokeconditions#</td>
                              		<tr>

                               </table> 
                          </td>
                      </tr>
                  </table>
                     </td>
                      </tr>
                  </table>
                       <!----INterests---->     
                             <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                        <tr>           
                            <td colspan=5 align="center"><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/HPpdf_08.jpg" /></Td>
                        </tr>
                        <tr>
                            <td valign="top">
                          <table  align="Center" width=100% cellpadding=4 cellspacing=0 border=0>
                                <tr>
                                    <td width=40%><span class="title">Does anyone play in a Band?</span></td>
                                    <td><Cfif qGetHostFamily.playBand is 0>No<cfelse>Yes</Cfif></td>
                                    <td><span class="title">Instrument:</td><td><cfif qGetHostFamily.bandInstrument is ''>N/A<cfelse>#capFirst1(qGetHostFamily.bandInstrument)#</cfif></td>
                                </tr>
                                <tr>
                                   	<Td><span class="title">Does anyone play in an Orchastra?</span></Td>
                                    <td><Cfif qGetHostFamily.playOrchestra is 0>No<cfelse>Yes</Cfif></td>
                                    <td><span class="title">Instrument:</td><td><Cfif qGetHostFamily.orcInstrument is ''>N/A<cfelse>  #capFirst1(qGetHostFamily.orcInstrument)#</Cfif></td>
                                </tr>
                          		<Tr>
                                	<Td><span class="title">Does anyone play in competitive sports?</span></Td>
                                    <td><Cfif qGetHostFamily.playCompSports is 0>No<cfelse>Yes</Cfif></td>
                                    <td><span class="title">Sport:</td><td><Cfif qGetHostFamily.sportDesc is ''>N/A<cfelse> #capFirst1(qGetHostFamily.sportDesc)#</Cfif></td>
                                </Tr>
                                  <tr>
                                    <td colspan=4><span class="title">List any specific interests, hobbies, activities and any awards or accomodations</span></td>
                                 </tr>
                                <tr>
                                    <td colspan=4><cfif qGetHostFamily.interests_other is ''>No other information provided.<cfelse>#qGetHostFamily.interests_other#</cfif></td>
                                </tr>
                               
                          		<tr>
                                	<td><span class="title">Family Interests:</span></td>
                                </tr>
                                <tr>
                                	<Td>
                                        <Cfloop list="#qGetHostFamily.interests#" index=i>
                                            <Cfquery name="interestName" datasource="#application.dsn#">
                                            SELECT interest
                                            FROM smg_interests
                                            WHERE interestid = <cfqueryparam cfsqltype="integer" value="#i#">
                                            </Cfquery>
                                        #capFirst1(interestName.interest)#<Cfif Len(qGetHostFamily.interests) neq #i#>,</Cfif>
                                        </Cfloop>
                                    </td>
                                </tr>
                           </table>

                        </td>
                    </tr>                
				</table>
            </td>
            </tr>                
        </table>
<!----End of page1---->
<div style="page-break-after:always;"></div>
<!----Page 2---->
  <table class="profileTable" align="center">
        <tr>
            <td>
   				 <table width=800>
                    <tr>
                        <td colspan=3 ><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/Pdf_Headers_02.jpg"></td>
                    </tr>
                    <tr>
                    
                    	
                        <Td valign="top" align="center" >
                           <span class="title"><font size=+1> #qGetHostFamily.familyLastName# (#qGetHostFamily.hostid#)<br /> Host Family Application</font></span>
                        </Td>
                       
                </table>
			<!--- Letter --->
                <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=5 align="center"><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/HPpdf_15.jpg"/></Td>
                    </tr>
                    <tr>
                    	<td><span class="title">Your personal description is THE most important part of this application. Along with photos of your family and your home, this description will be your
personal explanation of you and your family and why you have decided to host an exchange student. <br /><br />
We ask that you be brief yet
thorough with your introduction to your 'extended' family. Please include all information that might be of importance to your newest
son or daughter and their parents, such as personalities, background, lifestyle and hobbies.</span>
						</td>
                    <tr>
                    	<td>#ParagraphFormat(qGetHostFamily.familyletter)#</td>
                    </tr>
                </table>
                <br>
                <table width=100%>
                	<tr>
                 	  <td align="left"> <span class="title">Printed: #DateFormat(now(),'mmm, d, yyyy')#</span>	</td>
                      <td align="right"><span class="title">Page 2</span>
                          
               </td>
             </tr>
           
           </table>
                    </td>
            </tr>                
        </table>

<!----End of page2---->
<div style="page-break-after:always;"></div>
<!----Page 3---->
 <table class="profileTable" align="center">
        <tr>
            <td>
   				 <table width=800>
                    <tr>
                        <td colspan=3 align="Center"><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/Pdf_Headers_02.jpg"></td>
                    </tr>
                    <tr>
                    
                    	
                        <Td valign="top" align="center" >
                           <span class="title"><font size=+1> #qGetHostFamily.familyLastName# (#qGetHostFamily.hostid#)<br /> Host Family Application</font></span>
                        </Td>
                       
                </table>
                <!--- Letter --->
                <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=5 align="center"><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/HPpdf_20.jpg"/></Td>
                    </tr>
                    <tr>
                    	<td>
                        <h3>Your Photo Album</h3>
<table width=100% cellspacing=0 cellpadding=2 class="border">


	<tr>
    <cfset count = 1>
    <cfoutput>
    <cfloop query="current_photos">
    	<cfquery name="catDesc" datasource="mysql">
        select cat_name
        from smg_host_pic_cat
        where catID = #cat#
        </cfquery>
    	<Td><img src="http://ise.exitsapplication.com/nsmg/uploadedfiles/hostAlbum/thumbs/#filename#" width = 250><br />
            <span class="title">Catagory:</span> #catDesc.cat_name#<br />
            <span class="title">Description:</span>#description#
		</Td>
                <td valign="top">
                
              <Cfset count = #count# + 1>
 	<Cfif  #count#  mod 2>
    </tr>
    </Cfif>
    </cfloop>
    </Cfoutput>
   <tr>
    	
   </tr>
</table>
                    
                        
                        
                        </td>
                    </tr>
                </table>
                
                
                
                
                
                <table width=100%>
                	<tr>
                 	  <td align="left"> <span class="title">Printed: #DateFormat(now(),'mmm. d, yyyy')#</span>	</td>
                      <td align="right"><span class="title">Page 3</span>
                          
               </td>
             </tr>
           
           </table>
                 </td>
            </tr>                
        </table>

<!----End of page 3---->
<div style="page-break-after:always;"></div>
<!----Page 4---->
  <table class="profileTable" align="center">
        <tr>
            <td>
   				 <table width=800>
                    <tr>
                        <td colspan=3><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/Pdf_Headers_02.jpg"></td>
                    </tr>
                    <tr>
                    
                    	
                        <Td valign="top" align="center" >
                           <span class="title"><font size=+1> #qGetHostFamily.familyLastName# (#qGetHostFamily.hostid#)<br /> Host Family Application</font></span>
                        </Td>
                       
                </table>
			<!--- Religious Prefs --->
                <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=2 align="center"><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/HPpdf_23.jpg"/></Td>
                    </tr>
                   
                          <tr>
                          <td>
                          	<Table width=100%>
                                <tr>
                                    <td>  <span class="title">School</span></td><td>#schoolInfo.schoolname#</td>
                                </tr>
                                <tr>
                                    <td valign="Top">  <span class="title">Address</span></td><td>#schoolInfo.address#<br>#schoolInfo.address2#</td>
                                </tr>
                                <tr>
                                    <td>  <span class="title">City, State Zip</span></td><td>#schoolInfo.city#, #schoolInfo.state# #schoolInfo.zip#</td>
                                </tr>
                                <tr>
                                    <td>  <span class="title">Principal</span></td><td>#schoolInfo.principal#</td>
                                </tr>
                                <tr>
                                    <td>  <span class="title">Phone</span></td><td>#schoolInfo.phone# <Cfif schoolInfo.phone_ext is not ''>x</Cfif>#schoolInfo.phone_ext#</td>
                                </tr>
                              </table> 

                          </td>
                        </tr>
                         <tr>
                    	<Td width=50% valign="top">
                        	<Table width=100%>
                                <tr>
                                    <td width=75%>  <span class="title">Does any member of your household work for the high
school in a coaching/teaching/administrative capacity?</span></td><td><Cfif qGetHostFamily.schoolWorks eq 1>Yes<cfelse>No</Cfif></td>
                                </tr>
                                <Tr>
                                	<Td colspan=2><span class="title">Remarks:</span>
									<cfif qGetHostFamily.schoolWorksExpl is ''><em>No additional information entered</em><cfelse>#qGetHostFamily.schoolWorksExpl#</cfif>
                                </Tr>
                                <tr>
                                    <td>  <span class="title">Has any member of your household had contact with a coach
regarding the hosting of an exchange student with a particular athletic ability?</span></td><td><cfif qGetHostFamily.schoolCoach eq 1>Yes<cfelse>No</cfif></td>
                                </tr>
                                                                <Tr>
                                	<Td colspan=2><span class="title">Remarks:</span>
									<cfif qGetHostFamily.schoolCoachExpl is ''><em>No additional information entered</em><cfelse>#qGetHostFamily.schoolCoachExpl#</cfif>
                                </Tr>
                                <tr>
                                    <td>  <span class="title">How will the student get to school?</span></td><td>#qGetHostFamily.schooltransportation# 
										  <Cfif qGetHostFamily.schooltransportationother is not ''> - #qGetHostFamily.schooltransportationother#</Cfif>
									</td>
                                </tr>
                              
                                
                              </table> 
                          </Td>
                          </tr>
                      </table>        
                       <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                  		  <tr>           
                       		<td colspan=2 align="center"><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/HPpdf_21.jpg"/></Td>
                  		  </tr>
                     	<Tr>
                        	<Td>
                            	<Table>
                                	<Tr>
                                    	<Td width = 25% valign="top"> <span class="title">Smoking</span></Td><Td>#qGetHostFamily.houserules_smoke#</Td>
                                    </Tr>
                                    <Tr>
                                    	<Td valign="top"> <span class="title">Curfew on School Nights</span></Td><Td>#qGetHostFamily.houserules_curfewweeknights#</Td>
                                    </Tr>
                                    <Tr>
                                    	<Td valign="top"> <span class="title">Curfew on Weekends</span></Td><Td>#qGetHostFamily.houserules_curfewweekends#</Td>
                                    </Tr>
                                    <Tr>
                                    	<Td valign="top"> <span class="title">Chores</span></Td><Td>#qGetHostFamily.houserules_chores#</Td>
                                    </Tr>
                     				<Tr>
                                    	<Td valign="top"> <span class="title">Religious Expectations</span></Td><Td>#qGetHostFamily.houserules_church#</Td>
                                    </Tr>
                                    <Tr>
                                    	<Td valign="top"> <span class="title">Other</span></Td><Td>#qGetHostFamily.houserules_other#</Td>
                                    </Tr>
                                 </Table>  
                                       <br>
<table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=2 align="center"><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/Religion_43.jpg"/></Td>
                    </tr>
                    <tr>
                    	<Td valign="top" width=450>
                        	<Table>
                                <tr>
                                    <td width=80%>  <span class="title">Religious Affiliation</span></td><td>#religion.religionname#</td>
                                </tr>
                                <tr>
                                    <td>  <span class="title">Religious Attendance</span></td><td>#qGetHostFamily.religious_participation#</td>
                                </tr>
                                <tr>
                                    <td>  <span class="title">Do you expect your student to attend<br> services?</span></td><td>#capFirst1(qGetHostFamily.churchfam)#</td>
                                </tr>
                                <tr>
                                    <td>  <span class="title">Would you transport the student to their religious services
if they are different from your own?</span></td><td>#capFirst1(qGetHostFamily.churchtrans)#</td>
                                </tr>
                                
                              </table> 
                          </Td>
                          <td >
                          	<Table width=100%>
                                <tr>
                                    <td>  <span class="title">Religious Institution</span></td><td>#religionInfo.churchname#</td>
                                </tr>
                                <tr>
                                    <td valign="Top">  <span class="title">Address</span></td><td>#religionInfo.address#<br>#religionInfo.address2#</td>
                                </tr>
                                <tr>
                                    <td>  <span class="title">City, State Zip</span></td><td>#religionInfo.city#, #religionInfo.state# #religionInfo.zip#</td>
                                </tr>
                                <tr>
                                    <td>  <span class="title">Religious Leader</span></td><td>#religionInfo.pastor#</td>
                                </tr>
                                <tr>
                                    <td>  <span class="title">Phone</span></td><td>#religionInfo.phone#</td>
                                </tr>
                              </table> 
                          </td>
                        </tr>
                      </table>        
                     
                <table width=100%>
                	<tr>
                 	  <td align="left"> <span class="title">Printed: #DateFormat(now(),'mmm. d, yyyy')#</span>	</td>
                      <td align="right"><span class="title">Page 4</span>
                          
               </td>
             </tr>
           
           </table>
              
                </td>
        </tr>
       </table>   
                </td>
        </tr>
       </table>            
<!----End of page 4---->
<div style="page-break-after:always;"></div>
<!----Page 5---->
 <table class="profileTable" align="center">
        <tr>
            <td>
   				 <table width=800>
                    <tr>
                        <td colspan=3><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/Pdf_Headers_02.jpg"></td>
                    </tr>
                    <tr>
                    
                    	
                        <Td valign="top" align="center">
                           <span class="title"><font size=+1> #qGetHostFamily.familyLastName# (#qGetHostFamily.hostid#)<br /> Host Family Application</font></span>
                        </Td>
                       
                </table>
			<!--- Religious Prefs --->
                <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=6 align="center"><img src="http://ise.exitsapplication.com/nsmg/pics/hostAppBanners/HPpdf_27.jpg"/></Td>
                    </tr>
                    <tr>
                        <Td><span class="title">Community</span></Td>
                        <td>#qGetHostFamily.city#</Td>
                    	<Td><span class="title">Population</span></Td>
                        <td>#qGetHostFamily.population#</td>
                        <td><span class="title">#qGetHostFamily.city# Airport Code</td>
                        <Td>#qGetHostFamily.local_Air_code#</Td>
                    </tr>
                    <Tr>
                    	<Td><span class="title">Our Neighborhood is</span></Td>
                        <td>#qGetHostFamily.neighborhood# </td>
                        <Td><span class="title">Our community is </span></Td>
                        <td>#qGetHostFamily.community#</td>
                        <td><span class="title">Our community Terrain is </span></td>
                        <Td>#qGetHostFamily.terrain1# #qGetHostFamily.terrain2# #qGetHostFamily.terrain3# #qGetHostFamily.terrain3_desc#</Td>
                    </tr>
                    
                    <Tr>
                    	<Td><span class="title">Nearest City</span></Td>
                        <td>#qGetHostFamily.NearBigCity# (#qGetHostFamily.near_City_Dist# miles)</td>
                        <Td><span class="title">Population</span></Td>
                        <td>#qGetHostFamily.near_pop#</td>
                        <td><span class="title">#qGetHostFamily.NearBigCity# Airport Code</span></td>
                        <Td>#qGetHostFamily.major_Air_code#</Td>
                    </tr>
                    <Tr>
                    	<Td><span class="title">Winter Temp</span></Td>
                        <td>#qGetHostFamily.wintertemp# </td>
                        <Td><span class="title">Summer Temp </span></Td>
                        <td>#qGetHostFamily.summertemp#</td>
                        <td colspan=2><span class="title">Seasons</span>
						<cfif qGetHostFamily.snowy_winter  eq 1>Cold, snowy winters;</cfif>
                        <cfif qGetHostFamily.rainy_winter  eq 1>Mild, rainy winters;</cfif>
                       	<cfif qGetHostFamily.hot_summer  eq 1>Hot Summers;</cfif>
                       	<cfif qGetHostFamily.mild_summer  eq 1>Mild Summers;</cfif>
                        <cfif qGetHostFamily.high_hummidity  eq 1>High Humidity;</cfif>
                        <cfif qGetHostFamily.dry_air  eq 1>Dry Air</cfif>
                                                                     
                        
                        </Td>
                    </tr>
                    <tr>
                    	<td colspan=6><span class="title">Indicate particular clothes, sports equipment, etc. that your student should consider bringing</span></td>
                    </tr>
                    <tr>
                    	<td colspan=6>#qGetHostFamily.special_cloths#</td>
                    </tr>
                    <tr>
                    	<td colspan=6><span class="title">Describe the points of interest and available activities/opportunities for teenagers in your surrounding area</span></td>
                    </tr>
                    <tr>
                    	<td colspan=6>#qGetHostFamily.point_interest#</td>
                    </tr>
                     </table>
                     
                     
                     
                                     <table width=100%>
                	<tr>
                 	  <td align="left"> <span class="title">Printed: #DateFormat(now(),'mmm. d, yyyy')#</span>	</td>
                      <td align="right"><span class="title">Page 5</span>
                          
               </td>
             </tr>
           
           </table>
               </td>
             </tr>
           
           </table>
<!----End of page 5---->
</cfoutput>