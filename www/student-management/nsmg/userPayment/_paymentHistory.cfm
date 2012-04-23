<!--- ------------------------------------------------------------------------- ----
	
	File:		_paymentHistory.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Intial Page - User Payments
				
				index.cfm?curdoc=userPayment/index&action=searchRepresentative
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param URL variables --->
    <cfparam name="URL.userID" default="0">
    <cfparam name="URL.paymentID" default="0">    

	<!--- Delete Payment - Thea, Craig and Bryan Mc --->
    <cfif VAL(URL.userID) AND VAL(URL.paymentID) AND ( listfind("7657,1960,9719", CLIENT.userID) OR ListFind("1,2", CLIENT.userType) )>	
		
        <cfquery datasource="MySql" result="test">
            DELETE FROM 
            	smg_rep_payments
	        WHERE 
            	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.paymentid#">
			AND
            	agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">                
        	LIMIT 1
        </cfquery>

    	<cfscript>
			// Set Page Message
			SESSION.pageMessages.Add("Payment successfully deleted.");
		</cfscript>
    
    </cfif>
    
    <cfscript>
		// Stores our total
		runningTotal = 0;
		
		// Check if User has access to view these payments
		allowAccess = APPLICATION.CFC.USER.checkUserAccess(currentUserID=CLIENT.userID, currentRegionID=CLIENT.regionID, currentUserType=CLIENT.userType, viewUserID=URL.userID );
		
		if (NOT allowAccess) {
			URL.userID = CLIENT.userID;		
		}
		
		// Get Rep Information
		qGetRepInfo = APPLICATION.CFC.USER.getUserByID(userID=VAL(URL.userID));
	</cfscript>
    
    <cfquery name="qGetPayments" datasource="MySQL">
        SELECT 
            rep.id, 
            rep.agentid, 
            rep.amount,
            rep.comment, 
            rep.date, 
            rep.inputby, 
            rep.companyID, 
            rep.transtype,
            s.firstName, 
            s.familyLastName, 
            s.studentID,
            type.type
        FROM 
            smg_rep_payments rep
        LEFT JOIN 
            smg_students s ON s.studentID = rep.studentID
        LEFT JOIN 
            smg_payment_types type ON type.id = rep.paymenttype
        WHERE 
            rep.agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRepInfo.userID#"> 
        
        <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            AND 
                rep.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            AND 
                rep.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        </cfif>

        ORDER BY         
            studentID DESC,
            rep.date DESC
    </cfquery>

</cfsilent>

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

		<script>
            function areYouSure() { 
               if(confirm("You are about to delete this payment record. You should only delete payments if they were entered by mistake. Click OK to continue")) { 
                 form.submit(); 
                    return true; 
               } else { 
                    return false; 
               } 
            } 
        </script>
    
        <!--- Table Header --->
        <gui:tableHeader
            imageName="user.gif"
            tableTitle="Division: #CLIENT.programManager#"
            tableRightTitle="Payment History for #qGetRepInfo.firstName# #qGetRepInfo.lastname# ###qGetRepInfo.userID#"
            imagePath="../"
        />    
        
        <!--- Page Messages --->
        <gui:displayPageMessages 
            pageMessages="#SESSION.pageMessages.GetCollection()#"
            messageType="tableSection"
            />

        <table width="100%" border="0" cellpadding="4" cellspacing="0" class="section">
            <tr>
                <td><b>Date</b></td>
                <Td><b>ID</b></Td>
                <td><b>Student</b></td>
                <td><b>Type</b></td>
                <td><b>Amount</b></td>
                <td><b>Comments</b></td>
                <td><b>Trans. Type</b></td>
               	<!--- Delete Payment - Thea, Craig and Bryan Mc --->
                <cfif listfind("7657,1960,9719", CLIENT.userID) OR ListFind("1,2", CLIENT.userType)>
                    <td><b>Delete</b></td>
                </cfif>            
            </tr>
            
            <cfloop query="qGetPayments">
                <tr bgcolor="#iif(qGetPayments.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
                    <td>#DateFormat(date, 'mm/dd/yyyy')#</td>
                    <Td>###id#</Td>
                    <td><cfif studentID is ''>n/a<cfelse>#firstName# #familyLastName# (###studentID#)</cfif></td>
                    <Td>#type#</Td>  
                    <td>#LSCurrencyFormat(amount, 'local')#</td>
                    <td>#comment#</td>
                    <td>#transtype#</td>
                    <!--- Delete Payment - Thea, Craig and Bryan Mc --->
                    <cfif listfind("7657,1960,9719", CLIENT.userID) OR ListFind("1,2", CLIENT.userType)>
                        <td align="center">
                            <a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=paymentHistory&paymentID=#id#&userID=#qGetRepInfo.userid#" onClick="return areYouSure(this);">
                                <img src="../pics/deletex.gif" border="0"></img>
                            </a>
                        </td>
                    </cfif>
                </tr>
                <cfset runningTotal = runningTotal + amount>
            </cfloop>
        
            <tr>
                <td colspan=4 align="right"><b>Total to Date:</b></td>
                <td>#LSCurrencyFormat(runningTotal, 'local')#</td>
                <td colspan=2></td>
            </tr>
        
            <cfif NOT VAL(qGetPayments.recordcount)>
                <tr><td colspan="8" align="center">There are no records for this user.</td></tr>
            </cfif>
            
        </table>
        
        <table border="0" cellpadding="4" cellspacing="0" width=100% class="section" style="padding-top:5px;">
            <tr><td align="center" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
        </table>
        
        <!--- Table Footer --->
        <gui:tableFooter 
			imagePath="../"
        />

	<!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />

</cfoutput>
