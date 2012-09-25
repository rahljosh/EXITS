<!--- ------------------------------------------------------------------------- ----
	
	File:		initial_welcome.cfm
	Author:		Marcus Melo
	Date:		March 15, 2010
	Desc:		Initial Welcome Screen

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <cfsetting requesttimeout="200">

	<!--- the number of weeks to display new items. --->
    <cfparam name="url.new_weeks" default="2">

	<cfset new_date = dateFormat(dateAdd("ww", "-#url.new_weeks#", now()), "mm/dd/yyyy")>
    
    <cfquery name="news_messages" datasource="#application.dsn#">
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
        <cfif CLIENT.companyID EQ 10 or CLIENT.companyID EQ 11 or CLIENT.companyid EQ 13 or CLIENT.companyid EQ 14>
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

    <cfquery name="smg_pics" datasource="#application.dsn#" maxrows="1">
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

    <cfquery name="help_desk_user" datasource="#application.dsn#">
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

    <cfquery name="new_students" datasource="#application.dsn#">
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

    <cfquery name="get_new_users" datasource="#application.dsn#">
        SELECT 
        	u.email, 
            u.userid, 
            u.firstname, 
            u.lastname, 
            u.city, 
            u.state, 
            u.datecreated,
            u.whocreated,
            u.accountCreationVerified,
            u.dateAccountVerified,
            u.active,
            uar.advisorid
        FROM 
        	smg_users u
        INNER JOIN 
        	user_access_rights uar ON u.userid = uar.userid
        WHERE 
        <cfif client.usertype gte 5>
           	uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionid#">
    	<cfelse>
        	uar.companyid = #client.companyid#
        </cfif>
        AND 
        	u.datecreated >= <cfqueryparam cfsqltype="cf_sql_date" value="#new_date#">
        <!--- Do not display student view users. Managers shouldn't know who is looking at their kids --->
        AND	
        	uar.userType != <cfqueryparam cfsqltype="cf_sql_integer" value="9">
        ORDER BY 
        	u.datecreated DESC
    </cfquery>
    
        <cfquery name="placed_students" datasource="#application.dsn#">
        SELECT COUNT(*) AS Count
        FROM smg_students
        INNER JOIN smg_programs ON smg_programs.programid = smg_students.programid
        INNER JOIN smg_incentive_trip ON smg_programs.tripid = smg_incentive_trip.tripid
        WHERE smg_students.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#"> 
        AND smg_students.host_fam_approved < 5 
        AND smg_students.active = 1
        AND smg_incentive_trip.active = 1
    </cfquery>

    <cfquery name="incentive_trip" datasource="#application.dsn#">
        SELECT trip_place
        FROM smg_incentive_trip 
        WHERE active = 1
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
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function MM_jumpMenu(targ,selObj,restore){ //v3.0
	  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
	  if (restore) selObj.selectedIndex=0;
	}
	// End -->
</script>

<!--- Display Host Lead Pop Up --->
<cfif CLIENT.displayHostLeadPopUp>

	<script language="javascript">
		// JQuery ColorBox Modal
		$(document).ready(function(){ 
			$.fn.colorbox( {href:'hostLeads/index.cfm?action=needAttention', iframe:true,width:'60%',height:'50%', onLoad: function() { }} );
		}); 
	</script>

</cfif>

<style type="text/css">
	<!--
	.new_weeks {
		font-size: 10px;
	}
	-->
</style>

<cfoutput>
<cfif client.companyid eq 10 OR client.companyid eq 14 OR client.companyid eq 11>
	<cflocation url="?curdoc=old_initial_welcome">
</cfif>
<!--- OFFICE USERS - INTL. REPS AND BRANCHES --->
<cfif listFind("1,2,3,4,5,6,7,8,11,15", CLIENT.usertype)>
<!----news section, if there is a news item---->
    <table width=100%>
        <tr>
            <td>Your last visit was on #DateFormat(CLIENT.lastlogin, 'mmm d, yyyy')# MST</td>
            <td align="right">#DateFormat(now(), 'MMMM D, YYYY')#</td>
        </tr>
    </table>
