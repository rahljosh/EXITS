<!--- ------------------------------------------------------------------------- ----
	
	File:		initial_welcome.cfm
	Author:		Marcus Melo
	Date:		March 15, 2010
	Desc:		Initial Welcome Screen

	Updated:  	

----- ------------------------------------------------------------------------- --->
<cfset newPageList = '1,16718,510'>
<!---
<Cfif listFind(newPageList, client.userid)>
	<cflocation url="?curdoc=new_initial_welcome" addtoken="no">
</Cfif>
---->
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
                <table width=100% cellpadding=0 cellspacing=0 border="0" height=24>
                    <tr height=24>
                        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
                        <td background="pics/header_background.gif"><h2>Activities Relating to Today</h2></td>
                        <td background="pics/header_background.gif" width=16></td>
                        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                    
                <table width=100% cellpadding="4" cellspacing=0 border="0" class="section" >
                    <tr>
                        <td  valign="top" width="100%">
                         
                            <img src="pics/tower_100.jpg" width=71 height=100 align="left">
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
                <cfelseif APPLICATION.CFC.USER.isOfficeUser()>
                    <cfinclude template="welcome_includes/office_apps.cfm">
                </cfif>
            </td>
            <td align="right" valign="top" rowspan="2"></td>
        </tr>
    </table>
    
<!---- FIELD --->
<cfelse>

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

