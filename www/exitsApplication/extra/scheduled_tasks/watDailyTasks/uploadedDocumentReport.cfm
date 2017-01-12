<!--- ------------------------------------------------------------------------- ----
	
	File:		uploadedDocumentReport.cfm
	Author:		Marcus Melo
	Date:		July 21, 2011
	Desc:		Scheduled Task - Email Notification when documents are uploaded 
				in the last 24 hours.
				It should be scheduled to run daily.

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>
		// Get flights updated in the last 24 hours
		qGetUploadedDocs = APPLICATION.CFC.DOCUMENT.getDailyDocumentReport(foreignTable='extra_candidates');	
	</cfscript>

</cfsilent>

<cfif qGetUploadedDocs.recordCount>

    <cfsavecontent variable="documentReport">
   
        <!--- Arrival Information --->
        <fieldset style="margin: 5px 0px 20px 0px; padding: 10px; border: ##DDD 1px solid;">
            
            <legend style="color: ##666; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">UPLOADED DOCUMENTS REPORT</legend>
    
			<cfoutput query="qGetUploadedDocs" group="candidateID">
            <cfif val(qGetUploadedDocs.uploadedBy)>
            	<cfquery name="uploadedBy" datasource="#Application.DSN.Source#">
                select firstname, lastname
                from smg_users
                where userid = #qGetUploadedDocs.uploadedBy#
                </cfquery>
            </cfif>
                
                <div style="color: ##666; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">
                  <a href="http://extra.exitsapplication.com/internal/wat/index.cfm?curdoc=candidate/candidate_info&uniqueid=#qGetUploadedDocs.uniqueid#">#qGetUploadedDocs.firstName# #qGetUploadedDocs.lastName#</a> (###qGetUploadedDocs.candidateID#)  - #qGetUploadedDocs.businessName#<br />Approved: #DateFormat(qGetUploadedDocs.appApproved, 'mm/dd/yyyy')# @ #TimeFormat(qGetUploadedDocs.appApproved, 'hh:mm tt')#
                </div>
                
                <table cellspacing="1" style="width: 100%; border:1px solid ##0069aa; margin-bottom:15px; padding:0px;">	
                    <tr style="color: ##fff; font-weight: bold; text-align:center; background-color: ##0069aa;">
                        <td style="padding:4px 0px 4px 0px;">Uploaded Date</td>
                        <td style="padding:4px 0px 4px 0px;">Type</td>
                        <td style="padding:4px 0px 4px 0px;">File Name</td>
                        <td style="padding:4px 0px 4px 0px;">Size</td>
                        <td style="padding:4px 0px 4px 0px;">Actions</td>
                        <td style="padding:4px 0px 4px 0px;">Uploaded By</td>
                    </tr>                                
                    <cfoutput>
                        <tr style="text-align:center; <cfif qGetUploadedDocs.currentRow MOD 2>background-color: ##EEEEEE;</cfif> ">
                            <td style="padding:4px 0px 4px 0px;">#qGetUploadedDocs.displayDateCreated# #TimeFormat(qGetUploadedDocs.dateCreated, "hh:mm tt")# </td>
                            <td style="padding:4px 0px 4px 0px;">#qGetUploadedDocs.documentType#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetUploadedDocs.fileName#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetUploadedDocs.fileSize#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetUploadedDocs.action#</td>
                            <td style="padding:4px 0px 4px 0px;"><cfif val(qGetUploadedDocs.uploadedBy)> #uploadedBy.firstname# #uploadedBy.lastname# </cfif></td>
                        </tr>                         
                    </cfoutput>    						
                </table>
                
                <br />
                
            </cfoutput>
    
        </fieldset>
        
        <br />
        
        <cfoutput>
            <div style="margin:5px 0px 10px 0px;">
                Uploaded Document Report Sent On #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm:ss tt')# 
            </div>
        </cfoutput>
       
    </cfsavecontent>
	
	<cfscript>
		APPLICATION.CFC.EMAIL.sendEmail(
			emailTo='anca@csb-usa.com,joanna@csb-usa.com',
			emailSubject='EXTRA - WAT - Daily Uploaded Document Report',
			emailMessage=documentReport
		);
        
        WriteOutput(documentReport);
    </cfscript>

<cfelse>

    <div style="margin:5px 0px 10px 0px;">
        No documents were uploaded in the last 24 hours. 
    </div>

</cfif>