<!--- ------------------------------------------------------------------------- ----
	
	File:		_breadCrumb.cfm
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		Header Links: Trips | Contact | Rules and Policies | Questions
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->
<cfoutput>

	<!--- Breadcrumb --->
    <cfif ListFind("tripDetails,lookUpAccount,preferences,myTripDetails,bookTrip,confirmation,reservationSeat,reservationConfirmed,reservationDetails", FORM.action)>
    	
        <table width="665px" border="0" align="center" cellpadding="2" cellspacing="0" class="tripBreadCrumbNav">
            <tr>
                <td>
                    <cfswitch expression="#FORM.action#">
    
                        <cfcase value="tripDetails">
                            <a href="#CGI.SCRIPT_NAME#">[ Home ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=tripDetails" class="on">[ Details ]</a> 
                        </cfcase>

                        <cfcase value="myTripDetails">
                            <a href="#CGI.SCRIPT_NAME#">[ Home ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=tripDetails">[ Details ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=myTripDetails" class="on">[ My Trip Details ]</a> 
                        </cfcase>
    
                        <cfcase value="lookUpAccount">
                            <a href="#CGI.SCRIPT_NAME#">[ Home ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=tripDetails">[ Details ]</a> 
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
    
                        <cfcase value="bookTrip">
                            <a href="#CGI.SCRIPT_NAME#">[ Home ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=tripDetails">[ Details ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=preferences">[ Preferences ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=bookTrip" class="on">[ Book Trip ]</a>
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

                        <cfcase value="reservationSeat">
                            <a href="#CGI.SCRIPT_NAME#">[ Home ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=tripDetails">[ Details ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=preferences">[ Preferences ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=reservationSeat" class="on">[ Reserve Spot ]</a>
                        </cfcase>
    
                        <cfcase value="reservationConfirmed">
                            <a href="#CGI.SCRIPT_NAME#">[ Home ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#">[ Details ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#">[ Preferences ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#">[ Reserve Spot ]</a>
                            >
                            <a href="#CGI.SCRIPT_NAME#" class="on">[ Confirmation ]</a>            
                        </cfcase>
                    
                        <cfcase value="reservationDetails">
                            <a href="#CGI.SCRIPT_NAME#">[ Home ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=tripDetails">[ Details ]</a> 
                            > 
                            <a href="#CGI.SCRIPT_NAME#?action=reservationDetails" class="on">[ My Reservation Details ]</a> 
                        </cfcase>
                    
                    </cfswitch>
                    
                    <cfif VAL(SESSION.TOUR.isLoggedIn)>
                        <a href="#CGI.SCRIPT_NAME#?action=logOut" style="float:right; padding-right:5px;">[ Log Out ]</a>
                    </cfif>

                </td>
            </tr>  
	    </table>	
	</cfif>            

</cfoutput>