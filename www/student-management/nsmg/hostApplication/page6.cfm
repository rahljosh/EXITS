<link rel="stylesheet" href="../linked/css/hostApp.css" type="text/css">


    <cfscript>
		// Host Family
		qGetHostFamily = APPLICATION.CFC.HOST.getHosts(hostID=url.hostID);
		
		// Host Family Children
		qGetHostChildren = APPLICATION.CFC.HOST.getHostMemberByID(hostID=url.hostID);
		

    </cfscript>
    

<cfquery name="qreferences" datasource="MySQL">
select *
from smg_family_references
where referencefor = <cfqueryparam cfsqltype="integer" value="#url.hostID#">
</cfquery>
   <cfoutput> 
  <table class="profileTable" align="center">
        <tr>
            <td>
   				 <table width=800>
                    <tr>
                        <td colspan=3><img src="../pics/hostAppBanners/Pdf_Headers_02.jpg"></td>
                    </tr>
                    <tr>
                    
                    	
                        <Td valign="top" align="center" width=50%>
                           <span class="title"><font size=+1> #qGetHostFamily.familyLastName# (#qGetHostFamily.hostid#)<br /> Host Family Application</font></span>
                        </Td>
                       
                </table>
			<!--- Finance Prefs --->
                <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=6 align="center"><img src="../pics/hostAppBanners/HPpdf_29.jpg"/></Td>
                    </tr>
                    <tr>
                    	<Td><span class="title">Is any member of your household receiving
any kind of public assistance?</span>
						</Td>
                        <Td>
                        	<Cfif val(qGetHostFamily.publicAssitance)>Yes<cfelse>No</Cfif> 
                    </tr>
                     <tr>
                    	<Td><span class="title">Average annual income range</span>
						</Td>
                        <Td>
                        	<Cfif qGetHostFamily.income eq 25>Less then $25,000</Cfif> 
                            <Cfif qGetHostFamily.income eq 35>$25,000 - $35,000</Cfif> 
                            <Cfif qGetHostFamily.income eq 45>$35,001 - $45,000</Cfif> 
                            <Cfif qGetHostFamily.income eq 55>$45,001 - $55,000</Cfif> 
                            <Cfif qGetHostFamily.income eq 65>$55,001 - $65,000</Cfif> 
                            <Cfif qGetHostFamily.income eq 75>$65,001 - $75,000</Cfif> 
                            <Cfif qGetHostFamily.income eq 85>$75,000 and above</Cfif> 
                    	</Td>
                    </tr>
                       <tr>
                    	<Td><span class="title">Has any member of your household ever been charged
with a crime?</span>
						</Td>
                        <Td>
                        	<Cfif val(qGetHostFamily.crime)>Yes<cfelse>No</Cfif> 
                    </tr>
                    <tr>
                    	<td colspan=2><span class="title">Explain:</span><Cfif qGetHostFamily.crimeExpl is ''>No explanation received.<cfelse> #qGetHostFamily.crimeExpl#</Cfif></Td>
                    </tr>
                      <tr>
                    	<Td><span class="title">Have you had any contact with Child Protective Services
Agency in the past?</span>
						</Td>
                        <Td>
                        	<Cfif val(qGetHostFamily.cps)>Yes<cfelse>No</Cfif> 
                    </tr>
                    <tr>
                    	<td  colspan=2><span class="title">Explain:</span> <Cfif qGetHostFamily.cpsExpl is ''>No explanation received.<cfelse>#qGetHostFamily.cpsExpl#</Cfif></Td>
                    </tr>
            		</table>
     				<!--- Finance Prefs --->
                <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=6 align="center"><img src="../pics/hostAppBanners/HPpdf_32.jpg"/></Td>
                     </tr>
                     <tr>
                     	<td>         
                           <table width=100% cellspacing=0 cellpadding=2 class="border">
                               <Tr>
                                <Th>Name</Th><Th>Address</Th><th>City</th><Th>State</Th><th>Zip</th><th>Phone</th><th></th>
                                </Tr>
                           	   <Cfloop query="qreferences">
                                    <tr <Cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
                                        <Td><h3><p class=p_uppercase>#firstname# #lastname#</h3></Td>
                                        <td><h3><p class=p_uppercase>#address# #address2#</h3></td>
                                        <Td><h3>#city#</h3></Td>
                                        <td><h3>#state#</h3></td>
                                        <td><h3>#zip#</h3></td>
                                        <td><h3>#phone#</h3></td>
                                       
                                    </tr>
                                    </Cfloop>     
                                  </table>
                         </td>              
           			</tr>
                    </table>                              
           <table width=100%>
                                     	
                	<tr>
                 	  <td align="left"> <span class="title">Printed: #DateFormat(now(),'mmm. d, yyyy')#</span>	</td>
                      <td align="right"><span class="title">Page 6</span>
                          
               </td>
             </tr>
           
           </table>
           
           
           
 </cfoutput>