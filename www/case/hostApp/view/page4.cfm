<link rel="stylesheet" href="../linked/css/hostApp.css" type="text/css">


<cfquery name="qGetHostFamily" datasource="mysql">
select * 
from smg_hosts
where hostid = <cfqueryparam cfsqltype="integer" value="#client.hostid#">
</cfquery>

<cfquery name="qGetHostChildren" datasource="mysql">
select * 
from smg_host_children
where hostid = <cfqueryparam cfsqltype="integer" value="#client.hostid#">
</cfquery>

    <cfquery name="schoolInfo" datasource="mysql">
    select s.schoolname, s.principal, s.address, s.address2, s.city, s.state, s.zip, s.phone, s.phone_ext
    from smg_schools s
    where s.schoolid = <cfqueryparam cfsqltype="integer" value="#qGetHostFamily.schoolid#">
    </cfquery>

    <cfquery name="religionInfo" datasource="mysql">
    select c.churchname, c.address, c.address2, c.city, c.state, c.zip, c.phone, c.pastor
    from churches c
    where c.churchid = <cfqueryparam cfsqltype="integer" value="#qGetHostFamily.churchid#">
    </cfquery>

    <cfquery name="religion" datasource="mysql">
    select religionname
    from smg_religions 
    where religionid = <cfqueryparam cfsqltype="integer" value="#qGetHostFamily.religion#">
    </cfquery>
    
    <cffunction name="CapFirst3" returntype="string" output="false">
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

   <cfoutput> 
   <table class="profileTable" align="center">
        <tr>
            <td>
   				 <table width=800>
                    <tr>
                        <td colspan=3><img src="../images/hostAppBanners/Pdf_Headers_02.jpg"></td>
                    </tr>
                    <tr>
                    
                    	
                        <Td valign="top" align="center" width=50%>
                           <span class="title"><font size=+1> #qGetHostFamily.familyLastName# (#qGetHostFamily.hostid#)<br /> Host Family Application</font></span>
                        </Td>
                       
                </table>
			<!--- Religious Prefs --->
                <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=2 align="center"><img src="../images/hostAppBanners/HPpdf_23.jpg"/></Td>
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
                       		<td colspan=2 align="center"><img src="../images/hostAppBanners/HPpdf_21.jpg"/></Td>
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
                        <td colspan=2 align="center"><img src="../images/hostAppBanners/Religion_43.jpg"/></Td>
                    </tr>
                    <tr>
                    	<Td width=50% valign="top">
                        	<Table width=100%>
                                <tr>
                                    <td width=80%>  <span class="title">Religious Affiliation</span></td><td>#religion.religionname#</td>
                                </tr>
                                <tr>
                                    <td>  <span class="title">Religious Attendance</span></td><td>#qGetHostFamily.religious_participation#</td>
                                </tr>
                                <tr>
                                    <td>  <span class="title">Do you expect your student to attend<br> services?</span></td><td>#CapFirst3(qGetHostFamily.churchfam)#</td>
                                </tr>
                                <tr>
                                    <td>  <span class="title">Would you transport the student to their religious<Br> services
if they are different from your own?</span></td><td>#CapFirst3(qGetHostFamily.churchtrans)#</td>
                                </tr>
                                
                              </table> 
                          </Td>
                          <td>
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
           
           
           
 </cfoutput>