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
                    
                    <tr onMouseOver="this.style.background='#SESSION.LEFTMENU.colorSection[x]#'" onMouseOut="this.style.background=''" <cfif URL.section EQ SESSION.LEFTMENU.linkSection[x]>bgcolor="#SESSION.LEFTMENU.colorSection[x]#"</cfif> >
                        <td>#SESSION.LEFTMENU.displaySection[x]#</td>
                    </tr>	
                                                   
                </cfloop>
                
            </table>
            
        </div> <!--leftMenu -->
    
    </cfif>
    
</cfoutput>    