<!--- ------------------------------------------------------------------------- ----
	
	File:		_selectPayment.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Process Representative Payment
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param FORM Variables --->
    <cfparam name="FORM.supervising" default="0">
    <cfparam name="FORM.placing" default="0">
    <cfparam name="FORM.student" default="0">
	
    <!----If coming from User Profile, don't check for form vaiables--->
    <Cfif isDefined('url.user')>
        
		<cfset FORM.supervising = url.user>
    
	<cfelse>
    
        <cfif NOT VAL(FORM.placing) AND NOT VAL(FORM.supervising) AND NOT VAL(FORM.student)>
            <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&selected=0&placing=#FORM.placing#&supervising=#FORM.supervising#&student=#FORM.student#" addtoken="no">
        <cfelseif VAL(FORM.placing) AND ( VAL(FORM.supervising) OR VAL(FORM.student) )>
            <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&selected=2&placing=#FORM.placing#&supervising=#FORM.supervising#&student=#FORM.student#" addtoken="no">
        <cfelseif VAL(FORM.supervising) AND ( VAL(FORM.placing) OR VAL(FORM.student) )> 
            <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&selected=2&placing=#FORM.placing#&supervising=#FORM.supervising#&student=#FORM.student#" addtoken="no">
        <cfelseif VAL(FORM.student) AND ( VAL(FORM.placing) OR VAL(FORM.supervising) )>
            <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&selected=2&placing=#FORM.placing#&supervising=#FORM.supervising#&student=#FORM.student#" addtoken="no">
        </cfif>
        
        <!--- If student is selected it's redirected to another page --->
        <cfif VAL(FORM.student) AND FORM.placing is 0 AND FORM.supervising is 0>
            <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processPayment&studentid=#FORM.student#" addtoken="no">
        </cfif>	
        
    </cfif>
    
    <cfquery name="qGetSupervisingPaymentType" datasource="MySql">
        SELECT 
        	id, 
            type
        FROM 
        	smg_payment_types
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
        AND
        	( 
        		paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="Supervision">
            OR
            	paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
            )
    </cfquery>
    
    <cfquery name="qGetPlacingPaymentType" datasource="MySql">
        SELECT 
        	id, 
            type
        FROM 
        	smg_payment_types
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
        AND
        	( 
        		paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="Placement">
            OR
            	paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
            )
    </cfquery>

    <!----Regardless of where rep selected, pull all students supervised by that rep---->
    <cfquery name="qGetSupervisedStudents" datasource="MySQL">
        SELECT 
        	s.studentid, 
            s.familylastname, 
            s.firstname, 
            s.programid, 
            p.programname
        FROM
        	smg_students s
        LEFT JOIN 
        	smg_programs p ON p.programid = s.programid
        WHERE 
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        AND
        	p.startDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('yyyy', -1, now())#">
            
		<cfif VAL(FORM.placing)>
            AND	
            	s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.placing#">
        <cfelseif VAL(FORM.supervising)>
            AND	
            	s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.supervising#">
        </cfif> 
        
        ORDER BY
        	s.studentID DESC
    </cfquery>
    
	<!----Regardless of where rep selected, pull all students placed by that rep---->
    <cfquery name="qGetPlacedStudents" datasource="mysql">
        SELECT 
        	s.studentid, 
            s.familylastname, 
            s.firstname, 
            s.programid, 
            p.programname
        FROM
        	smg_students s
        LEFT JOIN 
        	smg_programs p ON p.programid = s.programid
        WHERE 
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        AND
        	p.startDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('yyyy', -1, now())#">
            
		<cfif VAL(FORM.placing)>
            AND	
            	s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.placing#">
        <cfelseif VAL(FORM.supervising)>
            AND	
            	s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.supervising#">
        </cfif> 
        
        ORDER BY 
        	s.studentID DESC
    </cfquery>
    
    <Cfquery name="qGetRepInfo" datasource="MySQL">
        SELECT 
        	userid,
        	firstname, 
            lastname
        FROM 
        	smg_users
        WHERE 
        <cfif VAL(FORM.placing)>
			userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.placing#">
        <cfelseif VAL(FORM.supervising)>
            userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.supervising#">
        </cfif>
    </Cfquery>
    
</cfsilent>

