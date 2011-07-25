<!--- ------------------------------------------------------------------------- ----
	
	File:		flightInfoMenu.cfm
	Author:		Marcus Melo
	Date:		May 26, 2011
	Desc:		Flight Information Report Menu

	Updated:	Intl. Representatives have access to the Received Flight Info Report  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfsetting requesttimeout="9999">
	
	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>		
		// Intl. Representatives
		if ( CLIENT.userType EQ 8 ) {

			// List of Intl. Reps.
			qGetIntlRepList = APPLICATION.CFC.USER.getUsers(userID=CLIENT.userID);

		} else {

			// List of Intl. Reps.
			qGetIntlRepList = APPLICATION.CFC.USER.getUsers(userType=8);
			
		}

		// Programs
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(dateActive=1);

		// Get Regions
		qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(companyID=CLIENT.companyID, userID=CLIENT.userID, usertype=CLIENT.usertype);
	</cfscript>
    
</cfsilent>

<!--- Table Header --->
<gui:tableHeader
	imageName="students.gif"
	tableTitle="Flight Information Reports"
/>

<cfoutput>
    
        <table border="0" cellpadding="8" cellspacing="2" width=100% class="section">

			<!--- Office & Field Users --->
            <cfif ListFind("1,2,3,4,5,6,7", CLIENT.userType)>

                <tr>
                    <td width="50%" valign="top">
    
                        <form action="reports/flight_information_report.cfm" method="post" target="blank">
                            <Table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                                <tr><th colspan="2" bgcolor="##e2efc7">Flight Arrival Information</th></tr>
                                <tr>
                                    <td>Program:</td>
                                    <td>
                                        <select name="programID" multiple size="6">
                                            <cfloop query="qGetProgramList">
                                                <option value="#qGetProgramList.programID#">#programName#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Region:</td>
                                    <td>
                                        <select name="regionID">
                                            <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                                <option value="0">All Regions</option>
                                            </cfif>
                                            <cfloop query="qGetRegionList"><option value="#regionid#">#regionname#</option></cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Arrival Type:</td>
                                    <td>
                                        <select name="flight_type">
                                            <option value="arrival">Arrival to Host Family</option>
                                            <option value="preAypArrival">Arrival to Pre-Ayp</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr><td colspan="2">Including Period Below (Arrival Date)</td></tr>
                                <tr>
                                    <td>From:</td>
                                    <td><input type="text" name="date1" size="7" maxlength="10" class="datePicker"> mm-dd-yyyy</td>
                                </tr>
                                <tr>
                                    <td>To: </td>
                                    <td><input type="text" name="date2" size="7" maxlength="10" class="datePicker"> mm-dd-yyyy</td>
                                </tr>			
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
                            </table>
                        </form>
                    
	                </td>

	                <td width="50%" valign="top">

                        <cfform action="reports/flight_info_depart_report.cfm" method="post" target="blank">
                            <Table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                                <tr><th colspan="2" bgcolor="##e2efc7">Flight Departure Information</th></tr>
                                <tr>
                                    <td>Program:</td>
                                    <td>
                                        <select name="programID" multiple size="6">
                                            <cfloop query="qGetProgramList">
                                                <option value="#qGetProgramList.programID#">#programName#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Region:</td>
                                    <td>
                                        <select name="regionid">
                                            <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                                <option value="0">All Regions</option>
                                            </cfif>
                                            <cfloop query="qGetRegionList">
                                                <option value="#qGetRegionList.regionID#">#qGetRegionList.regionName#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr><td colspan="2"><input type="checkbox" name="dates">&nbsp; Including Period Below (Departure Date)</input></td></tr>
                                <tr>
                                    <td width="5">From:</td>
                                    <td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date" class="datePicker"> mm-dd-yyyy</td>
                                </tr>
                                <tr>
                                    <td width="5">To: </td>
                                    <td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date" class="datePicker"> mm-dd-yyyy</td>
                                </tr>			
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
                            </table>
                        </cfform>

                    </td>
                </tr>
    			
                <tr>
	                <td width="50%" valign="top">
    
                        <cfform action="reports/flight_info_missing_by_region.cfm" method="post" target="blank">
                            <Table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                                <tr><th colspan="2" bgcolor="##e2efc7">Flight Info Missing By Region</th></tr>
                                <tr>
                                    <td>Program:</td>
                                    <td>
                                        <select name="programID" multiple size="6">
                                            <cfloop query="qGetProgramList">
                                                <option value="#qGetProgramList.programID#">#programName#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Region:</td>
                                    <td>
                                        <select name="regionid">
                                            <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                                <option value="0">All Regions</option>
                                            </cfif>
                                            <cfloop query="qGetRegionList">
                                                <option value="#qGetRegionList.regionID#">#qGetRegionList.regionName#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Pre-AYP :</td>
                                    <td>
                                        <select name="preayp">
                                            <option value='none'>None</option>
                                            <option value="english">English Camp</option>
                                            <option value="orientation">Orientation Camp</option>
                                            <option value="all">Both Camps</option>
                                        </select>
                                    </td>
                                </tr>	
                                <tr><td colspan="2">Date Placed (leave blank for no filter):</td></tr>
                                <tr>
                                    <td width="5">From:</td>
                                    <td><cfinput type="text" name="place_date1" size="7" maxlength="10" validate="date" class="datePicker"> mm-dd-yyyy</td>
                                </tr>
                                <tr>
                                    <td width="5">To: </td>
                                    <td><cfinput type="text" name="place_date2" size="7" maxlength="10" validate="date" class="datePicker"> mm-dd-yyyy</td>
                                </tr>			
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
                            </table>
                        </cfform>
                    
	    	        </td>
		            
                    <td width="50%" valign="top">&nbsp;
                    	
                    </td>        
            	
                </tr>
            
			</cfif> <!--- Office & Field Users --->
	                

			<!--- Office & Intl. Rep. --->
            <cfif ListFind("1,2,3,4,8", CLIENT.userType)>

                <tr>
            
	                <td width="50%" valign="top">
                    
                        <cfform action="reports/flightInfoByInltRep.cfm" method="post" target="blank">
                            <Table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                                <tr><th colspan="2" bgcolor="##e2efc7">Received Flight Information By International Representative</th></tr>
                                <tr>
                                    <td>Program:</td>
                                    <td>
                                        <select name="programID" multiple size="6">
                                            <cfloop query="qGetProgramList">
                                                <option value="#qGetProgramList.programID#">#programName#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Intl. Rep.</td>
                                    <td>
                                        <select name="intRep">
                                            <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                                <option value="0">All Intl. Rep.</option>
                                            </cfif>
                                            <cfloop query="qGetIntlRepList">
                                                <option value="#qGetIntlRepList.userID#">#qGetIntlRepList.businessName#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Flight Type :</td>
                                    <td>
                                        <select name="flightType">
                                            <option value=""></option>
                                            <option value="preAypArrival">Pre-Ayp Arrival</option>
                                            <option value="Arrival">Arrival</option>
                                            <option value="Departure">Departure</option>
                                        </select>
                                    </td>
                                </tr>	
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
                            </table>
                        </cfform>

                    </td>
                    
                    <td width="50%" valign="top">&nbsp;
                    	
                    </td>   
                         
	            </tr>

			</cfif> <!--- Office & Intl. Rep. --->
                
        </table>

</cfoutput>

<!--- Table Footer --->
<gui:tableFooter />
