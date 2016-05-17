<!--- ------------------------------------------------------------------------- ----
	
	File:		sendDocumentEmails.cfm
	Author:		James Griffiths
	Date:		March 11, 2014
	Desc:		Send emails with links to documents to candidates after the DS-2019 is added
				- Should be run at least daily (set for every 2 hours)

----- ------------------------------------------------------------------------- --->

<cfquery name="qGetCandidatesMissingGenericDocuments" datasource="#APPLICATION.DSN.Source#">
	SELECT *
    FROM extra_candidates
    INNER JOIN
            extra_hostcompany h ON extra_candidates.hostCompanyID = h.hostCompanyID
    WHERE status = 1
        AND isDeleted = 0
        AND ds2019 IS NOT NULL
        AND ds2019 != ""
        AND (dateGenericDocumentsSent IS NULL OR dateGenericDocumentsSent = "")
        AND programID >= 378
</cfquery>

<cfquery name="qGetCandidatesMissingIDs" datasource="#APPLICATION.DSN.Source#">
	SELECT c.*
    FROM extra_candidates c
    INNER JOIN smg_programs p ON p.programID = c.programID
    	AND p.startDate = <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',5,NOW())#">
    WHERE c.status = 1
    AND c.isDeleted = 0
    AND c.ds2019 IS NOT NULL
    AND ds2019 != ""
    AND (c.dateIDSent IS NULL OR c.dateIDSent = "")
    AND c.programID >= 378
</cfquery>

<cfscript>
	// Get List of Documents - Download Forms = Type 2
	qDocumentList = APPLICATION.CFC.DOCUMENT.getDocumentsByFilter(documentTypeID=43);
	vErrors = "";
</cfscript>

<cfoutput query="qGetCandidatesMissingGenericDocuments">
	<cfsavecontent variable="candidateEmail">
    	<p>Dear #firstName# <cfif LEN(middleName)>#middleName# </cfif>#lastName#</p>
        
        <p>
        	Congratulations! Your Form DS-2019 (Certificate of Eligibility for Exchange Visitor 
            (J-1) Status) was issued and you are now on your way to obtaining a J-1 Visa as a 
            participant in the CSB sponsored Summer Work Travel (SWT) Program. We are glad that 
            you have successfully completed the selection and application process and are now 
            preparing yourself for a challenging and rewarding experience in the United States. 
            Please be in touch with your international representative to find out when the form 
            will arrive in your home country.
        </p>
        
        <p>
        	To ensure that your program will run as smoothly as possible and that your health, 
            safety and welfare are protected, we would like to draw your attention to the 
            <font color="red">CSB participant’s arrival package</font>, which includes the below 
            materials:
            <ul>
            	<li>
                	<a href="#APPLICATION.SITE.URL.main#internal/wat/reports/idcards_per_intl_rep.cfm?uniqueID=#uniqueID#" class="itemLinks" title="Download CSB Participant ID Card">
                		CSB Participant ID card
                    </a> 
                    (this card also contains the CSB Emergency Number and the Department of State Help Line)
				</li>
            	<li>
                	<a href="#APPLICATION.SITE.URL.main#internal/wat/candidate/supportLetter.cfm?uniqueID=#uniqueID#" class="itemLinks" title="Download CSB Letter of Sponsorship">
                		CSB Letter of Sponsorship
                  	</a> 
                    (to be used at the United States Consulate / Social Security Administration)
				</li>
                <cfloop query="qDocumentList">
                	<li>
                    	<a href="#APPLICATION.SITE.URL.main#internal/wat/onlineApplication/publicDocument.cfm?ID=#qDocumentList.id#&Key=#APPLICATION.CFC.DOCUMENT.HashID(qDocumentList.id)#" class="itemLinks" title="Download #qDocumentList.description#">
                        	#qDocumentList.description#
                      	</a>
                  	</li>
                </cfloop>

                <cfquery name="qGetFile" datasource="MySql">
                    SELECT *
                    FROM extra_cities
                    WHERE stateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#state#">
                        AND name = <cfqueryparam cfsqltype="cf_sql_char" value="#city#">
                </cfquery>

                <cfif state NEQ "" AND city NEQ "" AND qGetFile.recordCount GT 0>
                    <li>
                        <a href="#APPLICATION.SITE.URL.main#internal/wat/hostcompany/CityFlyer.cfm?stateID=#state#&city=#city#" class="itemLinks" title="Download the City Flyer">
                            City Flyer
                        </a> 
                    </li>
                </cfif>
            </ul>
        </p>
        
        <p>
        	Being prepared is crucial for your summer experience. Please take a few moments to 
            <font color="red">read all materials and documents</font> you have received, as 
            they provide you with essential information about your rights and responsibilities, 
            as well as program procedures and guidelines to ensure your smooth adjustment to the 
            daily routine in the United States. 
        </p>
        
        <p>
        	You must also <font color="red">attend the orientation meeting</font> scheduled by your 
            International Representative. If you have questions or do not understand any part thereof, 
            please contact your representative for clarification before you leave your home country.
        </p>
        
        <p>
        	CSB will always be there for you! We are proud to have you on our program and will make 
            our best effort to assist you in any way we can and support you throughout your experience. 
            If you will have questions or concerns during your stay in the United States, please feel 
            free to contact us anytime.  
        </p>
        
        <p>
        	Good Luck!<br/>
            The CSB Support Team<br/>
            support@csb-usa.com
        </p>
    </cfsavecontent>
    
    <cftry>
        
		<cfscript>
            APPLICATION.CFC.EMAIL.sendEmail(
                emailFrom="support@csb-usa.com",
                emailTo=email,
                emailSubject="CSB Summer Work Travel – Arrival Package",
                emailMessage=candidateEmail);
        </cfscript>
        
        <cfquery datasource="#APPLICATION.DSN.Source#">
            UPDATE extra_candidates
            SET dateGenericDocumentsSent = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
            WHERE candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#candidateID#">
        </cfquery>
        
        <cfcatch type="any">
        	<cfset vErrors = vErrors & "<b>EXTRA Document sending error - " & candidateID & " - " & CFCATCH.Message & " - " & CFCATCH.Detail & "<br/>">	
        </cfcatch>
        
 	</cftry>

