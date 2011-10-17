<!--- ------------------------------------------------------------------------- ----
	
	File:		error-message.cfm
	Author:		Marcus Melo
	Date:		October 14, 2011
	Desc:		MPD Tour Trips - Error
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->
<cfoutput>
    
    <!--- Include Header ---> 
    <cfinclude template="extensions/includes/header.cfm">
                    
          <h1 class="enter">An Error Has Occurred</h1>
          
          <table width="100%" border="0" align="center">
              <tr>
                  <th class="bBackground">
              
                    <p>We are sorry, a system error has occurred.</p>
                    
                    <p>Please try again later.</p>

                    <h2 class="upperCase">#APPLICATION.MPD.name#</h2>
                    <p>
                        #APPLICATION.MPD.address#<br />
                        #APPLICATION.MPD.city#, #APPLICATION.MPD.state# #APPLICATION.MPD.zipCode#<br /><br />
                        
                        TOLL FREE: #APPLICATION.MPD.tollFree#<br />
                        TELEPHONE: #APPLICATION.MPD.phone#<br />
                        FAX: #APPLICATION.MPD.fax#<br /><br />
                        
                        E-MAIL: <a href="mailto:#APPLICATION.MPD.email#">#APPLICATION.MPD.email#</a>
                    </p>

              	</td>
          	</tr>                    
		</table>
      
    <!--- Include Footer ---> 
    <cfinclude template="extensions/includes/footer.cfm">
    
</cfoutput>