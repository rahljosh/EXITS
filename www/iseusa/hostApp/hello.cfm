<cfparam name="convertLead" default="0">
<!----
<cfset client.hostId = 0>
---->

<cfif isDefined('form.processLogin')>
	
	<!----check to see if they have an active app---->
	<cfquery name="login" datasource="mysql">
    select  hostid
    from smg_hosts
    where email = '#form.username#'
    and password = '#form.password#'
    </cfquery>
	<!----If info is found, then they have an account, if now, we check to see if they are a potential host fam, and copy info over.---->
	<cfif login.recordcount eq 1>
    	<cfset client.hostid = #login.hostid#>
	<cfelse>
		<cfquery name="login" datasource="mysql">
        select id,firstname, lastname, address, address2, city, stateID, zipCode, email,phone, password
        from smg_host_lead
        where email = '#form.username#'
        and password = '#form.password#'
        </cfquery>
        <cfif login.recordcount gt 0>
        <cfset convertLead =1>
        <cfset client.hostid = #login.id#>
        
        <cfelse>
        <cfset client.hostid = -2>
        </cfif>
	</cfif>
    
</cfif>
<style type="text/css">
.green {
	background-color: #E6F2D5;
	padding-left: 20px;
}

.gradientBack{
		background-image:url(images/faintGradient.png);
}
</style>

 <cfif client.hostid lte 0>
 <form method="post" action="index.cfm?page=hello">
 <input type="hidden" name="processLogin" />
 	<cfif client.hostid eq -2>
    <div align="center">
    	<font color="##CC0000">The email and password you submitted do not match an account on file.<br />  Please check your information and try again.</font>
    </div>
    </cfif>
     <p align="center">Please login to access your application<br /><br />
     <table align="center">
        <tr>
            <td>Email</td><td><input type="text" name="username" size=20 /></td>
        </tr>
        <tr>
            <td>Password</td><td><input type="password" name="password" size=20 /></p></td>
        </tr>
    	<tr>
        	<td colspan=2><input type="submit" value="Login" /></td>
        </tr>
    </table>
    
  </form>
    </p> 
 <cfelse>
 <cfoutput> 
 <cfif convertLead eq 1>
     <cfquery name="checkIn" datasource="mysql">
     select hostid 
     from smg_hosts
     where email = '#login.email#'
     </cfquery>
  
     <cfif checkIn.recordcount eq 0>
         <cfquery name="getState" datasource="mysql">
         select state
         from smg_states
         where id = #login.stateID#
         </cfquery>
         <cfquery name="startApp" datasource="mysql">
         insert into smg_hosts (familylastname, address, address2, city, state, zip, email,phone, password,applicationStarted, lead)
            values ('#login.lastname#','#login.address#','#login.address2#','#login.city#','#getState.state#','#login.zipCode#', '#login.email#','#login.phone#','#login.password#', #now()#, 1)
         </cfquery>
         
     </cfif>
     <cfquery name="hostId" datasource="mysql">
     select hostid
     from smg_hosts
     where email = '#login.email#'
     </cfquery>
     <cfset client.hostid = #hostid.hostid#>
 </cfif>
 
 <cfquery name="appInfo" datasource="mysql">
 SELECT h.familylastname, h.applicationStarted, h.applicationapproved, h.applicationDenied, h.email, h.regionid, h.arearepid, h.reasonAppDenied, h.lead,
 r.regionname, u.firstname as repFirst, u.lastname as repLast
 FROM smg_hosts h
 LEFT JOIN smg_regions r on r.regionid = h.regionid
 LEFT JOIN smg_users u on u.userid = h.arearepid
 WHERE hostid = #client.hostid#
 </cfquery>
 <Cfset client.hostfam = '#appInfo.familylastname#'>
 <Cfset client.hostemail = '#appInfo.email#'>
<cfset appNotComplete = 1>
<cfinclude template="appStatus.cfm">
  
  
 <h1 class="enter">Welcome #lcase(appInfo.familylastname)# Family!</h1>
  <table>
  	<tr>
    	<td><h3 align="Center">App Overview</h3></td><Td></Td><td><h3 align="Center">Application Instructions / Announcements</h3></td>
    </tr>
    <tr>
     <td width=50% valign="top" class="green">
     
    
     		<p><div align="Center">
            
					   <cfif appNotComplete eq 285>
                            <a href="index.cfm?page=checkList"><strong><u>Ready to Submit!</u></strong></a>
                       <cfelse>
                           <a href="index.cfm?page=checkList"><strong><u>View Missing Information</u></strong></a>
                        </cfif>
      				</div>
                    
             </p>
				
                
                 <table  width= 95% border=0 cellpadding=0 cellspacng=0>
                 	<tr class="gradientBack">
                    	<td  colspan=5 align="left" ><img src="images/gradient.png" alt="Percentage Complete" name="Percent Complete" width="#appNotComplete#" height=10 /></td>
                    </tr>
                    <tr>
                    	<Td align="left" width=20%>0%</td>
                        <td align="center" width=20%>25%</td>
                        <td align="center" width=20%>50%</td>
                        <td align="center" width=20%>75%</td>
                        <td align="right" width=20%>100%</td>
                     </tr>
                  </table>
                  
   		   <p><strong> Application Started -</strong> 
            <cfif appInfo.applicationStarted is ''>
              N/A
              <cfelse>
              #DateFormat(appInfo.applicationStarted, 'mmm d, yyyy')#
            </cfif>
   		  </p>
            
            <p><strong>Application 
                <cfif appInfo.applicationDenied is not ''>
                  Denied</strong> - #DateFormat(appInfo.applicationDenied, 'mmm d, yyyy')#<br />
                  For: 
                  <cfelse>
                  Approved</strong> -
                  <cfif appInfo.applicationApproved is ''>
                    Application in Progress
                    <cfelse>
                    #DateFormat(appInfo.applicationApproved, 'mmm d, yyyy')#
                  </cfif>
                </cfif>
            </p>
            <hr align="center" width=80% />
            <p><strong>Region - </strong>
                <cfif appInfo.regionid eq 0>
                Not Assigned
                <cfelse>#appInfo.regionname#
                </cfif>
            </p>
            <p><strong>Regional Manager -</strong> 
            <cfif appInfo.regionid eq 0>
              Not Assigned
              <cfelse>#appInfo.regionname#
            </cfif>
            </p>
            <p><strong>Area Representative -</strong> 
            <cfif appInfo.regionid eq 0>
              Not Assigned
              <cfelse>#appInfo.repFirst# #appInfo.repLast# 
            </cfif>
        </td>
            <td>
            &nbsp;&nbsp;
            </td>
    		<td>
      
      <p>Carefully complete this application.  Your student's family will receive a copy of the information you provide so please be as complete as possible.  Please be aware that the Department of State has specific requirements regarding the photos that are uploaded on the family album.  We are mandated to have photos of specific areas of your home on file. <br /><br /> 
         Before your applcation can be approved, you will need to agree to and electronically sign the Host Family Rule Page and background checks will need to be run on all household members over the age of 18.<br /><br />
         If you have not already been in contact with a representative, you will be contacted shortly after your application is submitted.</p>
        	<div align="right">
			<cfif appInfo.lead eq 0>
            	<a href="index.cfm?page=startHostApp##pageTop"><img src="../images/buttons/startApp.png" alt="start" border="0" /></a>
            <cfelse>
            	<a href="index.cfm?page=startHostApp"><img src="../images/buttons/continueApp.png" alt="continue" border="0" /></a>
            </cfif>
            </div>
      		</td>
           
      </tr>
    </table>
  <!----
    
   <table width=80%>
    <tr>
        <Th><u>Contact Info</u></Th>
        <th><u>Your App Status</u></th>
    </tr>
    <Tr>
        <Td valign="top">
        <p class="p_uppercase">#hostInfo.familylastname#<Br />
        #hostInfo.address#<br />
        <cfif hostInfo.address2 is not ''>#hostInfo.address2#<br /></cfif>
        #hostInfo.city# #hostInfo.state#, #hostInfo.zip#</p></Td>
        <td valign="top">Initial - Student view limited.<br />
        Rep - N/A<br />
        Region - N/A </td>
     </Tr>
    </table>
    <br />
    <Table align="center">
    <tr>
        <Td><a href="../viewStudents.cfm"><img src="../images/subMeetStudents.png" width="207" height="138" border=0/></a></Td><td>Due to Department of State regulations, you are unable to view student pictures and personal information until a completed Host Family Application is submitted and Criminal Background Check's are submitted and accepted. <br />Once the application process has been completed, you will have access to see complete information on available students.  Until then, you are able to view limited information on available students, but will not be able to see pictures.</td>
    </tr>
    <tr>
    
        <td><a href="index.cfm?page=startHostApp"><img src="../images/subBhost.png" width="207" height="138" border=0 /></a></td><td>Please feel free to start your host family application as this will help speed up the placement process.</td>
        
    </tr>
    </table>
	---->
 </cfoutput>
 </cfif>