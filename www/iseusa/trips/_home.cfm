<!--- ------------------------------------------------------------------------- ----
	
	File:		home.cfm
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		MPD Tours
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<style type="text/css">
<!--
	.whtMiddleTrips {
		margin: 0px;
		height: auto;
		min-height: 1500px;
		text-align: justify;
		padding:5px 0px 0px 0px;
		background-repeat: repeat-y;
		background-image: url(../images/whtBoxMiddle.png);
	}
-->
</style>

<cfoutput>
    
    <div class="whtMiddleTrips">    
        
        <div class="trips">
    
			<!--- Include Trip Header --->
            <cfinclude template="_tripHeader.cfm">
        
            <h1 class="enter">ISE Student Trips</h1>
            
            <div style="font-weight:bold; color:##be1e2d; text-align:center; font-size:1.2em;">For ISE students ONLY!</div>
            
            <p>International Student Exchange and our partner organization, MPD Tour America are proud to offer this year's ISE Trips of exciting adventures across America. MPD Tour America will be organizing 9 ISE trips, chaperoned and supervised exclusively by ISE Representatives, for the 2010-11 season.<br /><br />
            
            <strong>NEW THIS SEASON: STUDENTS DO NOT PURCHASE THEIR OWN AIRFARE.  Once you are registered for a tour, you will be contacted regarding airfare.</strong></p>
        
            <table width="573" height="333" border="0">
                <tr>
                    <td colspan="4" align="4"> 
                        <cfif NOT VAL(qGetTourList.recordcount)>
                            <h3><div align="center">Trips will be available for booking on Sept. 15<br />  Please check back on that date to book your trip.</div></h3>
                        </cfif>
                    </td>
                </tr>
                <tr>
                <cfloop query="qGetTourList">
                    <td width="285" height="178" class="lightGreen" scope="row">
                        <form action="#CGI.SCRIPT_NAME#?action=tripDetails" method="post">
                            <input type="hidden" name="action" value="TripDetails" />
                            <input type="hidden" name="tourID" value="#qGetTourList.tour_id#" />
                            <input type="image" name="submit" src="images/trips_#qGetTourList.tour_id#.png" alt="#qGetTourList.tour_name# Details" /> <br />
                            <strong>#qGetTourList.tour_name#</strong><br />
                            #qGetTourList.tour_date#<br />
                            Status: <cfif qGetTourList.tour_status EQ 'Active'>Seats Available<cfelse>#qGetTourList.tour_status#</cfif><br /><br />
                        </form>
                    </td>
                    <cfif currentrow MOD 2 EQ 0> 
                        </tr>
                        <tr>
                        </tr>
                    </cfif>
                </cfloop>    
            </table>
            
        </div>
    
    </div><!-- end whtMiddleTrips -->
                        
</cfoutput>