</cfoutput>

<cfoutput query="qGetCandidatesMissingIDs">
	<cfsavecontent variable="candidateEmail">
    	<p>Dear #firstName# <cfif LEN(middleName)>#middleName# </cfif>#lastName#</p>
        
        <p>
			You are on your way to enjoying a cultural exchange opportunity as a participant in the CSB Summer Work Travel (SWT) Program. 
        </p>
        
        <p>
        	If you have not yet done so, please read the <font color="red">CSB participant’s arrival package</font> 
            you have received, as it provides you with essential information about your upcoming program. The arrival 
            package includes the below materials:
            <ul>
            	<li>
                	<a href="#APPLICATION.SITE.URL.main#internal/wat/reports/idcards_per_intl_rep.cfm?uniqueID=#uniqueID#" class="itemLinks" title="Download CSB Participant ID Card">
                		CSB Participant ID card
                    </a> 
                    (this card also contains the CSB Emergency Number and the Department of State Help Line)
				</li>
            	<li>
                	<a href="#APPLICATION.SITE.URL.main#internal/wat/candidate/supportLetter.cfm?uniqueID=#uniqueID#" class="itemLinks" title="Download CSB Letter of Sponsorship">
                		CSB Letter of Sponsorship
                  	</a> 
                    (to be used at the United States Consulate / Social Security Administration)
				</li>
                <cfloop query="qDocumentList">
                	<li>
                    	<a href="#APPLICATION.SITE.URL.main#internal/wat/onlineApplication/publicDocument.cfm?ID=#qDocumentList.id#&Key=#APPLICATION.CFC.DOCUMENT.HashID(qDocumentList.id)#" class="itemLinks" title="Download #qDocumentList.description#">
                        	#qDocumentList.description#
                      	</a>
                  	</li>
                </cfloop>
            </ul>
        </p>
        
        <p>
        	CSB will always be there for you! We are proud to have you on our program and will make our best 
            effort to assist you in any way we can and support you throughout your experience. If you will have 
            questions or concerns during your stay in the United States, please feel free to contact us anytime.   
        </p>
        
        <p>
        	Have a safe and enjoyable trip!<br/>
            The CSB Support Team<br/>
            support@csb-usa.com
        </p>
    </cfsavecontent>
    
    <cftry>
    
		<cfscript>
            APPLICATION.CFC.EMAIL.sendEmail(
                emailFrom="support@csb-usa.com",
                emailTo=email,
                emailSubject="Reminder: CSB Summer Work Travel – Arrival Package",
                emailMessage=candidateEmail);
        </cfscript>
        
        <cfquery datasource="#APPLICATION.DSN.Source#">
            UPDATE extra_candidates
            SET dateIDSent = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
            WHERE candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#candidateID#">
        </cfquery>
    
    	<cfcatch type="any">
        	<cfset vErrors = vErrors & "<b>EXTRA Document sending error - " & candidateID & " - " & CFCATCH.Message & " - " & CFCATCH.Detail & "<br/>">	
        </cfcatch>
        
  	</cftry>
</cfoutput>

<cfif LEN(vErrors)>
	<cfscript>
		APPLICATION.CFC.EMAIL.sendEmail(
			emailFrom="support@csb-usa.com",
			emailTo="jim@iseusa.org",
			emailSubject="Errors - Arrival Package",
			emailMessage=vErrors);
	</cfscript>
</cfif>
