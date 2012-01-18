<link rel="stylesheet" href="../linked/css/hostApp.css" type="text/css">
<cfset client.hostid = 33169>

    <cfscript>
		// Host Family
		qGetHostFamily = APPLICATION.CFC.HOST.getHosts(hostID=url.hostID);
		
		// Host Family Children
		qGetHostChildren = APPLICATION.CFC.HOST.getHostMemberByID(hostID=url.hostID);
		

    </cfscript>

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
			<!--- Religious Prefs --->
                <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=6 align="center"><img src="../pics/hostAppBanners/HPpdf_27.jpg"/></Td>
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
           
           
           
 </cfoutput>