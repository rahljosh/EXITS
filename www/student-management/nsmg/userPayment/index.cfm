<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		User Payments
				
				#CGI.SCRIPT_NAME#?curdoc=userPayment/index

	Update:		08/23/2011 - Adding second visit representative
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
	<!--- Param local variables --->
	<cfparam name="action" default="list">
    <cfparam name="paymentID" default="0" />
    <cfparam name="user" default="0" /> <!--- Get rid of this one later --->
    <cfparam name="userID" default="0" />
    <cfparam name="studentID" default="0" />
    <cfparam name="familyLastName" default="" />

    <!--- Param URL Variables --->
	<cfparam name="URL.orderBy" default="">
    <cfparam name="URL.userID" default="0">
    <cfparam name="URL.lastName" default="">
	
    <!--- Confirmed Variables --->
    
    <!--- Param URL Variables --->
	<cfparam name="URL.errorSection" default="">
    <cfparam name="URL.timeStamp" default="">   
    <cfparam name="URL.orderBy" default="">
    
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.isSplitPayment" default="0">
    <cfparam name="FORM.paymentType" default="0">
    <cfparam name="FORM.amount" default="0">
    <cfparam name="FORM.comments" default="0">
    <!--- Student --->
    <cfparam name="FORM.studentID" default="0">
    <cfparam name="FORM.familyLastName" default="0">
    <!--- Representative --->
    <cfparam name="FORM.userID" default="0">
    <cfparam name="FORM.areaRepID" default="0">
    <cfparam name="FORM.placeRepID" default="0">
    <cfparam name="FORM.secondVisitRepID" default="0">
    <cfparam name="FORM.lastName" default="0">
	<!--- Process Payment --->
    <cfparam name="FORM.supervisedPaymentType" default="0">
    <cfparam name="FORM.supervisedStudentIDList" default="0">
    <cfparam name="FORM.placedPaymentType" default="0">
    <cfparam name="FORM.placedStudentIDList" default="0">
    <cfparam name="FORM.secondVisitPaymentType" default="0">
    <cfparam name="FORM.secondVisitStudentIDList" default="0">
        
    <cfscript>
		// URL.userID comes from user profile
		if ( VAL(URL.userID) ) {
			FORM.userID = URL.userID;		 
		}
	</cfscript>
    
</cfsilent>
	
<!--- 
	Check to see which action we are taking. 
--->

<div class="application_section_header">Representative Payments</div>

<cfif ListFind("1,2,3,4", CLIENT.userType)>

    <cfswitch expression="#action#">
    
        <cfcase value="initial,searchRepresentative,listStudentRepresentatives,selectPayment,searchStudent,incentiveTripPayment,maintenance,paymentHistory,processPayment,studentPaymentHistory,paymentReport" delimiters=",">
    
            <!--- Include template --->
            <cfinclude template="_#action#.cfm" />
    
        </cfcase>
    
    
        <!--- The default case is the login page --->
        <cfdefaultcase>
            
            <!--- Include template --->
            <cfinclude template="_initial.cfm" />
    
        </cfdefaultcase>
    
    </cfswitch>

<cfelse>
	
    <!--- Other Users Only Have Access to the Report --->
    <cfswitch expression="#action#">
    
        <cfcase value="paymentReport" delimiters=",">
    
            <!--- Include template --->
            <cfinclude template="_#action#.cfm" />
    
        </cfcase>
    
    
        <!--- The default case is the login page --->
        <cfdefaultcase>
            
            <!--- Include template --->
            <cfinclude template="_paymentReport.cfm" />
    
        </cfdefaultcase>
    
    </cfswitch>
    
</cfif>
