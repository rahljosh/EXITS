<!--- ------------------------------------------------------------------------- ----
	
	File:		overall_reports_menu.cfm
	Author:		Marcus Melo
	Date:		June 13, 2011
	Desc:		Reports Menu
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfparam name="URL.showAllPrograms" default="0">
    
	<cfscript>
		// Get AYP English Camps
		qAYPEnglishCamps = APPCFC.SCHOOL.getAYPCamps(campType='english');	
		
		if ( URL.showAllPrograms EQ 1 ) {
			reportRightTitle = '<a href="?curdoc=reports/overall_reports_menu&showAllPrograms=1">Show All Programs</a>';
		} else {
			reportRightTitle = '<a href="?curdoc=reports/overall_reports_menu&showAllPrograms=0">Show Active Programs Only</a>';
		}
	</cfscript>
	
	<cfinclude template="../querys/get_programs.cfm">
	
	<cfinclude template="../querys/get_regions.cfm">
	
	<cfinclude template="../querys/get_intl_rep.cfm">
	
	<cfinclude template="../querys/get_all_intl_rep.cfm">
	
	<cfinclude template="../querys/get_countries.cfm">
	
	<cfinclude template="../querys/get_states.cfm">
	
	<cfinclude template="../querys/get_facilitators.cfm">
	
	<cfinclude template="../querys/get_insurance_type.cfm">

</cfsilent>

<!--- Table Header --->
<gui:tableHeader
	imageName="students.gif"
	tableTitle="Overall Program Reports"
	tableRightTitle="#reportRightTitle#"
/>

<cfoutput>
    
