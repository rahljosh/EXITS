<link rel="stylesheet" href="../linked/css/buttons.css" type="text/css">
<cfoutput>
<form method="post" action="#listlast(cgi.script_name,"/")#?itemID=#url.itemID#&userType=#url.usertype#">
<cfif isDefined('url.reportid')>
	<input type="hidden" name="pr_id" value="#url.reportid#"/>
</cfif>
<!----
<table cellpadding=10 align="center">
	<tr>
    	<td><input type="image" src="../pics/buttons/deny.png" name="deny" value="1" width="90%" /></td><td>&nbsp;</td>
        
        <Td><input type="image" src="../pics/buttons/approveBut.png" name="approve" value="1" width="90%" /></Td>
    </tr>
</table>
---->

<table cellpadding=10 align="center">
	<tr>
<td valing="top" align="center">
				
                
                   <input name="deny" type="submit" value="Deny" alt="Deny Application" border="0" class="buttonRed" /> 
               
                </td>
                
                <td align="Center">   
                
                   
                </td>
                <td align="Center">   
                
                   <input name="approve" type="submit" value="Approve"  alt="Approve Application" border="0" class="buttonGreen" />
                </td>
 </tABLE>

</form>
</cfoutput>