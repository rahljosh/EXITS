<!--- this is included by cfc/email.cfc, send_mail function --->
<cfoutput>

<!--- sample image
<img src="#CLIENT.exits_url#/images/email/email-header.jpg" width="750" height="100" border="0" usemap="#Map" />--->

<cfswitch expression="#include_content#">

	<!--- Send/resend login info:  used when called by: forms/user_form.cfm, user_info.cfm --->
    <cfcase value="resend_login">
        <cfquery name="get_user" datasource="#application.dsn#">
            SELECT smg_users.*, smg_companies.companyname
            FROM smg_users LEFT JOIN smg_companies ON smg_users.defaultcompany = smg_companies.companyid
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userid#">
        </cfquery>
    
        
    
        <p>A request for your login information to be sent to you was submitted by #client.name#. </p>
        
        <p>Login ID / Username: #get_user.username#<br />
    Password: #get_user.password#</p>
        
        
        <p>You can login immediately by visiting:  <a href="#CLIENT.exits_url#">#CLIENT.exits_url#</a>  and log in with the information above.</p> 
        
        <p>If you have any questions or problems with logging in please contact <a href="mailto:#client.support_email#">#client.support_email#</a> or by replying to this email.</p>
        
        <p>If you have questions regarding your account access levels, please contact your Regional Advisor or Regional Director.</p> 
        
        <br />
        <p>Sincerely-</p>
        
        <p>#client.companyshort# Technical Support</p>
    </cfcase>
    <!--- Send/resend login info:  used when called by: forms/user_form.cfm, user_info.cfm --->
    <cfcase value="accountActive">
        <cfquery name="get_user" datasource="#application.dsn#">
            SELECT smg_users.*, smg_companies.companyname
            FROM smg_users LEFT JOIN smg_companies ON smg_users.defaultcompany = smg_companies.companyid
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userid#">
        </cfquery>
    
        
    
        <p>Your account is now active! </p>
        
        <p>Login ID / Username: #get_user.username#<br />
    Password: #get_user.password#</p>
        
        
        <p>You can login immediately by visiting:  <a href="#CLIENT.exits_url#">#CLIENT.exits_url#</a>  and log in with the information above.</p> 
        
        <p>If you have any questions or problems with logging in please contact <a href="mailto:#client.support_email#">#client.support_email#</a> or by replying to this email.</p>
        
        <p>If you have questions regarding your account access levels, please contact your Regional Advisor or Regional Director.</p> 
        
        <br />
        <p>Sincerely-</p>
        
        <p>#client.companyshort# Technical Support</p>
    </cfcase>
    
    <!----Send information that user needs to supply more information before they will be allowed to login.  CBC, refernce, employment history---->
    <cfcase value="newUserMoreInfo">
        <cfquery name="get_user" datasource="#application.dsn#">
            SELECT smg_users.*, smg_companies.companyname
            FROM smg_users LEFT JOIN smg_companies ON smg_users.defaultcompany = smg_companies.companyid
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userid#">
        </cfquery>
    	
       
    
        

<table width="800"  cellspacing="0" cellpadding="10" border="2" bordercolor="##666666">
  <tr>
    <td>
    <table width="750" border="0" cellspacing="0" cellpadding="10" align="center" bgcolor="##EFEFEF">
  <tr>
    <td><h3>An account has been created for you on the #client.companyname# website.  Your account login information is below.</h3>
     <table width="250" border="1" cellspacing="0" cellpadding="10" align="center" bgcolor="##FFF">
  <tr>
    <td>  <p>Username: <strong>#get_user.username#</strong><br />
Password:<strong> #get_user.password#</strong></p></td>
  </tr>
</table>
  
        
      
    
        <p>During your first login, you will need to complete three steps, verify your information, change your password, and complete your application process.</p></td>
  </tr>
</table>


<table width ="650" cellspacing="20">
      <Tr>
            <Td width="626"><h2>Step ##1</h2>The first step is verifying your contact information.  Please make sure that all of your information has been entered correctly.  Inaccurate information can delay payments, communications, etc.  Once you have verified and changed, if necessary, your contact info,  you MUST click on the button stating your information is correct before you can continute. </Td><Td width="542"align="center"><img src="http://ise.exitsapplication.com/nsmg/pics/verify_info.png" width= "375" border="1"/></Td>
           </Tr>
            <Tr>
                <Td colspan=2><hr width="100%" align="center" />
                </Tr>
           <Tr>
            <Td align="center"><img src="http://ise.exitsapplication.com/nsmg/pics/change_pass.png" width="300" border="1" /></Td>
                <td><h2>Step ##2</h2>
                 <p>You will then be prompted to change your password from the temporary password to one of your choosing.  
                 <ol>
                    <li>Cannot re-use your existing password.</li>
                    <li>Must be at least 8 characters.</li>
                    <li>Must include both alphabetic and numeric characters.</li>
                    <li>Cannot be a substring of your Email.</li>
                    <li>Should not be easily recognizable passwords, such as your name, birth dates, or names of children.</li>
                  </ol>
                 </p>
             </td>
    </Tr>
            <Tr>
                <Td colspan=2><hr width="100%" align="center" />
           
                </Tr>
           <cfif client.companyid NEQ 13>
            <tr>
            
            <td><h2>Step ##3</h2>
                 <p>Once you have successfully logged in, you will continue the application process by being prompted with <strong>4 sections</strong> that need to be filled out.
        <ol>
          <li>Criminal Background Check (mandated by the Dept. of State)</li>
            <li>Area Representative Agreement</li>
            <li>Employment History </li>
          <li>References</li>
        </ol>
         <em>Once submitted, your information will be reviewed and a final approval will be needed before your account is fully active. Once your account is active, you will receive an email notification and you will be able to login with full access.</em></p>
                </td>
            <td align="center">
                <img src="http://ise.exitsapplication.com/nsmg/pics/infoNeededScreen.png" width="300"  border="1"/>
                </td>
            </tr>
            </cfif>
            <Tr>
                <Td colspan=2><hr width="100%" align="center" />
                </Tr>
         </table>
       
       
       <p>You can login immediately to provide this additional information by visiting:  <a href="#CLIENT.exits_url#">#CLIENT.exits_url#</a>  and log in with the information above.</p> 
         <p>If you should have any questions or problems, please contact your regional advisor or manager.</p>
          
             
        
        <br />
        <p><strong>Welcome-</strong></p>
        
        <p>#client.companyshort# Technical Support</p>
      </td>
  </tr>
</table>



    </cfcase>
</cfswitch>

<p><font size="1"><a href="#client.site_url#">#client.site_url#</a></font></p>

</cfoutput>