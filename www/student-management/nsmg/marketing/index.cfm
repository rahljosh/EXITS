<cfquery name="marketingMaterial" datasource="#application.dsn#">
select *
from smg_marketingmaterial	 
</cfquery>

<cfoutput>
	<!--- Table Header --->
  <div class="rdholder"> 
   		<div class="rdtop"><span class="rdtitle">Marketing Materials</span></div> <!-- end top --> 
        <div class="rdbox">
    	
       <table cellpadding="8" cellspacing="0" width="100%">
       		<Tr>
            	<td>
                <Cfif url.type is 'sm'>
                	<img src="marketing/social-media-2.png" />
                <cfelse>
                	<img src="marketing/print-2.png" />
                </Cfif>
                 </td><td><h2>
                  <Cfif url.type is 'sm'>
                 Use these materials on your various social media threads:  Facebook, Twitter, Google +, etc. <br /> Once you open the image, save it to your computer and then post as necessary.
                   <cfelse>
                  Generate print quality versions of these materials that you want to hand out or post at various fairs, gatherings, etc.<br />  Once you open the image, save it to your computer and then print as necessary.
                 </Cfif>
                 </h2></td><td></td>
            </Tr>
       <table cellpadding="8" cellspacing="0" width="100%">
       <tr>
       <cfloop query="marketingMaterial">
       	<td><br>
        	<Cfif url.type is 'sm'><a href="marketing/#printImage#" download="#name#" title="#name#" class="orangeButton"><img src=marketing/#icon# height=250></a></Cfif>
           <Cfif url.type is 'pr'><a href="marketing/#printLink#" class="orangeButton"><img src=marketing/#icon# height=250></a></Cfif></td>
       </td>
       <cfif currentrow mod 4 eq 0>
       		</tr><tr>
       </cfif>
       </cfloop>
       </table>
    
    
    <!--- Table Footer --->
 </div>
   		<div class="rdbottom"></div> <!-- end bottom --> 
    </div>
</cfoutput>