<cfif news_messages.recordcount gt 0>
<div class="rdholder"> 
				<div class="rdtop"> 
                <span class="rdtitle">Please take note...</span> 
            </div> <!-- end top --> 
             <div class="rdbox">
			<img src="pics/newsIcon.png" width=65 height=65 align="left">
            
      
						<cfloop query="news_messages">
                                    <p><b>#message#</b><br>
                                    #DateFormat(startdate, 'MMMM D, YYYY')# - #replaceList(details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#
                                    <cfif additional_file is not ''>
                                        <br /><img src="pics/info.gif" height="15" border="0" />&nbsp;<a href="uploadedfiles/news/#additional_file#" target="_blank">Additional Information (pdf)</font></a>
                                    </cfif>
                                    </p>
                                </cfloop>
				
			</div>
             <div class="rdbottom"></div> <!-- end bottom --> 
            
             </div>
</cfif>
    <table width=100%>
        <tr>
            <td></td>
        </tr>
    </table>
<Cfif client.usertype eq 15>
 <!----Current Items ---->
		   <div class="rdholder" style="width:100%;float:left;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Online Reports</span> 
               
            	</div> <!-- end top --> 
             <div class="rdbox">
             <table width=90% align="center" cellpadding=4>
             	<tr>
                	
			
                    <td><img src="pics/icons/annualPaperwork.png" border="0" title="Click Here to fill out  your annual paperwork" /></td>
				     <td>
                     	<a href="index.cfm?curdoc=user/index">
                          Yearly Paperwork
                        </a>
                    </td>
                    <td></td><td></td>
                 </tr>
             
                    	<tr>
                        <!----Progress Reports---->
                        	<Td width=22><img src="pics/icons/onlineReports.png" /></Td><td>          
							<cfif client.usertype eq 15>
                                <a href="index.cfm?curdoc=secondVisitReports">Second Visit Reports</a><br>
                            <cfelse>
                                <a href="index.cfm?curdoc=progress_reports">Progress Reports</a>
                                / 
                                <a href="index.cfm?curdoc=secondVisitReports">Second Visit Reports</a>
                            </cfif>
                            </td>
                        
                        <!----View Pending Placements---->
                        <cfif client.usertype lte 7>
                        
                        	<Td  width=22><img src="pics/icons/viewPlacements.png" /></Td><td>
                            
                            <a href="index.cfm?curdoc=pendingPlacementList">View Pending Placements</a></td>
                        
                        </cfif>
                      	<!----Help Project---->
                        </tr>
                         <tr>
                        <cfif (CLIENT.companyID LTE 5 or CLIENT.companyID EQ 12 or client.companyID eq 10) and client.usertype lte 7>
                       
                        	<Td  width=22><img src="pics/icons/HelpHours.png" /></Td><td>	
                            <a href="index.cfm?curdoc=project_help">H.E.L.P. Community Service Hours</a></td>
                      
                        </cfif>
                        	
                        
                        
                        <cfif APPLICATION.CFC.USER.isOfficeUser() and (CLIENT.companyID LTE 5 or CLIENT.companyID EQ 12 or client.companyid eq 10)>
                      
                        	<Td  width=22><img src="pics/icons/webex.png" /></Td><td>	
                            <a href="index.cfm?curdoc=calendar/index">WebEx Calendar</a></td>
                        
                        </cfif>
                        </tr>
                      </Table>
                        
                  
                
    		</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>

