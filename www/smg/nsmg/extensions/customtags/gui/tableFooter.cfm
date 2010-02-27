<!--- ------------------------------------------------------------------------- ----
	
	File:		tableFooter.cfm
	Author:		Marcus Melo
	Date:		February 26, 2010
	Desc:		This Tag displays the table footer used in the internal database.

	Status:		In Development

	Call Custom Tag: 

		<!--- Import CustomTag --->
		<cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
	
		<gui:tableFooter />
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param tag attributes --->
        
</cfsilent>

<!--- 
	Check to see which tag mode we are in. We only want to output this 
	in the start mode. 
--->
<cfif NOT CompareNoCase(THISTAG.ExecutionMode, "Start")>

<cfoutput>

<!--- Footer of Table --->
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr valign="bottom">
		<td width="9" valign="top" height=12><img src="pics/footer_leftcap.gif"></td>
		<td width="100%" background="pics/header_background_footer.gif"></td>
		<td width="9" valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

</cfoutput>
    	
</cfif>