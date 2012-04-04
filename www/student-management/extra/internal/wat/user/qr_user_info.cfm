<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>New International Representative</title>
</head>

<body>

<cftransaction action="begin" isolation="serializable">

<cftry>

<!--- IF THE USER IS AN INTERNATIONAL REPRESENTATIVE, CREATE A MESSAGE --->
<cfif CLIENT.usertype EQ '8'>
	<cfinclude template="../querys/get_user.cfm">
 	<cfinclude template="../querys/countrylist.cfm">
	<cfinclude template="../querys/statelist.cfm">
    <cfsavecontent variable="vEmailMessage">
		<cfoutput>
            <p>INTERNATIONAL REPRESENTATIVE NOTICE OF INFORMATION CHANGE</p>
            
            <p><strong>#CLIENT.firstName# #CLIENT.lastName# (###CLIENT.userID#)</strong> has made a change to their profile information.</p>
            
            <p><strong>NEW INFORMATION</strong></p>
            #FORM.address#<br />
            <cfif LEN(FORM.address2)>#FORM.address2#<br /></cfif>
            #FORM.city#
            <cfif #FORM.state# NEQ 0>
            	<cfloop query="statelist">
                	<cfif #FORM.state# EQ #id#>, #state# </cfif>
                </cfloop>
			</cfif>
            <cfif LEN(FORM.zip)>#FORM.zip#</cfif>
            <br />
            <cfloop query="countrylist">
				<cfif #FORM.country# EQ #countryid#>#countryname#<br /></cfif>
            </cfloop>
            #FORM.phone#<br />
            #FORM.email#<br />
            
            <p><strong>PREVIOUS INFORMATION</strong></p>
            #get_user.address#<br />
            <cfif LEN(get_user.address2)>#get_user.address2#<br /></cfif>
            #get_user.city#
            <cfif #get_user.state# NEQ 0>
            	<cfloop query="statelist">
                	<cfif #get_user.state# EQ #id#>, #state# </cfif>
                </cfloop></cfif>
            <cfif LEN(get_user.zip)>#get_user.zip#</cfif>
            <br />
            <cfloop query="countrylist">
				<cfif #get_user.country# EQ #countryid#>#countryname#<br /></cfif>
            </cfloop>
            #get_user.phone#<br />
            #get_user.email#<br />
       
            <p>This is the only notification of this change that you will receive.</p>
            
            <p>Please update any records that do NOT pull information from EXTRA.</p>
        </cfoutput>
 	</cfsavecontent>
</cfif>