<cfoutput>

	<div class="application_section_header">Supervising & Placement Payments</div>

    <h2 style="margin-top:10px;">
        Representative: #qGetRepInfo.firstname# #qGetRepInfo.lastname# (#qGetRepInfo.userid#) &nbsp; <span class="get_attention"><b>::</b></span>
        <a href="javascript:openPopUp('userPayment/index.cfm?action=paymentHistory&userid=#qGetRepInfo.userid#', 700, 500);" class="nav_bar">Payment History</a>
    </h2>
    
    <cfform method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processPayment">
        <input type="hidden" name="user" value="#qGetRepInfo.userid#">
		
        <div style="margin-top:10px;">Check each student you want to apply payments for.</div>        
		
        <!--- SUPERVISED STUDENTS --->
        <table width="90%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;"> 
            <tr>
                <td colspan="5" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Supervised Students &nbsp; - &nbsp; Total of #qGetSupervisedStudents.recordcount# student(s)</td>
            </tr>
            <tr>
                <td colspan="5" style="font-weight:bold;">
                    Please, select type of payment for the supervised students: 
                    <cfselect name="payment_type_super" query="qGetSupervisingPaymentType" value="id" display="type" queryPosition="below">
                        <option value="">-- Select a Type --</option>
                    </cfselect>
                </td>
            </tr>
            <tr style="background-color:##E2EFC7; font-weight:bold;">
                <td width="4%">&nbsp;</td>
                <td width="10%">ID</td>
                <td width="25%">Last Name, First Name</td>
                <td width="25%">Program</td>
                <td width="36%">Actions</td>
            </tr>
            <cfloop query="qGetSupervisedStudents">
                <tr bgcolor="###iif(qGetSupervisedStudents.currentrow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                    <td align="center"><input type="checkbox" name="supervisedStudentIDList" id="superCheckBox#qGetSupervisedStudents.studentid#" value="#qGetSupervisedStudents.studentid#"></td>
                    <td>
                    	<label for="superCheckBox#qGetSupervisedStudents.studentid#">
                        	#qGetSupervisedStudents.studentid#
                        </label>
                    </td>
                    <td>
                    	<label for="superCheckBox#qGetSupervisedStudents.studentid#">
                        	#qGetSupervisedStudents.familylastname#, #qGetSupervisedStudents.firstname#
                        </label>
                    </td>
                    <td>#qGetSupervisedStudents.programname#</td>
                    <td><a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#qGetSupervisedStudents.studentid#', 700, 500);" class="nav_bar">[ Payment History ]</a></td>  
                </tr>
            </cfloop>
            <tr style="background-color:##E2EFC7;">
            	<td colspan="5" align="right"> <input name="submit" type="image" src="pics/next.gif" align="right" border="0" alt="search"></td>
            </Tr>
		</table>
        
        <!--- PLACED STUDENTS --->
        <table width="90%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
            <tr>
                <td colspan="5" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Placed Students &nbsp; - &nbsp; Total of #qGetPlacedStudents.recordcount# student(s)</td>
            </tr>
            <tr>
                <td colspan="5" style="font-weight:bold;">
                    Please, select type of payment for the placed students: 
                    <cfselect name="payment_type_place" query="qGetPlacingPaymentType" value="id" display="type" queryPosition="below">
                        <option value="">-- Select a Type --</option>
                    </cfselect>
                </td>
            </tr>
            <tr style="background-color:##E2EFC7; font-weight:bold;">
                <td width="4%">&nbsp;</td>
                <td width="10%">ID</td>
                <td width="25%">Last Name, First Name</td>
                <td width="25%">Program</td>
                <td width="36%">Actions</td>
            </tr>
            <cfloop query="qGetPlacedStudents">
                <tr bgcolor="###iif(qGetPlacedStudents.currentrow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                    <td align="center"><input type="checkbox" name="placedStudentIDList" id="placeCheckBox#qGetPlacedStudents.studentid#" value="#qGetPlacedStudents.studentid#"></td>
                    <td>
                    	<label for="placeCheckBox#qGetPlacedStudents.studentid#">
                        	#qGetPlacedStudents.studentid#
                        </label>
					</td>
                    <td>
                    	<label for="placeCheckBox#qGetPlacedStudents.studentid#">
                        	#qGetPlacedStudents.familylastname#, #qGetPlacedStudents.firstname#
						</label>
					</td>
                    <td>#qGetPlacedStudents.programname#</td> 
                    <td><a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#qGetPlacedStudents.studentid#', 700, 500);" class="nav_bar">[ Payment History ]</a></td>  
                </tr>
            </cfloop>
            <tr style="background-color:##E2EFC7;">
                <td colspan="5" align="right"><input name="submit" type="image" src="pics/next.gif" align="right" border="0" alt="search"></td>
            </Tr>
        </table>
	
    </cfform>
    
</cfoutput>