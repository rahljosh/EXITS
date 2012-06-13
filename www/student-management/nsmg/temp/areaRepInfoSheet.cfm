<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
<link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css" />
<style type="text/css">


.clearfix {
	display: block;
	clear: both;
	height: 5px;
	width: 100%;
}

</style>
</head>

<body>

<cfquery name="userinfo" datasource="#application.dsn#">
select firstname, lastname, address, address2, city, state, zip, phone, cell_phone, email, work_phone,
prevOrgAffiliation, prevAffiliationName, prevAffiliationProblem 

from smg_users
where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
</cfquery>
<cfquery name="qEmploymentHistory" datasource="MySQL">
    select *
    from smg_users_employment_history
    where fk_userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
    order by current
    limit 3
</cfquery>

   <cfquery name="qreferences" datasource="MySQL">
        SELECT 
        	*
        FROM
        	smg_user_references
        WHERE
        	referencefor = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
    
    </cfquery>	
    
<table cellpadding=0 cellspacing=0>
	<tr>
    	<td>  <img src="../pics/1_short_profile_header.jpg" width="800" height="172" /></td>
    </tr>
    <tr>
    	<td align="center"><font size=+2>Area Rep Information Sheet</font></td>
    </tr>
   
</table>
<Cfoutput>
<!----Personal Information---->

		   <div class="rdholder" style="width:800px;float:left;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Personal Information</span> 
                <!--- DOS Usertype does not have access to edit information --->
				<cfif CLIENT.userType NEQ 27>
	                <a href="index.cfm?curdoc=forms/user_form&userid=#url.userid#"></a>
                </cfif>
            	</div> <!-- end top --> 
             <div class="rdbox">
             <!-----****personal info****---->
            
					<table  cellpadding="0" cellspacing="0" border="0" align="left" width=800>
							
							<tr>
								
								<td width=226 style="padding:5px;" valign="top">
									#userinfo.firstname# #userinfo.lastname#<br>
									#userinfo.address#<br>
									<cfif userinfo.address2 NEQ ''>#userinfo.address2#<br></cfif>
									#userinfo.city# #userinfo.state#, #userinfo.zip#<br>
                                 </td>
                                 <td valign="top">
									<cfif userinfo.phone NEQ ''>Home: #userinfo.phone#<br></cfif>
									<cfif userinfo.work_phone NEQ ''>Work: #userinfo.work_phone#<br></cfif>
									<cfif userinfo.cell_phone NEQ ''>Cell: #userinfo.cell_phone#<br></cfif>
									<cfif userinfo.email NEQ ''>Email:#userinfo.email#<br></cfif>
								
								</td>
								
							</tr>
							
						</table> 
			<div class="clearfix"></div>
            <!-----*****end Personal Info****---->
			
			</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
            <br /><br />
            <!----Personal Information---->
		   <div class="rdholder" style="width:800px;float:left;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Employment History</span> 
                <!--- DOS Usertype does not have access to edit information --->
				<cfif CLIENT.userType NEQ 27>
	                <a href="index.cfm?curdoc=forms/user_form&userid=#url.userid#"></a>
                </cfif>
            	</div> <!-- end top --> 
             <div class="rdbox">
             <!-----****personal info****---->
            
						<table  cellpadding="0" cellspacing="0" border="0" align="left" width=800>
						
							<tr>
								<cfloop query="qEmploymentHistory">
								<td valign="top">
									Occupation: #occupation#<br />
                                    #employer#<br />
                                    #address#<br />
                                    <cfif address2 is not ''>#address2#<br /></cfif>
                                    #city# #state#, #zip#
                                    Days Worked: #daysWorked#<br />
                                    Hours per Day: #hoursDay#<br />
                                    Phone: #phone#<br />
                                    Dates Employeed: #datesEmployed#
								
								</td>
								</cfloop>
							</tr>
						
						</table> 
		<div class="clearfix"></div>
            <!-----*****end Personal Info****---->
			
			</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
            <br /><br />
            <!----reference Information---->
		   <div class="rdholder" style="width:800px;float:left;"> 
				<div class="rdtop"> 
                <span class="rdtitle">References</span> 
                <!--- DOS Usertype does not have access to edit information --->
				<cfif CLIENT.userType NEQ 27>
	                <a href="index.cfm?curdoc=forms/user_form&userid=#url.userid#"></a>
                </cfif>
            	</div> <!-- end top --> 
             <div class="rdbox">
             <!-----****reference info****---->
            
						<table  cellpadding="0" cellspacing="0" border="0" align="left" width=800>
						
							<tr>
								<cfloop query="qreferences">
								<td valign="top">
									#firstname# #lastname#<br />
                                    #address#<br />
                                    <cfif address2 is not ''>#address2#<br /></cfif>
                                    #city# #state#, #zip#<br />
                                    Phone: #phone#<br />
                                    Email: #email#<br />
                                    Relationship: #relationship#<br />
                                    Known: #howLong#
								
								</td>
								</cfloop>
							</tr>
						
						</table> 
			<div class="clearfix"></div>
            <!-----*****end Personal Info****---->
			
			</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
         <br /><br />
            <!----History Information---->
		   <div class="rdholder" style="width:800px;float:left;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Prior Exchange Experience</span> 
                <!--- DOS Usertype does not have access to edit information --->
				<cfif CLIENT.userType NEQ 27>
	                <a href="index.cfm?curdoc=forms/user_form&userid=#url.userid#"></a>
                </cfif>
            	</div> <!-- end top --> 
             <div class="rdbox">
             <!-----****History info****---->
            
						<table  cellpadding="0" cellspacing="0" border="0" align="left" width=800>
						
							<tr>
								
								<td valign="top">
								Have you had a previous affiliation in any way with  international exchange student programs (i.e., hosting, placing, or monitoring 

exchange students) or with the Department of State Secondary School Student program? <b><cfif userinfo.prevOrgAffiliation eq 1>Yes<cfelse>No</cfif></b>
<br /><br />
If Yes, please indicate the name of the sponsor that you were affiliated with and list your dates of affiliation with that organization.<br />
<b><Cfif userinfo.prevAffiliationName is ''>N/A<cfelse>#userinfo.prevAffiliationName#</Cfif> </b>
<br /><br />
Were there any issues with the prior organization(s)? If Yes, please explain:<br />
<b><cfif userinfo.prevAffiliationProblem is ''>N/A<cfelse>#userinfo.prevAffiliationProblem#</cfif></b>

								
								</td>
							
							</tr>
						
						</table> 
			<div class="clearfix"></div>
            <!-----*****end History Info****---->
			
			</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>

</Cfoutput>
</body>
</html>