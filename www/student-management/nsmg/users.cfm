<!--- ------------------------------------------------------------------------- ----
	
	File:		users.cfm
	Author:		Marcus Melo
	Date:		May 10, 2011
	Desc:		User List

	Updated:  	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
    <cfparam name="URL.startPage" default="1">
    <cfparam name="submitted" default="0">
    <cfparam name="company_region" default="region,#CLIENT.regionid#">
    <cfparam name="user_type" default="">
    <cfparam name="assigned" default="1">
    <cfparam name="keyword" default="">
    <cfparam name="new_user" default="">
    <cfparam name="active" default="1">
    <cfparam name="orderby" default="lastname">
    <cfparam name="recordsToShow" default="25">

    <cfquery name="qRegionList" datasource="#APPLICATION.DSN#">
        SELECT 
        	r.regionid, 
            r.regionname, 
            c.companyid, 
            c.team_id
        FROM 
        	smg_regions r
        INNER JOIN 
        	smg_companies c ON r.company = c.companyid
        WHERE 
        	c.website = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CLIENT.company_submitting#">
        AND 
        	r.subofregion = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
        	r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        ORDER BY 
        	c.companyid, 
            r.regionname
    </cfquery>

    <cfquery name="qGetUserTypeList" datasource="#APPLICATION.DSN#">
        SELECT 
            usertypeid, 
            usertype
        FROM 
            smg_usertype
        WHERE 
            usertypeid BETWEEN 1 AND 9 
            OR usertypeid = 15
        ORDER BY 
            usertypeid
    </cfquery>

</cfsilent>

<!--- ONLY OFFICE, MANAGERS AND ADVISORS CAN ADD NEW USERS --->
<cfif ListFind("1,2,3,4,5,6", CLIENT.usertype)>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="students.gif"
        tableTitle="Users"
        tableRightTitle='<a href="index.cfm?curdoc=forms/add_user">Add User</a>'
        width="100%"
    />    

<cfelse>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="students.gif"
        tableTitle="Users"
        width="100%"
    />    

</cfif>

<cfform name="searchUser" action="index.cfm?curdoc=users" method="post">
<input name="submitted" type="hidden" value="1">

<table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
        
		<!--- Office Options --->
        <cfif ListFind("1,2,3,4", CLIENT.usertype)>
            <td>
                Program Manager - Region<br />
                <select name="company_region">
                    <option value="" selected="selected">All</option>
                    <cfoutput query="qRegionList" group="companyid">
                      <option value="company,#companyid#" >#team_id# (All Regions)</option> <!--- <cfif company_region EQ 'company,#companyid#'>selected</cfif> --->
                        <cfoutput>
                            <option value="region,#regionid#">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#team_id# - #regionname#</option> <!--- <cfif company_region EQ 'region,#regionid#'>selected</cfif> --->
                        </cfoutput>
                    </cfoutput>
                </select>
            </td>
            <td>
                User Type<br />
                <cfselect name="user_type" query="qGetUserTypeList" value="usertypeid" display="usertype" selected="#user_type#" queryPosition="below">
                    <option value="">All</option>
                </cfselect>
            </td>
            <td>
                Assigned<br />
                <select name="assigned">
                    <option value="1" <cfif assigned EQ 1>selected</cfif>>Yes</option>
                    <option value="0" <cfif assigned EQ 0>selected</cfif>>No</option>
                </select>
            </td>
        </cfif>
        
        <cfoutput>
        <td>
            Keyword / ID<br />
            <input type="text" name="keyword" value="#keyword#" size="10" maxlength="50" style="width:150px;">         
        </td>
        </cfoutput>
        
        <!--- Do Not Show this option for Guest User --->
        <cfif CLIENT.userType NEQ 27>
            <td>
                New Users<br />
                <select name="new_user">
                    <option value="">All</option>
                    <option value="1" <cfif new_user EQ 1>selected</cfif>>Yes</option>
                </select>            
            </td>
        </cfif>
        <td>
            Active<br />
            <select name="active">
                <option value="">All</option>
                <option value="1" <cfif active EQ 1>selected</cfif>>Yes</option>
                <option value="0" <cfif active EQ 0>selected</cfif>>No</option>
            </select>            
        </td>
        <td>
            Order By<br />
            <select name="orderby">
                <option value="userid" <cfif orderby EQ 'userid'>selected</cfif>>ID</option>
                <option value="lastname" <cfif orderby EQ 'lastname'>selected</cfif>>Last Name</option>
                <option value="firstname" <cfif orderby EQ 'firstname'>selected</cfif>>First Name</option>
                <option value="businessname" <cfif orderby EQ 'businessname'>selected</cfif>>Company Name</option>
                <option value="city" <cfif orderby EQ 'city'>selected</cfif>>City</option>
                <option value="state" <cfif orderby EQ 'state'>selected</cfif>>State</option>
                <option value="countryname" <cfif orderby EQ 'countryname'>selected</cfif>>Country</option>
                <option value="phone" <cfif orderby EQ 'phone'>selected</cfif>>Phone</option>
            </select>            
        </td>
        <td>
            Records Per Page<br />
            <select name="recordsToShow">
                <option <cfif recordsToShow EQ 25>selected</cfif>>25</option>
                <option <cfif recordsToShow EQ 50>selected</cfif>>50</option>
                <option <cfif recordsToShow EQ 100>selected</cfif>>100</option>
                <option <cfif recordsToShow EQ 250>selected</cfif>>250</option>
                <option <cfif recordsToShow EQ 500>selected</cfif>>500</option>
            </select>            
        </td>
    </tr>
    <cfif NOT VAL(assigned)>
        <tr>
            <td>&nbsp;</td>
            <td colspan="3"><font size="1"><em>Company - Region, and User Type are non-functional when Assigned=No.</em></font></td>
        </tr>
    </cfif>
