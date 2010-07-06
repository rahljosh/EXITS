<!--- ------------------------------------------------------------------------- ----
	
	File:		initial_welcome.cfm
	Author:		Marcus Melo
	Date:		March 15, 2010
	Desc:		Intial Welcome Screen

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <cfsetting requesttimeout="200">

	<!--- the number of weeks to display new items. --->
    <cfparam name="url.new_weeks" default="2">

	<cfset new_date = dateFormat(dateAdd("ww", "-#url.new_weeks#", now()), "mm/dd/yyyy")>
    
    <cfquery name="qGetNewsMessages" datasource="#application.dsn#">
        SELECT 
        	*
        FROM 
        	smg_news_messages
        WHERE 
        	messagetype = <cfqueryparam cfsqltype="cf_sql_varchar" value="news">
        AND
        	expires > #now()# 
        AND
        	startdate < #now()#
        AND
        	lowest_level >= <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.usertype#">
        <!--- Messages for CASE Only --->
		<cfif CLIENT.companyID EQ 10>
        	AND
            	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        <cfelse>
            AND
                (
                    companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                )
        </cfif>
        ORDER BY
        	startdate DESC
    </cfquery>

    <cfquery name="qGetSMGPics" datasource="#application.dsn#" maxrows="1">
        SELECT 
            pictureid, 
            title, 
            description
        FROM 
            smg_pictures
        WHERE 
            active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        ORDER BY 
            rand()
    </cfquery> 

    <cfquery name="qHelpDeskItems" datasource="#application.dsn#">
        SELECT 
        	helpdeskid, 
            title,
            category, 
            priority, 
            text, 
            status, 
            date, 
            submit.firstname as submit_firstname, submit.lastname as submit_lastname,
            assign.firstname as assign_firstname, assign.lastname as assign_lastname
        FROM 
        	smg_help_desk
        LEFT JOIN 
        	smg_users submit ON smg_help_desk.submitid = submit.userid
        LEFT JOIN 
        	smg_users assign ON smg_help_desk.assignid = assign.userid 
        
		<!--- Global Administrator Users --->
        <cfif CLIENT.usertype eq 1>
            WHERE 
                assignid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            AND 
                status = <cfqueryparam cfsqltype="cf_sql_varchar" value="initial">
        <!--- Field and Intl. Rep --->
        <cfelse>            
            WHERE 
                submitid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            AND
                status != <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
        </cfif>	
        ORDER BY 
        	status, 
            date
    </cfquery>

    <cfquery name="qGetNewStudents" datasource="#application.dsn#">
        SELECT 
        	studentid, 
            dateapplication, 
            firstname, 
            familylastname
        FROM
        	smg_students
        WHERE 
        	dateapplication >= <cfqueryparam cfsqltype="cf_sql_date" value="#new_date#">
        AND 
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        <cfif CLIENT.usertype LTE 5>
            AND 
            	regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionid#">
        <cfelseif CLIENT.usertype EQ 6>
            <!--- get reps who the user is the advisor of, and in the company. --->
            <cfquery name="get_reps" datasource="#application.dsn#">
                SELECT DISTINCT 
                	userid 
                FROM
                	user_access_rights
                WHERE
                	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                AND 

                (
                    advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                OR 
                	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                )
            </cfquery>
            <!--- use val() so if get_reps has no results we get 0 instead of null and get no results. --->
            AND 
            	arearepid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#val(valueList(get_reps.userid))#" list="yes"> )
        <cfelseif CLIENT.usertype eq 7 or CLIENT.usertype eq 9>
            AND 
            	arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
        </cfif>
        ORDER BY 
        	dateapplication DESC
    </cfquery>

    <cfquery name="qGetNewUsers" datasource="#application.dsn#">
        SELECT 
        	u.email, 
            u.userid, 
            u.firstname, 
            u.lastname, 
            u.city, 
            u.state, 
            u.datecreated,
            uar.advisorid
        FROM 
        	smg_users u
        INNER JOIN 
        	user_access_rights uar ON u.userid = uar.userid
        WHERE 
        	uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionid#">
        AND 
        	u.datecreated >= <cfqueryparam cfsqltype="cf_sql_date" value="#new_date#">
        <!--- Do not display student view users. Managers shouldn't know who is looking at their kids --->
        AND	
        	uar.userType != <cfqueryparam cfsqltype="cf_sql_integer" value="9">
        ORDER BY 
        	u.datecreated DESC
    </cfquery>
    