<cfoutput>

	<cfquery name="check_email" datasource="MySql">
		SELECT userid, firstname, lastname
		FROM smg_users
		WHERE email = '#form.email#' 
			AND userid != '#form.userid#'
	</cfquery>
	
	<cfif IsDefined('form.username')>
		<cfquery name="check_username" datasource="MySql">
			SELECT userid, firstname, lastname
			FROM smg_users
			WHERE username = '#form.username#'
				AND userid != '#form.userid#'
		</cfquery>
	</cfif>

	<cfset total_errors = 0>
	<cfloop from="1" to="4" index="i">
		<cfset form["error" & i] = ''>
	</cfloop>
	
	<!--- BLANK USERNAME --->
	<cfif IsDefined('form.username') AND form.username EQ ''>  
		<cfset form.error1 = '<b>Username</b> is required. Please go back and fill it out.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- BLANK PASSWORD --->
	<cfif IsDefined('form.password') AND form.password EQ ''>  
		<cfset form.error2 = '<b>Password</b> is required. Please go back and fill it out.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- EMAIL IN USE --->
	<cfif check_email.recordcount>  
		<cfset form.error3 = 'Email <b>#form.email#</b> is current in use by account <b>#check_email.firstname# #check_email.lastname# ###check_email.userid#</b>. You must change it in order to continue.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- USERNAME IN USE --->
	<cfif IsDefined('form.username') AND check_username.recordcount>  
		<cfset form.error4 = 'Username <b>#form.username#</b> is current in use by account <b>#check_username.firstname# #check_username.lastname# ###check_username.userid#</b>. You must change it in order to continue.'>
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

	<cfif IsDefined('form.comments')><cfset form.comments = #Replace(form.comments,"#chr(10)#","<br>","all")#></cfif>

	<cfquery name="update" datasource="MySql">
		UPDATE smg_users
		SET firstname = '#form.firstname#', 
			middlename = '#form.middlename#',
			lastname = '#form.lastname#',
			<cfif IsDefined('form.active')>active = '#form.active#',</cfif>
			sex = <cfif IsDefined('form.sex')>'#form.sex#'<cfelse>''</cfif>, 
			dob = <cfif form.dob EQ ''>NULL<cfelse>#CreateODBCDate(dob)#</cfif>,
			drivers_license = '#form.drivers_license#',
			address = '#form.address#',
			city = '#form.city#',
			state = '#form.state#',
			country = '#form.country#',
			zip = '#form.zip#',
			occupation = '#form.occupation#',
			businessname = '#form.businessname#',
			work_phone = '#form.work_phone#',
			phone = '#form.phone#',
			cell_phone = '#form.cell_phone#',
			email = '#form.email#', 
			email2 = '#form.email2#',
			<cfif IsDefined('form.username')>username = '#form.username#',</cfif>
			<cfif IsDefined('form.password')>password = '#form.password#',</cfif>
			<cfif IsDefined('form.comments')>comments = <cfqueryparam value = "#form.comments#" cfsqltype="cf_sql_longvarchar">,</cfif>
            fax = '#form.fax#'
		WHERE userid = '#form.userid#'
		LIMIT 1
	</cfquery>

	<!--- SET COMPANY DEFAULT --->
    <cfif IsDefined('form.default_company')>
		<cfif form.default_company NEQ 0>
            <cfquery name="erase_defaults" datasource="MySql">
                UPDATE user_access_rights uar
                INNER JOIN smg_companies c ON c.companyid = uar.companyid
                SET uar.default_region = '0'
                WHERE userid = '#form.userid#'
                    AND c.system_id = '4'				
            </cfquery>
            <cfquery name="set_default_company" datasource="MySql">
                UPDATE user_access_rights
                SET default_region = '1'
                WHERE userid = '#form.userid#'
                    AND companyid = '#form.default_company#'
                LIMIT 1
            </cfquery>
        </cfif>
    </cfif>
		
	<!--- EDIT / DELETE COMPANY ACCESS --->
	<cfif IsDefined('form.user_access_count')>
  		<cfloop from="1" to="#form.user_access_count#" index="x">
        
			<!--- EDIT COMPANY ACCESS --->
			<cfif NOT IsDefined('form.delete_'&x)>
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
	<cfif IsDefined('form.companyid_new')>
		<cfif companyid_new NEQ 0 AND usertype_new NEQ 0>
            <cfquery name="check_user_access" datasource="MySql">
                SELECT userid
                FROM user_access_rights
                WHERE userid = '#form.userid#'
                    AND companyid = '#form.companyid_new#'
            </cfquery>
        
            <cfif check_user_access.recordcount EQ 0>
                <cfquery name="user_access_rights" datasource="MySql">
                    INSERT INTO user_access_rights
                        (userid, companyid, usertype)
                    VALUES
                        ('#form.userid#', '#form.companyid_new#', '#form.usertype_new#')
                </cfquery>
            </cfif>
        </cfif>
    </cfif>

	<head>
    
    <!--- SEND EMAIL IF THIS USER IS AN INTERNATIONAL REPRESENTATIVE --->
    <cfif CLIENT.usertype EQ '8'>
	 	<cfinvoke component="EXTRA.extensions.components.email" method="sendEmail">
          	<cfinvokeargument name="emailTo" value="anca@csb-usa.com">
          	<cfinvokeargument name="emailSubject" value="EXTRA - International Representative Notice of Information Change">
          	<cfinvokeargument name="emailMessage" value="#vEmailMessage#">            
      	</cfinvoke>
	</cfif>
    
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page.");
		location.replace("?curdoc=user/user_info&uniqueid=#form.uniqueid#");
	-->
	</script>
	</head>
	</html> 
</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</cftransaction>

</body>
</html>
