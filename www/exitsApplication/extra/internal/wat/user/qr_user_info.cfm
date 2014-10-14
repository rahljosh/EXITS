<cftry>

	<cfinclude template="../querys/get_user.cfm">

	<!--- IF THE USER IS AN INTERNATIONAL REPRESENTATIVE AND THE INFORMATION HAS CHANGED, CREATE AND SEND A MESSAGE --->
    <cfif CLIENT.usertype EQ 8 AND
		(get_user.firstname NEQ FORM.firstname
		OR get_user.middlename NEQ FORM.middlename
		OR get_user.lastname NEQ FORM.lastname
		OR get_user.sex NEQ FORM.sex
		OR get_user.dob NEQ FORM.dob
		OR get_user.drivers_license NEQ FORM.drivers_license
		OR get_user.address NEQ FORM.address
		OR get_user.city NEQ FORM.city
		OR get_user.state NEQ FORM.state
		OR get_user.country NEQ FORM.country
		OR get_user.zip NEQ FORM.zip
		OR get_user.occupation NEQ FORM.occupation
		OR get_user.work_phone NEQ FORM.work_phone
		OR get_user.cell_phone NEQ FORM.cell_phone
		OR get_user.email NEQ FORM.email
		OR get_user.email2 NEQ FORM.email2)>
        
        <cfsavecontent variable="vEmailMessage">
            <cfoutput>
                <p>INTERNATIONAL REPRESENTATIVE NOTICE OF INFORMATION CHANGE</p>
                
                <p><strong>
                    #get_user.businessname# (###get_user.userID#)</strong> has made a change to their profile information.</p>
                
                <p><strong>NEW INFORMATION</strong></p>
                #FORM.address#<br />
                <cfif LEN(FORM.address2)>#FORM.address2#<br /></cfif>
                #FORM.city#
                <cfif FORM.state NEQ 0>
          			, #APPLICATION.CFC.LOOKUPTABLES.getState(ID=FORM.state).state#
                </cfif>
                
                <cfif LEN(FORM.zip)>#FORM.zip#</cfif><br />
                
                #APPLICATION.CFC.LOOKUPTABLES.getCountry(countryID=FORM.country).countryName#
                
                #FORM.phone#<br />
                #FORM.email#<br />
                
                <p><strong>PREVIOUS INFORMATION</strong></p>
                #get_user.address#<br />
                
				<cfif LEN(get_user.address2)>#get_user.address2#<br /></cfif>
                
                #get_user.city#
                
                <cfif get_user.state NEQ 0>
               		, #APPLICATION.CFC.LOOKUPTABLES.getState(ID=get_user.state).state#
				</cfif>
                    
                <cfif LEN(get_user.zip)>#get_user.zip#</cfif>
                <br />
                
                #APPLICATION.CFC.LOOKUPTABLES.getCountry(countryID=get_user.country).countryName#
                
                #get_user.phone#<br />
                #get_user.email#<br />
           
                <p>This is the only notification of this change that you will receive.</p>
                
                <p>Please update any records that do NOT pull information from EXTRA.</p>
            </cfoutput>
        </cfsavecontent>
    
        <!--- SEND EMAIL IF THIS USER IS AN INTERNATIONAL REPRESENTATIVE --->
        <cfinvoke component="extensions.components.email" method="sendEmail">
            <cfinvokeargument name="emailTo" value="anca@csb-usa.com">
            <cfinvokeargument name="emailSubject" value="EXTRA - International Representative Notice of Information Change">
            <cfinvokeargument name="emailMessage" value="#vEmailMessage#">            
        </cfinvoke>
        
    </cfif>
    
    <cfoutput>
    
        <cfquery name="check_email" datasource="MySql">
            SELECT userid, firstname, lastname
            FROM smg_users
            WHERE email = '#FORM.email#' 
                AND userid != <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userid#">
        </cfquery>
        
        <cfif IsDefined('FORM.username')>
            <cfquery name="check_username" datasource="MySql">
                SELECT userid, firstname, lastname
                FROM smg_users
                WHERE username = '#FORM.username#'
                    AND userid != <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userid#">
            </cfquery>
        </cfif>
    
        <cfset total_errors = 0>
        
        <cfloop from="1" to="4" index="i">
            <cfset form["error" & i] = ''>
        </cfloop>
        
        <!--- BLANK USERNAME --->
        <cfif IsDefined('FORM.username') AND FORM.username EQ ''>  
            <cfset FORM.error1 = '<b>Username</b> is required. Please go back and fill it out.'>
            <cfset total_errors = total_errors + 1>
        </cfif>
        
        <!--- BLANK PASSWORD --->
        <cfif IsDefined('FORM.password') AND FORM.password EQ ''>  
            <cfset FORM.error2 = '<b>Password</b> is required. Please go back and fill it out.'>
            <cfset total_errors = total_errors + 1>
        </cfif>
        
        <!--- EMAIL IN USE --->
        <cfif check_email.recordcount>  
            <cfset FORM.error3 = 'Email <b>#FORM.email#</b> is current in use by account <b>#check_email.firstname# #check_email.lastname# ###check_email.userid#</b>. You must change it in order to continue.'>
            <cfset total_errors = total_errors + 1>
        </cfif>
        
        <!--- USERNAME IN USE --->
        <cfif IsDefined('FORM.username') AND check_username.recordcount>  
            <cfset FORM.error4 = 'Username <b>#FORM.username#</b> is current in use by account <b>#check_username.firstname# #check_username.lastname# ###check_username.userid#</b>. You must change it in order to continue.'>
            <cfset total_errors = total_errors + 1>
        </cfif>
        
        <cfif total_errors GT 0>
            <table  bgcolor="FFFFFF" bordercolor="CCCCCC" border="1" height="100%" width="100%">
                <tr bordercolor="FFFFFF">
                    <td>
                        <table width=100% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
                        <tr bgcolor="E4E4E4">
                            <td class="title1">&nbsp; &nbsp; New User</td>
                        </tr>
                        </table><br>
                        <table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=90%>
                            <tr><th class="style1">EXTRA - Input Error</th></tr>
                            <tr><td class="style1">Total of #total_errors# error(s) &nbsp; -  &nbsp; Please see list below.</td></tr>
                            <cfloop from="1" to="4" index="i">
                                <cfif form["error" & i] NEQ ''>
                                    <tr><td class="style1">#form["error" & i]#</td></tr>
                                </cfif>
                            </cfloop>
                            <tr><td align="center" class="style1"><input type="image" value="back" src="../pics/goback.gif" onClick="javascript:history.back()"></td></tr>		
                        </table><br />
                    </td>
                </tr>
            </table>		
            <cfabort>	
        </cfif>
    
        <cfif IsDefined('FORM.comments')>
			<cfset FORM.comments = Replace(FORM.comments,"#chr(10)#","<br>","all")>
		</cfif>
    
        <cfquery name="update" datasource="MySql">
            UPDATE 
            	smg_users
            SET 
            	firstname = '#FORM.firstname#', 
                middlename = '#FORM.middlename#',
                lastname = '#FORM.lastname#',
                <cfif IsDefined('FORM.active')>active = '#FORM.active#',</cfif>
                sex = <cfif IsDefined('FORM.sex')>'#FORM.sex#'<cfelse>''</cfif>, 
                dob = <cfif FORM.dob EQ ''>NULL<cfelse>#CreateODBCDate(dob)#</cfif>,
                drivers_license = '#FORM.drivers_license#',
                address = '#FORM.address#',
                city = '#FORM.city#',
                state = '#FORM.state#',
                country = '#FORM.country#',
                zip = '#FORM.zip#',
                <cfif ListFind("1,2,3,4", CLIENT.userType)>
                	occupation = '#FORM.occupation#',
                </cfif>
                <cfif CLIENT.userType NEQ 8>
                	businessname = '#FORM.businessname#',
              	</cfif>
                work_phone = '#FORM.work_phone#',
                phone = '#FORM.phone#',
                cell_phone = '#FORM.cell_phone#',
                email = '#FORM.email#', 
                email2 = '#FORM.email2#',
                <cfif IsDefined('FORM.username')>username = '#FORM.username#',</cfif>
                <cfif IsDefined('FORM.password')>password = '#FORM.password#',</cfif>
                <cfif IsDefined('FORM.comments')>comments = <cfqueryparam value = "#FORM.comments#" cfsqltype="cf_sql_longvarchar">,</cfif>
                fax = '#FORM.fax#'
            WHERE 
            	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userid#">
            LIMIT 1
        </cfquery>
    
        <!--- SET COMPANY DEFAULT --->
        <cfif IsDefined('FORM.default_company')>
        
            <cfif FORM.default_company NEQ 0>
            
                <cfquery name="erase_defaults" datasource="MySql">
                    UPDATE user_access_rights uar
                    INNER JOIN smg_companies c ON c.companyid = uar.companyid
                    SET uar.default_region = '0'
                    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userid#">
                        AND c.system_id = '4'				
                </cfquery>
                
                <cfquery name="set_default_company" datasource="MySql">
                    UPDATE user_access_rights
                    SET default_region = '1'
                    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userid#">
                        AND companyid = '#FORM.default_company#'
                    LIMIT 1
                </cfquery>
                
            </cfif>
            
        </cfif>
            
        <!--- EDIT / DELETE COMPANY ACCESS --->
        <cfif IsDefined('FORM.user_access_count')>
        
            <cfloop from="1" to="#FORM.user_access_count#" index="x">
            
                <!--- EDIT COMPANY ACCESS --->
                <cfif NOT IsDefined('FORM.delete_'&x)>
                
                    <cfquery name="update_user_access" datasource="MySql">
                        UPDATE user_access_rights
                        SET usertype = '#form["usertype_" & x]#'
                        WHERE id = '#form["access_id_" & x]#'
                    </cfquery>
                    
                <!--- DELETE COMPANY ACCESS ---->
                <cfelse>
                
                    <cfquery name="update_user_access" datasource="MySql">
                        DELETE FROM user_access_rights
                        WHERE id = '#form["access_id_" & x]#'
                        LIMIT 1
                    </cfquery>
                    
                </cfif>
                
            </cfloop>
            
        </cfif>	
        
        <!--- ADD NEW COMPANY ACCESS --->
        <cfif IsDefined('FORM.companyid_new')>
        
            <cfif companyid_new NEQ 0 AND usertype_new NEQ 0>
            
                <cfquery name="check_user_access" datasource="MySql">
                    SELECT userid
                    FROM user_access_rights
                    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userid#">
                        AND companyid = '#FORM.companyid_new#'
                </cfquery>
            
                <cfif check_user_access.recordcount EQ 0>
                
                    <cfquery name="user_access_rights" datasource="MySql">
                        INSERT INTO user_access_rights
                            (userid, companyid, usertype)
                        VALUES
                            (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userid#">, '#FORM.companyid_new#', '#FORM.usertype_new#')
                    </cfquery>
                    
                </cfif>
                
            </cfif>
            
        </cfif>
        
        <script language="JavaScript">
			<!-- 
			alert("You have successfully updated this page.");
				location.replace("?curdoc=user/user_info&uniqueid=#FORM.uniqueid#");
			-->
        </script>
        
    </cfoutput>
	
    <cfcatch type="any">
        <cfinclude template="../error_message.cfm">
    </cfcatch>
    
</cftry>