<CFABORT>
</CFIF>
<!----Left column for alignment purposes---->
<div style="width:49%;float:left;display:block;">

			<!----Student Applications---->
		   <div class="rdholder" style="width:100%;float:left;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Host  Applications</span> 
               
            	</div> <!-- end top --> 
             <div class="rdbox">
			<cfinclude template="welcome_includes/hostAppsOffice.cfm">
                
    		</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
  			<!----End Student Applications---->
          
            <!----Current Items ---->
		   <div class="rdholder" style="width:100%;float:left;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Online Reports</span> 
               
            	</div> <!-- end top --> 
             <div class="rdbox">
             <table width=90% align="center" cellpadding=4>
             	<tr>
                	
			
                    <td><img src="pics/icons/annualPaperwork.png" border="0" title="Click Here to fill out  your annual paperwork" /></td>
				     <td>		<a href="index.cfm?curdoc=user/index">
                          Yearly Paperwork
                        </a>
                    </td>
                    <td></td><td></td>
                 </tr>
             
                    	<tr>
                        <!----Progress Reports---->
                        	<Td width=22><img src="pics/icons/onlineReports.png" /></Td><td>          
							<cfif client.usertype eq 15>
                                <a href="index.cfm?curdoc=secondVisitReports">Second Visit Reports</a><br>
                            <cfelse>
                                <a href="index.cfm?curdoc=progress_reports">Progress Reports</a>
                                / 
                                <a href="index.cfm?curdoc=secondVisitReports">Second Visit Reports</a>
                            </cfif>
                            </td>
                        
                        <!----View Pending Placements---->
                        <cfif client.usertype lte 7>
                        
                        	<Td  width=22><img src="pics/icons/viewPlacements.png" /></Td><td>
                            
                            <a href="index.cfm?curdoc=pendingPlacementList">View Pending Placements</a></td>
                        
                        </cfif>
                      	<!----Help Project---->
                        </tr>
                         <tr>
                        <cfif (CLIENT.companyID LTE 5 or CLIENT.companyID EQ 12 or client.companyID eq 10) and client.usertype lte 7>
                       
                        	<Td  width=22><img src="pics/icons/HelpHours.png" /></Td><td>	
                            <a href="index.cfm?curdoc=project_help">H.E.L.P. Community Service Hours</a></td>
                      
                        </cfif>
                        	
                        
                        
                        <cfif APPLICATION.CFC.USER.isOfficeUser() and (CLIENT.companyID LTE 5 or CLIENT.companyID EQ 12 or client.companyid eq 10)>
                      
                        	<Td  width=22><img src="pics/icons/webex.png" /></Td><td>	
                            <a href="index.cfm?curdoc=calendar/index">WebEx Calendar</a></td>
                        
                        </cfif>
                        </tr>
                      </Table>
                        
                  
                
    		</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
             <div class="rdholder" style="width:100%;float:right;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Incentives</span> 
            	</div> <!-- end top --> 
             <div class="rdbox">
             <cfif client.companyid lte 5>
                        <Table width=90% align="center" cellpadding=4>
                        	<Tr>
                            	<Td width=22><img src="pics/icons/bonus.png" /></td>
                                <td><a href="uploadedfiles/pdf_docs/ISE/promotion/Pre-Ayp%20Bonus%202012.pdf" target="_blank">Pre-AYP</a> </td>
                            </Tr>	
                            <Tr>
                            	<td><img src="pics/icons/bonus2.png" /></td>
                                <td><a href="uploadedfiles/pdf_docs/ISE/promotion/Early%20Placement%20Bonus%202012.pdf" target="_blank">Early Placement</a> </td>
                            </Tr>
                            <Tr>
                            	<td><img src="pics/icons/bonus.png" /></td>
                                <td><a href="slideshow/pdfs/CASE/CEOBonus.pdf" target="_blank">CEO Placement Bonus</a></td>
                            </Tr>
                         </Table>
                           	
			 <cfelse>
             There are currently no available bonuses
             </cfif>
             
                    
			
             
             </div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>

			
			<!----New Students---->
             <div class="rdholder" style="width:100%;float:right;"> 
				<div class="rdtop"> 
                <span class="rdtitle">New Students</span> 
            	</div> <!-- end top --> 
             <div class="rdbox">
            <cfif new_students.recordcount eq 0>
                           <em> There are no new students.</em>
                        <cfelse>
                            <!--- this is used to display the message if the user was added since last login. --->
                            <cfset since_lastlogin = 0>
                            <cfloop query="new_students">
								<!--- highlight if user was added since last login. --->
                                <cfif dateapplication GTE CLIENT.lastlogin>
                                    <a href="index.cfm?curdoc=student_info&studentid=#studentid#"><font color="FF0000">#firstname# #familylastname#</font></a>
			                        <cfset since_lastlogin = 1>
                                <cfelse>
                                    <a href="index.cfm?curdoc=student_info&studentid=#studentid#">#firstname# #familylastname#</a>
                                </cfif>
                                <br>
                            </cfloop>
                            <cfif since_lastlogin>
                            	<br /><font color="FF0000">students in red were added since your last visit</font>
                            </cfif>
                        </cfif>
                    
			
             
             </div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
                 	
    <!--- ------------------------------------------------------------------------- ---->
	<!---- Right Column---->
    <!--- ------------------------------------------------------------------------- ---->
    <!--- ------------------------------------------------------------------------- ---->
    <!--- ------------------------------------------------------------------------- ---->
     </div>
  <div style="width:49%;float:right;display:block;">
            
     <!-----Student Applications---->
	
		   <div class="rdholder" style="width:100%;float:right;"> 
           <cfif client.usertype lte 7 AND client.usertype GT 4>
           <cfinclude template="welcome_includes/adds.cfm">
           <cfelse>
				<div class="rdtop"> 
                <span class="rdtitle">Student Applications </span> 
            	</div> <!-- end top --> 
             <div class="rdbox">
             <cfif CLIENT.userid EQ 10115>
                    <cfinclude template="welcome_includes/ef_centraloffice.cfm">
                <cfelseif CLIENT.usertype EQ 8>
                    <cfinclude template="welcome_includes/int_agent_apps.cfm">
                <cfelseif CLIENT.usertype EQ 11>
                    <cfinclude template="welcome_includes/branch_apps.cfm">
                <cfelseif CLIENT.usertype LTE 4>
                    <cfinclude template="welcome_includes/office_apps.cfm">
                </cfif>
                	
                
             
             </div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
            </cfif>
            <!-----------Marketing Material-------->
             <div class="rdholder" style="width:100%;float:right;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Marketing Materials </span> 
                 <em>Save/Print option available on preview
             	</em></div>
             <div class="rdbox">
             
            
             	<table width=80% align="center">
					<!---_Available for All companies---->
                    <cfif ListFind("1,2,3,4,5,10,12,14", CLIENT.companyid) >
                	<tr>
                    	<Td><img src="pics/icons/marketing.png" /></Td><td><a href="marketing/difference.cfm" target="_blank">Make A Difference</a></td>
                        <td><img src="pics/icons/marketing2.png" /></td><td><a href="marketing/HostFam2012/HostFamiles.cfm" target="_blank">Host Families</a></td>
                        
                    </tr>
                    <tr>    
                        <td><img src="pics/icons/marketing2.png" /></td><td><A href="marketing/aroundWorld.cfm" target="_blank"> School Around the World</A></td>
                        <td><img src="pics/icons/marketing3.png" /></td><td> <a href="marketing/bookmark.cfm" target="_blank">  Enrich Your Life Bookmarks</A></td>

                    </tr>
                    <tr>
                    	<td><img src="pics/icons/marketing3.png" /></td><td><a href="marketing/openHeart.cfm" target="_blank">Open Heart & Soul</a></td>
                    	<td></td><td></td>
                    </tr>
                    </cfif>
                    <!----ESI ONLY Docs---->
                    <cfif ListFind("14", CLIENT.companyid) >
                    <tr>
                    	<td><img src="pics/icons/marketing.png" /></td><td><a href="marketing/bookmark.cfm" target="_blank">Enrich Your Life Bookmarks</a></td>
                        <td><img src="pics/icons/marketing.png" /></td><td><a href="marketing/difference.cfm" target="_blank">Make A Difference</a></td>
                    </tr>
                    </cfif>
             </TABLE>
                    
			
             
             </div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
 			<!------End of Marketing Material---->
            <!----State and Region Availability---->
            <cfif listFind("1,2,3,4,8,11", CLIENT.usertype)>
             <div class="rdholder" style="width:100%;float:right;"> 
				<div class="rdtop"> 
                <span class="rdtitle">State & Region Availability</span> 
            	</div> <!-- end top --> 
             <div class="rdbox">
             <Cfif APPLICATION.CFC.USER.isOfficeUser()>
                    <table align="Center" width=80% >
                	<Tr>
                    	<Td width=25><img src="pics/icons/map.png" /></Td><td>
           <a href="javascript:openPopUp('tools/stateStatus.cfm', 875, 675);">Available States</a>
            			</Td>
                        <td rowspan=2 width=60%><font size=-2><em>State and Region availability can change at any time, acceptance of choice will not be guranteed until application is submitted for approval</em></font>
                  </tr>
                  <tr>
                    <td><img src="pics/icons/region.png" /></td>
                        <td>
            <a href="javascript:openPopUp('tools/regionStatus.cfm', 750, 775);">Available Regions</a>
                        </td>
                    </Tr>
                </table>
                 
				</cfif>
                    
			
             
             </div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
            </cfif>
            <!----New Users---->
             <div class="rdholder" style="width:100%;float:right;"> 
				<div class="rdtop"> 
                <span class="rdtitle">New Users</span> 
            	</div> <!-- end top --> 
             <div class="rdbox">
              <cfif get_new_users.recordcount eq 0 or CLIENT.usertype gte 6>
                           <em> There are no new reps in your region.</em>
                        <cfelse>
                            <!--- this is used to display the message if the user was added since last login. --->
                            <cfset since_lastlogin = 0>
							<!--- this is used to display the message if the user is the advisor of any new users. --->
                            <cfset is_advisor = 0>
                             <table>
                             	<Tr>
                                	<Td></Td><td>Name & Location</td><Td>Account Status</Td>
                                </Tr>
                                
                            <cfloop query="get_new_users"> 
                           
                            	<cfscript>
                                	//Check if paperwork is complete for season
									CheckPaperwork = APPLICATION.CFC.udf.paperworkCompleted(userid=get_new_users..userid,season=9);
								</cfscript>
								
								<!--- put * if user is the advisor for this user. --->
                                <cfif advisorid EQ CLIENT.userid>
                                    <font color="FF0000" size="4"><strong>*</strong></font>
			                        <cfset is_advisor = 1>
                                </cfif>
                               
                                	<Tr>
                                    	<td>
                            	<a href="mailto:#email#"><img src="pics/email.gif" border="0" align="absmiddle"></a></td>
                                	<td>
								<!--- highlight if user was added since last login. --->
                                <cfif datecreated GTE CLIENT.lastlogin>
                                    <a href="index.cfm?curdoc=user_info&userid=#userid#"><font color="FF0000">#firstname# #lastname#</font></a> <font color="FF0000">of #city#, #state#</font>
			                        <cfset since_lastlogin = 1>
                                <cfelse>
                                    <a href="index.cfm?curdoc=user_info&userid=#userid#">#firstname# #lastname#</a> of #city#, #state#
                                </cfif>
                                </td><Td>
								
								<cfif not val(accountCreationVerified)>Not Active, <CFif client.usertype eq 4><a href="?curdoc=forms/user_paperwork&userid=#userid#"></cfif>Verification Needed</a><cfelse>Account Active</cfif></Td>
                                </Tr>
                            </cfloop>
                            </table>
                            <cfif since_lastlogin>
                            	<br /><font color="FF0000">users in red were added since your last visit</font>
                            </cfif>
                            <cfif is_advisor>
                            	<br /><font color="FF0000" size="4"><strong>*</strong></font> reps assigned to you
                            </cfif>
                        </cfif>
                    
			
             
             </div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
            
            	<!---End of new Users----->
                 <table align="right">
            	<Tr>
                	<td>
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
            
 </div>   
    
