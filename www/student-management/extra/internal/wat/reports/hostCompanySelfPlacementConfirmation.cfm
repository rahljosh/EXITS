<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
    <!--- Param FORM variables --->
    <cfparam name="FORM.hostCompanyID" default="0">
	<cfparam name="FORM.programID" default="0">
	<cfparam name="FORM.selfJobOfferStatus" default="">
    <cfparam name="FORM.emailHostCompany" default="0">
	<cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.submitted" default="0">

    <cfscript>
		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
	</cfscript>
    
    <cfquery name="qGetHostCompanyList" datasource="MySql">
        SELECT 
        	hostcompanyID, 
            name 
        FROM 
        	extra_hostcompany 
        WHERE         	
            companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        AND 
        	name != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        <!---
        AND
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        --->
		ORDER BY 
        	name
    </cfquery>
    
    <!--- FORM submitted --->
    <cfif FORM.submitted>
		
        <cfquery name="qGetProgramInfo" datasource="mysql">
            SELECT 
            	programname
            FROM 
            	smg_programs
            WHERE 
            	programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
        </cfquery> 
    	
        <cfquery name="qGetResults" datasource="MySql">
            SELECT 
                ec.candidateID,
                ec.uniqueID,
                ec.firstname, 
                ec.lastname, 
                ec.sex, 
                ec.email,
                ec.ds2019,
                ec.startdate, 
                ec.enddate,
                ecpc.jobID AS jobTitleID,
                ej.title AS jobTitle,
                <!--- Host Company --->
                ehc.hostCompanyID,
                ehc.name AS hostCompanyName,
                ehc.email AS hostCompanyEmail,
                ehc.supervisor AS hostCompanySupervisor,
                ehc.personJobOfferName,
                <!--- Country --->
                cl.countryName
            FROM
                extra_candidates ec
            INNER JOIN
            	extra_candidate_place_company ecpc ON ecpc.candidateID = ec.candidateID 
                	AND 
                    	ecpc.hostCompanyID = ec.hostCompanyID 
					AND 
                    	ecpc.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            LEFT JOIN
            	extra_jobs ej ON ej.id = ecpc.jobID
            INNER JOIN
                extra_hostcompany ehc ON ehc.hostcompanyid = ecpc.hostcompanyid  
                
				<cfif VAL(FORM.hostCompanyID)>    
                    AND    
                        ehc.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostCompanyID#">                        
                </cfif>

            LEFT OUTER JOIN
            	smg_countryList cl ON cl.countryID = ec.residence_country            
            WHERE 
                ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
            AND 
                ec.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
            AND
            	ec.wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Self-Placement">
                
			<cfif LEN(FORM.selfJobOfferStatus)>
            	AND
                    ecpc.selfJobOfferStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.selfJobOfferStatus#">                 
			</cfif> 
                       
            ORDER BY
            	ehc.name,
                ec.candidateID            
        </cfquery>

    </cfif>       
    
</cfsilent>

<script type="text/javascript">
	<!-- Begin

	$(document).ready(function() {
		displayEmailOption();
	});	

	var displayEmailOption = function() {
		
		selectedStatus = $("#selfJobOfferStatus").val();
		
		if ( selectedStatus == 'Pending' ) {
			$("#trEmailOption").slideDown("fast");
		} else {
			$("#trEmailOption").slideUp("fast");
		}
	
	}
	// End -->
</script>

<style type="text/css">
	<!--
	.tableTitleView {
		font-family: Verdana, Arial, Helvetica, sans-serif;
		font-size: 10px;
		padding:2px;
		color:#FFFFFF;
		background:#4F8EA4;
		padding:5px;
	}
	-->
</style>

<cfoutput>

<!--- Form --->
<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" name="form">
<input type="hidden" name="submitted" value="1" />

