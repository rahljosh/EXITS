<!--- ------------------------------------------------------------------------- ----
	
	File:		overview.cfm
	Author:		Marcus Melo
	Date:		November 6, 2012
	Desc:		Overview Page

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

	<cfscript>
		// Get Application Status
		stApplicationStatus = APPLICATION.CFC.HOST.getApplicationProcess();
	</cfscript>

	<!--- Get Host Family Information --->
    <cfquery name="qGetHostFamilyInfo" datasource="#APPLICATION.DSN.Source#">
        SELECT 
            h.hostAppStatus,
            h.familylastname, 
            h.applicationStarted, 
            h.email, 
            h.regionID, 
            h.areaRepID, 
            h.lead, 
            h.hostAppStatus,
            r.regionname, 
            u.firstName AS areaRepFirstName,
            u.lastName AS areaRepLastName,
            u.email AS areaRepEmail,
            u.phone AS areaRepPhone,
            u.work_phone AS areaRepWorkPhone
        FROM 
            smg_hosts h
        LEFT OUTER JOIN 
            smg_regions r on r.regionID = h.regionID
        LEFT OUTER JOIN 
            smg_users u on u.userID = h.areaRepID
        WHERE 
            h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
    </cfquery>

    <!--- Regional Manager --->
    <cfquery name="qGetRegionalManager" datasource="#APPLICATION.DSN.Source#">
        SELECT 
            u.firstName, 
            u.lastName
        FROM 
            smg_users u
        LEFT OUTER JOIN 
            user_access_rights uar on uar.userID = u.userID
        WHERE 
            uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostFamilyInfo.regionID)#">
        AND
            uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
    </cfquery>
    
</cfsilent>

<script type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		//Examples of how to assign the ColorBox event to elements
		$(".iframe").colorbox({width:"80%", height:"80%", iframe:true, 
			onClosed:function(){ location.reload(false); } });
	});
//]]>
</script>

