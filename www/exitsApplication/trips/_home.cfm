<!--- ------------------------------------------------------------------------- ----
	
	File:		home.cfm
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		MPD Tours
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<cfoutput>
    
	<!--- Include Trip Header --->
    <cfinclude template="_breadCrumb.cfm">

    <h1>Student Trips</h1>
    
    <table width="600" height="333" border="0" align="center">
        <tr>
            <td colspan="4"> 
                <div style="font-weight:bold; color:##be1e2d; text-align:center; font-size:1.2em;">For our partner exchange organization students ONLY!</div>
                
                <p>
                    #APPLICATION.MPD.name# and our partner exchange organizations are proud to offer this year's Student Exchange Trips of exciting adventures across America.
                    #APPLICATION.MPD.name# will be organizing 10 trips, chaperoned and supervised exclusively by our representatives for the 2012-13 season.
                </p>
                
                <strong>NEW THIS SEASON: STUDENTS DO NOT PURCHASE THEIR OWN AIRFARE.  Once you are registered for a tour, you will be contacted regarding airfare.</strong></p>
            </td>
        </tr> 
        
        <cfif NOT VAL(qGetTourList.recordcount)>           
            <tr>
                <td colspan="4"> 
                    <h3><div align="center">Please check back on Sept 30th for new trip availability.</div></h3>
                </td>
            </tr>
        </cfif>
        
        <tr>
        <cfloop query="qGetTourList">
            <td width="285" height="270" class="bBackground" scope="row">
                <form action="#CGI.SCRIPT_NAME#?action=tripDetails" method="post">
                    <input type="hidden" name="action" value="tripDetails" />
                    <input type="hidden" name="tourID" value="#qGetTourList.tour_id#" />
                    <cfif APPLICATION.isServerLocal>
                    	<input type="image" name="submit" src="https://smg.local/nsmg/uploadedfiles/student-tours/#qGetTourList.tour_img1#.jpg" alt="#qGetTourList.tour_name# Details" /> <br />
                   	<cfelse>
                    	<input type="image" name="submit" src="https://ise.exitsapplication.com/nsmg/uploadedfiles/student-tours/#qGetTourList.tour_img1#.jpg" alt="#qGetTourList.tour_name# Details" /> <br />
                    </cfif>
                    
                    <p style="font-weight:bold; margin:3px;">#qGetTourList.tour_name#</p>
                    
                    <p style="margin:3px;">#qGetTourList.tour_date#</p>
                    
                    <p style="margin:3px;">
                   		Status: 
                        <strong>
							<cfif qGetTourList.tour_status EQ 'Cancelled'>
                            	Cancelled
                            <cfelseif qGetTourList.totalRegistrations LT qGetTourList.spotLimit>
                                Seats Available
							<cfelseif qGetTourList.totalRegistrations GTE qGetTourList.totalSpots>
								Full - No more seats available
                            <cfelseif qGetTourList.totalRegistrations GTE qGetTourList.spotLimit AND ( VAL(qGetTourList.extraMaleSpot) OR VAL(qGetTourList.extraFemaleSpot) )>
                            	Limited Seats Available
							<cfelseif qGetTourList.totalRegistrations GTE qGetTourList.spotLimit AND NOT VAL(qGetTourList.extraMaleSpot) AND NOT VAL(qGetTourList.extraFemaleSpot)>
								Full - No more seats available
                            <cfelse>
                            	Full - No more seats available             
							</cfif>
                        </strong>    
                    </p>
                </form>
            </td>
            <cfif currentrow MOD 2 EQ 0> 
                </tr>
                <tr>
                </tr>
            </cfif>
        </cfloop>    
    </table>
                        
</cfoutput>