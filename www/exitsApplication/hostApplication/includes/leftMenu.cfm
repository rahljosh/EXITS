<!--- ------------------------------------------------------------------------- ----
	
	File:		leftMenu.cfm
	Author:		Marcus Melo
	Date:		November 12, 2012
	Desc:		Left Menu

	Updated:	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfscript>	
		// Get Current Section
		vCurrentSectionID = ArrayFindNoCase(APPLICATION.leftMenu.linkSection, URL.section);
		
		if ( NOT VAL(vCurrentSectionID) ) {
			// Set Default Section
			vCurrentSectionID = 1;
		}
	</cfscript>

</cfsilent>

<cfoutput>

	<!--- Display Menu for Logged In Applications --->
    <cfif APPLICATION.CFC.SESSION.getHostSession().ID>
    
        <div id="leftMenu">
        
            <table width="154" border="0" border="1">
				                
                <!--- EXITS Logged IN - Display Current Section Only --->
                <cfif APPLICATION.CFC.SESSION.getHostSession().isMenuBlocked AND APPLICATION.CFC.SESSION.getHostSession().isExitsLogin>
					
                    <tr onMouseOver="this.style.background='#APPLICATION.leftMenu.colorSection[vCurrentSectionID]#'" onMouseOut="this.style.background=''" <cfif URL.section EQ APPLICATION.leftMenu.linkSection[vCurrentSectionID]>bgcolor="#APPLICATION.leftMenu.colorSection[vCurrentSectionID]#"</cfif> >
                        <td>#APPLICATION.leftMenu.displaySection[vCurrentSectionID]#</td>
                    </tr>	
                
                <!--- Menu Blocked - Display Overview, Checklist and Lougout --->
                <cfelseif APPLICATION.CFC.SESSION.getHostSession().isMenuBlocked>

                    <cfloop list="#APPLICATION.leftMenu.allowedMenuList#" index="x">
                    
                        <tr onMouseOver="this.style.background='#APPLICATION.leftMenu.colorSection[x]#'" onMouseOut="this.style.background=''" <cfif URL.section EQ APPLICATION.leftMenu.linkSection[x]>bgcolor="#APPLICATION.leftMenu.colorSection[x]#"</cfif> >
                            <td>#APPLICATION.leftMenu.displaySection[x]#</td>
                        </tr>	

                    </cfloop>
                
                
				<!--- Display Complete Menu --->
                <cfelse>
                    
                    <cfloop from="1" to="#ArrayLen(APPLICATION.leftMenu.linkSection)#" index="x">

                        <tr onMouseOver="this.style.background='#APPLICATION.leftMenu.colorSection[x]#'" onMouseOut="this.style.background=''" <cfif URL.section EQ APPLICATION.leftMenu.linkSection[x]>bgcolor="#APPLICATION.leftMenu.colorSection[x]#"</cfif> >
                            <td>#APPLICATION.leftMenu.displaySection[x]#</td>
                        </tr>	
                                
                    </cfloop>

                </cfif>
                
            </table>
            
        </div> <!--leftMenu -->
    
    </cfif>
    
</cfoutput>    