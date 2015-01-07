<!--- ------------------------------------------------------------------------- ----
	
	File:		_myTripDetails.cfm
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
            st.totalCost,
            st.stunationality,
            st.email,
            st.nationality,
            st.person1,
            st.person2,
            st.person3,
            st.med,            
            ap.authTransactionID, 
            ap.amount,  
            ap.nameOnCard,
            ap.creditCardType,
            ap.lastDigits,
            ap.expirationMonth,
            ap.expirationYear ,
            ap.authTransactionID,
            ap.dateUpdated        
        FROM 
        	student_tours st
		INNER JOIN
        	applicationpayment ap ON ap.foreignID = st.ID
            	AND
                	ap.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="student_tours">
                AND
                	authIsSuccess = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
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
    <h3 class="tripSectionTitle">You are already registered for this trip, please see details below:</h3>
    
    <h3 class="tripSectionTitle">Trip Book Confirmation - Invoice ###Year(now())#-#qGetRegistrationDetails.ID#</h3>
    <em class="tripTitleNotes">Print this page for your records</em>
                                                
    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
        <tr class="blueRow">
            <td class="tripFormTitle" width="30%">Trip:</td>
            <td class="tripFormField" width="70%">#APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_name)#</td>
        </tr>
        <tr>
            <td class="tripFormTitle">Dates:</td>
            <td class="tripFormField">#qGetTourDetails.tour_date# - #qGetTourDetails.tour_length#</td>
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
            <td class="tripFormTitle">Total Cost:</td>
            <td class="tripFormField">
                #LSCurrencyFormat(qGetRegistrationDetails.totalCost)#
                <em class="tripNotesRight">#LSCurrencyFormat(qGetTourDetails.tour_price)# Per person - Does not include your round trip airline ticket</em>
            </td>
        </tr>
        <!--- Deposit Only --->
        <cfif qGetTourDetails.chargeType EQ 'deposit'>
            <tr class="blueRow">
                <td class="tripFormTitle">Deposit:</td>
                <td class="tripFormField">#LSCurrencyFormat(100)#</td>
            </tr>
            <tr>
                <td class="tripFormTitle">Remaining Balance:</td>
                <td class="tripFormField">
                    #LSCurrencyFormat(qGetRegistrationDetails.totalCost - qGetRegistrationDetails.amount)#
                    <em class="tripNotesRight">
                        Remaining balance will be charged to the same credit card 60 days prior to the trip. If credit card used changes please notify MPD Tours America with new information
                    </em>
                </td>
            </tr>
        </cfif>
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
    
    
    <!--- Credit Card Information --->
    <h3 class="tripSectionTitle">Credit Card Information</h3>

    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">  
        <tr class="blueRow">
            <td class="tripFormTitle" width="30%">Date:</td>
            <td class="tripFormField" width="70%">#DateFormat(qGetRegistrationDetails.dateUpdated, 'mm/dd/yyyy')#</td>
        </tr>                                     
        <tr>
            <td class="tripFormTitle" width="30%">Total Charged:</td>
            <td class="tripFormField" width="70%">#LSCurrencyFormat(qGetRegistrationDetails.amount)#</td>
        </tr>
        <tr class="blueRow">
            <td class="tripFormTitle" width="30%">Transaction ID:</td>
            <td class="tripFormField" width="70%">#qGetRegistrationDetails.authTransactionID#</td>
        </tr>                    
        <tr>
            <td class="tripFormTitle">Name on Credit Card:</td>
            <td class="tripFormField">#qGetRegistrationDetails.nameOnCard#</td>
        </tr>
        <tr class="blueRow">
            <td class="tripFormTitle">Credit Card Type:</td>
            <td class="tripFormField">#qGetRegistrationDetails.creditCardType#</td>
        </tr>
        <tr>
            <td class="tripFormTitle">Last 4 Digits:</td>
            <td class="tripFormField">#qGetRegistrationDetails.lastDigits#</td>
        </tr>
        <tr class="blueRow">
            <td class="tripFormTitle">Expiration Date:</td>
            <td class="tripFormField">#qGetRegistrationDetails.expirationMonth#/#qGetRegistrationDetails.expirationYear#</td>
        </tr>
    </table>	

</cfoutput>