<table border="0" cellpadding="8" cellspacing="2" width=100% class="section">

    <tr>
        <td width="50%" valign="top">

            <form action="reports/students_per_region.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Students per Region</td></tr>
                    <tr>
                        <td class="reportFieldTitle">Program:</td>
                        <td>
                            <select name="programID" multiple size="6">
                                <cfloop query="get_program">
                                    <option value="#programID#">#programname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Region:</td>
                        <td>
                            <select name="regionid">
                                <option value="0">All Regions</option>
                                <cfloop query="get_regions">
                                    <option value="#regionid#">#regionname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Status:</td>
                        <td>
                            <select name="status">
                                <option value="0">All</option>
                                <option value="1">Placed</option>
                                <option value="2">Unplaced</option>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Continent:</td>
                        <td>
                            <select name="continent">
                                <option value="0">All</option>
                                <option value="Asia">Asia</option>
                                <option value="Europe">Europe</option>
                                <option value="South America">South America</option>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Pre-AYP:</td>
                        <td>
                            <select name="preayp">
                                <option value='none'>None</option>
                                <option value="english">English Camp</option><option value="orientation">Orientation Camp</option><option value="all">Both Camps</option>
                            </select>               
                        </td>
                    </tr>	
                    <tr>
                        <td align="right"><input type="checkbox" name="usa"></input></td>
                        <td>American Citizen Students (Birth, Resident or Citizenship Countries)</td>
                    </tr>								
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </form>
                
        </td>

        <td width="50%" valign="top">
            
            <form action="reports/students_per_intl_rep.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Students per International Rep.</td></tr>
                    <tr>
                        <td class="reportFieldTitle">Program:</td>
                        <td>
                            <select name="programID" multiple size="6">
                                <cfloop query="get_program">
                                    <option value="#programID#">#programname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Intl. Rep:</td>
                        <td>
                        	<select name="intrep">
		                        <option value="0">All Intl. Reps</option>
        		                <cfloop query="get_intl_rep">
                                	<option value="#intrep#">#businessname#</option>
                                </cfloop>
                	        </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Status:</td>
                        <td>
                        	<select name="status">
                                <option value="0">All</option>
                                <option value="1">Placed</option>
                                <option value="2">Unplaced</option>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Active:</td>
                        <td>
                        	<select name="active">
                                <option value="1">Active</option>
                                <option value="0">Inactive</option>
                                <option value="2">Canceled</option>					
                                <option value="3">All</option>
	                        </select>
						</td>
                    </tr>					
                    <tr>
                        <td class="reportFieldTitle">Pre-AYP:</td>
                        <td>
                            <select name="preayp">
                                <option value='None'>None</option>
                                <option value='All'>All</option>
                                <cfloop query="qAYPEnglishCamps">
                                    <option value="#qAYPEnglishCamps.campid#">#qAYPEnglishCamps.name#</option>
                                </cfloop>
                            </select>
                        </td>
                    </tr>	
                    <tr>
                        <td class="reportFieldTitle">Report Format:</td>
                        <td>
                            <select name="reportFormat">
                                <option value='Screen'>Screen</option>
                                <option value='Excel'>Excel</option>
                            </select>
                            * Only Available for Pre-AYP report
                        </td>
                    </tr>	
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </form>

        </td>
    </tr>
    
    <!--- ROW 2 - 2 boxes --->  
    <tr>
        <td width="50%" valign="top">

            <form action="reports/students_region_guarantee.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Students - Region Guarantee Only</td></tr>
                    <tr>
                        <td class="reportFieldTitle">Program:</td>
                        <td>
                            <select name="programID" multiple size="6">
                                <cfloop query="get_program">
                                    <option value="#programID#">#programname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Status:</td>
                        <td>
                        	<select name="status">
                            	<option value="0">All</option>
                                <option value="1">Placed</option>
                                <option value="2">Unplaced</option>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Region:</td>
                        <td>
                        	<select name="regionid">
                            	<option value="0">All Regions</option>
                            	<cfloop query="get_regions">
                                	<option value="#regionid#">#regionname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </form>

        </td>

        <td width="50%" valign="top">

            <cfform action="reports/students_state_guarantee.cfm" method="POST" target="blank">
            <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                <tr><td colspan="2" class="reportTitle">Students - State Preference Only</td></tr>
                    <tr>
                        <td class="reportFieldTitle">Program:</td>
                        <td>
                            <select name="programID" multiple size="6">
                                <cfloop query="get_program">
                                    <option value="#programID#">#programname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                <tr>
                    <td class="reportFieldTitle">Status:</td>
                    <td>
                    	<select name="status">
                        	<option value="0">All</option>
                            <option value="1">Placed</option>
                            <option value="2">Unplaced</option>
                        </select>               
                    </td>
                </tr>
                <tr>
                    <td class="reportFieldTitle">Region:</td>
                    <td>
                    	<select name="regionid">
                            <option value="0">All Regions</option>
                            <cfloop query="get_regions">
                            	<option value="#regionid#">#regionname#</option>
                            </cfloop>
                        </select>               
                    </td>
                </tr>
                <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
            </table>
            </cfform>

        </td>
    </tr>
    
    <!--- ROW 3 - 2 boxes --->  
    <tr>
        <td width="50%" valign="top">

            <cfform action="reports/students_us_citizens.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">US Citizen Students in Program</td></tr>
                    <tr>
                        <td class="reportFieldTitle">Program:</td>
                        <td>
                            <select name="programID" multiple size="6">
                                <cfloop query="get_program">
                                    <option value="#programID#">#programname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr><td colspan="2">Countries of Birth, Citizen and/or Residence = USA</td></tr>
                    <tr>
                        <td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0" ></td>
                    </tr>
                </table>
            </cfform>

        </td>

        <td width="50%" valign="top">
            
            <cfform action="reports/overall_students_per_fac.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Overall Students by Facilitator</td></tr>
                    <tr>
                        <td class="reportFieldTitle">Program:</td>
                        <td>
                            <select name="programID" multiple size="6">
                                <cfloop query="get_program">
                                    <option value="#programID#">#programname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Facilitator:</td>
                        <td>
                            <select name="userid">
                                <option value="0">All </option>		
                                <cfloop query="get_facilitators">
                                	<option value="#userid#">#get_facilitators.firstname# #get_facilitators.lastname#</option>
                                </cfloop>
                            </select>
                        </td>		
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Placement Status:</td>
                        <td>
                            <select name="placementStatus">
                                <option value="All">All</option>
                                <option value="Placed">Placed</option>
                                <option value="Unplaced">Unplaced</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                    	<td>&nbsp;</td>
                        <td>Placement Date Range</td>
					</tr>
                    <tr>
                        <td class="reportFieldTitle">From:</td>
                        <td>	
                        	<input type="text" name="placedDateFrom" class="datePicker" size="7" maxlength="10">
                            &nbsp; To: &nbsp;
                            <input type="text" name="placedDateTo" class="datePicker" size="7" maxlength="10"> mm-dd-yyyy
                        </td>
                    </tr>                    
                    <tr>
                        <td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0" ></td>
                    </tr>
                </table>
            </cfform>

        </td>
    </tr>
    
    <!--- ROW 4 - 2 boxes --->  
    <tr>
        <td width="50%" valign="top">

            <cfform action="reports/total_students_graduated.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Total of Graduated Students per Country (12th grade)</td></tr>
                        <tr>
                            <td class="reportFieldTitle">Program:</td>
                            <td>
                                <select name="programID" multiple size="6">
                                    <cfloop query="get_program">
                                        <option value="#programID#">#programname#</option>
                                    </cfloop>
                                </select>               
                            </td>
                        </tr>
                    <tr>
                        <td class="reportFieldTitle">Country:</td>
                        <td>
                            <select name="countryid">			
                                <option value="0">All Countries</option>
                                <cfloop query="get_countries">
                                    <option value="#Countryid#">#countryname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                    	<td></td>
                        <td><input type="text" size="8" name="dateplaced" class="datePicker" maxlength="10" readonly="yes"></td>
                    </tr>
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>
            
        </td>

        <td width="50%" valign="top">
    
            <cfform action="reports/graduate_students_region.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Total of Graduated Students per Region (Placed Only)</td></tr>
                    <tr>
                        <td class="reportFieldTitle">Program:</td>
                        <td>
                            <select name="programID" multiple size="6">
                                <cfloop query="get_program">
                                    <option value="#programID#">#programname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Region:</td>
                        <td>
                        	<select name="regionid">
                            	<option value="0">All Regions</option>
	                            <cfloop query="get_regions">
                                	<option value="#regionid#">#regionname#</option>
								</cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Last Placement Date:</td>
                        <td><input type="text" size="8" name="dateplaced" class="datePicker" maxlength="10"> mm/dd/yyyy</td>
                    </tr>
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>		

        </td>
    </tr>
    
    <!--- ROW 5 - 2 boxes --->  
    <tr>
        <td width="50%" valign="top">

            <cfform action="reports/scholarship_students.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Scholarship Students</td></tr>
                        <tr>
                            <td class="reportFieldTitle">Program:</td>
                            <td>
                                <select name="programID" multiple size="6">
                                    <cfloop query="get_program">
                                        <option value="#programID#">#programname#</option>
                                    </cfloop>
                                </select>               
                            </td>
                        </tr>
                    <tr>
                        <td class="reportFieldTitle">Region:</td>
                        <td><select name="regionid">
                            <option value="0">All Regions</option>
                            <cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Status:</td>
                        <td><select name="status">
                            <option value="0">All</option><option value="1">Placed</option><option value="2">Unplaced</option>
                            </select>               
                        </td>
                    </tr>
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>
                
        </td>

        <td width="50%" valign="top">
    
            <cfform action="reports/iff_students.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">IFF Students</td></tr>
                        <tr>
                            <td class="reportFieldTitle">Program:</td>
                            <td>
                                <select name="programID" multiple size="6">
                                    <cfloop query="get_program">
                                        <option value="#programID#">#programname#</option>
                                    </cfloop>
                                </select>               
                            </td>
                        </tr>
                    <tr>
                        <td class="reportFieldTitle">Region:</td>
                        <td><select name="regionid">
                            <option value="0">All Regions</option>
                            <cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Status:</td>
                        <td><select name="status">
                            <option value="0">All</option><option value="1">Placed</option><option value="2">Unplaced</option>
                        </select>               
                        </td>
                    </tr>
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>

        </td>
    </tr>
    
    <!--- ROW 6 - 2 boxes --->  
    <tr>
        <td width="50%" valign="top">

            <cfform action="reports/total_students_per_country.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Total of Students per Country</td></tr>
                        <tr>
                            <td class="reportFieldTitle">Program:</td>
                            <td>
                                <select name="programID" multiple size="6">
                                    <cfloop query="get_program">
                                        <option value="#programID#">#programname#</option>
                                    </cfloop>
                                </select>               
                            </td>
                        </tr>
                    <tr>
                        <td class="reportFieldTitle">Country:</td>
                        <td><select name="countryid">			
                            <option value="0">All Countries</option>
                            <cfloop query="get_countries"><option value="#Countryid#">#countryname#</option></cfloop>
                            </select>               
                            </td>
                        </tr>
                    <tr>
                        <td class="reportFieldTitle">Placement Status:</td>
                        <td><select name="status">
                            <option value="0">All</option><option value="1">Placed</option><option value="2">Unplaced</option>
                        </select>               
                            </td>
                        </tr>
                    <tr><td align="right"><input type="checkbox" name="all" /></td><td>Include All Students (canceled and inactive)</td></tr>
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>
            
        </td>

        <td width="50%" valign="top">
    
            <cfform action="reports/total_students_per_country_agent.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Total of Students per Country and Intl. Rep.</td></tr>
                        <tr>
                            <td class="reportFieldTitle">Program:</td>
                            <td>
                                <select name="programID" multiple size="6">
                                    <cfloop query="get_program">
                                        <option value="#programID#">#programname#</option>
                                    </cfloop>
                                </select>               
                            </td>
                        </tr>
                    <tr>
                        <td class="reportFieldTitle">Country:</td>
                        <td><select name="countryid">			
                            <option value="0">All Countries</option>
                            <cfloop query="get_countries"><option value="#Countryid#">#countryname#</option></cfloop>
                            </select>               
                            </td>
                        </tr>
                    <tr>
                        <td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                    </tr>
                </table>
            </cfform>

        </td>
    </tr>
    
    <!--- ROW 7 - 2 boxes --->  
    <tr>
        <td width="50%" valign="top">

            <cfform action="reports/total_students_per_agent.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Total of Students per International Rep.</td></tr>
                        <tr>
                            <td class="reportFieldTitle">Program:</td>
                            <td>
                                <select name="programID" multiple size="6">
                                    <cfloop query="get_program">
                                        <option value="#programID#">#programname#</option>
                                    </cfloop>
                                </select>               
                            </td>
                        </tr>
                    <tr>
                        <td class="reportFieldTitle">Country:</td>
                        <td><select name="countryid">			
                            <option value="0">All Countries</option>
                            <cfloop query="get_countries"><option value="#Countryid#">#countryname#</option></cfloop>
                            </select>               
                            </td>
                        </tr>
                    <tr>
                        <td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                    </tr>
                </table>
            </cfform>

        </td>

        <td width="50%" valign="top">
    
            <cfform action="reports/student_unplaced_days.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Total of Unplaced Days</td></tr>
                        <tr>
                            <td class="reportFieldTitle">Program:</td>
                            <td>
                                <select name="programID" multiple size="6">
                                    <cfloop query="get_program">
                                        <option value="#programID#">#programname#</option>
                                    </cfloop>
                                </select>               
                            </td>
                        </tr>
                    <tr>
                        <td class="reportFieldTitle">Region:</td>
                        <td><select name="regionid">
                                <option value="0">All Regions</option>			
                                <cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                    </tr>
                </table>
            </cfform>		

        </td>
    </tr>
    
    <!--- ROW 8 - 2 boxes --->  
    <tr>
        <td width="50%" valign="top">

            <cfform action="reports/flight_information_report.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Arrival Flight Information</td></tr>
                    <tr>
                        <td class="reportFieldTitle">Program:</td>
                        <td>
                            <select name="programID" multiple size="6">
                                <cfloop query="get_program">
                                    <option value="#programID#">#programname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Region:</td>
                        <td><select name="regionid">
                            <option value="0">All Regions</option>
                            <cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td><input type="checkbox" name="dates">&nbsp; Including Period Below (Arrival Date)</input></td></tr>
                    <tr>
                        <td class="reportFieldTitle">From : </td>
                        <td><input type="text" name="date1" class="datePicker" size="7" maxlength="10"> mm-dd-yyyy</td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">To : </td>
                        <td><input type="text" name="date2" class="datePicker" size="7" maxlength="10"> mm-dd-yyyy</td>
                    </tr>			
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>

        </td>

        <td width="50%" valign="top">
    
            <cfform action="reports/flight_info_depart_report.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Departure Flight Information</td></tr>
                    <tr>
                        <td class="reportFieldTitle">Program:</td>
                        <td>
                            <select name="programID" multiple size="6">
                                <cfloop query="get_program">
                                    <option value="#programID#">#programname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Region:</td>
                        <td><select name="regionid">
                            <option value="0">All Regions</option>
                            <cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td><input type="checkbox" name="dates">&nbsp; Including Period Below (Arrival Date)</input></td></tr>
                    <tr>
                        <td class="reportFieldTitle">From : </td>
                        <td><input type="text" name="date1" class="datePicker" size="7" maxlength="10"> mm-dd-yyyy</td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">To : </td>
                        <td><input type="text" name="date2" class="datePicker" size="7" maxlength="10"> mm-dd-yyyy</td>
                    </tr>			
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>

        </td>
    </tr>
    
    <!--- ROW 9 - 2 boxes --->  
    <tr>
        <td width="50%" valign="top">

            <cfform action="reports/flight_info_missing.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Missing Arrival Flight Information (placed students)</td></tr>
                        <tr>
                            <td class="reportFieldTitle">Program:</td>
                            <td>
                                <select name="programID" multiple size="6">
                                    <cfloop query="get_program">
                                        <option value="#programID#">#programname#</option>
                                    </cfloop>
                                </select>               
                            </td>
                        </tr>
                        <tr>
                            <td class="reportFieldTitle">Intl. Rep:</td>
                            <td><select name="intrep">
                                <option value="0">All Intl. Reps</option>
                                <cfloop query="get_intl_rep"><option value="#intrep#"><cfif #len(get_intl_rep.businessname)# gt 45>#Left(get_intl_rep.businessname, 17)#...<cfelse>#businessname#</cfif></option></cfloop>
                                </select>               
                            </td>
                        </tr>
                        <tr><td class="reportFieldTitle">Pre-AYP:</td>
                        <td><select name="preayp">
                            <option value='none'>None</option>
                            <option value="english">English Camp</option>
                            <option value="orientation">Orientation Camp</option>
                            <option value="all">Both Camps</option>
                            </select>               
                            </td>
                        </tr>							
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>

        </td>

        <td width="50%" valign="top">
    
            <cfform action="reports/flight_info_missing_by_region.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Missing Arrival Flight Info By Region</td></tr>
                    <tr>
                        <td class="reportFieldTitle">Program:</td>
                        <td>
                            <select name="programID" multiple size="6">
                                <cfloop query="get_program">
                                    <option value="#programID#">#programname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Region:</td>
                        <td><select name="regionid">
                            <option value="0">All Regions</option>
                            <cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr><td class="reportFieldTitle">Pre-AYP:</td>
                    <td><select name="preayp">
                        <option value='none'>None</option>
                        <option value="english">English Camp</option>
                        <option value="orientation">Orientation Camp</option>
                        <option value="all">Both Camps</option>
                        </select>               
                        </td>
                    </tr>					
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>

        </td>
    </tr>
    
    <!--- ROW 10 - 2 boxes --->  
    <tr>
        <td width="50%" valign="top">

            <cfform action="reports/flight_depart_missing.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Missing Departure Flight Information (placed students)</td></tr>
                        <tr>
                            <td class="reportFieldTitle">Program:</td>
                            <td>
                                <select name="programID" multiple size="6">
                                    <cfloop query="get_program">
                                        <option value="#programID#">#programname#</option>
                                    </cfloop>
                                </select>               
                            </td>
                        </tr>
                        <tr>
                            <td class="reportFieldTitle">Intl. Rep:</td>
                            <td><select name="intrep">
                                <option value="0">All Intl. Reps</option>
                                <cfloop query="get_intl_rep"><option value="#intrep#"><cfif #len(get_intl_rep.businessname)# gt 45>#Left(get_intl_rep.businessname, 17)#...<cfelse>#businessname#</cfif></option></cfloop>
                                </select>               
                            </td>
                        </tr>
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>

        </td>

        <td width="50%" valign="top">
            
            <cfform action="reports/flight_depart_missing_by_region.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Missing Departure Flight Info By Region</td></tr>
                    <tr>
                        <td class="reportFieldTitle">Program:</td>
                        <td>
                            <select name="programID" multiple size="6">
                                <cfloop query="get_program">
                                    <option value="#programID#">#programname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Region:</td>
                        <td><select name="regionid">
                            <option value="0">All Regions</option>
                            <cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>

        </td>
    </tr>
    
    <!--- ROW 11 - 2 boxes --->  
    <tr>
        <td width="50%" valign="top">

            <cfform action="reports/report_stu_school.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Students in School</td></tr>
                        <tr>
                            <td class="reportFieldTitle">Program:</td>
                            <td>
                                <select name="programID" multiple size="6">
                                    <cfloop query="get_program">
                                        <option value="#programID#">#programname#</option>
                                    </cfloop>
                                </select>               
                            </td>
                        </tr>
                        <tr>
                            <td>State :</td>
                            <td><cfselect name="stateid" query="get_states" display="statename" value="state" queryPosition="below">
                                <option value="0">All</option>
                                </cfselect>
                            </td>
                        </tr>		
                        <tr><td align="right"><cfinput type="checkbox" name="school_filter"></td><td>Schools with more than 5 students attending.</td></tr>
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>

        </td>

        <td width="50%" valign="top">
    
            <cfform action="reports/stu_missing_school_accep.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Students in the USA Missing School Acceptance Letter</td></tr>
                        <tr>
                            <td class="reportFieldTitle">Program:</td>
                            <td>
                                <select name="programID" multiple size="6">
                                    <cfloop query="get_program">
                                        <option value="#programID#">#programname#</option>
                                    </cfloop>
                                </select>               
                            </td>
                        </tr>
                        <tr>
                            <td class="reportFieldTitle">Region:</td>
                            <td><select name="regionid">
                                <option value="0">All Regions</option>
                                <cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
                                </select>               
                            </td>
                        </tr>
                        <tr><td class="reportFieldTitle">Pre-AYP:</td>
                        <td><select name="preayp">
                            <option value='none'>None</option>
                            <option value="english">English Camp</option>
                            <option value="orientation">Orientation Camp</option>
                            <option value="all">Both Camps</option>
                            </select>               
                            </td>
                        </tr>	
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>	


        </td>
    </tr>
    
    <!--- ROW 12 - 2 boxes --->  
    <tr>
        <td width="50%" valign="top">

            <cfform action="reports/continent_report.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Continent Report</td></tr>
                        <tr>
                            <td class="reportFieldTitle">Program:</td>
                            <td>
                                <select name="programID" multiple size="6">
                                    <cfloop query="get_program">
                                        <option value="#programID#">#programname#</option>
                                    </cfloop>
                                </select>               
                            </td>
                        </tr>
                    <tr>
                        <td class="reportFieldTitle">Status:</td>
                        <td><select name="status">
                            <option value="0">All</option>
                            <option value="1">Placed</option>
                            <option value="2">Unplaced</option>
                            </select>               
                            </td>
                        </tr>
                    <tr>
                        <td class="reportFieldTitle">Continent:</td>
                        <td><select name="continent">
                            <option value="Asia">Asia</option>
                            <!--- <!--- <option value="Africa">Africa</option> ---> --->
                            <option value="Europe">Europe</option>
                            <!--- <option value="North America">North America</option> --->
                            <option value="South America">South America</option>
                            <!--- <option value="Oceania">Oceania</option> --->		
                            </select>               
                            </td>
                        </tr>
                    <tr><td></td><td><input  type="text" size="8">&nbsp;</input></td></tr>
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>

        </td>

        <td width="50%" valign="top">
    
            <cfform action="reports/continent_report_region.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">Continent Report By Region</td></tr>
                    <tr>
                        <td class="reportFieldTitle">Program:</td>
                        <td>
                            <select name="programID" multiple size="6">
                                <cfloop query="get_program">
                                    <option value="#programID#">#programname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Status:</td>
                        <td><select name="status">
                            <option value="0">All</option>
                            <option value="1">Placed</option>
                            <option value="2">Unplaced</option>
                            </select></td></tr>
                    <tr></tr><td class="reportFieldTitle">Continent:</td>
                        <td><select name="continent">
                            <option value="Asia">Asia</option>
                            <!--- <!--- <option value="Africa">Africa</option> ---> --->
                            <option value="Europe">Europe</option>
                            <!--- <option value="North America">North America</option> --->
                            <option value="South America">South America</option>
                            <!--- <option value="Oceania">Oceania</option> --->		
                        </select></td></tr>						
                    <tr>
                        <td class="reportFieldTitle">Region:</td>
                        <td><select name="regionid">
                            <option value="0">All Regions</option>
                            <cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
                            </select></td></tr>
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>

        </td>
    </tr>
    
    <!--- ROW 13 - 2 boxes --->  
    <tr>
        <td width="50%" valign="top">

            <cfform action="reports/intl_rep_list.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">International Representatives by Country</td></tr>
                    <tr>
                        <td class="reportFieldTitle">Intl. Rep:</td>
                        <td><select name="intrep">
                            <option value="0">All Reps</option>
                            <cfloop query="get_all_intl_rep"><option value="#userid#">#businessname#</option></cfloop>
                            </select></td></tr>
                    <tr>
                        <td class="reportFieldTitle">Country:</td>
                        <td><select name="countryid" multiple  size="6">			
                            <option value="0">All Countries</option>
                            <cfloop query="get_countries"><option value="#Countryid#">#countryname#</option></cfloop>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Insurance :</td>
                        <td><select name="insurance">
                            <option value="0">
                            <cfloop query="get_insurance_type">
                            <option value="#insutypeid#">#type#</option>
                            </cfloop>
                            </select></td></tr>
                    <tr>
                        <td class="reportFieldTitle">Status:</td>
                        <td><select name="status">
                            <option value="0">Active</option>
                            <option value="1">Inactive</option>
                            <option value="2">All</option>
                            </select>               
                        </td>
                    </tr>
                    <tr><td></td><td><input  type="text" size="8">&nbsp;</input></td></tr>
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>		

        </td>

        <td width="50%" valign="top">

            <cfform action="reports/intl_contact_list.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                    <tr><td colspan="2" class="reportTitle">International Representatives</td></tr>
                    <tr>
                        <td class="reportFieldTitle">Intl. Rep:</td>
                        <td><select name="intrep">
                            <option value="0">All Reps</option>
                            <cfloop query="get_all_intl_rep"><option value="#userid#">#businessname#</option></cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Country:</td>
                        <td><select name="countryid" multiple  size="6">			
                            <option value="0">All Countries</option>
                            <cfloop query="get_countries"><option value="#Countryid#">#countryname#</option></cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Insurance :</td>
                        <td><select name="insurance">
                            <option value="0">
                            <cfloop query="get_insurance_type">
                            <option value="#insutypeid#">#type#</option>
                            </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Status:</td>
                        <td><select name="status">
                            <option value="0">Active</option>
                            <option value="1">Inactive</option>
                            <option value="2">All</option>
                            </select>               
                        </td>
                    </tr>
                    <tr></tr><td class="reportFieldTitle">Continent:</td>
                        <td><select name="continent">
                            <option value="0"></option>
                            <option value="Asia">Asia</option>
                            <!--- <!--- <option value="Africa">Africa</option> ---> --->
                            <option value="Europe">Europe</option>
                            <!--- <option value="North America">North America</option> --->
                            <option value="South America">South America</option>
                            <!--- <option value="Oceania">Oceania</option> --->	
                            <option value="non-asia">Non-Asia</option>	
                        </select>               
                        </td>
                    </tr>						
                    <tr>
                    <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                </table>
            </cfform>		

        </td>
    </tr>


    <cfif client.companyid EQ 5>
        
        <!--- ROW 14 - 2 boxes --->  
        <tr>
            <td width="50%" valign="top">

                <form action="reports/smg_total_stu_country.cfm" method="POST" target="blank"> 
                    <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                        <tr><td colspan="2" class="reportTitle">SMG Students per Country</td></tr>
                        <tr>
                            <td class="reportFieldTitle">Country:</td>
                            <td><select name="countryid">			
                                <option value="0">All Countries</option>
                                <cfloop query="get_countries"><option value="#countryid#">#countryname#</option></cfloop>
                                </select>               
                            </td>
                        </tr>
                        <tr>
                            <td class="reportFieldTitle">Status:</td>
                            <td><select name="status">
                                <option value="0">All</option>
                                <option value="1">Placed</option>
                                <option value="2">Unplaced</option>
                                </select>               
                            </td>
                        </tr>
                        <tr><td colspan="2" class="reportTitle"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                    </table>
                </form>

            </td>

            <td width="50%" valign="top">&nbsp;</td>
        </tr>
                        
    </cfif>

</table>

</cfoutput>

<!--- Table Footer --->
<gui:tableFooter />