<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
    <tr valign="middle" height="24">
        <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Host Companies -> Self Placement Confirmation</font>
        </td>
    </tr>
    <tr valign="middle" height="24">
        <td valign="middle" colspan="2">&nbsp;</td>
    </tr>
    <tr valign="middle">
        <td align="right" valign="middle" class="style1"><b>Host Company: </b></td>
        <td valign="middle">  
            <select name="hostCompanyID" class="style1">
                <option value="ALL">---  All Host Companies  ---</option>
                <cfloop query="qGetHostCompanyList">
                    <option value="#hostcompanyID#" <cfif qGetHostCompanyList.hostcompanyID EQ FORM.hostCompanyID> selected </cfif> >#qGetHostCompanyList.name#</option>
                </cfloop>
            </select>
        </td>
    </tr>
    <tr>
        <td valign="middle" align="right" class="style1"><b>Program:</b></td>
        <td> 
            <select name="programID" class="style1">
                <option value="0">Select a Program</option>
                <cfloop query="qGetProgramList">
                	<option value="#programID#" <cfif qGetProgramList.programID eq FORM.programID> selected="selected" </cfif> >#programname#</option>
                </cfloop>
            </select>
        </td>
    </tr>
    <tr>
        <td valign="middle" align="right" class="style1"><b>Job Offer Status:</b></td>
        <td> 
            <select name="selfJobOfferStatus" id="selfJobOfferStatus" class="style1" onchange="displayEmailOption();">
                <option value="" <cfif NOT LEN(FORM.selfJobOfferStatus)> selected="selected" </cfif> >All</option>
                <option value="Pending" <cfif FORM.selfJobOfferStatus EQ 'Pending'> selected="selected" </cfif> >Pending</option>
                <option value="Confirmed" <cfif FORM.selfJobOfferStatus EQ 'Confirmed'> selected="selected" </cfif> >Confirmed</option>
                <option value="Rejected" <cfif FORM.selfJobOfferStatus EQ 'Rejected'> selected="selected" </cfif> >Rejected</option>
            </select>
        </td>
    </tr>  
    <tr id="trEmailOption" class="displayNone">
        <td align="right"  class="style1"><b>Email Host Company: </b></td>
        <td class="style1"> 
            <input type="radio" name="emailHostCompany" id="emailHostCompany1" value="0" <cfif NOT VAL(FORM.emailHostCompany)> checked </cfif> > <label for="emailHostCompany1">No</label>
            <input type="radio" name="emailHostCompany" id="emailHostCompany2" value="1" <cfif VAL(FORM.emailHostCompany)> checked </cfif> > <label for="emailHostCompany2">Yes</label> 
        </td>
    </tr>
    <tr>
        <td align="right" class="style1"><b>Format: </b></td>
        <td  class="style1"> 
            <input type="radio" name="printOption" id="printOption1" value="1" <cfif FORM.printOption EQ 1> checked </cfif> > <label for="printOption1">Onscreen (View Only)</label>
            <input type="radio" name="printOption" id="printOption2" value="2" <cfif FORM.printOption EQ 2> checked </cfif> > <label for="printOption2">Print (FlashPaper)</label> 
            <input type="radio" name="printOption" id="printOption3" value="3" <cfif FORM.printOption EQ 3> checked </cfif> > <label for="printOption3">Print (PDF)</label>
		</td>           
    </tr>
    <tr>
        <td colspan=2 align="center"><br />
            <input type="submit" value="Generate Report" class="style1" />
            <br />
		</td>
	</tr>
</table>

</form>

</cfoutput>

