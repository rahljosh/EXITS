<!--- ------------------------------------------------------------------------- ----
	
	File:		leftMenu.cfm
	Author:		Marcus Melo
	Date:		November 12, 2012
	Desc:		Left Menu

	Updated:	

----- ------------------------------------------------------------------------- --->

<!--- Display Menu for Logged In Applications --->
<cfif APPLICATION.CFC.SESSION.getHostSession().ID>

    <div id="leftMenu">
    
        <table width="154" border="0" border="1">
            <tr onMouseOver="this.style.background='#8cc540'" onMouseOut="this.style.background=''" <cfif URL.section EQ 'overview'>bgcolor="#8cc540"</cfif> >
                <td><a href="?section=overview" class="whtLinks">Overview</a></td>
            </tr>	
            
            <cfif NOT APPLICATION.CFC.SESSION.getHostSession().isMenuBlocked>
            
                <tr onMouseOver="this.style.background='#00aeef'" onMouseOut="this.style.background=''" <cfif URL.section EQ 'contactInfo'>bgcolor="#00aeef"</cfif> >
                    <td><a href="?section=contactInfo" class="whtLinks">Name & Contact Info</a></td>
                </tr>
                
                <tr onMouseOver="this.style.background='#f6931e'" onMouseOut="this.style.background=''" <cfif URL.section EQ 'familyMembers'>bgcolor="#f6931e"</cfif> > 
                    <td><a href="?section=familyMembers" class="whtLinks">Family Members</a></td>
                </tr>
                
                <tr onMouseOver="this.style.background='#c0272c'" onMouseOut="this.style.background=''" <cfif URL.section EQ 'cbcAuthorization'>bgcolor="#c0272c"</cfif> > 
                    <td><a href="?section=cbcAuthorization" class="whtLinks">Background Checks</a></td>
                </tr>
                
                <tr onMouseOver="this.style.background='#0171bd'" onMouseOut="this.style.background=''" <cfif URL.section EQ 'personalDescription'>bgcolor="#0171bd"</cfif> > 
                    <td><a href="?section=personalDescription" class="whtLinks">Personal Description</a></td>
                </tr>
                
                <tr onMouseOver="this.style.background='#8cc540'" onMouseOut="this.style.background=''" <cfif URL.section EQ 'hostingEnvironment'>bgcolor="#8cc540"</cfif> > 
                    <td><a href="?section=hostingEnvironment" class="whtLinks">Hosting Environment</a></td>
                </tr>
                
                <tr onMouseOver="this.style.background='#00aeef'" onMouseOut="this.style.background=''" <cfif URL.section EQ 'religiousPreference'>bgcolor="#00aeef"</cfif> >
                    <td><a href="?section=religiousPreference" class="whtLinks">Religious Preference</a></td>
                </tr>	
                
                <tr onMouseOver="this.style.background='#f6931e'" onMouseOut="this.style.background=''" <cfif URL.section EQ 'familyRules'>bgcolor="#f6931e"</cfif> > 
                    <td><a href="?section=familyRules" class="whtLinks">Family Rules</a></td>
                </tr>
                
                <tr onMouseOver="this.style.background='#c0272c'" onMouseOut="this.style.background=''" <cfif URL.section EQ 'familyAlbum'>bgcolor="#c0272c"</cfif> > 
                    <td><a href="?section=familyAlbum" class="whtLinks">Family Album</a></td>
                </tr>
                
                <tr onMouseOver="this.style.background='#0171bd'" onMouseOut="this.style.background=''" <cfif URL.section EQ 'schoolInfo'>bgcolor="#0171bd"</cfif> > 
                    <td><a href="?section=schoolInfo" class="whtLinks">School Info</a></td>
                </tr>
                
                <tr onMouseOver="this.style.background='#8cc540'" onMouseOut="this.style.background=''" <cfif URL.section EQ 'communityProfile'>bgcolor="#8cc540"</cfif> > 
                    <td><a href="?section=communityProfile" class="whtLinks">Community Profile</a></td>
                </tr>
                
                <tr onMouseOver="this.style.background='#00aeef'" onMouseOut="this.style.background=''" <cfif URL.section EQ 'confidentialData'>bgcolor="#00aeef"</cfif> >
                    <td><a href="?section=confidentialData" class="whtLinks">Confidential Data </a></td>
                </tr>
                
                <tr onMouseOver="this.style.background='#f6931e'" onMouseOut="this.style.background=''" <cfif URL.section EQ 'references'>bgcolor="#f6931e"</cfif> >
                    <td><a href="?section=references" class="whtLinks">References</a></td>
                </tr>	

                <tr onMouseOver="this.style.background='#c0272c'" onMouseOut="this.style.background=''" <cfif URL.section EQ 'checkList'>bgcolor="#c0272c"</cfif> > 
                    <td><a href="?section=checkList" class="whtLinks">Checklist</a></td>
                </tr>
                
			</cfif>
            
            <tr onMouseOver="this.style.background='#0171bd'"> 
                <td><a href="logout.cfm" class="whtLinks">Logout</a></td>
            </tr>
        </table>
        
    </div> <!--leftMenu -->

</cfif>
