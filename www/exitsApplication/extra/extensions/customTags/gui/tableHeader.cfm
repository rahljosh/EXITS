<!--- ------------------------------------------------------------------------- ----
	
	File:		tableHeader.cfm
	Author:		Marcus Melo
	Date:		August 19, 2010
	Desc:		This Tag displays the table header used in the internal database.

	Status:		In Development

	Call Custom Tag: 

		<!--- Import CustomTag --->
		<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
		
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
		name="ATTRIBUTES.tableTitle"
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
<table width="#ATTRIBUTES.width#" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC">
	<tr>
		<td>

            <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
                <tr valign="middle" height="24">
                    <td valign="middle" bgcolor="##E4E4E4" class="title1">
                        #ATTRIBUTES.tableTitle# <!--- <span class="style1"></span> --->
                    </td>
                </tr>
            </table>

</cfoutput>
    	
</cfif>