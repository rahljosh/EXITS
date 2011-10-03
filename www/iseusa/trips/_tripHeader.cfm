<!--- ------------------------------------------------------------------------- ----
	
	File:		_tripHeader.cfm
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		Header Links: Trips | Contact | Rules and Policies | Questions
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

</cfsilent>

<cfoutput>

	<!--- Breadcrumb --->
    <cfif ListFind("TripDetails,lookUpAccount,preferences,myTripDetails,bookTrip,confirmation", FORM.action)>
        <table width="665px" border="0" align="center" cellpadding="2" cellspacing="0" class="tripBreadCrumbNav">
            <tr>
                <td>
                    <cfswitch expression="#FORM.action#">
    
                        <cfcase value="TripDetails">
                            <a href="#CGI.SCRIPT_NAME#">[ Home ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=TripDetails" class="on">[ Details ]</a> 
                        </cfcase>

                        <cfcase value="myTripDetails">
                            <a href="#CGI.SCRIPT_NAME#">[ Home ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=TripDetails">[ Details ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=myTripDetails" class="on">[ My Trip Details ]</a> 
                        </cfcase>
    
                        <cfcase value="lookUpAccount">
                            <a href="#CGI.SCRIPT_NAME#">[ Home ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=TripDetails">[ Details ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=lookUpAccount" class="on">[ Look Up Account ]</a> 
                        </cfcase>
    
                        <cfcase value="preferences">
                            <a href="#CGI.SCRIPT_NAME#">[ Home ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=tripDetails">[ Details ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=preferences" class="on">[ Preferences ]</a> 
                        </cfcase>
    
                        <cfcase value="BookTrip">
                            <a href="#CGI.SCRIPT_NAME#">[ Home ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=tripDetails">[ Details ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=preferences">[ Preferences ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=BookTrip" class="on">[ Book Trip ]</a>
                        </cfcase>
    
                        <cfcase value="confirmation">
                            <a href="#CGI.SCRIPT_NAME#">[ Home ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#">[ Details ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#">[ Preferences ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#">[ Book Trip ]</a>
                            >
                            <a href="#CGI.SCRIPT_NAME#" class="on">[ Confirmation ]</a>            
                        </cfcase>
                    
                    </cfswitch>
                    
                    
                    <cfif VAL(SESSION.TOUR.isLoggedIn)>
                        <a href="#CGI.SCRIPT_NAME#?action=logOut" style="float:right; padding-right:5px;">[ Log Out ]</a>
                    </cfif>
					
                    <!---
                    <cfif 1 EQ 1>
                    	<a href="#CGI.SCRIPT_NAME#?action=myTrips" style="float:right;">[ My Trips ]</a>
                    </cfif>
					--->
                </td>
            </tr>  
	    </table>	
	</cfif>            

</cfoutput>