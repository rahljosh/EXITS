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

<cfquery name="churchCheck" datasource="mysql">
select churchid 
from smg_hosts
where hostid = #client.hostid#
</cfquery>
<div id="leftSide">
<table width="154" border="0" border=1>
  <tr onMouseOver="this.style.background='#8cc540'" onMouseOut="this.style.background=''">
   		
    <td <cfif url.page is 'hello'> </cfif>><a href="?page=hello" class="whtLinks">Overview</a></td>
  </tr>	
  <tr onMouseOver="this.style.background='#f6931e'" onMouseOut="this.style.background=''" <cfif url.page is 'startHostApp'>bgcolor="#f6931e" </cfif>>
 
     <td <cfif url.page is 'startHostApp'></cfif> > <a href="?page=startHostApp" class="whtLinks">Name & Contact Info</a></a></td>
  </tr>
  <tr onMouseOver="this.style.background='#8cc540'" onMouseOut="this.style.background=''" <cfif url.page is 'familyMembers'>bgcolor="#8cc540"</cfif>> 
  	
  	<td <cfif url.page is 'familyMembers'></cfif>><a href="?page=familyMembers" class="whtLinks">Family Members</a></td>
  </tr>
  <tr onMouseOver="this.style.background='#c0272c'" onMouseOut="this.style.background=''" <cfif url.page is 'familyQuestionInterupt'>bgcolor="#c0272c"</cfif>> 
  	
  	<td <cfif url.page is 'familyQuestionInterupt'></cfif>><a href="?page=familyQuestionInterupt" class="whtLinks">Background Checks</a></td>
  </tr>
  <tr onMouseOver="this.style.background='#00aeef'" onMouseOut="this.style.background=''" <cfif url.page is 'familyInterests'>bgcolor="#00aeef" </cfif>> 
  	
  	<td <cfif url.page is 'familyInterests'> </cfif>><a href="?page=familyInterests" class="whtLinks">Interests</a></td>
  </tr>
  <tr onMouseOver="this.style.background='#0171bd'" onMouseOut="this.style.background=''" <cfif url.page is 'hostLetter'>bgcolor="#0171bd"   </cfif>> 
  	
    <td <cfif url.page is 'hostLetter'>  </cfif>><a href="?page=hostLetter" class="whtLinks">Personal Description</a></td>
  </tr>
  <tr onMouseOver="this.style.background='#8cc540'" onMouseOut="this.style.background=''" <cfif url.page is 'familyAlbum'>bgcolor="#8cc540" </cfif>> 
  	
    <td <cfif url.page is 'familyAlbum'> </cfif>><a href="?page=familyAlbum" class="whtLinks">Family Album</a></td>
  </tr>
  <tr onMouseOver="this.style.background='#f6931e'" onMouseOut="this.style.background=''" <cfif url.page is 'roomPetsSmoke'>bgcolor="#f6931e"  </cfif>> 
  	
    <td <cfif url.page is 'roomPetsSmoke'> </cfif>><a href="?page=roomPetsSmoke" class="whtLinks">Hosting Environment</a></td>
  </tr>
  <tr onMouseOver="this.style.background='#c0272c'" onMouseOut="this.style.background=''" <cfif url.page is 'religionPref'>bgcolor="#c0272c" </cfif>>
    
    <td <cfif url.page is 'religionPref'> </cfif>><a href="?page=religionPref" class="whtLinks">Religious Preference</a></td>
  </tr>	
  <!----If a church has been specified, show link to info---->
  <cfif churchCheck.churchid gt 0>
  <tr onMouseOver="this.style.background='#8cc540'" onMouseOut="this.style.background=''" <cfif url.page is 'churchInfo'>bgcolor="#8cc540" </cfif>>

    <td <cfif url.page is 'churchInfo'> </cfif>><a href="?page=churchInfo" class="whtLinks">Religious Institution</a></td>
  </tr>	
  </cfif>
  <tr onMouseOver="this.style.background='#00aeef'" onMouseOut="this.style.background=''" <cfif url.page is 'communityProfile'>bgcolor="#00aeef" </cfif>> 

    <td <cfif url.page is 'communityProfile'> </cfif>><a href="?page=communityProfile" class="whtLinks">Community Profile</a></td>
  </tr>
  <tr onMouseOver="this.style.background='#0171bd'" onMouseOut="this.style.background=''" <cfif url.page is 'schoolInfo'>bgcolor="#0171bd"  </cfif>> 

    <td <cfif url.page is 'schoolInfo'> </cfif>><a href="?page=schoolInfo" class="whtLinks">School Info</a></td>
  </tr>
  <tr onMouseOver="this.style.background='#8cc540'" onMouseOut="this.style.background=''" <cfif url.page is 'familyRules'>bgcolor="#8cc540"  </cfif>> 

    <td <cfif url.page is 'familyRules'> </cfif>><a href="?page=familyRules" class="whtLinks">Family Rules</a></td>
  </tr>
  <tr onMouseOver="this.style.background='#f6931e'" onMouseOut="this.style.background=''" <cfif url.page is 'references'>bgcolor="#f6931e"  </cfif>>

    <td <cfif url.page is 'references'> </cfif>><a href="?page=references" class="whtLinks">References</a></td>
  </tr>	
  <tr onMouseOver="this.style.background='#c0272c'" onMouseOut="this.style.background=''" <cfif url.page is 'demographicInfo'>bgcolor="#c0272c"  </cfif>>
  	
     <td <cfif url.page is 'demographicInfo'> </cfif>><a href="?page=demographicInfo" class="whtLinks">Finance Data </a></td>
  </tr>
  <Tr>
  	<td align="center"><img src="../../images/HostAppButton.png" width=110  /></td> 
  </Tr>
</table>
<div class="clearfix">&nbsp;</div>
<!--leftside --></div>
