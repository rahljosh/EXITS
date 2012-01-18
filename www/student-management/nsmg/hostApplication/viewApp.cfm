<Cfparam name="url.page" default="1">


<Cfoutput>
<table align="Center">
	<Tr>
    	<Td><a href="viewApp.cfm?page=1&hostid=#url.hostid#">
			<cfif url.page eq 1><img src="../pics/buttons/PG1_G.png" border=0/><Cfelse><img src="../pics/buttons/PG1.png" border=0/></cfif></a></Td>
        <Td><a href="viewApp.cfm?page=2&hostid=#url.hostid#">
			<cfif url.page eq 2><img src="../pics/buttons/PG2_G.png" border=0/><Cfelse><img src="../pics/buttons/PG2.png" border=0/></cfif></a></Td>
        <Td><a href="viewApp.cfm?page=3&hostid=#url.hostid#">
			<cfif url.page eq 3><img src="../pics/buttons/PG3_G.png" border=0/><Cfelse><img src="../pics/buttons/PG3.png" border=0/></cfif></a></Td>
        <Td><a href="viewApp.cfm?page=4&hostid=#url.hostid#">
			<cfif url.page eq 4><img src="../pics/buttons/PG4_G.png" border=0/><Cfelse><img src="../pics/buttons/PG4.png" border=0/></cfif></a></Td>
        <Td><a href="viewApp.cfm?page=5&hostid=#url.hostid#">
			<cfif url.page eq 5><img src="../pics/buttons/PG5_G.png" border=0/><Cfelse><img src="../pics/buttons/PG5.png" border=0/></cfif></a></Td>
        <Td><a href="viewApp.cfm?page=6&hostid=#url.hostid#">
			<cfif url.page eq 6><img src="../pics/buttons/PG6_G.png" border=0/><Cfelse><img src="../pics/buttons/PG6.png" border=0/</cfif></a></Td>
     </Tr>
     <Tr>
     	
        <td colspan=6 align="center" valign="middle">
        <form action="viewApp.cfm?hostid=#url.hostid#" method="post">
            <table cellpadding=0 cellspacing=0>
                <tr>
                	<td valign="middle"><A href="viewPDF.cfm?hostid=#hostid#&pdf"><img src="../pics/buttons/View.png" border=0></A></td>
                    <td valign="middle"><input type="text" name="emailTo" size=20/></td>
                    <td valign="middle"> <input type="image" src="../pics/buttons/email.png" height=35></td>
                </tr>
            </table>
        </form>
     	</td>
     </Tr>
 </table>
 </cfoutput>

 <!----Email the Application---->
<Cfif isDefined('form.emailTo')>
<cfquery name="hostInfo" datasource="mysql">
select familylastname
from smg_hosts where hostid = #url.hostid#
</Cfquery>
<cfoutput>
   <cfsavecontent variable="emailMessage">
                <p>Attached is the host application for the #hostInfo.familylastname# family. </p>
                <p>Information is accurate as of #dateformat(now(), 'mm/dd/yyyy')#.</p>
   </cfsavecontent>
            
            <!--- Create PDF File - Include Profile and Letters --->
            <cfdocument name="HostApp" format="pdf">
	            <!--- Include Application Template --->
                <cfinclude template="appForPDF.cfm">
            </cfdocument>
            
            <!--- Save PDF File --->
            
            <cffile action="write" file="#AppPath.temp#HostApplication.pdf" output="#HostApp#" nameconflict="overwrite">    
           
            
            <!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#FORM.emailTo#">
                <cfinvokeargument name="email_subject" value="Host Application for #hostInfo.familylastname# family ">
                <cfinvokeargument name="email_message" value="#emailMessage#">
                <cfinvokeargument name="email_from" value="""Host Application Support"" <HostApplication@iseusa.com>">
                <!--- Attach Students Profile  --->
                <cfinvokeargument name="email_file" value="#AppPath.temp#HostApplication.pdf">
         		
               
               
            </cfinvoke>
        
           <div align="center">Host application was sent to #form.emailTo#</div>
			
 </cfoutput>
</Cfif>

<Br />
      <cfinclude template="page#url.page#.cfm">
      