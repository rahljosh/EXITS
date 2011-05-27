<!--- ------------------------------------------------------------------------- ----
	
	File:		flightInfoMenu.cfm
	Author:		Marcus Melo
	Date:		May 26, 2011
	Desc:		Flight Information Report Menu

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfsetting requesttimeout="9999">
	
	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>		
		// Programs
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID,dateActive=1);

		// Get Regions
		qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(companyID=CLIENT.companyID, userID=CLIENT.userID, usertype=CLIENT.usertype);

		// List of Intl. Reps.
		qGetIntlRepList = APPLICATION.CFC.USER.getUsers(userType=8);
	</cfscript>
    
</cfsilent>

<!--- Table Header --->
<gui:tableHeader
	imageName="students.gif"
	tableTitle="Flight Information Reports"
/>

<cfoutput>

    <table border="0" cellpadding="8" cellspacing="2" width=100% class="section">
        <tr>
            <td width="50%" valign="top">

                <cfform action="reports/flight_information_report.cfm" method="post" target="blank">
                    <Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
                        <tr><th colspan="2" bgcolor="##e2efc7">Flight Arrival Information</th></tr>
                        <tr align="left">
                            <td>Program:</td>
                            <td>
                            	<select name="programID" multiple size="6">
		                            <cfloop query="qGetProgramList">
                                    	<option value="#qGetProgramList.programID#">#programName#</option>
									</cfloop>
                                </select>
							</td>
						</tr>
                        <tr align="left">
                            <td>Region:</td>
                            <td>
                            	<select name="regionid" size="1">
									<cfif ListFind("1,2,3,4", CLIENT.userType)>
	                                    <option value="0">All Regions</option>
                                    </cfif>
                                    <cfloop query="qGetRegionList"><option value="#regionid#">#regionname#</option></cfloop>
                                </select>
                            </td>
						</tr>
                        <tr><td colspan="2"><input type="checkbox" name="dates">&nbsp; Including Period Below (Arrival Date)</input></td></tr>
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
            
            <td width="50%" valign="top">
                
                <cfform action="reports/flight_info_depart_report.cfm" method="post" target="blank">
                    <Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
                        <tr><th colspan="2" bgcolor="##e2efc7">Flight Departure Information</th></tr>
                        <tr align="left">
                            <td>Program:</td>
                            <td>
                            	<select name="programID" multiple size="6">
		                            <cfloop query="qGetProgramList">
                                    	<option value="#qGetProgramList.programID#">#programName#</option>
									</cfloop>
                                </select>
							</td>
						</tr>
                        <tr align="left">
                            <td>Region:</td>
                            <td>
                            	<select name="regionid" size="1">
									<cfif ListFind("1,2,3,4", CLIENT.userType)>
	                                    <option value="0">All Regions</option>
                                    </cfif>
                                    <cfloop query="qGetRegionList">
                                    	<option value="#qGetRegionList.regionID#">#qGetRegionList.regionName#</option>
                                    </cfloop>
                                </select>
                            </td>
						</tr>
                        <tr><td colspan="2"><input type="checkbox" name="dates">&nbsp; Including Period Below (Arrival Date)</input></td></tr>
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
                    <Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
                        <tr><th colspan="2" bgcolor="##e2efc7">Flight Info Missing By Region</th></tr>
                        <tr align="left">
                            <td>Program:</td>
                            <td>
                            	<select name="programID" multiple size="6">
		                            <cfloop query="qGetProgramList">
                                    	<option value="#qGetProgramList.programID#">#programName#</option>
									</cfloop>
                                </select>
							</td>
						</tr>
                        <tr align="left">
                            <td>Region:</td>
                            <td>
                            	<select name="regionid" size="1">
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
                            	<select name="preayp" size="1">
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
            
            <td width="50%" valign="top">
                
                <cfform action="reports/flightInfoByInltRep.cfm" method="post" target="blank">
                    <Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
                        <tr><th colspan="2" bgcolor="##e2efc7">Received Flight Information By International Representative</th></tr>
                        <tr align="left">
                            <td>Program:</td>
                            <td>
                            	<select name="programID" multiple size="6">
		                            <cfloop query="qGetProgramList">
                                    	<option value="#qGetProgramList.programID#">#programName#</option>
									</cfloop>
                                </select>
							</td>
						</tr>
                        <tr align="left">
                            <td>Intl. Rep.</td>
                            <td>
                            	<select name="intRep" size="1">
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
                            	<select name="flightType" size="1">
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
        </tr>
    </table>

</cfoutput>

<!--- Table Footer --->
<gui:tableFooter />