<cfoutput> 
  
    <h1 align="center">Welcome #qGetHostFamilyInfo.familylastname# Family!</h1> <br />
    
    <table width="100%" cellspacing="0" cellpadding="2"> 
        <tr>
            <td><h3 align="center">Application Overview</h3></td>
            <td>&nbsp;</td>
            <td><h3 align="center">Application Instructions / Announcements</h3></td>
        </tr>
        <tr>
            <td width="50%" valign="top" class="greenBackground">
    
                <table width="100%" style="margin-top:10px;">
                    <tr>
                        <td>
                        
                            <table border="0" cellpadding="0" cellspacng="0" width="300" align="center">
                                <tr>
                                    <td colspan="5" align="left" style="border:1px solid ##03518d;">
                                        <img src="images/gradient.png" alt="Percentage Complete" name="Percent Complete" width="#stApplicationStatus.applicationProgress#" height="15" border="0" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" width="60">0%</td>
                                    <td align="center" width="60">25%</td>
                                    <td align="center" width="60">50%</td>
                                    <td align="center" width="60">75%</td>
                                    <td align="right" width="60">100%</td>
                                </tr>
                            </table>
                            
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <cfif qGetHostFamilyInfo.hostAppStatus LTE 7>
                                <p><strong><u>Submitted!</u></strong></p>
                            <cfelse>
                                <a href="index.cfm?section=checkList" style="text-align: left;">Review Checklist</a>
                            </cfif>
                        </td>
                    </tr>
                </table>
                
                <hr align="center" width="80%" style="margin:15px auto 15px auto;" />
                
                <p>
                    <strong> Application Started -</strong> 
                    <cfif qGetHostFamilyInfo.applicationStarted is ''>
                        N/A
                    <cfelse>
                        #DateFormat(qGetHostFamilyInfo.applicationStarted, 'mmm d, yyyy')#
                    </cfif>
                </p>
                
                <p>
                    <strong>Application Status:</strong>
                    <cfswitch expression="#qGetHostFamilyInfo.hostAppStatus#">
                        
                        <cfcase value="1,2,3,4">
                            Submitted to Headquarters
                        </cfcase>

                        <cfcase value="5">
                            Submitted to Regional Manager
                        </cfcase>

                        <cfcase value="6">
                            Submitted to Regional Advisor
                        </cfcase>

                        <cfcase value="7">
                            Submitted to Area Representative
                        </cfcase>
                        
                        <cfdefaultcase>
                            
                            <cfif stApplicationStatus.isComplete>
                                Complete
                            <cfelse>
                                In Progress - #round(100 * stApplicationStatus.applicationProgress / 300)#% Complete
                            </cfif>
                            
                        </cfdefaultcase>
                    
                    </cfswitch>
                </p>
                
                <hr align="center" width="80%" style="margin:15px auto 15px auto;" />
                
                <!--- Area Representative --->
                <table border="0" cellpadding="0" cellspacng="0" width="300" align="center">
                	<tr>
                    	<td colspan="2">If you have any questions please contact your area representative: <br /><br /></td>
					</tr>                        
                    <tr>
                    	<td width="130px">
                        	<strong>Area Representative:</strong>  
                            
							<cfif LEN(qGetHostFamilyInfo.areaRepWorkPhone)>
                                <br />
                                <strong>Phone:</strong>  
                            </cfif>
                            
							<cfif LEN(qGetHostFamilyInfo.areaRepPhone)>
                                <br />
                                <strong>Phone:</strong>  
                            </cfif>

                            <cfif LEN(qGetHostFamilyInfo.areaRepEmail)>
                                <br />
                                <strong>Email Address:</strong>  
                            </cfif>
                            
                        </td>
                        <td>
							<cfif NOT VAL(qGetHostFamilyInfo.regionID)>
                                Not Assigned
                            <cfelse>
                                #qGetHostFamilyInfo.areaRepFirstName# #qGetHostFamilyInfo.areaRepLastName#
        
                                <cfif LEN(qGetHostFamilyInfo.areaRepPhone)>
                                    <br />
                                    #qGetHostFamilyInfo.areaRepPhone#
                                </cfif>

                                <cfif LEN(qGetHostFamilyInfo.areaRepWorkPhone)>
                                    <br />
                                    #qGetHostFamilyInfo.areaRepWorkPhone#
                                </cfif>
                                
                                <cfif LEN(qGetHostFamilyInfo.areaRepEmail)>
                                    <br />
                                    <a href="mailto:#qGetHostFamilyInfo.areaRepEmail#">#qGetHostFamilyInfo.areaRepEmail#</a>
                                </cfif>
                                
                            </cfif>
                        </td>
					</tr>  
                </table>
                
                <!--- Regional Manager --->
                <table border="0" cellpadding="0" cellspacng="0" width="300" align="center" style="margin-top:10px;">
                    <tr>
                    	<td width="130px"><strong>Regional Manager:</strong></td>
                        <td>
							<cfif NOT VAL(qGetHostFamilyInfo.regionID)>
                                Not Assigned
                            <cfelse>
                                #qGetRegionalManager.firstName# #qGetRegionalManager.lastName#  
                            </cfif>
                        </td>
					</tr>  
                </table>
                
                <!--- Region --->
                <table border="0" cellpadding="0" cellspacng="0" width="300" align="center" style="margin-top:10px;">
                    <tr>
                    	<td width="130px"><strong>Region:</strong></td>
                        <td>
							<cfif NOT VAL(qGetHostFamilyInfo.regionID)>
                                Not Assigned
                            <cfelse>
                                #qGetHostFamilyInfo.regionname#
                            </cfif>
                        </td>
					</tr>  
                </table>
                
            </td>
            <td>&nbsp;&nbsp;</td>
            <td valign="top">	
                <cfif qGetHostFamilyInfo.hostAppStatus LTE 7>
                    <h2 align="center">Thank you!</h2>
                    <p>Thats it!  Your application has been submitted for review.  You will hear from your local representative shortly.</p>
                <cfelse>
                	
                    <cfif stApplicationStatus.isComplete>
						<p><strong>Your application is complete!</strong> Happy with how everything looks? Click the button to the right to submit your application.</p>
                        
                        <p align="center">
                        	<a href="disclaimer.cfm" class="iframe"><img src="images/buttons/#SESSION.COMPANY.submitImage#" border="0"/></a>
                        </p>
                        
                    <cfelse>
                
                        <p>Congratulations on the decission to host a student with ISE.  We are excited to be working with you.</p>
                        <div align="center">
                            <a href="index.cfm?section=contactInfo"><img src="images/buttons/contApp.png" alt="continue" border="0" /></a>
                        </div>
                        
                    </cfif>
                    
                        <p>
                            Your student's family will receive selected  information from this application. 
                            Student and their families will not receive any confidential infromation.  
                            Please be aware that the Department of State has specific requirements regarding the photos that are uploaded on the family album.  
                            We are mandated to have photos of specific areas of your home on file. 
                            <br /><br /> 
                            Before your applcation can be approved background checks will need to be run on all household members over the age of 18.
                            <br /><br />
                            If you have not already been in contact with a representative, you will be contacted shortly after your application is submitted.
                        </p>
					
                </cfif>
            </td>
        </tr>
    </table>
    
</cfoutput>