</table>
</cfform>

<cfif submitted>
	
    <!--- OFFICE PEOPLE AND ABOVE --->
    <cfif ListFind("1,2,3,4", CLIENT.usertype)>
    
        <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
            SELECT DISTINCT 
            	u.userid, 
                u.firstname, 
                u.lastname, 
                u.city, 
                u.state, 
                u.phone, 
                u.businessname, 
                u.datecreated, 
                cl.countryname
            FROM 
            	smg_users u
            <!--- need LEFT OUTER JOIN on user_access_rights because of the "unassigned" search option. --->
            LEFT OUTER JOIN 
            	user_access_rights uar ON u.userid = uar.userid
            LEFT OUTER JOIN 
            	smg_companies c ON uar.companyid = c.companyid
            LEFT OUTER JOIN 
            	smg_countrylist cl ON u.country = cl.countryid
            WHERE 
            	1=1			

			<cfif assigned EQ 1>
	        
                AND 
                	c.website = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CLIENT.company_submitting#">
	            
				<cfif listFirst(company_region) EQ 'company'>
                    AND 
                        uar.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#listLast(company_region)#">
                <cfelseif listFirst(company_region) EQ 'region'>
                    AND 
                        uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#listLast(company_region)#">
                </cfif>	
                
				<cfif VAL(user_type)>
                	AND 
                    	uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(user_type)#">
                </cfif>
            
			<cfelseif assigned EQ 0>
            	AND 
                	uar.userid IS NULL
            </cfif>
            
            <cfif LEN(TRIM(keyword))>
                AND (
                        u.userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(keyword)#">
                    OR 
                        u.firstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                    OR 
                        u.lastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                    OR 
                        u.city LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                    OR 
                        u.state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                    OR 
                        u.phone LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                    OR 
                        u.businessname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                    OR 
                        cl.countryname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                )
            </cfif>
            
            <cfif LEN(new_user)>
            	AND 
                	u.datecreated > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CLIENT.lastlogin#">
            </cfif>
            
            <cfif LEN(active)>
	            AND 
                	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="#active#">
            </cfif>
            
            ORDER BY 
            	
                <cfswitch expression="#orderby#">

                	<cfcase value="userID,lastName,firstName,businessName,city,state,countryName,phone">
                    	#orderby#
                    </cfcase>

                	<cfdefaultcase>
                    	lastName,
                        firstName
                    </cfdefaultcase>
				
                </cfswitch>                 

        </cfquery>

		<!--- this is used with a query of query in the output. --->
        <cfquery name="qGetUserAccessRights" datasource="#APPLICATION.DSN#">
            SELECT 
            	uar.userid, 
                uar.regionid, 
                u.usertype, 
                c.team_id, 
                r.regionname
            FROM 
            	user_access_rights uar
            INNER JOIN 
            	smg_usertype u ON uar.usertype = u.usertypeid
            INNER JOIN 
            	smg_companies c ON uar.companyid = c.companyid
            <!--- international don't have regions. --->
            LEFT OUTER JOIN 
            	smg_regions r ON uar.regionid = r.regionid
            WHERE 
            	c.website = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CLIENT.company_submitting#">
            ORDER BY 
            	uar.companyid, 
                uar.regionid, 
                uar.usertype
        </cfquery>
    
    <!--- Guest Account --->
    <cfelseif CLIENT.userType EQ 27>

        <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
            SELECT DISTINCT 
            	u.userid, 
                u.firstname, 
                u.lastname, 
                u.city, 
                u.state, 
                u.phone, 
                u.businessname, 
                u.datecreated, 
                cl.countryname
            FROM 
            	user_access_rights uar
            INNER JOIN 
            	smg_users u ON u.userid = uar.userid
            LEFT OUTER JOIN 
            	smg_countrylist cl ON u.country = cl.countryid
            WHERE 
				<!--- Guest User / DO NOT SHOW STUDENT VIEW --->
            	uar.userType IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7,15" list="yes"> )
            
			<!--- Students under companies --->
			<cfif CLIENT.companyID EQ 5>
                AND
                    uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> ) 
            <cfelse>
                AND
                    uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            </cfif>
            
            <cfif LEN(TRIM(keyword))>
                AND (
                		u.userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(keyword)#">
                	OR 
                    	u.firstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                	OR 
                    	u.lastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                	OR 
                    	u.city LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                	OR 
                    	u.state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                	OR 
                    	u.phone LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                	OR 
                    	u.businessname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                	OR 
                    	cl.countryname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                )
            </cfif>
            
            <cfif LEN(active)>
                AND 
                	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="#active#">
            </cfif>
            
            ORDER BY 
            	
                <cfswitch expression="#orderby#">

                	<cfcase value="userID,lastName,firstName,businessName,city,state,countryName,phone">
                    	#orderby#
                    </cfcase>

                	<cfdefaultcase>
                    	lastName,
                        firstName
                    </cfdefaultcase>
				
                </cfswitch>   
                              
        </cfquery>
        
    <!--- FIELD --->
    <cfelse>
    
        <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
            SELECT DISTINCT 
            	u.userid, 
                u.firstname, 
                u.lastname, 
                u.city, 
                u.state, 
                u.phone, 
                u.businessname, 
                u.datecreated, 
                cl.countryname
            FROM 
            	user_access_rights uar
            INNER JOIN 
            	smg_users u ON u.userid = uar.userid
            LEFT OUTER JOIN 
            	smg_countrylist cl ON u.country = cl.countryid
            WHERE 
            	uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionid#">
			
			<!--- manager / DO NOT SHOW STUDENT VIEW --->
            AND 
            	uar.userType IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7,15" list="yes"> )
            
			<!--- advisor --->
            <cfif CLIENT.usertype EQ 6>
            	AND 
                	uar.advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            <!--- Area Representative --->
			<cfelseif CLIENT.userType EQ 7>
            	AND 
                	uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            </cfif>
            
            <cfif LEN(TRIM(keyword))>
                AND (
                		u.userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(keyword)#">
                	OR 
                    	u.firstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                	OR 
                    	u.lastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                	OR 
                    	u.city LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                	OR 
                    	u.state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                	OR 
                    	u.phone LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                	OR 
                    	u.businessname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                	OR 
                    	cl.countryname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                )
            </cfif>
            
            <cfif LEN(new_user)>
                AND 
                	u.datecreated > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CLIENT.lastlogin#">                    
            </cfif>
            
            <cfif LEN(active)>
                AND 
                	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="#active#">
            </cfif>
            
            ORDER BY 
            	
                <cfswitch expression="#orderby#">

                	<cfcase value="userID,lastName,firstName,businessName,city,state,countryName,phone">
                    	#orderby#
                    </cfcase>

                	<cfdefaultcase>
                    	lastName,
                        firstName
                    </cfdefaultcase>
				
                </cfswitch>   
                              
        </cfquery>
                
    </cfif>

	<cfif qGetResults.recordCount>
		
        <cfscript>
			totalPages = ceiling(qGetResults.recordCount / recordsToShow);
			startrow = 1 + ((url.startPage - 1) * recordsToShow);
			
			if ( qGetResults.recordCount GT url.startPage * recordsToShow ) {
				isNextPage = 1;
				endrow = url.startPage * recordsToShow;
			} else {
				isNextPage = 0;
				endrow = qGetResults.recordCount;
			}
			
			urlVariables = "submitted=1&company_region=#company_region#&user_type=#user_type#&assigned=#assigned#&keyword=#urlEncodedFormat(keyword)#&new_user=#new_user#&active=#active#&orderby=#orderby#&recordsToShow=#recordsToShow#";
		</cfscript>
        
        <cfoutput>
    
    	<cfif CLIENT.usertype NEQ 7>
        	<table width="100%" class="section" border="0" cellpadding="4" cellspacing="0">
                <tr align="center">
                    <td>
						<cfif totalPages GT 1>
                            <cfif url.startPage NEQ 1>
                                <a href="?curdoc=users&startPage=#url.startPage - 1#&#urlVariables#">< PREV</a> &nbsp;
                            </cfif>
                            
                            <cfloop from="1" to="#totalPages#" index="i">
                                <cfif i is url.startPage>#i#<cfelse><a href="?curdoc=users&startPage=#i#&#urlVariables#">#i#</a></cfif>
                            </cfloop>
                            
                            <cfif isNextPage>
                                &nbsp; <a href="?curdoc=users&startPage=#url.startPage + 1#&#urlVariables#">NEXT ></a>
                            </cfif>
                            
                            <br />
                        </cfif>
                        
                        Displaying #startrow# to #endrow# of #qGetResults.recordCount#
                    </td>
                </tr>
	        </table>
    	</cfif>

		<cfif CLIENT.usertype EQ 7>
        	<table width="100%" class="section" border="0" cellpadding="4" cellspacing="0">
                <tr>
                    <Td colspan="10" align="center">Your access level doesn't permit viewing other users.</Td>
                </tr>
			</table>
        </cfif>
        
        <table width="100%" class="section" border="0" cellpadding="2" cellspacing="0">
            <tr align="left" style="font-weight:bold;">
                <td>ID</td>
                <td>Last Name</td>
                <td>First Name</td>
				<cfif ListFind("1,2,3,4", CLIENT.usertype)>
                    <td>Program Manager - Region - User Type</td>
				</cfif>
                <td>Company Name</td>
                <td>City</td>
                <td>State</td>
                <td>Country</td>
                <td>Phone</td>
            </tr>
            
            <cfloop query="qGetResults" startrow="#startrow#" endrow="#endrow#">
                
                <cfscript>
                    if ( datecreated GT CLIENT.lastlogin ) {
                        bgcolor = "##E2EFC7";
                    } else {
                        bgcolor="";
                    }					
                </cfscript>
                
                <tr bgcolor="###iif(currentRow MOD 2 ,DE("FFFFE6") ,DE("FFFFFF") )#">
                    <td bgcolor="#bgcolor#"><a href="index.cfm?curdoc=user_info&userid=#userid#">#userid#</a></td>
                    <td>#lastname#</td>
                    <td>#firstname#</td>
                    <cfif ListFind("1,2,3,4", CLIENT.usertype)>
                        <cfquery name="qGetCurrentUserAccess" dbtype="query">
                            SELECT 
                                *
                            FROM 
                                qGetUserAccessRights
                            WHERE 
                                userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userid#">
                        </cfquery>
                        <td>
                            <table cellpadding="2" cellspacing="0">
                                <cfloop query="qGetCurrentUserAccess">
                                    <tr>
                                        <td>#team_id#</td>
                                        <td>-</td>
                                        <td nowrap="nowrap">#regionname# (#regionid#)</td>
                                        <td>-</td>
                                        <td nowrap="nowrap">#usertype#</td>
                                    </tr>
                                </cfloop>
                            </table>
                        </td>
                    </cfif>
                    <td>#businessname#</td>
                    <td>#city#</td>
                    <td>#state#</td>
                    <td>#countryname#</td>
                    <td>#phone#</td>
                </tr>
            </cfloop>
                
        </table>
    
        </cfoutput>

        <table width="100%" class="section" bgcolor="#ffffe6" border="0" cellpadding="2" cellspacing="0">
            <tr>
                <td bgcolor="#e2efc7" width="15">&nbsp;</td>
                <td>Added since your last vist.</td>
            </tr>
        </table>

	<cfelse>
    
        <table width="100%" class="section" border="0" cellpadding="2" cellspacing="0">
            <tr>
                <td>No users matched your criteria.</td>
            </tr>
        </table>
        
    </cfif>
    
</cfif>

   
<!--- Table Footer --->
<gui:tableFooter 
	width="100%"
/>