<!---- FIELD --->
<cfelse>



    <table width=100%>
        <tr>
            <td></td>
            <td align="right">
            Your last visit was on #DateFormat(CLIENT.lastlogin, 'mmm d, yyyy')# MST
            </td>
        </tr>
    </table>
     <table class="news">
    	<Tr>
        	<Td width=80% valign="top">
            
             <div class="rdholder"> 
				<div class="rdtop"> 
                <span class="rdtitle">News & Announcements</span> 
            </div> <!-- end top --> 
             <div class="rdbox">
   
       <table width=100% cellpadding="4" cellspacing=0 border="0">
        <tr>
           <td  valign="top" width="100%"><br>
                <img src="pics/newsIcon.png" width=100 height=100 align="left">
                <cfif client.usertype neq 15>
                           
                <!---<img src="#CLIENT.exits_url#/nsmg/pics/clover.gif" width="75" align="left" >--->
                <cfif news_messages.recordcount is 0>
                    <br>There are currently no announcements or news items.
                <cfelse>
                    <cfloop query="news_messages">
                        <p><b>#message#</b><br>
                        #DateFormat(startdate, 'MMMM D, YYYY')# - #replaceList(details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#
                        <cfif additional_file is not ''>
                            <br /><img src="pics/info.gif" height="15" border="0" />&nbsp;<a href="uploadedfiles/news/#additional_file#" target="_blank">Additional Information (pdf)</font></a>
                        </cfif>
                        </p>
                    </cfloop>
                </cfif>
                <cfif CLIENT.usertype gte 8>
                    <br><br>Please see below for announcements from your organization.
                </cfif>
                <cfelse>
               			 Announcement for 2nd Visit Rep will go here when received.
                </cfif>
          </td>
          <td align="right" valign="top" rowspan=2 class="rdPic">
                <!--- Intl. Rep Pictures --->
               <cfif (ListFind("5,6,7,9", CLIENT.userType) AND ListFind(APPLICATION.SETTINGS.COMPANYLIST.publicHS, CLIENT.companyid)) >  
                <cfif CLIENT.usertype EQ 8>
                    <cfset pic_num = RandRange(1,34)>
                    <img src="pics/intrep/#pic_num#.jpg"><br>
                <cfelse>
                	<!--- Office and Field Incentive Trip Pictures --->
                    <cfif LEN(smg_pics.description)>
                        <a href="index.cfm?curdoc=picture_details&pic=#smg_pics.pictureid#">
                            <img src="uploadedfiles/welcome_pics/#smg_pics.pictureid#.jpg" border="0"><br>
                            <em>#smg_pics.title#</em><br>
                            <img src="pics/view_details.gif" border="0">
                    	</a>                    
                    <cfelse>
                        <img src="uploadedfiles/welcome_pics/#smg_pics.pictureid#.jpg" border="0"><br>
                        <em>#smg_pics.title#</em>
                                           
                    </cfif>
                </cfif>	
               </cfif>
            </td>
        </tr>
    </table>
    

    
    <!----footer of table---->
    
    </div>
     <div class="rdbottom"></div> <!-- end bottom --> 
    
     </div>
       
    
    
    	</td>
        <Td valign="top">
        
      	 
    	 <cfif (ListFind("5,6,7,9", CLIENT.userType) AND ListFind(APPLICATION.SETTINGS.COMPANYLIST.publicHS, CLIENT.companyid)) >
                     <cfset tripcount = 7 - placed_students.Count>
                     <cfinclude template="slideshow/index.cfm">
         <table border=0>
        	<Tr>
             <cfif placed_students.Count LT 7>
            	<Td class="sticky" align="center">
             
                #tripcount#
                </Td>
                <td>
                 placements away from a trip to <A href="uploadedFiles/Incentive_trip/incentiveTrip_#client.companyid#.pdf" target="_blank">#incentive_trip.trip_place#!</A>
               
                <cfelse>
                 <td colspan=2>   You've earned a trip to <A href="uploadedFiles/Incentive_trip/incentiveTrip_#client.companyid#.pdf" target="_blank">#incentive_trip.trip_place#!!!</A> 
                </td></cfif>
           
                        
             </Tr>
         </table>
    </cfif>
      
      <!----
     <cfif client.companyid eq 10>
        		  <!----Special Announcements---->
    <table width=100% cellpadding=0 cellspacing=0 border="0" height=24>
        <tr height=24>
            <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
            <td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
            <td background="pics/header_background.gif"><h2>Bonuses!</h2></td>
            <td background="pics/header_background.gif" width=16></td>
            <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
        </tr>
    </table>
        <table width=100% cellpadding="4" cellspacing=0 border="0" class="section">
        <tr>
           <td  valign="top" width="100%">
           <img src="pics/Bonuses.png" height=200 />
           </td>
           <td align="center">
           
                        
           <h2><a href="uploadedfiles/pdf_docs/CASE/promotion/PreAypBonus.pdf" target="_blank">Pre-AYP Bonuses!</a></h2>
           <br />
           <h2><a href="uploadedfiles/pdf_docs/CASE/promotion/Early_Placement_Bonus_2012.pdf" target="_blank">Early Placement</a></h2>
           </td>
           </tr>
         </table>
        <!----footer of table---->
    <cfinclude template="table_footer.cfm">
    </cfif>
	---->
        </Td>
     </tr>
  </table>
