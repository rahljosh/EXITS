<!--- ------------------------------------------------------------------------- ----
	
	File:		place_menu.cfm
	Author:		Marcus Melo
	Date:		June 20, 2011
	Desc:		Placement Menu

	Updated:																	
				
----- ------------------------------------------------------------------------- --->
<cfdump var="#client#">
<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfparam name="URL.studentID" default="0">
    <cfparam name="URL.text" default="no">
    
    <cfscript>
		if ( VAL(URL.studentID) ) {
			CLIENT.studentid = URL.studentID;
		}		
	</cfscript>

    <cfquery name="qGetStudentInfo" datasource="MySQL">
        SELECT
        	s.studentid,
            s.uniqueid,  
            s.firstname, 
            s.familylastname, 
            s.middlename, 
            s.hostid, 
            s.arearepid, 
            s.placerepid, 
            s.schoolID, 
            s.dateplaced, 
            s.host_fam_approved, 
            s.date_host_fam_approved, 
            s.address, 
            s.address2, 
            s.city, 
            s.country, 
            s.programid,
            s.zip,  
            s.fax, 
            s.email, 
            s.phone, 
            s.welcome_family,
            p.seasonID,
            h.motherfirstname, 
            h.fatherfirstname, 
            h.familylastname as hostlastname, 
            h.hostid as hostfamid,
            area.firstname as areafirstname, 
            area.lastname as arealastname, 
            area.userid as areaid,
            place.firstname as placefirstname, 
            place.lastname as placelastname, 
            place.userid as placeid,
            countryname 
        FROM 
        	smg_students s
        LEFT OUTER JOIN
        	smg_programs p ON p.programID = s.programID
        LEFT OUTER JOIN 
        	smg_hosts h ON s.hostid = h.hostid
        LEFT OUTER JOIN 
        	smg_users area ON s.arearepid = area.userid
        LEFT OUTER JOIN 
        	smg_users place ON s.placerepid = place.userid
        LEFT OUTER JOIN 
        	smg_countrylist country ON s.countryresident = country.countryid
        WHERE 
        	s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentid#">
    </cfquery>

    <cfscript>
		// Check if Host Family is in compliance
		vHostInCompliance = APPLICATION.CFC.CBC.checkHostFamilyCompliance(hostID=qGetStudentInfo.hostID, studentID=qGetStudentInfo.studentID);
	</cfscript>
    
    <cfquery name="qGetSchoolInfo" datasource="#application.dsn#">
        SELECT 
        	sc.schoolname, 
            sc.schoolID, 
            sd.year_begins, 
            sd.semester_begins, 
            sd.semester_ends, 
            sd.year_ends
        FROM 
        	smg_schools sc
        LEFT JOIN 
        	smg_school_dates sd on sd.schoolID = sc.schoolID
            AND 
                sd.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.seasonID)#">
        WHERE 
        	sc.schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.schoolID)#">
    </cfquery>
    
    <!--- PLACEMENT HISTORY --->
    <cfquery name="qGetPlacementHistory" datasource="MySQL">
        SELECT 
        	hist.hostid, 
            hist.reason, 
            hist.studentid, 
            hist.dateofchange,
            hist.arearepid, 
            hist.placerepid, 
            hist.schoolID, 
            hist.changedby, 
            hist.original_place,
            h.familylastname,
            sc.schoolname,
            area.firstname as areafirstname, 
            area.lastname as arealastname,
            place.firstname as placefirstname, 
            place.lastname as placelastname,
            changedby.firstname as changedbyfirstname, 
            changedby.lastname as changedbylastname
        FROM 
        	smg_hosthistory hist
        LEFT JOIN 
        	smg_hosts h ON hist.hostid = h.hostid
        LEFT JOIN 
        	smg_schools sc ON hist.schoolID = sc.schoolID
        LEFT JOIN 
        	smg_users area ON hist.arearepid = area.userid
        LEFT JOIN 
        	smg_users place ON hist.placerepid = place.userid
        LEFT JOIN 
        	smg_users changedby ON hist.changedby = changedby.userid
        WHERE 
        	hist.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentid#">
        ORDER BY 
        	hist.dateofchange DESC, 
            hist.historyid DESC
    </cfquery>

