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
     	<td colspan=3 align="center"><A href="viewPDF.cfm?pdf"><img src="../pics/buttons/View.png"></A></td>
        <td colspan=3 align="center"><img src="../pics/buttons/email.png"></td>
     </Tr>
 </table>
 </cfoutput>
<br />
<Br />
      <cfinclude template="page#url.page#.cfm">
      