</cfsilent>    

<script type="text/javascript">
	<!-- Begin
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function MM_jumpMenu(targ,selObj,restore){ //v3.0
	  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
	  if (restore) selObj.selectedIndex=0;
	}
	// End -->
</script>

<style type="text/css">
	<!--
	.new_weeks {
		font-size: 10px;
	}
	-->
</style>

<cfoutput>

<!--- OFFICE USERS - INTL. REPS AND BRANCHES --->
<cfif listFind("1,2,3,4,8,11", CLIENT.usertype)>

    <table width=100%>
        <tr>
            <td>Your last visit was on #DateFormat(CLIENT.lastlogin, 'mmm d, yyyy')# MST</td>
            <td align="right">#DateFormat(now(), 'MMMM D, YYYY')#</td>
        </tr>
    </table>
    
    <table width=100%>
        <tr>
            <td width=40% valign="top">
            
                <!----News & Announcements---->
                <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                    <tr height=24>
                        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
                        <td background="pics/header_background.gif"><h2>Activities Relating to Today</h2></td>
                        <td background="pics/header_background.gif" width=16></td>
                        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                    
                <table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
                    <tr>
                        <td  valign="top" width="100%"><br>
                            <img src="pics/tower_100.jpg" width=71 height=100 align="left">
                            <!---<img src="http://www.student-management.com/nsmg/pics/clover.gif" width="75" align="left" >--->
                            <cfloop query="qGetNewsMessages">
                                <p><b>#message#</b><br>
                                #DateFormat(startdate, 'MMMM D, YYYY')# - #replaceList(details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#
                                <cfif additional_file is not ''>
                                    <br /><img src="pics/info.gif" height="15" border="0" />&nbsp;<a href="uploadedfiles/news/#additional_file#" target="_blank">Additional Information (pdf)</font></a>
                                </cfif>
                                </p>
                            </cfloop>
                            <cfif NOT VAL(qGetNewsMessages.recordcount)>
                                <br>There are currently no announcements or news items.
                            </cfif>
							<cfif CLIENT.usertype gte 8>
                                <br><br>Please see below for announcements from your organization.
                            </cfif>
                        </td>
                        <td align="right" valign="top" rowspan=2></td>
                    </tr>
                </table>
                
                <!----footer of table---->
                <cfinclude template="table_footer.cfm">
                
            </td>
            <td valign="top" width="1%">&nbsp;</td>
            <td valign="top" width="59%">
				<cfif CLIENT.userid EQ 10115>
                    <cfinclude template="welcome_includes/ef_centraloffice.cfm">
                <cfelseif CLIENT.usertype EQ 8>
                    <cfinclude template="welcome_includes/int_agent_apps.cfm">
                <cfelseif CLIENT.usertype EQ 11>
                    <cfinclude template="welcome_includes/branch_apps.cfm">
                <cfelseif CLIENT.usertype LTE 4>
                    <cfinclude template="welcome_includes/office_apps.cfm">
                </cfif>
            </td>
            <td align="right" valign="top" rowspan="2"></td>
        </tr>
    </table>
    
