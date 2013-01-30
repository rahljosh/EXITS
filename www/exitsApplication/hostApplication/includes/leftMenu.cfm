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
		vCurrentSection = ArrayFindNoCase(APPLICATION.leftMenu.linkSection, URL.section);
		
		if ( NOT VAL(vCurrentSection) ) {
			// Set Default Section
			vCurrentSection = 1;
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

                    <tr onMouseOver="this.style.background='#APPLICATION.leftMenu.colorSection[vCurrentSection]#'" onMouseOut="this.style.background=''" <cfif URL.section EQ APPLICATION.leftMenu.linkSection[vCurrentSection]>bgcolor="#APPLICATION.leftMenu.colorSection[vCurrentSection]#"</cfif> >
                        <td><a href="/index.cfm?section=#APPLICATION.leftMenu.linkSection[vCurrentSection]#" class="whtLinks">#APPLICATION.leftMenu.displaySection[vCurrentSection]#</a></td>
                    </tr>	
                
                <!--- Menu Blocked - Display Overview, Checklist and Lougout --->
                <cfelseif APPLICATION.CFC.SESSION.getHostSession().isMenuBlocked>
                	
                    <cfloop list="#APPLICATION.leftMenu.allowedMenuList#" index="x">
                    
                        <tr onMouseOver="this.style.background='#APPLICATION.leftMenu.colorSection[x]#'" onMouseOut="this.style.background=''" <cfif URL.section EQ APPLICATION.leftMenu.linkSection[x]>bgcolor="#APPLICATION.leftMenu.colorSection[x]#"</cfif> >
                            <td><a href="/index.cfm?section=#APPLICATION.leftMenu.linkSection[x]#" class="whtLinks">#APPLICATION.leftMenu.displaySection[x]#</a></td>
                        </tr>	

                    </cfloop>
                
                
                <!--- Display All Options --->
                <cfelse>

                    <cfloop from="1" to="#ArrayLen(APPLICATION.leftMenu.linkSection)#" index="x">

                        <tr onMouseOver="this.style.background='#APPLICATION.leftMenu.colorSection[x]#'" onMouseOut="this.style.background=''" <cfif URL.section EQ APPLICATION.leftMenu.linkSection[x]>bgcolor="#APPLICATION.leftMenu.colorSection[x]#"</cfif> >
                            <td><a href="/index.cfm?section=#APPLICATION.leftMenu.linkSection[x]#" class="whtLinks">#APPLICATION.leftMenu.displaySection[x]#</a></td>
                        </tr>	
                                
                    </cfloop>

                </cfif>
                
            </table>
            
        </div> <!--leftMenu -->
    
    </cfif>
    
</cfoutput>    