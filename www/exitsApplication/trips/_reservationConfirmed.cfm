<!--- ------------------------------------------------------------------------- ----
	
	File:		_reservationConfirmed.cfm
	Author:		Marcus Melo
	Date:		September 30, 2011
	Desc:		Confirmation
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
    <cfquery name="qGetRegistrationDetails" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	st.ID,
            st.stunationality,
            st.email,
            st.nationality,
            st.person1,
            st.person2,
            st.person3,
            st.med            
        FROM 
        	student_tours st
        WHERE 
     		active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND
            st.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#"> 
        AND
        	st.tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetTourDetails.tour_id)#">
    </cfquery>
	
    <cfquery name="qGetSiblingsRegistered" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	sts.ID,
            sts.masterTripID,
            sts.fk_studentID,
            sts.siblingID,
            sts.tripID,
            sts.paid,
            shc.name,
            shc.lastName,
            shc.birthDate
        FROM 
        	student_tours_siblings sts
        INNER JOIN	
			smg_host_children shc ON shc.childID = sts.siblingID
        WHERE 
     		sts.fk_studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#"> 
        AND
        	sts.tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetTourDetails.tour_id)#">
        AND
        	sts.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
    </cfquery>
	
    <cfscript>
		// Total of Registered People
		vTotalPeopleRegistered = VAL(qGetSiblingsRegistered.recordCount) + 1;	
    
		// Set Total Price	
		vTotalDue = qGetTourDetails.tour_price * vTotalPeopleRegistered;

		// Clear Session Variables | Keep student logged in
		APPLICATION.CFC.SESSION.setTripSessionVariables(
			tourID = 0,												
			applicationPaymentID = 0
		);
	</cfscript>
    
    <!--- Email Student the Permission Form and Student Packet --->
    <cfinclude template="_reservationEmail.cfm">
    
</cfsilent>
    