</cfif>
    
<br>



<!---- OFFICE AND FIELD ---->			
<cfif ListFind("5,6,7,9,15", CLIENT.usertype) and 1 eq 2>        
    <!----CURRENT ITEMS---->
<table width=100% cellpadding=0 cellspacing=0 border="0" height=24>
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/current_items.gif"></td>
        <td background="pics/header_background.gif"><h2>Current Items</h2></td>
        <td background="pics/header_background.gif" width=16></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>
    <table width=100% cellspacing=0 border="0" class="section">
        <tr>
            <td align="center">               
                
                <table cellpadding="2" cellspacing="4" width=100%>
                <tr>
                    <td class="get_attention"><span class="get_attention"><b>::</b></span> Items Needing Attention</u></td>
					<!--- Office Users --->
					<cfif APPLICATION.CFC.USER.isOfficeUser()>
                    	<td class="get_attention"><span class="get_attention"><b>::</b></span> Your Current Help Desk Tickets</td>
                    <!--- Field Users --->
					 <cfelseif (ListFind("5,6,7,9", CLIENT.userType) AND ListFind(APPLICATION.SETTINGS.COMPANYLIST.publicHS, CLIENT.companyid)) >
                    	<td class="get_attention"><span class="get_attention"><b>::</b></span> WebEx Calendar</td>
                    </cfif>
                </tr>
                <tr valign="top">
                    <td style="line-height:20px;">
                    	<!----<a href="index.cfm?curdoc=forms/startHostApp">Start a Host App</a><br />---->
                        
                        <
                        
                    </td>
         			<!--- Office Users --->
					<cfif APPLICATION.CFC.USER.isOfficeUser()>
						<td>
                            <table cellpadding="4" cellspacing="0" border="0" width="100%">
                                <tr>
                                	<td width="15%" style="font-weight:bold;">Submitted</td>
                                    <td width="60%" style="font-weight:bold;">Title</td>
                                    <td width="25%" style="font-weight:bold;">Status</td>
                                </Tr>
                                <cfif help_desk_user.recordcount>
                                    <cfloop query="help_desk_user">
                                        <tr bgcolor="#iif(help_desk_user.currentrow MOD 2 ,DE("EEEEEE") ,DE("FFFFFF") )#">
                                            <td valign="top">#DateFormat(date, 'mm/dd/yyyy')#</td>
                                            <td valign="top"><a href="">#title#</a></td>
                                            <td valign="top">#status#</td>
                                        </tr>
                                    </cfloop>
                                <cfelse>
                                    <tr><td colspan="6" bgcolor="ffffe6" valign="top">You have no open or recently completed tickets on the Help Desk</td></tr>
                                </cfif>
                            </table>
						</td>
					<!--- Field Users --->                        
                    <cfelseif (ListFind("5,6,7,9", CLIENT.userType) AND ListFind(APPLICATION.SETTINGS.COMPANYLIST.publicHS, CLIENT.companyid)) >
						<td>
                            <table cellpadding="4" cellspacing="0" border="0">
                                <tr>
                                	<td valign="top">
                                        <a href="index.cfm?curdoc=calendar/index">Click here to register for WebEx Meetings <br /></a>
                                        <a href="index.cfm?curdoc=calendar/index"><img src="pics/webex-logo.jpg" border="0"></a>                                        
                                	</td>
                                </tr>
                            </table>
						</td>
                    </cfif>
                </tr>
                <cfif client.usertype neq 15>
                <tr>
                    <td></td>
                </tr>
                <tr>
                   	<td class="get_attention"><span class="get_attention"><b>::</b></span> Marketing Material </td>
                    <td class="get_attention"><span class="get_attention"><b>::</b></span> New Users <font size=-2>since #new_date#</font></u></td>
                </tr>
                <tr valign="top">
               	  <td >
                 
                 </td>
                    <td>
                      
                     </td>
                </tr>
                <tr>
                <td class="get_attention" width="50%">
                    	<span class="get_attention"><b>::</b></span> New Students <font size=-2>since #new_date#</font></u></td>
                	<td  class="get_attention"><cfif APPLICATION.CFC.USER.isOfficeUser()> <b>::</b> State & Region Availability</cfif></td>
                    
                </tr>
                <tr>
                   
                     <td>
                        
                    </td>
                      <td valign="top" align="Center">
                  
                    
                    </td>
                </tr>
                <tr>
                	
                    
                    <Td></Td>
                </tr>
                </cfif>
            </table>
            
            </td>
        </tr>
        
    </table>

