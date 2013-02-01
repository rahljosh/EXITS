<link rel="stylesheet" href="../linked/css/hostApp.css" type="text/css">


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
                <!--- Letter --->
                <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=5 align="center"><img src="../pics/hostAppBanners/HPpdf_20.jpg"/></Td>
                    </tr>
                    <tr>
                    	<td>
                        <h3>Your Photo Album</h3>
<table width=100% cellspacing=0 cellpadding=2 class="border">


	<tr>
    <cfset count = 1>
    <cfoutput>
    	display images
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
           
           
           
 </cfoutput>
</body>
</html>