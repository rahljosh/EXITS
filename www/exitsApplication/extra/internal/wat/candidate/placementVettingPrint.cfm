<!--- ------------------------------------------------------------------------- ----
	
	File:		placementVettingPrint.cfm
	Author:		James Griffiths
	Date:		June 1, 2012
	Desc:		Print page for Candidate Placement Vetting

----- ------------------------------------------------------------------------- --->

<cfparam name="FORM.candCompID" default="0">
<cfparam name="FORM.uniqueID" default="0">
<cfparam name="FORM.saving" default="0">
<cfparam name="URL.saving" default="0">

<cfscript>

	// Set variables from the url
	FORM.candCompID = URL.candCompID;
	FORM.uniqueID = URL.uniqueID;
	FORM.saving = URL.saving;
	
	// Get Candidate Information
	qGetCandidate = APPLICATION.CFC.CANDIDATE.getCandidateByID(uniqueID=URL.uniqueID);
	
	// Get Candidate Place Company -- The placement Status is set to "" in order to get both inactive and active placements
	qCandidatePlaceCompany = APPLICATION.CFC.CANDIDATE.getCandidatePlacementInformation(candidateID=qGetCandidate.candidateID, displayAll="1", candCompID=FORM.candCompID, placementStatus="");

</cfscript>

<cfquery name="qGetIntlRepInfo" datasource="#APPLICATION.DSN.Source#">
    SELECT 
        u.userid, 
        u.businessname, 
        u.extra_insurance_typeid,
        u.extra_accepts_sevis_fee,
        type.type
    FROM 
        smg_users u
    LEFT JOIN 
        smg_insurance_type type ON type.insutypeid = u.extra_insurance_typeid
    WHERE 
        u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidate.intrep#">
</cfquery>