<!---- WELCOME SCREEN FOR INTL. AGENTS ---->
<cfelseif CLIENT.usertype EQ 8>

    <cfquery name="companyname" datasource="#application.dsn#">
        select businessname
        from smg_users
        where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.parentcompany#">
    </cfquery>
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

	<table cellpadding="2" cellspacing="4" width=100% bgcolor="##FFFFFF" class="section">
		<tr>
			<td class="get_attention" width="50%"><span class="get_attention"><b>::</b></span> News, Alerts, and Updates from #companyname.businessname#</u></td>
			<td class="get_attention"><span class="get_attention"><b>::</b></span> State & Region Access</Td>
		</tr>
		<tr>
			<td valign="top">
            
				<h3 style="text-align:center; padding:10px; text-decoration:underline;">News</h3>
				<p>
					<cfif intagent_alert_messages.recordcount neq 0>
                        <cfloop query="intagent_news_messages">
                            <cfif intagent_news_messages.details is not ''><b>#message#</b><br>
                                <div align="justify">#DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#</div>
                            </cfif>
                        </cfloop>
                    <cfelse>
                        There are currently no annoucements or news items from #companyname.businessname#
                    </cfif>
				</p>
                                
				<cfif intagent_alert_messages.recordcount neq 0>
                    <h3 style="text-align:center; padding:10px; text-decoration:underline;">Alerts</h3>
                    <cfloop query="intagent_alert_messages">
                        <cfif intagent_alert_messages.details is not ''><b>#message#</b><br>
                            <p>#DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#</p>
                        </cfif>
                    </cfloop>
                </cfif>
                
				<cfif intagent_update_messages.recordcount neq 0>
                    <h3 style="text-align:center; padding:10px; text-decoration:underline;">Updates</h3>
                    <cfloop query="intagent_update_messages">
                        <cfif intagent_update_messages.details is not ''><b>#message#</b><br>
                            <p>#DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#</p>
                        </cfif>
                    </cfloop>
                </cfif>
				
  <!--- Flight Information --->
                <p align="center">
                	<a href="index.cfm?curdoc=intRep/index&action=flightInformationList">
                        <img src="pics/flightSchedule.jpg" border="0" align="middle" />
                   	</a>
                </p>
                
			</td>
			<td valign="top" rowspan=2 align="center">
            	<table>
                	<Tr>
                    	<Td>
            <a href="javascript:openPopUp('tools/stateStatus.cfm', 875, 675);"><img src="pics/buttons/state.png"border=0/></a>
            			</Td>
                     	<td>
            <a href="javascript:openPopUp('tools/regionStatus.cfm', 750, 675);"><img src="pics/buttons/region.png"border=0/></a>
                        </td>
                    </Tr>
                </table>
           
            
                
			</td>
		</tr>
        <Tr>
        	<td class="get_attention"><span class="get_attention"><b>::</b></span> Your Current Help Desk Tickets </Td>
            <td></td>
        </Tr>
        <tr>
           <td valign="top"> <!--- Help Desk Items --->
				<table width="100%" cellpadding="4" cellspacing=0 border="0">
					<tr>
                    	<td width="20%">Submitted</td>
                        <td width="50%">Title</td>
                        <td width="20%">Status</td>
                        <td width="10%">&nbsp;</td>
                    </tr>
                    <cfloop query="help_desk_user">
                        <tr bgcolor="###iif(help_desk_user.currentrow MOD 2 ,DE("EEEEEE") ,DE("FFFFFF") )#">
                            <td>#DateFormat(date, 'mm/dd/yyyy')#</td>
                            <td>#title#</td>
                            <td>#status#</td>
                            <td><a href="index.cfm?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">View</a></td>
                        </tr>
                    </cfloop>
                    <cfif NOT VAL(help_desk_user.recordcount)>
                        <tr><td colspan="4" bgcolor="ffffe6" valign="top">You have no open or recently completed tickets on the Help Desk</td></tr>
                    </cfif>
				</table>
                
            
            </td>
			<td></Td>
        </Tr>
        <tr>
	</table>