<!--- Print --->
<cfif FORM.submitted>
	
    <cfscript>
		// On Screen
		if (FORM.printOption EQ 1) {
			tableTitleClass = 'tableTitleView';
		} else {
			tableTitleClass = 'style2';
		}
	</cfscript>
    
	<cfsavecontent variable="reportContent">
    	
        <cfoutput>
            <div style="border-bottom:1px solid ##999; margin:10px;">&nbsp;</div>
            <div class="style1">&nbsp; &nbsp; <strong>Total Number of Candidates:</strong> #qGetResults.recordCount# <br /><br /> </div>
            <div class="style1">&nbsp; &nbsp; Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</div>
            <div style="border-bottom:1px solid ##999; margin:10px;">&nbsp;</div>
		</cfoutput>
        		
        <cfoutput query="qGetResults" group="hostCompanyName">
                
            <cfsavecontent variable="reportHostCompanyContent">
                <table width="99%" cellpadding="4" cellspacing=0 align="center">
                    <tr>
                        <td colspan="6"><strong>#qGetResults.hostCompanyName# (###qGetResults.hostCompanyID#)</strong></td>
                    </tr>
                    <cfif ListFind("2,3", FORM.printOption)>
                        <tr>
                            <td colspan="6"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
                        </tr>
                    </cfif>
                    <tr>
                        <th width="25%" align="left" class="#tableTitleClass#">Candidate</Th>
                        <th width="10%" align="left" class="#tableTitleClass#">Gender</th>
                        <th width="18%" align="left" class="#tableTitleClass#">Country</th>
                        <th width="18%" align="left" class="#tableTitleClass#">Job Title</th>
                        <th width="11%" align="left" class="#tableTitleClass#">Start Date</th>
                        <th width="11%" align="left" class="#tableTitleClass#">End Date</th>
                        <th width="25%" align="left" class="#tableTitleClass#">Email</th>		
                    </tr>
                    <cfif ListFind("2,3", FORM.printOption)>
                        <tr>
                            <td colspan="6"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
                        </tr>
                    </cfif>
                    
                    <cfscript>
                        vRowCount = 0;
                    </cfscript>
                    
                    <cfoutput>
                        <cfscript>
                            vRowCount = vRowCount + 1;
                        </cfscript>
                        <tr <cfif vRowCount MOD 2>bgcolor="##E4E4E4"</cfif>>                    
                            <td class="style1">
                                <a href="?curdoc=candidate/candidate_info&uniqueid=#qGetResults.uniqueID#" target="_blank" class="style4">
                                    #qGetResults.firstname# #qGetResults.lastname# (###qGetResults.candidateID#)
                                </a>
                            </td>
                            <td class="style1">#qGetResults.sex#</td>
                            <td class="style1">#qGetResults.countryName#</td>
                            <td class="style1">#qGetResults.jobTitle#</td>
                            <td class="style1">#DateFormat(qGetResults.startdate, 'mm/dd/yyyy')#</td>
                            <td class="style1">#DateFormat(qGetResults.enddate, 'mm/dd/yyyy')#</td>
                            <td class="style1">#qGetResults.email#</td>
                        </tr>
                    </cfoutput>        
                </table>
                
            </cfsavecontent>
			
            <!--- Display Report Content --->
            <p>#reportHostCompanyContent#</p>
            
            <cfif VAL(FORM.emailHostCompany) AND IsValid("email", qGetResults.hostCompanyEmail)>
                <p style="margin-left:15px; font-weight:bold; color:##006">*** Email sent to #qGetResults.hostCompanyEmail# on #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm tt')# ***</p>
            <cfelseif VAL(FORM.emailHostCompany)>
                <p style="margin-left:15px; font-weight:bold; color:##F00">*** Email address missing or not valid ***</p>
			</cfif>
            
            <cfsavecontent variable="emailTemplate">
                <p>Dear #qGetResults.hostCompanySupervisor#,</p>
                
                <p>
                    We are writing you from CSB International, Inc., designated by the U.S. Department of State as a sponsor for the Summer Work Travel Program. 
                    Please accept this email as a formal inquire in regards to the job offer provided by <strong>#qGetResults.hostCompanyName#</strong> for the below participant(s), 
                    who has/have applied for our program, under the self-placement option. The job vetting process is crucial for the safety of our program participants 
                    and to ensure that they have a positive exchange experience in the U.S.
                </p>
                
                <!--- Display Report Content --->
                #reportHostCompanyContent#
                
                <p>
                    Please review the below and <font color="##FF0000">reply with complete answers</font> within <font color="##FF0000">5 (five) business days</font> of receiving this note.
                    <ol>
                        <li>Please confirm whether the job offer was <strong>signed personally</strong> by <strong>#qGetResults.personJobOfferName#</strong>.</li>
                        <li>Please confirm the <strong>employment availability</strong> for the above participant(s) and the <strong>start and end date</strong>.</li>
                        <li>Please confirm the <strong>job title</strong>.</li>
                        <li>Please confirm the <strong>number of hours of work per week you can provide</strong> for the above participant(s).</li>
                        <li>
                            Please confirm that<strong> you have read and will observe the employer's responsibilities</strong> (page ##2 of the job offer form), 
                            as set by the U.S. Department of State as a core program rule.
                        </li>
                    </ol>
                </p>
                
                <p>
                	Thank you for your support for the exchange programs and we are here to assist you with any further question you may have. 
                </p>
                
                <p>
                	<span style="color:##FF0000; text-decoration:underline; font-weight:bold;">Important note:</span>
                    If the job offer is cancelled or revoked due to any circumstances/ conditions, please notify CSB and the participant immediately.
                </p>
                
                <p>
                	Thank you.                
                </p>
            </cfsavecontent>
            
            <cfscript>
                // Email Host Company
                if ( VAL(FORM.emailHostCompany) AND IsValid("email", qGetResults.hostCompanyEmail) ) {
                    
                    // Send out Self Placement Confirmation Email
                    APPLICATION.CFC.EMAIL.sendEmail(
                        emailFrom="#APPLICATION.EMAIL.contactUs# (#CLIENT.firstName# #CLIENT.lastName# CSB-USA)",
                        emailTo=qGetResults.hostCompanyEmail, // 'marcus@iseusa.com' | qGetResults.hostCompanyEmail
						emailReplyTo=CLIENT.email,
                        emailSubject='SWT/CSB - Summer Job Confirmation',
						emailMessage=emailTemplate,
                        companyID=CLIENT.companyID,
                        footerType='emailRegular'
                    );	

				}
            </cfscript>
                                   
        </cfoutput>
		
        <cfoutput>
        
			<cfif ListFind("2,3", FORM.printOption)> 
                <div class="style1"><strong>&nbsp; &nbsp; Program:</strong> #qGetProgramInfo.programName#</div>	
                <div class="style1"><strong>&nbsp; &nbsp; Intl. Rep.:</strong> 
                    <cfif FORM.hostCompanyID EQ "All"> 
                        All International Rep. 
                    <cfelse>
                        #qGetResults.hostCompanyName#
                    </cfif>
                </div>
            </cfif>
        
        </cfoutput>
        
    </cfsavecontent>

	<cfoutput>

		<!-----Display Reports---->
        <cfswitch expression="#FORM.printOption#">
        
            <!--- Screen --->
            <cfcase value="1">
                <!--- Include Report --->
                #reportContent#
            </cfcase>
        
            <!--- Flash Paper --->
            <cfcase value="2">
                <cfdocument format="flashpaper" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">
                    <style type="text/css">
                    <!--
                    .style1 {
                        font-family: Verdana, Arial, Helvetica, sans-serif;
                        font-size: 10px;
                        padding:2;
                    }
                    .style2 {
                        font-family: Verdana, Arial, Helvetica, sans-serif;
                        font-size: 10px;
                        padding:2;
                    }
                    .title1 {
                        font-family: Verdana, Arial, Helvetica, sans-serif;
                        font-size: 15px;
                        font-weight: bold;
                        padding:5;
                    }					
                    -->
                    </style>
                   
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    <div class="title1">All active candidates enrolled in the program by Intl. Rep. and Program</div>
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    
                    <!--- Include Report --->
                    #reportContent#
                </cfdocument>
            </cfcase>
            
            <!--- PDF --->
            <cfcase value="3">   
                <cfdocument format="pdf" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">          	
                    <style type="text/css">
                    <!--
                    .style1 {
                        font-family: Verdana, Arial, Helvetica, sans-serif;
                        font-size: 10px;
                        padding:2;
                    }
                    .style2 {
                        font-family: Verdana, Arial, Helvetica, sans-serif;
                        font-size: 8px;
                        padding:2;
                    }
                    .title1 {
                        font-family: Verdana, Arial, Helvetica, sans-serif;
                        font-size: 15px;
                        font-weight: bold;
                        padding:5;
                    }					
                    -->
                    </style>
        
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    <div class="title1">All active candidates enrolled in the program by Intl. Rep. and Program</div>
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    
                    <!--- Include Report --->
                    #reportContent#
                </cfdocument>
            </cfcase>
        
            <cfdefaultcase>    
                <div align="center" class="style1">
                    <br />
                    Print results will replace the menu options and take a bit longer to generate. <br />
                    Onscreen will allow you to change criteria with out clicking your back button.
                </div>  <br />
            </cfdefaultcase>
            
        </cfswitch>

	</cfoutput>

<cfelse>

    <div align="center" class="style1">
        <br />
        Print results will replace the menu options and take a bit longer to generate. <br />
        Onscreen will allow you to change criteria with out clicking your back button.
    </div>  <br />

</cfif>    