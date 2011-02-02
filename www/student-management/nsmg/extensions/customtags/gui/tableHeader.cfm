<!--- ------------------------------------------------------------------------- ----
	
	File:		tableHeader.cfm
	Author:		Marcus Melo
	Date:		February 26, 2010
	Desc:		This Tag displays the table header used in the internal database.

	Status:		In Development

	Call Custom Tag: 

		<!--- Import CustomTag --->
		<cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
		
		<!--- Table Header --->
		<gui:tableHeader
			width=""
			imageName=""
			tableTitle=""
			tableRightTitle=""
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
		name="ATTRIBUTES.imageName"
		type="string"
        default="notes.gif"
		/>

	<cfparam 
		name="ATTRIBUTES.tableTitle"
		type="string"
        default=""
		/>

	<cfparam 
		name="ATTRIBUTES.tableRightTitle"
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

<!--- Header of Table --->
<table width="#ATTRIBUTES.width#" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr valign="middle" height="24">
        <td width="13" height="24" background="pics/header_leftcap.gif">&nbsp;</td>
        <td width="26" background="pics/header_background.gif"><img src="pics/#ATTRIBUTES.imageName#"></td>
        <td background="pics/header_background.gif"><h2>#ATTRIBUTES.tableTitle#</h2></td>
        <cfif LEN(ATTRIBUTES.tableRightTitle)>
	        <td align="right" background="pics/header_background.gif"><h2>#ATTRIBUTES.tableRightTitle#</h2></td>
        </cfif>
        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

</cfoutput>
    	
</cfif>