<!--- Intl Branch --->
<cfelseif CLIENT.usertype EQ 11>

    <cfquery name="companyname" datasource="#application.dsn#">
        select businessname
        from smg_users
        where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.parentcompany#">
    </cfquery>
  
    <table cellpadding="2" cellspacing="4" width=100% bgcolor="##FFFFFF" class="section">
        <tr>
            <td class="get_attention" width="50%"><span class="get_attention"><b>::</b></span> News, Alerts, and Updates from #companyname.businessname#</u></td>
            <td class="get_attention" width="50%"><span class="get_attention"><b>::</b></span> Your Current Help Desk Tickets </Td>
        </tr>
        <tr>
            <td valign="top">
				
                <!--- Flight Information --->
                <p align="center">
                	<a href="index.cfm?curdoc=intRep/index&action=flightInformationList">
                        <img src="pics/flightSchedule.jpg" border="0" align="middle" />
                   	</a>
                </p>
                
            </td>
            <td valign="top">
				
				<!--- Help Desk Items --->
                <table width="100%" cellpadding="4" cellspacing="0" border="0">
                    <tr>
                    	<td width="25%">Submitted</td>
                        <td width="50%">Title</td>
                        <td width="25%">Status</td>
                        <td width="10%">&nbsp;</td>
                    </tr>
                    <cfloop query="help_desk_user">
                        <tr bgcolor="###iif(help_desk_user.currentrow MOD 2 ,DE("EEEEEE") ,DE("FFFFFF") )#">
                            <td>#DateFormat(date, 'mm/dd/yyyy')#</td>
                            <td><a href="index.cfm?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">#title#</a></td>
                            <td>#status#</td>
                            <td><a href="index.cfm?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">View</a></td>
                        </tr>
                    </cfloop>
                    <cfif NOT VAL(help_desk_user.recordcount)>
                        <tr>
                        	<td colspan="3" bgcolor="##FFFFE6" valign="top">You have no open or recently completed tickets on the Help Desk</td>
                        </tr>
                    </cfif>
                </table>
                
            </td>
        </tr>
    </table>
<cfinclude template="table_footer.cfm">
</cfif>

<!----footer of table
<cfif client.usertype gt 4>
<cfinclude template="table_footer.cfm">
</cfif>
---->

</cfoutput>
