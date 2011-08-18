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

  
<cffunction name="CapFirst" returntype="string" output="false">
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


   <table class="profileTable" align="center">
        <tr>
            <td>
    
				<!--- Host Header --->
               <table width=800>
                    <tr>
                        <td colspan=3><img src="../pics/hostAppBanners/Pdf_Headers_02.jpg"></td>
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
                        <td colspan=5 align="center"><img src="../pics/hostAppBanners/HPpdf_04.jpg"/></Td>
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
                            <td colspan=5 align="center"><img src="../pics/hostAppBanners/HPpdf_06.jpg" /></Td>
                        </tr>
                        <tr>
                            <td valign="top">
                          <table  align="Center" width=100% cellpadding=4 cellspacing=0>
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
                                        <td align="center">#CapFirst(qGetHostChildren.sex)#</td>
                                        <td align="center">#CapFirst(qGetHostChildren.liveathome)#</td>
                                        <td align="center">#CapFirst(qGetHostChildren.shared)#</td>
                                        <td align="center">#CapFirst(qGetHostChildren.membertype)#</td>
                                        <td align="center">#qGetHostChildren.school#</td>
                                        <td align="center"></td>
                                    </tr>
                                </cfloop>
                            </table>
                         
                       <!----Dietary and smoking---->
                       <table  align="left" border="0" cellpadding="4" cellspacing="0" width="100%">
                       	<Tr>
                      		 <td align="center"><img src="../pics/hostAppBanners/dietary_38.jpg"></td>
                            	<td align="center"><img src="../pics/hostAppBanners/HPpdf_10.jpg"></Td>
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
                     <img src="../pics/hostAppBanners/HPpdf_12.jpg" />
                        <Td>
                    </Tr>
                    <Tr>
                 
                        <Td><table width=100% cellspacing=0 cellpadding=2 class="border">
                               		<Tr>
                               			<Td width=80%><span class="title">Does anyone in your home smoke?</span></Td><td>#CapFirst(qGetHostFamily.hostsmokes)#</td>
                              		<tr>
                                    <Tr>
                               			<Td><span class="title">Would you host a student who smokes?</span></Td><td>#CapFirst(qGetHostFamily.acceptsmoking)#</td>
                              		<tr>
                                    <Tr>
                               			<Td colspan=2><span class="title">Conditions:</span> #qGetHostFamily.smokeconditions#</td>
                              		<tr>

                               </table> 
                     
                     
                                 
                         <br /><br />
                       <!----INterests---->     
                             <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                        <tr>           
                            <td colspan=5 align="center"><img src="../pics/hostAppBanners/HPpdf_08.jpg" /></Td>
                        </tr>
                        <tr>
                            <td valign="top">
                          <table  align="Center" width=100% cellpadding=4 cellspacing=0 border=0>
                                <tr>
                                    <td width=40%><span class="title">Does anyone play in a Band?</span></td>
                                    <td><Cfif qGetHostFamily.playBand is 0>No<cfelse>Yes</Cfif></td>
                                    <td><span class="title">Instrument:</td><td><cfif qGetHostFamily.bandInstrument is ''>N/A<cfelse>#CapFirst(qGetHostFamily.bandInstrument)#</cfif></td>
                                </tr>
                                <tr>
                                   	<Td><span class="title">Does anyone play in an Orchastra?</span></Td>
                                    <td><Cfif qGetHostFamily.playOrchestra is 0>No<cfelse>Yes</Cfif></td>
                                    <td><span class="title">Instrument:</td><td><Cfif qGetHostFamily.orcInstrument is ''>N/A<cfelse>  #CapFirst(qGetHostFamily.orcInstrument)#</Cfif></td>
                                </tr>
                          		<Tr>
                                	<Td><span class="title">Does anyone play in competitive sports?</span></Td>
                                    <td><Cfif qGetHostFamily.playCompSports is 0>No<cfelse>Yes</Cfif></td>
                                    <td><span class="title">Sport:</td><td><Cfif qGetHostFamily.sportDesc is ''>N/A<cfelse> #CapFirst(qGetHostFamily.sportDesc)#</Cfif></td>
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
                                        #CapFirst(interestName.interest)#<Cfif Len(qGetHostFamily.interests) neq #i#>,</Cfif>
                                        </Cfloop>
                                    </td>
                                </tr>
                               
                               
                            
                                
                           </table>
                            
                            
                        </td>
                    </tr>                
				</table>






</cfoutput>
</body>