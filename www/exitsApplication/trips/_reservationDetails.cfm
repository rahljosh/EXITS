<!--- ------------------------------------------------------------------------- ----
	
	File:		_reservationDetails.cfm
	Author:		Marcus Melo
	Date:		September 30, 2011
	Desc:		Display details of a already booked trip.
	
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
            st.med,  
            st.paid,
            st.cell_phone,         
            ap.authTransactionID, 
            ap.amount,  
            ap.dateUpdated        
        FROM 
        	student_tours st
		INNER JOIN
        	applicationpayment ap ON ap.foreignID = st.ID
            	AND
                	ap.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="student_tours">
                AND
                	paymentMethodID = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
        WHERE 
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
        AND
        	paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
    </cfquery>
	
    <cfscript>
		// Total of Registered People
		vTotalPeopleRegistered = VAL(qGetSiblingsRegistered.recordCount) + 1;
	</cfscript>
    
</cfsilent>

<cfoutput>

	<!--- Include Trip Header --->
    <cfinclude template="_breadCrumb.cfm">
                
    <!--- Trip Information --->
    <h3 class="tripSectionTitle">You have already reserved a spot for this trip, please see details below:</h3>
    
    <h3 class="tripSectionTitle">Reservation - Invoice ###Year(now())#-#qGetRegistrationDetails.ID#</h3>
    <em class="tripTitleNotes">Print this page for your records</em>
                                                
    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
        <tr class="blueRow">
            <td class="tripFormTitle" width="30%">Trip:</td>
            <td class="tripFormField" width="70%">#APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_name)#</td>
        </tr>
        <tr>
            <td class="tripFormTitle">Total Cost:</td>
            <td class="tripFormField">
                #LSCurrencyFormat(qGetRegistrationDetails.amount)#
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
            <td class="tripFormTitle">Cell Phone:</td>
            <td class="tripFormField">#qGetRegistrationDetails.cell_phone#</td>
        </tr>
        <tr>
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
    
    
    <!--- Payment Information --->
    <h3 class="tripSectionTitle">Payment Information</h3>

    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">  
        <tr class="blueRow">
            <td class="tripFormTitle" width="30%">Date:</td>
            <td class="tripFormField" width="70%">
            	<cfif IsDate(qGetRegistrationDetails.paid)>
                    #DateFormat(qGetRegistrationDetails.paid, 'mm/dd/yyyy')#
            	<cfelse>
					Your Payment has NOT been received, please see below.
                </cfif>
            </td>
        </tr> 
        <cfif NOT IsDate(qGetRegistrationDetails.paid)>   
            <tr>
                <td class="tripFormTitle">&nbsp;</td>
                <td class="tripFormField">
                    Your spot on the trip is pending until you mail a: <br />
                    
                    <ul class="paragraphRules">
                        <li>Business Check</li>
                        <li>Personal Check</li>
                        <li>Money Order</li>
                    </ul>
                    
                    Payable out to <strong>MPD Tour Company</strong>, for the specified cost of your trip found in your confirmation email and sent to: <br /><br />
        
                    #APPLICATION.MPD.name# <br />
                    #APPLICATION.MPD.address# <br />
                    #APPLICATION.MPD.city#, #APPLICATION.MPD.state# #APPLICATION.MPD.zipCode#
            
                    <p>Once the payment of the specified trip has been collected your spot is reserved.</p>
            
                    <p>If payment is not collected within 60 days of the trip your spot is vacated.</p>
                    
                    <p>
                    	To be fully registered for your trip please return the permission forms, emailed to you when you originally signed up, 
                        back to MPD Tours signed by your host family, school, and area representative. 
                    </p>
                        
                    <p>
                    	Once the permission forms are returned signed send an email out to MPD explaining this and you will be contacted to book your flights. 
                        Do <strong>NOT</strong>  book your own flights. 
                    </p>
					
                    <hr width="95%" />

                    <p>
                    	<strong>Refund Policy</strong>
                    </p>

                    <p>
                    	There is a <strong>$100 cancellation fee</strong> and a <strong>$25 refund processing fee</strong> up to 30 days prior to your chosen trip. 
                        After 30 days, there are <strong>NO REFUNDS</strong>. 
                    </p>
                    
                    <hr width="95%" />
                    
                    <p>
                    	Submit permission form with all signatures to MPD Tours.
                        <ul class="paragraphRules">
                            <li><a href="mailto:#APPLICATION.MPD.email#">#APPLICATION.MPD.email#</a></li>
                            <li>fax: #APPLICATION.MPD.fax#</li>
                            <li>mail: #APPLICATION.MPD.address# - #APPLICATION.MPD.city#, #APPLICATION.MPD.state# #APPLICATION.MPD.zipCode#</li>
                        </ul>
                    </p>
                    
                    <hr width="95%" />
                    
                    <p>
                    	<strong>To Book Your Airfare</strong>
                    </p>

                    <p>
                    	To book your airfare, first reserve a spot on your chosen trip. 
                    </p>

                    <p>
                    	Once you have reserved a confirmation email will automatically be sent containing a trip information packet pdf and a permission forms pdf
                    </p>

                    <p>
                    	Please return the signed permission form to MPD tours via scanned and emailed or through the mail. Also pay for the trip via money order or check.
                    </p>

                    <p>
                    	Please email the tour company at <a href="mailto:#APPLICATION.MPD.email#">#APPLICATION.MPD.email#</a> explaining you have returned all of 
                        your material and include your full name, student ID number, and a phone number to best reach you.
                    </p>

                    <p>
                    	A representative from MPD will call you soon after to book your flight information.
                    </p>

                    <p>
                    	Please understand a working credit card is required at the time of the call to pay for your trip.
                    </p>
                </td>
            </tr>
        </cfif>                               
    </table>	

</cfoutput>