<cfoutput>

	<cfsavecontent variable="view">
		<style type="text/css">
            .right {
                font-size: 14px;
                font-weight: bold;
            }
            .left {
                font-size:14px;
            }
        </style>
    
        <table width="90%" border="1" align="center" cellpadding="6" cellspacing="6">	
            <tr>
                <td valign="top">
                
                    <table width="20%" align="left" cellpadding="2">
                        <tr>
                            <td valign="top">
                            	<!--- When it is being saved it is at a different directory level --->
                            	<cfset directoryUp = "">
                                <cfif NOT VAL(FORM.saving)>
                                	<cfset directoryUp = "../">
                                </cfif>
                                
                                <cfif FileExists(expandPath("#directoryUp#../uploadedfiles/web-candidates/#qGetCandidate.candidateID#.jpg"))>
                                    <img src="#directoryUp#../uploadedfiles/web-candidates/#qGetCandidate.candidateID#.jpg" width="135">
                                <cfelse>
                                    <img src="#directoryUp#../pics/no_stupicture.jpg" width="137" height="137">
                                </cfif>
                            </td>
                        </tr>
                    </table>
    
                    <table width="75%" align="left" cellpadding="2" class="readOnly" style="margin-left:10px;">
                        <tr>
                            <td align="left" colspan="2" class="title1"><strong>#qGetCandidate.firstname# #qGetCandidate.middlename# #qGetCandidate.lastname# (###qGetCandidate.candidateID#)</strong></td>
                        </tr>
                        <tr>
                            <td align="left" colspan="2" class="style1" style="font-size:14px;">
                                <cfif NOT LEN(qGetCandidate.dob)>N/A<cfelse>#dateFormat(qGetCandidate.dob, 'mm/dd/yyyy')# - #datediff('yyyy',qGetCandidate.dob,now())# year old</cfif> 
                                - 
                                <cfif qGetCandidate.sex EQ 'm'>Male<cfelse>Female</cfif>
                            </td>
                        </tr> 
                        <tr>
                            <td colspan="2"><strong>Intl. Rep.:</strong> #qGetIntlRepInfo.businessName#</td>
                        </tr>
                        <tr>
                            <td colspan="2" class="style1"><strong>Date of Entry: </strong> #dateFormat(qGetCandidate.entrydate, 'mm/dd/yyyy')#</td>
                        </tr>
                        <tr>
                            <td colspan="2">Candidate is
                                <cfif qGetCandidate.status EQ 1>
                                    ACTIVE 
                                <cfelseif qGetCandidate.status EQ 0>
                                    INACTIVE 
                                <cfelseif qGetCandidate.status EQ 'canceled'>
                                    CANCELED
                                </cfif> 
                            </td>
                        </tr>													
                    </table>
                    
                </td>
            </tr>													
        </table>
        
        <table class="information" width="90%" border="1" align="center" cellpadding="6" cellspacing="6">
            <tr>
                <td>
                
                    <table width="100%">
                        <tr>
                            <td width="50%" align="right" class="right">Company Name:</td>
                            <td width="50%" align="left" class="left">#qCandidatePlaceCompany.hostCompanyName#</td>
                        </tr>
                        <tr>
                            <td width="50%" align="right" class="right">Address:</td>
                            <td width="50%" align="left" class="left">#qCandidatePlaceCompany.address#<br/>#qCandidatePlaceCompany.city#, #qCandidatePlaceCompany.state# #qCandidatePlaceCompany.zip#</td>
                        </tr>
                        <tr>
                            <td align="right" class="right">Job Title:</td>
                            <td align="left" class="left">#qCandidatePlaceCompany.jobTitle#</td>
                        </tr>
                        <tr>
                            <td align="right" class="right">Placement Date:</td>
                            <td align="left" class="left">#dateFormat(qCandidatePlaceCompany.placement_date, 'mm/dd/yyyy')#</td>
                        </tr>
                        <tr>
                            <td align="right" class="right">Type: </td>
                            <td align="left" class="left"><cfif VAL(qCandidatePlaceCompany.isSecondary)>Secondary<cfelse>Primary</cfif></td>
                        </tr>
                        <tr>
                            <td align="right" class="right">Replacement:</td>
                            <td align="left" class="left">#YesNoFormat(qCandidatePlaceCompany.isTransfer)#</td>
                        </tr>
                        <tr>
                            <td align="right" class="right">Job Offer Status:</td>
                            <td align="left" class="left">#qCandidatePlaceCompany.selfJobOfferStatus#</td>
                        </tr>
                        <tr>
                            <td align="right" class="right">Name:</td>
                            <td align="left" class="left">#qCandidatePlaceCompany.selfConfirmationName#</td>
                        </tr>
                        <tr>
                            <td align="right" class="right">Confirmation of Terms:</td>
                            <td align="left" class="left">#YesNoFormat(qCandidatePlaceCompany.confirmed)#</td>
                        </tr>
                        <tr>
                            <td align="right" class="right">Available J1 Positions:</td>
                            <td align="left" class="left">#qCandidatePlaceCompany.numberPositions#</td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center"><b><u>Authentications</u></b></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table width="70%" align="center" style="border:1px solid black;">
                                    <tr>
                                        <td align="right" class="right" width="50%">Business License:</td>
                                        <td align="left" class="left">
                                        	#YesNoFormat(qCandidatePlaceCompany.authentication_secretaryOfState)#&nbsp;
                                            #DateFormat(qCandidatePlaceCompany.authentication_secretaryOfStateExpiration,'mm/dd/yyyy')#
                                     	</td>
                                    </tr>
                                    <cfif VAL(qCandidatePlaceCompany.authentication_businessLicenseNotAvailable)>
                                        <tr>
                                            <td align="right" class="right">Incorporation:</td>
                                            <td align="left" class="left">
                                            	#YesNoFormat(qCandidatePlaceCompany.authentication_incorporation)#&nbsp;
                                          	</td>
                                        </tr>
                                        <tr>
                                            <td align="right" class="right">Certificate of Existence:</td>
                                            <td align="left" class="left">
                                            	#YesNoFormat(qCandidatePlaceCompany.authentication_certificateOfExistence)#&nbsp;
                                         	</td>
                                        </tr>
                                        <tr>
                                            <td align="right" class="right">Certificate of Reinstatement:</td>
                                            <td align="left" class="left">
                                            	#YesNoFormat(qCandidatePlaceCompany.authentication_certificateOfReinstatement)#&nbsp;
                                         	</td>
                                        </tr>
                                        <tr>
                                            <td align="right" class="right">Department of State:</td>
                                            <td align="left" class="left">
                                            	#YesNoFormat(qCandidatePlaceCompany.authentication_departmentOfState)#&nbsp;
                                       		</td>
                                        </tr>
                                    </cfif>
                                    <tr>
                                        <td align="right" class="right">Department of Labor:</td>
                                        <td align="left" class="left">
                                        	#YesNoFormat(qCandidatePlaceCompany.authentication_departmentOfLabor)#&nbsp;
                                            #DateFormat(qCandidatePlaceCompany.authentication_departmentOfLaborExpiration,'mm/dd/yyyy')#
                                      	</td>
                                    </tr>
                                    <tr>
                                        <td align="right" class="right">Google Earth:</td>
                                        <td align="left" class="left">
                                        	#YesNoFormat(qCandidatePlaceCompany.authentication_googleEarth)#&nbsp;
                                            #DateFormat(qCandidatePlaceCompany.authentication_googleEarthExpiration,'mm/dd/yyyy')#
                                      	</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" class="right">EIN:</td>
                            <td align="left" class="left">#qCandidatePlaceCompany.EIN#</td>
                        </tr>
                        <tr>
                            <td align="right" class="right">Workmen's Compensation:</td>
                            <td align="left" class="left">
                                <cfif qCandidatePlaceCompany.workmensCompensation EQ 0>
                                    No
                                <cfelseif qCandidatePlaceCompany.workmensCompensation EQ 1>
                                    Yes
                                <cfelseif qCandidatePlaceCompany.workmensCompensation EQ 2>
                                    N/A
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" class="right">Carrier Name:</td>
                            <td align="left" class="left">#qCandidatePlaceCompany.WC_carrierName#</td>
                        </tr>
                        <tr>
                            <td align="right" class="right">Carrier Phone:</td>
                            <td align="left" class="left">#qCandidatePlaceCompany.WC_carrierPhone#</td>
                        </tr>
                        <tr>
                            <td align="right" class="right">Policy Number:</td>
                            <td align="left" class="left">#qCandidatePlaceCompany.WC_policyNumber#</td>
                        </tr>
                        <tr>
                            <td align="right" class="right">WC Expiration Date:</td>
                            <td align="left" class="left">
                                <cfif IsDate(qCandidatePlaceCompany.WCDateExpired) AND qCandidatePlaceCompany.WCDateExpired GT NOW()>
                                    #DateFormat(qCandidatePlaceCompany.WCDateExpired, 'mm/dd/yyyy')#
                                <cfelse>
                                    Workmen's compensation is missing.
                                </cfif>
                            </td>
                        </tr>
                        <cfif qCandidatePlaceCompany.isTransfer EQ 0 AND qCandidatePlaceCompany.isSecondary EQ 0>                        
                            <tr>
                                <td align="right" class="right">Email Confirmation:</td>
                                <td align="left" class="left">#DateFormat(qCandidatePlaceCompany.selfEmailConfirmationDate, 'mm/dd/yyyy')#</td>
                            </tr>
                        </cfif>
                        <tr>
                            <td align="right" class="right">Phone Confirmation:</td>
                            <td align="left" class="left">#DateFormat(qCandidatePlaceCompany.confirmation_phone, 'mm/dd/yyyy')#</td>
                        </tr>
                    </table>
                
                </td>
            </tr>
        </table>
    </cfsavecontent>

	<cfif VAL(FORM.saving)>
        <cfoutput>#view#</cfoutput>
    <cfelse>
        <cfdocument format="pdf" orientation="portrait" backgroundvisible="yes" overwrite="no" fontembed="yes">
            #view#
        </cfdocument>
    </cfif>

</cfoutput>