
<cfoutput>
<form method="post" action="#listlast(cgi.script_name,"/")#?itemID=#url.itemID#&userType=#url.usertype#">
<table cellpadding=10 align="center">
	<tr>
    	<td><input type="image" src="../pics/buttons/deny.png" name="deny" value="1" width="90%" /></td><td>&nbsp;</td>
        
        <Td><input type="image" src="../pics/buttons/approveBut.png" name="approve" value="1" width="90%" /></Td>
    </tr>
</table>
</form>
</cfoutput>