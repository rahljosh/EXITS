<!--- ------------------------------------------------------------------------- ----
	
	File:		tableFooter.cfm
	Author:		Marcus Melo
	Date:		August 19, 2010
	Desc:		This Tag displays the table footer used in the internal database.

	Status:		In Development

	Call Custom Tag: 

		<!--- Import CustomTag --->
		<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
		<!--- Table Footer --->
		<gui:tableFooter
			footerType=""
		/>
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param tag attributes --->
	<cfparam 
		name="ATTRIBUTES.footerType"
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
                </td>
            </tr>
        </table>
                
    </cfoutput>
    	
</cfif>