<!---- OFFICE AND FIELD ---->			
<cfif ListFind("1,2,3,4,5,6,7,9,15", CLIENT.usertype)>        
    
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
                        
                        <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.publicHS, CLIENT.companyID)>
                            <a href="index.cfm?curdoc=user/index&uniqueID=#CLIENT.uniqueID#&action=trainCasterLogin" target="_blank" title="Click Here to Take the DOS Test">
                                <img src="pics/buttons/DOScertification.png" border="0" title="Click Here to Take the DOS Certification Test" />
                            </a><br />
                        </cfif>
                        
                      	<a href="index.cfm?curdoc=user/index">Please complete your annual area representative agreement and paperwork!<br /></a>
                        
                        <cfif client.usertype eq 15>
                            <a href="index.cfm?curdoc=secondVisitReports">Online Reports</a><br>
                        <cfelse>
                            <a href="index.cfm?curdoc=progress_reports">Online Reports</a><br>
                        </cfif>
                        
                        <cfif (CLIENT.companyID LTE 5 or CLIENT.companyID EQ 12 or client.companyID eq 10) and client.usertype lte 7>
                        	<a href="index.cfm?curdoc=project_help">H.E.L.P. Community Service Hours</a><br>
                        </cfif>
                        	
                        <cfif client.usertype lte 7>
                            <a href="index.cfm?curdoc=pendingPlacementList">View Pending Placements</a><br />
                        </cfif>
                        
                        <cfif APPLICATION.CFC.USER.isOfficeUser() and (CLIENT.companyID LTE 5 or CLIENT.companyID EQ 12 or client.companyid eq 10)>
                        	<a href="index.cfm?curdoc=calendar/index">WebEx Calendar</a> <br />
                        </cfif>
                        
                       	<cfif client.companyid lte 5>
                        	2012 Placing Season Bonuses!<BR />
                           	<a href="uploadedfiles/pdf_docs/ISE/promotion/Pre-Ayp%20Bonus%202012.pdf" target="_blank">Pre-AYP</a> :: 
                           	<a href="uploadedfiles/pdf_docs/ISE/promotion/Early%20Placement%20Bonus%202012.pdf" target="_blank">Early Placement</a> :: 
                           	<a href="slideshow/pdfs/CASE/CEOBonus.pdf" target="_blank">CEO Placement Bonus</a>
						</cfif>
                        
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
                                            <td valign="top"><a href="?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">#title#</a></td>
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
                  <!---_Available for All companies---->
                  	<cfif ListFind("1,2,3,4,5,10,12,14", CLIENT.companyid) >
                    Here are some new brochures to help in your marketing.<Br />
                    <a href="marketing/difference.cfm" target="_blank">Make A Difference</a><img src="pics/new_03.png" /><br />
                    <a href="marketing/openHeart.cfm" target="_blank">Open Heart & Soul</a><br />
                 	<A href="marketing/aroundWorld.cfm" target="_blank"> School Around the World</A><Br />
                    <a href="marketing/bookmark.cfm" target="_blank">Enrich Your Life Bookmarks</a><br />
                    <!----ESI ONLY Docs---->
                    <cfif ListFind("14", CLIENT.companyid) >
					<a href="marketing/bookmark.cfm" target="_blank">Enrich Your Life Bookmarks</a><br />
				 	</cfif>
                    <!----NOT ESI---->
                    <cfif ListFind("1,2,3,4,5,10,12,14", CLIENT.companyid) >
                    <a href="marketing/HostFam2012/HostFamiles.cfm" target="_blank">Host Families</a><img src="pics/new_03.png" /><br />
                    </cfif>
					<!---CASE ONLY---->
					<cfif ListFind("10", CLIENT.companyid) >
					<a href="marketing/difference.cfm" target="_blank">Make A Difference</a><br />
				 	</cfif>
                    <br /><br />
                     <font size=-1> <em>Click on the Save/Print option to generate a PDF that is suitable for printing.</em></font>
                          
                  </cfif>
                  <!----Available for just ISE companies---->
                  <Cfif client.userid eq 1 or client.userid eq 16718 or client.userid eq 13251>
                  <br /><Br />
				 </Cfif>
                 </td>
                    <td>
                        <cfif get_new_users.recordcount eq 0 or CLIENT.usertype gte 6>
                            There are no new reps in your region.
                        <cfelse>
                            <!--- this is used to display the message if the user was added since last login. --->
                            <cfset since_lastlogin = 0>
							<!--- this is used to display the message if the user is the advisor of any new users. --->
                            <cfset is_advisor = 0>
                            <table width="100%" cellpadding="4" cellspacing="0">
                                <tr style="font-weight:bold;">
                                	<td></td>
                                    <td>Name & Location</td>
                                    <td>Account Status</td>
                                </tr>
                                
                            <cfloop query="get_new_users"> 
                           
								<cfscript>
                                    // Get User Paperwork Struct
                                    stUserPaperwork = APPLICATION.CFC.USER.getUserPaperwork(userID=get_new_users.userID);
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
                                </td>
                                <td>
									<cfif stUserPaperwork.isAccountCompliant>
                                        
                                        Active - Fully Enabled (Paperwork Compliant)
                                        
                                    <cfelseif stUserPaperwork.accountReviewStatus EQ 'rmReview'>
                                       
                                        Active (Initial Paperwork Received) - 
                                        <a href="index.cfm?curdoc=user_info&userID=#get_new_users.userID#">RM - Reference Questionnaires Needed</a>
                                        
                                    <cfelseif stUserPaperwork.accountReviewStatus EQ 'officeReview'>
                                    
                                        Active (Initial Paperwork Received) - 
                                        <cfif APPLICATION.CFC.USER.isOfficeUser()>
                                            <a href="index.cfm?curdoc=user/index&action=paperworkDetails&userID=#get_new_users.userID#">Office Verification Needed</a>
                                        <cfelse>
                                            Office Verification Needed
                                        </cfif>
                                    
                                    <cfelseif stUserPaperwork.accountReviewStatus EQ 'missingTraining'>
                                        
                                        <cfif NOT stUserPaperwork.isDOSCertificationCompleted AND NOT stUserPaperwork.isTrainingCompleted>
                                            Active (Initial Paperwork Received) - DOS Certification and AR training needed
                                        <cfelseif NOT stUserPaperwork.isDOSCertificationCompleted>
                                            Active (Initial Paperwork Received) - DOS Certification training needed
                                        <cfelse>
                                            Active (Initial Paperwork Received) - AR training needed
                                        </cfif>
                                        
                                    <cfelse>
                                    
                                        Active - 
                                        <cfif APPLICATION.CFC.USER.isOfficeUser()>
                                            <a href="index.cfm?curdoc=user/index&action=paperworkDetails&userID=#get_new_users.userID#">Missing Paperwork</a>
                                        <cfelse>
                                            Missing Paperwork
                                        </cfif>
                                        
                                    </cfif>
                                </td>
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
                     </td>
                </tr>
                <tr>
                <td class="get_attention" width="50%">
                    	<span class="get_attention"><b>::</b></span> New Students <font size=-2>since #new_date#</font></u></td>
                	<td  class="get_attention"><cfif APPLICATION.CFC.USER.isOfficeUser()> <b>::</b> State & Region Availability</cfif></td>
                    
                </tr>
                <tr>
                   
                     <td>
                        <cfif new_students.recordcount eq 0>
                            There are no new students.
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
                    </td>
                      <td valign="top" align="Center">
                   <Cfif APPLICATION.CFC.USER.isOfficeUser()>
                    <table>
                	<Tr>
                    	<Td>
           <a href="javascript:openPopUp('tools/stateStatus.cfm', 875, 675);"><img src="pics/buttons/state.png"border=0/></a>
            			</Td>
                     	<td>
            <a href="javascript:openPopUp('tools/regionStatus.cfm', 750, 775);"><img src="pics/buttons/region.png"border=0/></a>
                        </td>
                    </Tr>
                </table>
                 
				</cfif>
                    
                    </td>
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

</cfif>

<!----footer of table---->
<cfinclude template="table_footer.cfm">

</cfoutput>