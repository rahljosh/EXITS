<cfparam name="convertLead" default="0">
<cfparam name="client.initialHostAppType" default="3">

<!----
<cfset client.hostId = 0>
---->

<cfif isDefined('form.processLogin')>
	
	<!----check to see if they have an active app---->
	<cfquery name="login" datasource="mysql">
    select  hostid, initialHostAppType
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
         <cfset client.initialHostAppType = #login.initialHostAppType#>
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
     <p align="center">Please login to access your host family application. <br /><br />
     <div style="display: block; padding: 10px; background-color: #efefef; width: 400px; margin-left: auto; margin-right: auto; height: 150px;"><div style="display: block; with: 200px; float: left;"><img src="images/LoginIcon_2.png" width="196" height="140" /></div>
    <div style="padding-top: 30px;"> <table align="center">
        <tr>
            <td>Email</td><td><input type="text" name="username" size=20 /></td>
        </tr>
        <tr>
            <td>Password</td><td><input type="password" name="password" size=20 /></p></td>
        </tr>
    	<tr>
        	<td colspan=2 align="right"><input name="login" type="submit" value="Login"  /></td>
        </tr>
    </table></div>
    </div>
  </form>
    </p> 
 <cfelse>
     <cfquery name="checkAppExists" datasource="mysql">
     select familylastname
     from smg_hosts
     where hostid = #client.hostid#
     </cfquery>
     <cfif checkAppExists.recordcount eq 0>
     	<cflocation url="../hostLogout.cfm">
     </cfif>
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
     <cfset client.hostid = #hostId.hostid#>
 </cfif>
 
 <cfquery name="appInfo" datasource="mysql">
 SELECT h.familylastname, h.applicationStarted, h.applicationapproved, h.applicationDenied, h.email, h.regionid, h.arearepid, h.reasonAppDenied, h.lead, h.HostAppStatus,
 r.regionname, u.firstname as repFirst, u.lastname as repLast
 FROM smg_hosts h
 LEFT JOIN smg_regions r on r.regionid = h.regionid
 LEFT JOIN smg_users u on u.userid = h.arearepid
 WHERE h.hostid = #client.hostid#
 </cfquery>
<!----Regional Manager---->
<cfquery name="regionalManager" datasource="mysql">
select u.firstname, u.lastname
from smg_users u
left join user_access_rights uar on uar.userid = u.userid
where uar.regionid = #appInfo.regionid# and uar.usertype = 5
</cfquery>
 <Cfset client.hostfam = '#appInfo.familylastname#'>
 <Cfset client.hostemail = '#appInfo.email#'>
<cfset appNotComplete = 1>
<cfinclude template="appStatus.cfm">
 <cfif appInfo.hostAppStatus eq 9>
  <cfquery name="updateHostAppStatus" datasource="mysql">
  update smg_hosts
  set HostAppStatus = 8
  where hostid = #client.hostid#
  </cfquery>
</cfif>
  

 <h1 class="enter">Welcome #lcase(appInfo.familylastname)# Family!</h1>
 <div align="center"><a href="../hostLogout.cfm">Logout</a></div>


  <table>
  	<tr>
    	<td><h3 align="Center">Application Overview</h3></td><Td></Td><td><h3 align="Center">Application Instructions / Announcements</h3></td>
    </tr>
    <tr>
     <td width=50% valign="top" class="green">
     <br />
   
				<Table width=95%>
                	<Tr>
                    	<td>
      
                 <table   border=0 cellpadding=0 cellspacng=0 width=190 align="Center">
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
                  			</td>
                       </Tr>
                       <tr>
                         <td align="center">
                         <cfif appInfo.HostAppStatus lte 7>
            	<strong><u>Submitted!</u></strong>
             <cfelse>
           
					   
                            <a href="index.cfm?page=checkList" style="text-align: left;">Review Check List</a>
                      
             </cfif>
                         </td>
                      </Tr>
                   </Table>
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
              <cfelse>#regionalManager.firstname# #regionalManager.lastname#  
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
      <cfif appInfo.HostAppStatus lte 7>
      
      <h2 align="center">Thank you!</h2>
      <p>Thats it!  Your application has been submitted for review.  You will hear from your local representative shortly. 
      <cfelse>
      <p>Congratulations on the decission to host a student with ISE.  We are excited to be working with you.
      <div align="center">
			
            	<a href="index.cfm?page=startHostApp"><img src="images/buttons/contApp.png" alt="continue" border="0" /></a>
                <!----
				<cfif appInfo.lead eq 0>
            	<a href="index.cfm?page=startHostApp##pageTop"><img src="../images/buttons/startApp.png" alt="start" border="0" /></a>
            <cfelse>
            </cfif>
            ---->
            
            </div>
      <p>  Your student's family will receive selected  information from this application. Student and their families will not receive any confidential infromation.  Please be aware that the Department of State has specific requirements regarding the photos that are uploaded on the family album.  We are mandated to have photos of specific areas of your home on file. <br /><br /> 
         Before your applcation can be approved background checks will need to be run on all household members over the age of 18.<br /><br />
         If you have not already been in contact with a representative, you will be contacted shortly after your application is submitted.</p>
        	</cfif>
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
    
<Cfif client.initialHostAppType eq 3>
<cfelseif client.initialHostAppType eq 2>
    <p style="background-color:##efefef;padding:10px">The next 2 pages collect all the information that is needed to complete the background check. A background check is required on anyone who is 17 years of age or older and living in the residence where the exchange student will be living.  Some or all of this information may be completed.  If it is, please review the information and then provide signatures on the approriate pages before submitting.  </p>
    <br />
    <div align="Center">
   
                    <a href="index.cfm?page=startHostApp"><img src="../images/buttons/getStarted.png" alt="continue" border="0" /></a>
              
    </div>
    <br />
   <hr width=50% align="center"/>
   <BR /><br />
 <h3><u>Department Of State Regulations</u></h3>
<p>&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(7)</a></strong><br />
<em> Verify that each member of the host family household 18 years of age and older, as well as any new adult member added to the household, or any member of the host family household who will turn eighteen years of age during the exchange student's stay in that household, has undergone a criminal background check (which must include a search of the Department of Justice's National Sex Offender Public Registry);</em>               
                

<cfelseif client.initialHostAppType eq 1>
      <p style="background-color:##efefef;padding:10px">This account is not set up for the online applciation system.  </p>
    <br />
  
                  
      

</cfif>
 </cfoutput>
 </cfif>
