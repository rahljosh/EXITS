<!--- ------------------------------------------------------------------------- ----
	
	File:		leftMenu.cfm
	Author:		Marcus Melo
	Date:		November 12, 2012
	Desc:		Left Menu

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfoutput>

	<!--- Display Menu for Logged In Applications --->
    <cfif APPLICATION.CFC.SESSION.getHostSession().ID>
    
        <div id="leftMenu">
        
            <table width="154" border="0" border="1">
        
				<!--- Loop Through Complete Menu --->
                <cfloop from="1" to="#ArrayLen(SESSION.LEFTMENU.linkSection)#" index="x">
                	<!--- Do not display section 5 (W9) if this is not company 14 (ESI) --->
                    <cfif qGetHostFamilyInfo.companyID NEQ 14 AND x NEQ 6>
                        <tr onMouseOver="this.style.background='#SESSION.LEFTMENU.colorSection[x]#'" onMouseOut="this.style.background=''" <cfif URL.section EQ SESSION.LEFTMENU.linkSection[x]>bgcolor="#SESSION.LEFTMENU.colorSection[x]#"</cfif> >
                            <td>#SESSION.LEFTMENU.displaySection[x]#</td>
                        </tr>
                  	<cfelseif qGetHostFamilyInfo.companyID EQ 14>
                    	<tr onMouseOver="this.style.background='#SESSION.LEFTMENU.colorSection[x]#'" onMouseOut="this.style.background=''" <cfif URL.section EQ SESSION.LEFTMENU.linkSection[x]>bgcolor="#SESSION.LEFTMENU.colorSection[x]#"</cfif> >
                            <td>#SESSION.LEFTMENU.displaySection[x]#</td>
                        </tr>
                  	</cfif>	
                                                   
                </cfloop>
                
            </table>
            
        </div> <!--leftMenu -->
    
    </cfif>
    
</cfoutput>    