</cfsilent>

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

		<script language="javascript">
            // Display warning when page is ready
            $(document).ready(function() {
                opener.location.reload();
            });
			
			function displayApprovalButton(divID) {
				if($("##" + divID).css("display") == "none"){
					$("##" + divID).fadeIn("slow");
				} else {
					$("##" + divID).fadeOut("slow");	
				}
			}	
		</script>

		<style type="text/css">
            <!--
				.placeinfo {color: ##3434B6}
				.history {color: ##7B848A}
				/* region table */
				table.dash { font-size: 12px; border: 1px solid ##202020; }
				tr.dash {  font-size: 12px; border-bottom: dashed ##201D3E; }
				td.dash {  font-size: 12px; border-bottom: 1px dashed ##201D3E;}
            -->
        </style>
	
		<!--- include template page header --->
        <cfinclude template="placement_status_header.cfm">

        <!--- Table Header --->
        <gui:tableHeader
            tableTitle="Placement Information"
            width="580px"
            imagePath="../"
        />    

            <table class="section" align="Center" width="580px" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                    
                        <table width="100%" align="center" bgcolor="##FFFFE6">
                            <tr><td align="center"><h3>Welcome to the Placement Management Screen</h3></td></tr>
                            <tr>
                            	<td align="center">
									<cfif URL.text EQ 'no'>
                                        <a href="place_menu.cfm?text=yes"><img src="../pics/help_show.gif" align="center" border="0"></a>
                                    <cfelseif URL.text EQ 'yes'>
                                        <a href="place_menu.cfm?text=no"><img src="../pics/help_hide.gif" align="center" border="0"></a>
									</cfif>
                            	</td>
                            </tr>
                            <cfif URL.text EQ 'yes'>
                                <tr><td align="center"><h3>Steps 1-4 are mandatory and step 5 is optional when placing a student.</h3></td></tr>
                                <tr><td align="center"><h3>Gray buttons indicate the step has never been completed.</h3></td></tr>
                                <tr><td align="center"><h3>Green buttons indicate the step has been completed.</h3></td></tr>
                                <tr><td align="center"><h3>After Original Placement is completed, green buttons can be used to update placement information.</h3></td></tr>
                                <tr><td align="center"><h3>When placement information is updated, the Placement Log will be updated.</h3></td></tr>
                                <tr><td align="center"><h3>Current Placement Information is always listed as the top description.</h3></td></tr>
                                <tr><td align="center"><h3>The Placement Log then lists all past changes in placement information</h3></td></tr>
                                <tr><td align="center"><h3>The Placement Log starts from the bottom and lists the most recent updates on the top of the log.</h3></td></tr>
                            </cfif>
                        </table>
                        
                        <br />
                        
                        <table width="100%" class="placeinfo" align="center">
							<!--- if placement status --->
                            <cfif qGetStudentInfo.hostid NEQ 0 AND qGetStudentInfo.schoolID NEQ 0 AND qGetStudentInfo.placerepid NEQ 0 AND qGetStudentInfo.arearepid NEQ 0> 
                                
                                <!---99---->
                                <cfif qGetStudentInfo.host_fam_approved EQ 99>
                                    <tr>
                                        <td align="center" colspan="3" font="red"> 
                                            Placement has been <b><font color="##CC3300">R E J E C T E D</font></b> 
                                            on #DateFormat(qGetStudentInfo.date_host_fam_approved, 'mm/dd/yyyy')# 
                                            at #TimeFormat(qGetStudentInfo.date_host_fam_approved, 'hh:mm tt')# EST
                                            see the history below<br />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="3">
                                            <form method="post" action="../querys/update_host_fam_resubmit.cfm">
                                                <input type="image" value="resubmit" src="../pics/resubmit.gif">
                                            </form>
                                        </td>
                                    </tr>	
                                </cfif>
                                <!---/99---->
                                
                                <!--- Placement Approval Information - 5 TO 7 --->
                                <cfif ListFind("5,6,7", qGetStudentInfo.host_fam_Approved)>
                                    
                                    <cfif CLIENT.usertype LT qGetStudentInfo.host_fam_Approved>
                                        <tr>
                                            <td align="center" colspan="3">
                                                <a href="javascript:openPopUp('../reports/PlacementInfoSheet.cfm?uniqueID=#qGetStudentInfo.uniqueID#&approve', 900, 600);"><img src="../pics/previewpis.gif" border="0"></a><br />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center" colspan="3">
                                                <font color="##FF3300">To approve this placement, please review the placement letter clicking on the link above.</font><br /><br />
                                            </td>
                                        </tr>
                                    <cfelse>
                                        <tr>
                                            <td align="center" colspan="3">
                                                <a href="javascript:openPopUp('../reports/PlacementInfoSheet.cfm?uniqueID=#qGetStudentInfo.uniqueID#', 900, 600);"><img src="../pics/previewpis.gif" border="0"></a>
                                                <br /><br />
                                            </td>
                                        </tr>
                                    </cfif>
                                    <tr>
                                        <td align="center" colspan="3">
                                            Placement is being approved. Last Approval: #DateFormat(qGetStudentInfo.date_host_fam_approved, 'mm/dd/yyyy')# by the
                                            <cfswitch expression="#qGetStudentInfo.host_fam_approved#">
                                            
                                                <cfcase value="1,2,3,4">
                                                    <strong>HQ</strong>.
                                                </cfcase>
                                                
                                                <cfcase value="5">
                                                    <strong>Regional Manager</strong>.
                                                </cfcase>
                                                
                                                <cfcase value="6">
                                                    <strong>Regional Advisor</strong>.
                                                </cfcase>
                                                
                                                <cfcase value="7">
                                                    <strong>Area Representative</strong>.
                                                </cfcase>
                                                
                                            </cfswitch>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="3" style="padding-top:10px;">
											<!--- Check if CBCs are in compliance with DOS --->											
                                            <cfif LEN(vHostInCompliance) AND ListFind("1,2,3,4", CLIENT.userType)>
                                            	
                                                <!--- Display Compliance --->
                                                #vHostInCompliance#

											<cfelseif CLIENT.usertype LT qGetStudentInfo.host_fam_Approved>
                                                
                                                <span id="actionButtons" class="displayNone">
                                                
													<!--- Approval Button ---->
                                                    <a href="../querys/update_host_fam_approved.cfm"><img src="../pics/approve.gif" border="0"></img></a>
                                                    &nbsp; &nbsp;
                                                    <!--- Reject Button ---->
                                                    <a href="place_reject_host.cfm?studentid=#qGetStudentInfo.studentid#"><img src="../pics/reject.gif" border="0"></img></a>
                                                
                                                </span>
                                                
                                            <cfelse>
                                            
                                                <img src="../pics/no_approve.jpg" alt="Reject" border="0">
                                                
                                            </cfif>
                                        </td>
                                    </tr>
                                <cfelseif listFind("1,2,3,4", qGetStudentInfo.host_fam_approved)>
                                    <tr>
                                        <td align="center" colspan="3">
                                            <a href="" onClick="javascript: win=window.open('../reports/PlacementInfoSheet.cfm?uniqueID=#qGetStudentInfo.uniqueid#&approve', 'Settings', 'height=450, width=850, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="../pics/previewpis.gif" border="0"></a>
                                            <br /><br />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="3">Placement approved on #DateFormat(qGetStudentInfo.date_host_fam_approved, 'mm/dd/yyyy')# by the HQ.</td>
                                    </tr>	
                                </cfif>
                            
                            <!--- if placement status --->                    
                            <cfelse> 
                                <tr><td align="center" colspan="3">#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# is <b>U N P L A C E D</b><br /><br /></td></tr>
                            </cfif> 
							<!--- if placement status --->
                            
                            <tr><td align="center" colspan="3"><br /><b><u>CURRENT PLACEMENT INFORMATION</u></b><br /><br /></td></tr>
                        </table>
                        
                        <div class="row1">
                            <table border="0" width="530px" align="center" bgcolor="##FFFFE6">
                                <tr>
                                    <td rowspan="2" valign="top" width=5><span class="get_attention"><b>></b></span></td>
                                    <td class="dash" width="50%"><b>Student</b> &nbsp; [ <a href="../student_profile.cfm?uniqueid=#qGetStudentInfo.uniqueid#" target="_blank">view student</a> ]</td>
                                    <td rowspan="2" valign="top" width='10'></td>
                                    <td rowspan="4" valign="top" width=5><span class="get_attention"><b>></b></span></td>
                                    <td class="dash">
                                    	<b>Host Family</b> &nbsp; 
										<cfif VAL(qGetStudentInfo.hostid) AND listFind("1,2,3,4", CLIENT.userType)>
                                        	[ <a href="../index.cfm?curdoc=host_fam_info&hostid=#qGetStudentInfo.hostid#" target="_blank">view host</a> ] 
										</cfif>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        #qGetStudentInfo.firstname# #qGetStudentInfo.middlename# #qGetStudentInfo.familylastname#<br />
                                        #qGetStudentInfo.city# &nbsp; #qGetStudentInfo.countryname#, &nbsp; #qGetStudentInfo.zip#<br />
                                        Phone: #qGetStudentInfo.phone#<br />
                                        <cfif NOT LEN(qGetStudentInfo.fax)>Fax: #qGetStudentInfo.fax#<br /></cfif>
                                        <cfif NOT LEN(qGetStudentInfo.email)>Email: #qGetStudentInfo.email#<br /></cfif>
                                    </td>		
                                    <td rowspan="3" valign="top">
										<cfif qGetStudentInfo.hostid EQ 0>
                                            <font color="##CC3300">Host Family has not been assigned yet.</font>				
                                        <cfelseif qGetStudentInfo.hostfamid EQ ''>
                                            <font color="##CC3300">Host Family (###qGetStudentInfo.hostid#) was not found in the system.</font>						
                                        <cfelse>
											<cfif qGetStudentInfo.welcome_family EQ 1>*** This is a Welcome Family ***<br /></cfif>	                       
											
											<cfif CLIENT.totalfam EQ 1 AND qGetStudentInfo.seasonID GT 8>
                                                <font color="##CC0000">*** Single Person Placement***<br /></font>
											</cfif>
                                            #qGetStudentInfo.hostlastname# (###qGetStudentInfo.hostid#)
                                        </cfif>	
                                    </td> 
                                </tr>
                            </table>
                            
                            <table border="0" width="530px" class="placeinfo" align="center" class="section">
                                <tr>
                                    <td rowspan="2" valign="top" width='5'><span class="get_attention"><b>></b></span></td>
                                    <td class="dash" width="50%">
                                    	<b>School</b> 
										<cfif VAL(qGetStudentInfo.schoolID) AND listFind("1,2,3,4", CLIENT.userType)>
                                        	[ <a href="../index.cfm?curdoc=school_Info&schoolID=#qGetStudentInfo.schoolID#" target="_blank">view school</a> ]
										</cfif>
                                    </td>
                                    <td rowspan="2" valign="top" width='10'></td>
                                    <td rowspan="4" valign="top" width='5'><span class="get_attention"><b>></b></span></td>
                                    <td class="dash"><b>Placement and Supervision</b></td>
                                </tr>
                                <tr>
                                    <td valign="top">
										<cfif qGetStudentInfo.schoolID EQ 0>
                                        	<font color="##CC3300">School has not been assigned yet.</font>
										<cfelseif NOT LEN(qGetStudentInfo.schoolID)>
                                            <font color="##CC3300">School (###qGetSchoolInfo.schoolID#) was not found in the system.</font>
                                        <cfelse>
                                            #qGetSchoolInfo.schoolname# (###qGetSchoolInfo.schoolID#)<br />
                                            <font size=-2>
                                                year beg: #DateFormat(qGetSchoolInfo.year_begins, 'mm/dd/yy')# sem end: #DateFormat(qGetSchoolInfo.semester_ends, 'mm/dd/yy')# <br /> 
                                                sem start:#DateFormat(qGetSchoolInfo.semester_begins, 'mm/dd/yy')#  year end: #DateFormat(qGetSchoolInfo.year_ends, 'mm/dd/yy')#
                                            </font>
                                        </cfif>
                                    </td>		
                                	<td rowspan="3" valign="top">
                               			<table border="0" class="placeinfo" align="center">
                                            <tr><td align="right">Placing :</td>
                                                <Td>
                                                    <cfif qGetStudentInfo.placerepid EQ 0>
                                                        <font color="##CC3300">Placing Rep has not been assigned yet.</font>
                                                    <cfelseif NOT LEN(qGetStudentInfo.placeid)>
                                                        <font color="##CC3300">Placing Rep (###qGetStudentInfo.placerepid#) was not found in the system.</font>
                                                    <cfelse>
                                                        #qGetStudentInfo.placefirstname# #qGetStudentInfo.placelastname# (###qGetStudentInfo.placerepid#)
                                                    </cfif>
                                                </td>
                                            </tr>
                                            <tr><td align="right">Supervising :</td>
                                                <td>
                                                    <cfif qGetStudentInfo.arearepid EQ 0>
                                                        <font color="##CC3300">Supervising Rep. has not been assigned yet.</font>
                                                    <cfelseif  NOT LEN(qGetStudentInfo.areaid)>
                                                        <font color="##CC3300">Supervising Rep (###qGetStudentInfoarearepid#) was not found in the system.</font>
                                                    <cfelse>
                                                        #qGetStudentInfo.areafirstname# #qGetStudentInfo.arealastname# (###qGetStudentInfo.arearepid#)
                                                    </cfif>
                                                </Td>
                                            </tr>
                                        </table>
                        			</td>
								</tr>                                   
	                        </table>
                        </div>
                        
                        <br />
                        
                        <table width="100%" align="center">
                        	<tr><td align="center"><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
                        </table>
                    </td>
                </tr>
            </table>

        <!--- Table Footer --->
        <gui:tableFooter 
  	        width="580px"
			imagePath="../"
        />

		<cfif VAL(qGetPlacementHistory.recordcount)>
            <Table width="580px" cellpadding=3 cellspacing="0" align="center" class="history" style="margin-top:10px;">
                <tr><th colspan="6" align="center" bgcolor="##e2efc7">P L A C E M E N T &nbsp; L O G</th></tr>
                
                <cfloop query="qGetPlacementHistory">								
					
                    <tr bgcolor="##D5DCE5" style="font-weight:bold; text-decoration:underline;">
                        <cfif qGetPlacementHistory.original_place EQ 'yes'>
                            <td colspan="2">Date: #DateFormat(dateofchange, 'mm/dd/yyyy')# </td>
                            <td colspan="4" align="left">O R I G I N A L &nbsp; &nbsp; P L A C E M E N T </td>
                        <cfelse>
                            <td colspan="6">Date: #DateFormat(dateofchange, 'mm/dd/yyyy')#</td>
                        </cfif>
                    </tr>
                    <tr style="font-weight:bold; text-decoration:underline;">
                        <td width="90">Host Family</td>
                        <td width="90">School</td>
                        <td width="90">Super Rep.</td>
                        <td width="90">Place Rep.</td>
                        <td width="130">Reason</td>
                        <td width="90">Updated By</td>
                    </tr>	
                    <tr bgcolor="###iif(qGetPlacementHistory.currentrow MOD 2 ,DE("F5F5F5") ,DE("FFFFFF") )#">
                        <td valign="top"><cfif VAL(qGetPlacementHistory.hostid)>#qGetPlacementHistory.familylastname# (###qGetPlacementHistory.hostid#)</cfif></td>
                        <td valign="top"><cfif VAL(qGetPlacementHistory.schoolID)>#qGetPlacementHistory.schoolname# (###qGetPlacementHistory.schoolID#)</cfif></td>
                        <td valign="top"><cfif VAL(qGetPlacementHistory.arearepid)>#qGetPlacementHistory.areafirstname# #qGetPlacementHistory.arealastname# (###qGetPlacementHistory.arearepid#)</cfif></td>
                        <td valign="top"><cfif VAL(qGetPlacementHistory.placerepid)>#qGetPlacementHistory.placefirstname# #qGetPlacementHistory.placelastname# (###qGetPlacementHistory.placerepid#)</cfif></td>
                        <td valign="top">#qGetPlacementHistory.reason#</td>
                        <td valign="top">#qGetPlacementHistory.changedbyfirstname# #qGetPlacementHistory.changedbylastname# (###qGetPlacementHistory.changedby#)</td>
                    </tr>
                   
                </cfloop>
            </table>
        </cfif>
        
	</cfoutput>

<!--- Page Footer --->
<gui:pageFooter
    footerType="application"
/>