<!---- FIELD --->
<cfelse>

    <cfquery name="qIncentiveTrip" datasource="#application.dsn#">
        SELECT 
        	tripID,
            trip_place
        FROM 
        	smg_incentive_trip 
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>

    <cfquery name="qTotalIncentiveTrip" datasource="#application.dsn#">
        SELECT
        	COUNT(s.studentID) AS count
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_programs ON smg_programs.programid = s.programid
        INNER JOIN 
        	smg_incentive_trip t ON smg_programs.tripid = t.tripid
        WHERE 
        	s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#"> 
        AND 
        	s.host_fam_approved < <cfqueryparam cfsqltype="cf_sql_integer" value="5">
        AND 
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	t.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">  
    </cfquery>
    
    <!--- Get only 10 August Placements - 10 Month and 1st Semester --->
    <cfquery name="qTotalPlacedCurrent" datasource="#application.dsn#">
        SELECT
        	COUNT(s.studentID) AS count
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_programs p ON p.programid = s.programid AND p.type IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,3,5,25" list="yes"> )
        INNER JOIN 
        	smg_incentive_trip t ON p.tripid = t.tripid
        WHERE 
        	s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#"> 
        AND 
        	s.host_fam_approved < <cfqueryparam cfsqltype="cf_sql_integer" value="5">
        AND 
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	t.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">  
    </cfquery>

	<!--- 
		Get only 10 August Placements - 10 Month and 1st Semester
		It does not include students that were cancelled prior to August 31st 
	--->
    <cfquery name="qTotalPlacedPrevious" datasource="#application.dsn#">
        SELECT
        	COUNT(s.studentID) AS count
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_programs p ON p.programid = s.programid AND p.type IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,3,5,25" list="yes"> )
        INNER JOIN 
        	smg_incentive_trip t ON p.tripid = t.tripid
        WHERE 
        	s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#"> 
        AND 
        	s.host_fam_approved < <cfqueryparam cfsqltype="cf_sql_integer" value="5">
        <!--- Get active students or students canceled after July 31st that either withdrewl or terminated the program --->
        AND 
        	(
            	s.cancelDate IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
			OR
				(
                	s.cancelDate > <cfqueryparam cfsqltype="cf_sql_date" value="#Year(now())-1#-07-31">                
                AND    
                 	(
                    	s.cancelReason = <cfqueryparam cfsqltype="cf_sql_varchar" value="Withdrawl">   
					OR
                 		s.cancelReason = <cfqueryparam cfsqltype="cf_sql_varchar" value="Termination">   
					)
             	)
             )
        AND 
        	t.tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qIncentiveTrip.tripID - 1#">  
    </cfquery>

    <cfscript>
		// Number of Placements for previous season
		setPlacedPrevious = qTotalPlacedPrevious.count;
		//setPlacedPrevious = 0;
		
		// Number of Placements for current season
		setPlacedCurrent = qTotalPlacedCurrent.count;
		//setPlacedCurrent = 6;
		
		// Number of minimum placements to get 1st bonus (previous placement + 3)
		setMinCurrent = setPlacedPrevious + 3;
		
		// Declare Multiplier
		setMultiplier = 0;

		// Declare First Bonus
		firstBonusMessage = '';

		// Set current row used in the loop
		currentRow = 0;

		if ( ListFind("0,1,2,3,4,5", setPlacedPrevious) ) {
			// Starts at $450 with $50 increment for 0-5 students placed previous year
			setBonus = 450 + (50 * setPlacedPrevious);		
		} else if ( ListFind("6,7,8,9,10", setPlacedPrevious) ) {
			// $800 bonus for 6-10 students placed previous year
			setBonus = 800;
		} else if ( ListFind("11,12,13,14,15", setPlacedPrevious) ) {
			// $900 bonus for 11-15 students placed previous year
			setBonus = 900;
		} else {
			// $1000 bonus for 16 students placed previous year and on 
			setBonus = 1000;
		}
		
		// Check if setMinCurrent goal has been reached, if yes user won a bonus and we need to reset setMinCurrent
		if ( setPlacedCurrent >= setMinCurrent ) {
			
			// Calculate how many times bonus needs to be multiplied
			setFirstBonusMultiplier = fix( (setPlacedCurrent - setPlacedPrevious) / 3);
			firstBonusMessage = "<h2>Congratulations! You've won a bonus of #DollarFormat(setBonus * setFirstBonusMultiplier)#.</h2>";
		
			// setMinCurrent has been reached. Set a new setMinCurrent in increments of 3
			do {
				setMinCurrent = setMinCurrent + 3;
			} while ( setPlacedCurrent GTE setMinCurrent );
		}
	</cfscript>
    
    <table width=100%>
        <tr>
            <td>Your last visit was on #DateFormat(CLIENT.lastlogin, 'mmm d, yyyy')# MST</td>
            <td align="right">
                <cfset tripcount = 7 - qTotalIncentiveTrip.Count>
                <cfif qTotalIncentiveTrip.Count LT 7>
                    You're only #tripcount# placements away from a trip to <A href="http://www.student-management.com/flash/images/incentiveTrip2010.pdf" target="_blank">#qIncentiveTrip.trip_place#!</A>
                <cfelse>
                    You've earned a trip to <A href="http://www.student-management.com/flash/images/incentiveTrip2010.pdf" target="_blank">#qIncentiveTrip.trip_place#!!!</A> 
                </cfif>
            </td>
        </tr>
    </table>
    
    <!----News & Announcements---->
    <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
        <tr height=24>
            <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
            <td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
            <td background="pics/header_background.gif"><h2>Activities Relating to Today</h2></td>
            <td background="pics/header_background.gif" width=16></td>
            <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
        </tr>
    </table>
    
    <table width=100% cellpadding=4 cellspacing=0 border=0 class="section">
        <tr>
           <td  valign="top" width="100%"><br>
                <img src="pics/tower_100.jpg" width=71 height=100 align="left">
                <!---<img src="http://www.student-management.com/nsmg/pics/clover.gif" width="75" align="left" >--->
                <cfloop query="qGetNewsMessages">
                    <p><b>#message#</b><br>
                    #DateFormat(startdate, 'MMMM D, YYYY')# - #replaceList(details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#
                    <cfif additional_file is not ''>
                        <br /><img src="pics/info.gif" height="15" border="0" />&nbsp;<a href="uploadedfiles/news/#additional_file#" target="_blank">Additional Information (pdf)</font></a>
                    </cfif>
                    </p>
                </cfloop>
                <cfif NOT VAL(qGetNewsMessages.recordcount)>
                    <br>There are currently no announcements or news items.
                </cfif>
                <cfif CLIENT.usertype gte 8>
                    <br><br>Please see below for announcements from your organization.
                </cfif>
          </td>
          <td align="right" valign="top" rowspan=2>
                <!--- Intl. Rep Pictures --->
                <cfif CLIENT.usertype EQ 8>
                    <cfset pic_num = RandRange(1,34)>
                    <img src="pics/intrep/#pic_num#.jpg"><br>
                <cfelse>
                	<!--- Field Incentive Trip Pictures --->
                    <cfif LEN(qGetSMGPics.description)>
                        <a href="index.cfm?curdoc=picture_details&pic=#qGetSMGPics.pictureid#">
                            <img src="uploadedfiles/welcome_pics/#qGetSMGPics.pictureid#.jpg" border="0"><br>
                            <em>#qGetSMGPics.title#</em><br>
                            <img src="pics/view_details.gif" border="0">
                    	</a>                    
                    <cfelse>
                        <img src="uploadedfiles/welcome_pics/#qGetSMGPics.pictureid#.jpg" border="0"><br>
                        <em>#qGetSMGPics.title#</em><br>
                        <img src="pics/view_details.gif" border="0">                    
                    </cfif>
                </cfif>	
            </td>
        </tr>
    </table>
    
    <!----footer of table---->
    <cfinclude template="table_footer.cfm">
    
