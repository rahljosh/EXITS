<style type="text/css">
<!--
#leftSide .whtLinks {
font-family: Arial, Helvetica, sans-serif;
font-size: 12px;
color: #FFF;
text-decoration: none;
}
#leftSide .whtLinks:links{
font-family: Arial, Helvetica, sans-serif;
font-size: 12px;
color: #FFF;
text-decoration: none;
}
#leftSide .whtLinks:hover{
color: #000;
text-decoration: none;
}
#leftSide .whtLinks:active{
color: #FFF;
text-decoration: none;
}
-->
</style>

<div id="leftSide">

    <table width="154" border="0" border="1">
        <tr onMouseOver="this.style.background='#8cc540'" onMouseOut="this.style.background=''" <cfif URL.page is 'hello'>bgcolor="#8cc540"</cfif> >
            <td><a href="?page=hello" class="whtLinks">Overview</a></td>
        </tr>	
        
        <cfif CLIENT.hostAppStatus GT 7>
        
            <tr onMouseOver="this.style.background='#f6931e'" onMouseOut="this.style.background=''" <cfif URL.page is 'startHostApp'>bgcolor="#f6931e"</cfif> >
                <td><a href="?page=startHostApp" class="whtLinks">Name & Contact Info</a></td>
            </tr>
            
            <tr onMouseOver="this.style.background='#8cc540'" onMouseOut="this.style.background=''" <cfif URL.page is 'familyMembers'>bgcolor="#8cc540"</cfif> > 
                <td><a href="?page=familyMembers" class="whtLinks">Family Members</a></td>
            </tr>
            
            <tr onMouseOver="this.style.background='#c0272c'" onMouseOut="this.style.background=''" <cfif URL.page is 'familyQuestionInterupt'>bgcolor="#c0272c"</cfif> > 
                <td><a href="?page=familyQuestionInterupt" class="whtLinks">Background Checks</a></td>
            </tr>
            
            <tr onMouseOver="this.style.background='#0171bd'" onMouseOut="this.style.background=''" <cfif URL.page is 'hostLetter'>bgcolor="#0171bd"</cfif> > 
                <td><a href="?page=hostLetter" class="whtLinks">Personal Description</a></td>
            </tr>
            
            <tr onMouseOver="this.style.background='#f6931e'" onMouseOut="this.style.background=''" <cfif URL.page is 'roomPetsSmoke'>bgcolor="#f6931e"</cfif> > 
                <td><a href="?page=roomPetsSmoke" class="whtLinks">Hosting Environment</a></td>
            </tr>
            
            <tr onMouseOver="this.style.background='#c0272c'" onMouseOut="this.style.background=''" <cfif URL.page is 'religionPref'>bgcolor="#c0272c"</cfif> >
                <td><a href="?page=religionPref" class="whtLinks">Religious Preference</a></td>
            </tr>	
            
            <tr onMouseOver="this.style.background='#8cc540'" onMouseOut="this.style.background=''" <cfif URL.page is 'familyRules'>bgcolor="#8cc540"</cfif> > 
                <td><a href="?page=familyRules" class="whtLinks">Family Rules</a></td>
            </tr>
            
            <tr onMouseOver="this.style.background='#8cc540'" onMouseOut="this.style.background=''" <cfif URL.page is 'familyAlbum'>bgcolor="#8cc540"</cfif> > 
                <td><a href="?page=familyAlbum" class="whtLinks">Family Album</a></td>
            </tr>
            
            <tr onMouseOver="this.style.background='#0171bd'" onMouseOut="this.style.background=''" <cfif URL.page is 'schoolInfo'>bgcolor="#0171bd"</cfif> > 
                <td><a href="?page=schoolInfo" class="whtLinks">School Info</a></td>
            </tr>
            
            <tr onMouseOver="this.style.background='#00aeef'" onMouseOut="this.style.background=''" <cfif URL.page is 'communityProfile'>bgcolor="#00aeef"</cfif> > 
                <td><a href="?page=communityProfile" class="whtLinks">Community Profile</a></td>
            </tr>
            
            <tr onMouseOver="this.style.background='#c0272c'" onMouseOut="this.style.background=''" <cfif URL.page is 'demographicInfo'>bgcolor="#c0272c"</cfif> >
                <td><a href="?page=demographicInfo" class="whtLinks">Confidential Data </a></td>
            </tr>
            
            <tr onMouseOver="this.style.background='#f6931e'" onMouseOut="this.style.background=''" <cfif URL.page is 'references'>bgcolor="#f6931e"</cfif> >
                <td><a href="?page=references" class="whtLinks">References</a></td>
            </tr>	
            
            <tr onMouseOver="this.style.background='#8cc540'" onMouseOut="this.style.background=''" <cfif URL.page is 'checkList'>bgcolor="#8cc540"</cfif> > 
                <td><a href="?page=checkList" class="whtLinks">Checklist</a></td>
            </tr>
        
        </cfif>
        
        <tr onMouseOver="this.style.background='#f6931e'" onMouseOut="this.style.background=''"> 
            <td><a href="logout.cfm" class="whtLinks">Logout</a></td>
        </tr>
    </table>
    
    <div class="clearfix">&nbsp;</div>

</div> <!--leftside -->
