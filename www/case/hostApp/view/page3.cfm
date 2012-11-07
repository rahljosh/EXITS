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


    <Cfquery name="current_photos" datasource="mysql">
        select filename, description, cat 
        from smg_host_picture_album
        where fk_hostid = <cfqueryparam cfsqltype="integer" value="#client.hostid#">
    </cfquery>
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
                <!--- Letter --->
                <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                    <tr>           
                        <td colspan=5 align="center"><img src="../images/hostAppBanners/HPpdf_20.jpg"/></Td>
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
    	<Td><img src="http://ise.exitsapplication.com/nsmg/uploadedfiles/hostAlbum/#filename#" width = 250><br />
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
           
           
           
 </cfoutput>
</body>
</html>