</cfif>
<!--- END OF FIELD --->
    
<br>

<!----CURRENT ITEMS---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/current_items.gif"></td>
        <td background="pics/header_background.gif"><h2>Current Items</h2></td>
        <td background="pics/header_background.gif" width=16></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<!---- OFFICE AND FIELD ---->			
<cfif ListFind("1,2,3,4,5,6,7,9", CLIENT.usertype)>        
    
    <table width=100% cellspacing=0 border=0 class="section">
        <tr>
            <td align="center">               
                
                <table cellpadding=2 cellspacing=4 width=100%>
                <tr>
                    <td class="get_attention"><span class="get_attention"><b>::</b></span> Items Needing Attention</u></td>
                    <!--- Office Users --->
					<cfif CLIENT.usertype lte 4>
                    	<td class="get_attention"><span class="get_attention"><b>::</b></span> Your Current Help Desk Tickets</td>
                    <!--- Field Users --->
					<cfelseif ListFind("5,6,7,9", CLIENT.userType)>
                    	<td class="get_attention"><span class="get_attention"><b>::</b></span> WebEx Calendar</td>
                    </cfif>
                </tr>
                <tr valign="top">
                    <td style="line-height:20px;">
                        <a href="index.cfm?curdoc=progress_reports">Progress Reports</a><br>
                        <a href="index.cfm?curdoc=project_help">H.E.L.P. Community Service Hours</a><br>
                        <a href="index.cfm?curdoc=pending_hosts">View Pending Placements</a><br />
                        <cfif CLIENT.userType LTE 4>
                        	<a href="index.cfm?curdoc=calendar/index">WebEx Calendar</a> <br />
                        </cfif>
                       <cfif client.companyid lte 5>
                        <a href="uploadedfiles/pdf_docs/ISE/payment/Aug%2010%20bonus%20flyer%202.pdf" target="_blank">Click Here For Exciting Bonuses For The Placing Season!</a>
                   		</cfif>
                    </td>
         			<!--- Office Users --->
					<cfif CLIENT.usertype LTE 4>
						<td>
                            <table cellpadding=4 cellspacing =0 border=0>
                                <tr><td>Submitted</td><td>Title</td><td>Status</td></Tr>
                                <cfloop query="qHelpDeskItems">
                                    <tr bgcolor="#iif(qHelpDeskItems.currentrow MOD 2 ,DE("eeeeee") ,DE("white") )#">
                                        <td width="10%" valign="top">#DateFormat(date, 'mm/dd/yyyy')#</td>
                                        <td width="21%"valign="top"><a href="?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">#title#</a></td>
                                        <td width="10%"valign="top">#status#</td>
                                    </tr>
                                </cfloop>
                                <cfif NOT VAL(qHelpDeskItems.recordcount)>
                                    <tr><td colspan="6" bgcolor="ffffe6" valign="top">You have no open or recently completed tickets on the Help Desk</td></tr>
                                </cfif>
                            </table>
						</td>
					<!--- Field Users --->                        
                    <cfelseif ListFind("5,6,7,9", CLIENT.userType)>
						<td>
                            <table cellpadding=4 cellspacing =0 border=0>
                                <tr>
                                	<td valign="top">
                                        <a href="index.cfm?curdoc=calendar/index">Click here to register for WebEx Meetings <br /></a>
                                        <a href="index.cfm?curdoc=calendar/index"><img src="pics/webex-logo.jpg" border=0></a>                                        
                                	</td>
                                </tr>
                            </table>
						</td>
                    </cfif>
                </tr>
                <tr>
                    <td></td>
                </tr>
                <tr>
                    <td class="get_attention" width=50%><span class="get_attention"><b>::</b></span> New Students <font size=-2>since #new_date#</font></u></td>                    
                    <!--- Thank You Bonus - Only Available for ISE --->
                    <cfif ListFind("1,2,3,4,12", CLIENT.companyID) AND ListFind("5,6,7,9", CLIENT.userType)>
                    	<td class="get_attention"><span class="get_attention"><b>::</b></span> Thank You Bonus</u></td>
					<cfelse>
                    	<td class="get_attention"><span class="get_attention"></span></td>
                    </cfif>                        
                </tr>
                <tr valign="top">
                    <!--- New Students --->
                    <td>
						<!--- this is used to display the message if the user was added since last login. --->
                        <cfset since_lastlogin = 0>
                        <cfloop query="qGetNewStudents">
                            <!--- highlight if user was added since last login. --->
                            <cfif dateapplication GTE CLIENT.lastlogin>
                                <a href="index.cfm?curdoc=student_info&studentid=#studentid#"><font color="FF0000">#firstname# #familylastname#</font></a>
                                <cfset since_lastlogin = 1>
                            <cfelse>
                                <a href="index.cfm?curdoc=student_info&studentid=#studentid#">#firstname# #familylastname#</a>
                            </cfif>
                            <br>
                        </cfloop>
                        <cfif NOT VAL(qGetNewStudents.recordcount)>
                            There are no new students.
                        </cfif>
                        <cfif since_lastlogin>
                            <br /><font color="FF0000">students in red were added since your last visit</font>
                        </cfif>
                    </td>
                    
                    <!--- Thank You Bonus - Only Available for ISE --->
                    <cfif ListFind("1,2,3,4,12", CLIENT.companyID) AND ListFind("5,6,7,9", CLIENT.userType)>
                        <td>
                        
                            <table width="100%" cellpadding="2" cellspacing="2">
                                <tr>
                                    <th>#setPlacedPrevious# August students placed in #Year(now())-1#</th>
                                    <th>#setPlacedCurrent# August students placed in #Year(now())#</th>
                                </tr>            
                            </table>   <br />  

                            <div style="float:left" style="padding-right:15px; padding-left:15px;">
                            	<img src="pics/thankYouBonus.jpg" border="0">
                            </div>
                            
                            <div style="padding-top:10px; float:left;">
								
								<cfif LEN(firstBonusMessage)>
                                   #firstBonusMessage# <br />
                                </cfif>
                                
								<!--- Show 5 Placement Bonus Opportunities - Increments of 3 --->
                                <cfloop from="#setMinCurrent#" to="#setMinCurrent + 12#" index="i" step="3">
                                    
                                    <cfscript>                                        
										currentRow = currentRow + 1;
										
										// Declare default bonus message
										bonusMessage = '';
										
										// Set how many times bonus will be applied
										if ( LEN(firstBonusMessage) AND currentRow EQ 1 ) {
											// 1st bonus amount
											setMultiplier = 1;
										} else if ( NOT LEN(firstBonusMessage) AND ListFind("1,2", currentRow) ) {											
											// 1st and 2nd bonus have the same value if there is no first bonus
											setMultiplier = 1;
										} else {
											setMultiplier = setMultiplier + 1;
										}
																			
                                        // Set Additional Bonus	        
										setAddtionalBonus = setBonus * setMultiplier;
                                        
										// Calculate how many placements user is away from bonus
										setAwayPlacements = i - setPlacedCurrent;
										if ( setAwayPlacements EQ 1 ) {
											awayMessage = 'placement';													
										} else {
											awayMessage = 'placements';	
										}
										
                                        if ( (setPlacedCurrent >= i AND setPlacedCurrent < i + 3)  ) {
                                            // Check if setPlacedCurrent is bigger than current bonus and smaller than next bonus
                                            bonusMessage = "<h2>Congratulations! You've won a bonus of #DollarFormat(setAddtionalBonus)#.</h2>";	
                                        } else if ( currentRow EQ 1 AND setAwayPlacements GT 0 AND NOT LEN(firstBonusMessage) ) {
											// First Bonus Message
											bonusMessage = "You're <strong>#setAwayPlacements#</strong> #awayMessage# away from a <strong>#DollarFormat(setAddtionalBonus)#</strong> bonus.";						
										} else if (setPlacedCurrent < i ) {
                                            // Additional Bonuses - Check if Current Placements is less than current bonus
                                            bonusMessage = "You're <strong>#setAwayPlacements#</strong> #awayMessage# away from an additional #DollarFormat(setAddtionalBonus)#</strong> bonus.";						
                                        } 
                                    </cfscript>
									
                                    <!---
                                    setFirstBonusMultiplier -> #setFirstBonusMultiplier# //
                                    setPlacedCurrent -> #setPlacedCurrent# //
                                    setMinCurrent -> #setMinCurrent# //
                                    maxLoop -> #setMinCurrent + 15# // 
                                    i -> #i# // 
                                    setAddtionalBonus -> #setAddtionalBonus# //  <br />
                                    setAwayPlacements -> #setAwayPlacements# // setMultiplier -> #setMultiplier# <br /><br />
                                    --->
                                    
									<cfif LEN(bonusMessage)>
                                       #bonusMessage# <br />
                                    </cfif>
                    
                            	</cfloop>
                                
                        	</div>
                            
                        </td>
                    </cfif>
                </tr>
                <tr>
                    <td class="get_attention" width=50%><span class="get_attention"><b>::</b></span> New Users <font size=-2>since #new_date#</font></u></td>
                    <td class="get_attention"><span class="get_attention"></span></td>
                </tr>
                <tr valign="top">
                    <!--- New Users --->
                    <td>
                        <cfif NOT VAL(qGetNewUsers.recordcount) OR CLIENT.usertype GTE 6>
                            There are no new reps in your region.
                        <cfelse>
                            
                            <cfscript>
								// this is used to display the message if the user was added since last login.
								since_lastlogin = 0; 
								
								// this is used to display the message if the user is the advisor of any new users.
								is_advisor = 0;
							</cfscript>

                            <cfloop query="qGetNewUsers"> 
								<!--- put * if user is the advisor for this user. --->
                                <cfif advisorid EQ CLIENT.userid>
                                    <font color="FF0000" size="4"><strong>*</strong></font>
			                        <cfset is_advisor = 1>
                                </cfif>
                            	<a href="mailto:#email#"><img src="pics/email.gif" border=0 align="absmiddle"></a>
								<!--- highlight if user was added since last login. --->
                                <cfif datecreated GTE CLIENT.lastlogin>
                                    <a href="index.cfm?curdoc=user_info&userid=#userid#"><font color="FF0000">#firstname# #lastname#</font></a> <font color="FF0000">of #city#, #state#</font>
			                        <cfset since_lastlogin = 1>
                                <cfelse>
                                    <a href="index.cfm?curdoc=user_info&userid=#userid#">#firstname# #lastname#</a> of #city#, #state#
                                </cfif>
                                <br>
                            </cfloop>
                            <cfif since_lastlogin>
                            	<br /><font color="FF0000">users in red were added since your last visit</font>
                            </cfif>
                            <cfif is_advisor>
                            	<br /><font color="FF0000" size="4"><strong>*</strong></font> reps assigned to you
                            </cfif>
                        </cfif>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td></td>
                </tr>
                <tr>
                    <form name="form" id="form">
                    <td><font size="1">
						Display students & users newer than
                        <select name="jumpMenu" id="jumpMenu" onchange="MM_jumpMenu('parent',this,0)" class="new_weeks">
                            <option value="index.cfm?curdoc=initial_welcome&new_weeks=1" <cfif url.new_weeks EQ 1>selected="selected"</cfif>>1 Week</option>
                            <option value="index.cfm?curdoc=initial_welcome&new_weeks=2" <cfif url.new_weeks EQ 2>selected="selected"</cfif>>2 Weeks</option>
                            <option value="index.cfm?curdoc=initial_welcome&new_weeks=3" <cfif url.new_weeks EQ 3>selected="selected"</cfif>>3 Weeks</option>
                            <option value="index.cfm?curdoc=initial_welcome&new_weeks=4" <cfif url.new_weeks EQ 4>selected="selected"</cfif>>4 Weeks</option>
                            <option value="index.cfm?curdoc=initial_welcome&new_weeks=5" <cfif url.new_weeks EQ 5>selected="selected"</cfif>>5 Weeks</option>
                            <option value="index.cfm?curdoc=initial_welcome&new_weeks=6" <cfif url.new_weeks EQ 6>selected="selected"</cfif>>6 Weeks</option>
                        </select>
                    </font></td>
                    </form>
                </tr>
            </table>
            
            </td>
        </tr>
    </table>

