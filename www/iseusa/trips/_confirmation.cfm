<!--- ------------------------------------------------------------------------- ----
	
	File:		_confirmation.cfm
	Author:		Marcus Melo
	Date:		September 30, 2011
	Desc:		Confirmation
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>
		// Get Payment Details
    	qGetPaymentDetails = APPLICATION.CFC.PAYMENTGATEWAY.getApplicationPaymentByID(ID=VAL(SESSION.TOUR.applicationPaymentID));
	</cfscript>
    
    <cfquery name="qGetStudentRegistered" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	* 
        FROM 
        	student_tours 
        WHERE 
     		studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#"> 
        AND
        	tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetTourDetails.tour_id)#">
        AND
        	paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
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
		
		// Clear Session Variables | Keep student logged in
		APPLICATION.CFC.SESSION.setTripSessionVariables(
			tourID = 0,												
			applicationPaymentID = 0
		);		
	</cfscript>
    
    <!--- Email Student the Permission Form and Student Packet --->
    <cfinclude template="_sendEmail.cfm">
    
</cfsilent>
    
<style type="text/css">
<!--
	.whtMiddleTrips {		
		margin: 0px;
		height: auto;
		min-height: 800px;
		text-align: justify;
		padding:5px 0px 0px 0px;
		background-repeat: repeat-y;
		background-image: url(../images/whtBoxMiddle.png);
	}
-->
</style>

<cfoutput>

    <div class="whtMiddleTrips">    

        <div class="tripsTours">

			<!--- Include Trip Header --->
            <cfinclude template="_tripHeader.cfm">
            			
            <form action="#CGI.SCRIPT_NAME#?action=preferences" method="post">
                <input type="hidden" name="submitted" value="1" />
				
				<!--- Display Form Errors --->
                <gui:displayFormErrors 
                    formErrors="#SESSION.formErrors.GetCollection()#"
                    messageType="tripSection"
                />
                
                <!--- Trip Information --->
                <h3 class="tripSectionTitle">Trip Book Confirmation - Invoice ###Year(now())#-#qGetStudentRegistered.ID#</h3>
                <em class="tripTitleNotes">Print this page for your records</em>
                                                            
                <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
                    <tr class="blueRow">
                        <td class="tripFormTitle" width="30%">Trip:</td>
                        <td class="tripFormField" width="70%">#APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_name)#</td>
                    </tr>
                    <tr>
                        <td class="tripFormTitle">Total Cost:</td>
                        <td class="tripFormField">
                            #LSCurrencyFormat(qGetPaymentDetails.amount)#
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
                        <td class="tripFormField">#qGetStudentRegistered.email#</td>
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
                        <td class="tripFormTitle" width="30%">Total Charged</td>
                        <td class="tripFormField" width="70%">#LSCurrencyFormat(qGetPaymentDetails.amount)#</td>
                    </tr>
                    <tr>
                        <td class="tripFormTitle">Name on Credit Card</td>
                        <td class="tripFormField">#qGetPaymentDetails.nameOnCard#</td>
                    </tr>
                    <tr class="blueRow">
                        <td class="tripFormTitle">Credit Card Type</td>
                        <td class="tripFormField">#qGetPaymentDetails.creditCardType#</td>
                    </tr>
                    <tr>
                        <td class="tripFormTitle">Last 4 Digits</td>
                        <td class="tripFormField">#qGetPaymentDetails.lastDigits#</td>
                    </tr>
                    <tr class="blueRow">
                        <td class="tripFormTitle">Expiration Date</td>
                        <td class="tripFormField">#qGetPaymentDetails.expirationMonth#/#qGetPaymentDetails.expirationYear#</td>
                    </tr>
                </table>	
                
            </form>

			<!--- Include Trip Footer --->
            <cfinclude template="_tripFooter.cfm">

        </div> <!-- tripsTours -->

    </div><!-- end whtMiddleTrips -->

</cfoutput>
