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
                        <td colspan=5 align="center"><img src="../pics/hostAppBanners/HPpdf_15.jpg"/></Td>
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
           
           
           
 </cfoutput>