<!---- INTERNATIONAL REPRESENTATIVES - WELCOME SCREEN ---->
<cfelseif CLIENT.usertype EQ 8>

    <cfquery name="companyname" datasource="#application.dsn#">
        select businessname
        from smg_users
        where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.parentcompany#">
    </cfquery>

	<table cellpadding=2 cellspacing=4 width=100% bgcolor="##ffffff" class="section">
		<tr>
			<td class="get_attention" width=50%><span class="get_attention"><b>::</b></span> News, Alerts, and Updates from #companyname.businessname#</u></td>
			<td class="get_attention"><span class="get_attention"><b>::</b></span> Your Current Help Desk Tickets </Td>
		</tr>
		<tr>
			<td valign="top">
			<cfquery name="intagent_messages" datasource="#application.dsn#">
                select *
                from smg_intagent_messages
                where parentcompany = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.parentcompany#">
                and expires > #now()#
                and startdate < #now()#
			</cfquery>
			<cfquery name="intagent_alert_messages" dbtype="query">
                select *
                from intagent_messages
                where messagetype = 'alert'
			</cfquery>
			<cfquery name="intagent_update_messages" dbtype="query">
                select *
                from intagent_messages
                where messagetype = 'update'
			</cfquery>
			<cfquery name="intagent_news_messages" dbtype="query">
                select *
                from intagent_messages
                where messagetype = 'news'
			</cfquery>
			<div align="center"><h3>News</h3></div>
			<cfif intagent_alert_messages.recordcount>
                <cfloop query="intagent_news_messages">
                    <cfif intagent_news_messages.details is not ''><b>#message#</b><br>
                        <div align="justify">#DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#</div>
                    </cfif>
                </cfloop>
			<cfelse>
				There are currently no annoucements or news items from #companyname.businessname#
			</cfif>
			<cfif intagent_alert_messages.recordcount>
                <div class="alerts"><h3>Alerts</h3><br>
                <cfloop query="intagent_alert_messages">
                    <cfif intagent_alert_messages.details is not ''><b>#message#</b><br>
                        <div align="justify">#DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#</div>
                    </cfif>
                </cfloop>
                </div>
            </cfif>
			<cfif intagent_update_messages.recordcount>
                <div class="updates"><h3>Updates</h3><br>
                <cfloop query="intagent_update_messages">
                    <cfif intagent_update_messages.details is not ''><b>#message#</b><br>
                        <div align="justify">#DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#</div>
                    </cfif>
                </cfloop>
                </div>
            </cfif>
			</td>
			<td valign="top">
				<table cellpadding=4 cellspacing=0 border=0>
					<tr>
                    	<td>&nbsp;</td>
                    	<td>Submitted</td>
                        <td>Title</td>
                        <td>Status</td>
                    </tr>
                    <cfloop query="qHelpDeskItems">
                        <tr bgcolor="#iif(qHelpDeskItems.currentrow MOD 2 ,DE("eeeeee") ,DE("white") )#">
                            <td><a href="index.cfm?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">View</a></td>
                            <td>#DateFormat(date, 'mm/dd/yyyy')#</td>
                            <td>#title#</td>
                            <td>#status#</td>
                        </tr>
                    </cfloop>
					<cfif NOT VAL(qHelpDeskItems.recordcount)>
                        <tr><td colspan="4" bgcolor="ffffe6" valign="top">You have no open or recently completed tickets on the Help Desk</td></tr>
                    </cfif>
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>

