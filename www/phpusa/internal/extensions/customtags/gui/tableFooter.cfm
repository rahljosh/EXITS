<!--- ------------------------------------------------------------------------- ----
	
	File:		tableFooter.cfm
	Author:		Marcus Melo
	Date:		February 26, 2010
	Desc:		This Tag displays the table footer used in the internal database.

	Status:		In Development

	Call Custom Tag: 

		<!--- Import CustomTag --->
		<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
		<!--- Table Footer --->
		<gui:tableFooter
			width=""
		/>
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param tag attributes --->
	<cfparam 
		name="ATTRIBUTES.width"
		type="string"
        default="100%"
		/>

	<cfparam 
		name="ATTRIBUTES.imagePath"
		type="string"
        default=""
		/>

	<cfparam 
		name="ATTRIBUTES.imagePath"
		type="string"
        default=""
		/>
        
</cfsilent>

<!--- 
	Check to see which tag mode we are in. We only want to output this 
	in the start mode. 
--->
<cfif NOT CompareNoCase(THISTAG.ExecutionMode, "Start")>

<cfoutput>

<!--- Footer of Table --->
<table width="#ATTRIBUTES.width#" align="center" cellpadding="0" cellspacing="0" border="0" style="margin-bottom:10px;">
	<tr valign="bottom">
		<td width="9" valign="top" height=12><img src="#ATTRIBUTES.imagePath#pics/footer_leftcap.gif"></td>
		<td width="100%" background="#ATTRIBUTES.imagePath#pics/header_background_footer.gif"></td>
		<td width="9" valign="top"><img src="#ATTRIBUTES.imagePath#pics/footer_rightcap.gif"></td>
	</tr>
</table>

</cfoutput>
    	
</cfif>