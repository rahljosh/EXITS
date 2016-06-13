<!--- ------------------------------------------------------------------------- ----
	
	File:		contact-us.cfm
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		MPD Tour Trips - Index
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->
<cfoutput>
    
    <!--- Include Header ---> 
    <cfinclude template="extensions/includes/header.cfm">
                    
        <h1>Student Tours Contact</h1>
        
        <table width="100%" border="0" align="center">
            <tr>
                <td>
                    #APPLICATION.MPD.name# and our partner exchange organizations are proud to offer this year's Student Exchange Trips of exciting adventures across America.
                    #APPLICATION.MPD.name# will be organizing 8 trips, chaperoned and supervised exclusively by our representatives for the 2016-17 season.
                    
                    <img src="extensions/images/webStore_lines_03.gif" width="600" height="15" alt="line" style="margin:10px 0px 10px 0px;" />
                </td>
            </tr>
            <tr>
                <th class="bBackground">
                    <h2 class="upperCase">#APPLICATION.MPD.name#</h2>
                    <p>
                        #APPLICATION.MPD.address#<br />
                        #APPLICATION.MPD.city#, #APPLICATION.MPD.state# #APPLICATION.MPD.zipCode#<br /><br />
                        
                        TOLL FREE: #APPLICATION.MPD.tollFree#<br />
                        TELEPHONE: #APPLICATION.MPD.phone#<br />
                        FAX: #APPLICATION.MPD.fax#<br /><br />
                        
                        E-MAIL: <a href="mailto:#APPLICATION.MPD.email#">#APPLICATION.MPD.email#</a>
                    </p>
                </th>
            </tr>
		</table>
                      
    <!--- Include Footer ---> 
    <cfinclude template="extensions/includes/footer.cfm">
    
</cfoutput>