<!--- INTERNATIONAL BRANCH --->
<cfelseif CLIENT.usertype EQ 11>
  
		<table cellpadding=2 cellspacing=4 width=100% bgcolor="##ffffff" class="section">
		<tr>
			<td class="get_attention"><span class="get_attention"><b>::</b></span> Your Current Help Desk Tickets</td>
		</tr>
		<tr>
			<td valign="top">
				<table cellpadding=4 cellspacing =0 border=0>
					<tr><td>Submitted</td><td>Title</td><td>Status</td></Tr>
                    <cfloop query="qHelpDeskItems">
                        <tr bgcolor="#iif(qHelpDeskItems.currentrow MOD 2 ,DE("eeeeee") ,DE("white") )#">
                            <td width="10%" valign="top">#DateFormat(date, 'mm/dd/yyyy')#</td>
                            <td width="21%"valign="top"><a href="index.cfm?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">#title#</a></td>
                            <td width="10%"valign="top">#status#</td>
                        </tr>
                    </cfloop>
                    <cfif NOT VAL(qHelpDeskItems.recordcount)>
                        <tr><td colspan="6" bgcolor="ffffe6" valign="top">You have no open or recently completed tickets on the Help Desk</td></tr>
                    </cfif>
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		</table>

</cfif>

<!----footer of table---->
<cfinclude template="table_footer.cfm">

</cfoutput>