<cfoutput>

	<!--- Include Trip Header --->
    <cfinclude template="_breadCrumb.cfm">
        
    <!--- Trip Information --->
    <h3 class="tripSectionTitle">A Spot has been reserved for you - Invoice ###Year(now())#-#qGetRegistrationDetails.ID#</h3>
    <em class="tripTitleNotes">Print this page for your records</em>
                                                
    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
        <tr class="blueRow">
            <td class="tripFormTitle" width="30%">Trip:</td>
            <td class="tripFormField" width="70%">#APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_name)#</td>
        </tr>
        <tr>
            <td class="tripFormTitle">Total Cost:</td>
            <td class="tripFormField">
                #LSCurrencyFormat(vTotalDue)#
                <em class="tripNotesRight">#LSCurrencyFormat(qGetTourDetails.tour_price)# Per person - Does not include your round trip airline ticket</em>
            </td>
        </tr>
        <tr class="blueRow">
            <td class="tripFormTitle">Number of Registrations:</td>
            <td class="tripFormField">
                #vTotalPeopleRegistered#
                <cfif VAL(qGetSiblingsRegistered.recordCount)>
                    <em class="tripNotesRight">You and #qGetSiblingsRegistered.recordCount# host sibling(s)</em>
                </cfif>
            </td>
        </tr>
        <tr>
            <td class="tripFormTitle">Dates:</td>
            <td class="tripFormField">#qGetTourDetails.tour_date# - #qGetTourDetails.tour_length#</td>
        </tr>
    </table>
    
    
    <!--- Student Information --->     
    <h3 class="tripSectionTitle">Student Information</h3>     

    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
        <tr class="blueRow">
            <td class="tripFormTitle" width="30%">Student:</td>
            <td class="tripFormField" width="70%">#qGetStudentInfo.firstName# #qGetStudentInfo.familyLastName# (###qGetStudentInfo.studentID#)</td>
        </tr>
        <tr>
            <td class="tripFormTitle">Country Of Birth:</td>
            <td class="tripFormField">#qGetStudentInfo.countryname#</td>
        </tr> 
        <tr class="blueRow">
            <td class="tripFormTitle">Email Address:</td>
            <td class="tripFormField">#qGetRegistrationDetails.email#</td>
        </tr> 
    </table>
        
        
    <!--- Host Sibling Information ---> 
    <cfif VAL(qGetSiblingsRegistered.recordCount)>
        <h3 class="tripSectionTitle">Host Siblings Going Along</h3>
    
        <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
            <cfloop query="qGetSiblingsRegistered">
                <tr class="#iif(qGetSiblingsRegistered.currentrow MOD 2 ,DE("blueRow") ,DE("") )#">
                    <td class="tripFormTitle" width="30%">Name:</td>
                    <td class="tripFormField" width="70%">#qGetSiblingsRegistered.name# #qGetSiblingsRegistered.lastName# - #DateFormat(qGetSiblingsRegistered.birthDate, 'mm/dd/yyyy')#</td>
                </tr>
            </cfloop>
        </table>
    </cfif>
    
    
    <!--- TERMS AND CONDITIONS --->
    <h3 class="tripSectionTitle">TERMS AND CONDITIONS</h3>

    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
    	<tr>
        	<td>

                <ol class="termsConditions">
                    
                    <li>
                        You will automatically be sent a confirmation of registration containing a trip information packet pdf and a permission form pdf
                    </li>
    
                    <li>
                        Your spot on the trip is then pending until you mail a:
                        <ul class="paragraphRules">
                            <li>Business Check</li>
                            <li>Personal Check</li>
                            <li>Money Order</li>
                        </ul>
                        
                        <p style="padding-left:25px;">
                            Made out to <strong>MPD Tour Company</strong>, for the specified cost of your trip found in your confirmation email and sent to:
                        </p>
    
                        <p style="font-weight:bold; padding-left:25px;">
                            #APPLICATION.MPD.name# <br />
                            #APPLICATION.MPD.address# <br />
                            #APPLICATION.MPD.city#, #APPLICATION.MPD.state# #APPLICATION.MPD.zipCode#
                        </p>
                        
                    </li>
    
                    <li>
                        Once the payment of the specified trip has been collected your spot is reserved.
                    </li>
    
                    <li>
                        If payment is not collected within 60 days of the trip your spot is vacated.
                    </li>
    
                    <li>
                        To be fully registered for your trip please return the permission form, emailed to you when you originally signed up, 
                        back to MPD Tours signed by your host family, school, natural family, and regional manager. 
                    </li>
    
                    <li>
                        Once the permission forms are returned signed then MPD will contact you to book your flights. Do <strong>NOT</strong> book your own flights.
                    </li>

                    <li>
                        Please submit your permission form with all signatures to MPD Tours
                        <ul class="paragraphRules">
                            <li><a href="mailto:#APPLICATION.MPD.email#">#APPLICATION.MPD.email#</a></li>
                            <li>fax: #APPLICATION.MPD.fax#</li>
                            <li>mail: #APPLICATION.MPD.address# - #APPLICATION.MPD.city#, #APPLICATION.MPD.state# #APPLICATION.MPD.zipCode#</li>
                        </ul>
                    </li>
                
                </ol>  
				
                <hr width="80%" />
                
                <div style="padding-left:40px;">
                    
                    <p>Contact us if you have any questions</p>
                    
                    <p>
                        #APPLICATION.MPD.name# <br />
                        #APPLICATION.MPD.address# <br />
                        #APPLICATION.MPD.city#, #APPLICATION.MPD.state# #APPLICATION.MPD.zipCode#
                    </p>
    
                    <p>
                        TOLL FREE: #APPLICATION.MPD.tollFree# <br />
                        TELEPHONE: #APPLICATION.MPD.phone# <br />
                        FAX: #APPLICATION.MPD.fax#
                    </p>
    
                    <p>E-MAIL: <a href="mailto:#APPLICATION.MPD.email#">#APPLICATION.MPD.email#</a></p>
                
                </div>                            

            </td>
		</tr>              
    </table>	

</cfoutput>
