<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		User Payments
				
				#CGI.SCRIPT_NAME#?curdoc=userPayment/index
				
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
    <!--- These are used to display search messages --->
    <cfparam name="URL.selected" default="" />
    <cfparam name="URL.search" default="" />
    <cfparam name="URL.searchStu" default="">
    <cfparam name="URL.displaySplitPaymentError" default="0">
    <cfparam name="URL.displayIncentiveTripError" default="0">
	<!--- Search --->
    <cfparam name="URL.placing" default="" />
    <cfparam name="URL.supervising" default="" />
    <cfparam name="URL.student" default="">    
    
</cfsilent>
	
<!--- 
	Check to see which action we are taking. 
--->

<cfif ListFind("1,2,3,4", CLIENT.userType)>

    <cfswitch expression="#action#">
    
        <cfcase value="initial,searchRepresentative,selectPayment,searchStudent,splitPayments,incentiveTripPayment,maintenance,paymentHistory,processPayment,processStudentPayment,studentPaymentHistory,paymentReport" delimiters=",">
    
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
