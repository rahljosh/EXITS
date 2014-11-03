<!--- ------------------------------------------------------------------------- ----
	
	File:		_searchRepresentative.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Searches for a representative
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
    
    <cfquery name="qGetStudentInfo" datasource="#APPLICATION.DSN#">
        SELECT 	
            s.studentID,
            s.firstName,
            s.familyLastName,
            s.areaRepID,
            s.placeRepID,
            s.secondVisitRepID
        FROM 
            smg_students s 
        WHERE
        	s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.studentID)#">
    </cfquery>
	
    <!--- Area Rep --->
    <cfquery name="qGetAreaReps" datasource="#APPLICATION.DSN#">
        SELECT DISTINCT
        	u.userid, 
            u.firstname, 
            u.lastname
        FROM 
        	smg_users u
        WHERE 
        	u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.areaRepID#">
        
        UNION
        
        SELECT DISTINCT
            u.userID,
            u.firstname, 
            u.lastname
        FROM 
        	smg_users u
        INNER JOIN 
        	smg_hosthistory ht ON u.userid = ht.areaRepID
        WHERE 
        	ht.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#"> 
        AND 
        	ht.areaRepID != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 

        UNION
        
        <!--- Area Rep History | New Table --->
        SELECT DISTINCT 
        	u.userid,
            u.firstName, 
            u.lastname             
        FROM 
        	smg_users u
        INNER JOIN
        	smg_hosthistorytracking sht ON sht.fieldID = u.userID
            	AND
                	sht.fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="areaRepID">
                AND
                	sht.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#"> 
        INNER JOIN 
        	smg_students s ON sht.studentID = s.studentID
            AND	
                s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            AND 
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
            
        GROUP BY 
        	userID
    </cfquery>

	<!--- Place Rep --->
    <cfquery name="qGetPlaceReps" datasource="#APPLICATION.DSN#">
        SELECT DISTINCT
        	u.userid, 
            u.firstname, 
            u.lastname
        FROM 
        	smg_users u
        WHERE 
        	u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.placeRepID#">
        
        UNION
        
        SELECT DISTINCT
            u.userID,
            u.firstname, 
            u.lastname
        FROM 
        	smg_users u
        INNER JOIN 
        	smg_hosthistory ht ON u.userid = ht.placeRepID
        WHERE 
        	ht.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#"> 
        AND 
        	ht.placeRepID != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
        
        UNION
        
        <!--- Place Rep History | New Table --->
        SELECT DISTINCT 
        	u.userid,
            u.firstName, 
            u.lastname             
        FROM 
        	smg_users u
        INNER JOIN
        	smg_hosthistorytracking sht ON sht.fieldID = u.userID
            	AND
                	sht.fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="placeRepID">
                AND
                	sht.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#"> 
        INNER JOIN 
        	smg_students s ON sht.studentID = s.studentID
            AND	
                s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            AND 
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        
        GROUP BY 
        	userID
    </cfquery>

	<!--- Second Visit --->
    <cfquery name="qGetSecondVisitReps" datasource="#APPLICATION.DSN#">
        SELECT DISTINCT
        	u.userid, 
            u.firstname, 
            u.lastname
        FROM 
        	smg_users u
        WHERE 
        	u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.secondVisitRepID#">
        
        UNION
        
        SELECT DISTINCT
            u.userID,
            u.firstname, 
            u.lastname
        FROM 
        	smg_users u
        INNER JOIN 
        	smg_hosthistory ht ON u.userid = ht.secondVisitRepID
        WHERE 
        	ht.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#"> 
        AND 
        	ht.secondVisitRepID != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
        
        UNION
        
        <!--- Second Visit Rep History | New Table --->
        SELECT DISTINCT 
        	u.userid,
            u.firstName, 
            u.lastname             
        FROM 
        	smg_users u
        INNER JOIN
        	smg_hostHistoryTracking sht ON sht.fieldID = u.userID
            	AND
                	sht.fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="secondVisitRepID">
                AND
                	sht.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#"> 
        INNER JOIN 
        	smg_students s ON sht.studentID = s.studentID
            AND	
                s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            AND 
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        
        GROUP BY 
        	userID
    </cfquery>

</cfsilent>

<cfoutput>

    <h2 style="margin-top:10px;">
        Student: #qGetStudentInfo.firstName# #qGetStudentInfo.familyLastName# (###qGetStudentInfo.studentID#) &nbsp; <span class="get_attention"><b>::</b></span>
        <a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentID=#qGetStudentInfo.studentID#', 700, 500);" class="nav_bar">Payment History</a>
    </h2>

    <div style="margin-top:10px;">Select a Supervising or Placing Representative that you want to work with from the list below:</div>        

    <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=selectPayment">
        <input type="hidden" name="studentID" value="#qGetStudentInfo.studentID#" />

        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;"> 
            <tr>
                <td colspan="2" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Supervising Representative</td>
            </tr>    
            
            <cfif VAL(qGetStudentInfo.areaRepID)>	
                <tr bgcolor="###iif(qGetStudentInfo.currentrow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                    <td width="45%" align="right" style="font-weight:bold; vertical-align:top;">
                    	Supervising Representative
                    </td>
                    <td>
                        <select name="areaRepID" class="xLargeField">
                        	<cfloop query="qGetAreaReps">
                            	<option value="#qGetAreaReps.userID#">
                                	#qGetAreaReps.lastName#, #qGetAreaReps.firstName# (###qGetAreaReps.userID#)
									<cfif qGetStudentInfo.areaRepID EQ qGetAreaReps.userID>
                                        *
                                    </cfif>
                                </option>
                            </cfloop>
                       	</select>
                        <p>* Current representative</p>
                    </td>
                </tr>
                <tr style="background-color:##E2EFC7;">
                    <td colspan="2" align="center"> <input name="submit" type="image" src="pics/next.gif" border="0" alt="search"></td>
                </tr>
			<cfelse>
                <tr>
                    <td colspan="2" align="center">Sorry, student is not assigned to a supervising representative.</td>
                </tr>
                <tr style="background-color:##E2EFC7;">
                    <td colspan="2" align="center"><img border="0" src="pics/back.gif" onClick="javascript:history.back()"></td>
                </tr>
			</cfif>
        </table>

    </form>

    <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=selectPayment">
        <input type="hidden" name="studentID" value="#qGetStudentInfo.studentID#" />
        
        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;"> 
            <tr>
                <td colspan="2" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Placing Representative</td>
            </tr>    
            
            <cfif VAL(qGetStudentInfo.placeRepID)>	
                <tr bgcolor="###iif(qGetStudentInfo.currentrow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                    <td width="45%" align="right" style="font-weight:bold; vertical-align:top;">
                    	Placing Representative
                    </td>                
                    <td>
                        <select name="placeRepID" class="xLargeField">
                        	<cfloop query="qGetPlaceReps">
                            	<option value="#qGetPlaceReps.userID#">
                                	#qGetPlaceReps.lastName#, #qGetPlaceReps.firstName# (###qGetPlaceReps.userID#)
                                    <cfif qGetStudentInfo.placeRepID EQ qGetPlaceReps.userID>
                                    	*
                                    </cfif>
                                </option>
                            </cfloop>
                       	</select>
                        <p>* Current representative</p>
                    </td>
                </tr>
                <tr style="background-color:##E2EFC7;">
                    <td colspan="2" align="center"> <input name="submit" type="image" src="pics/next.gif" border="0" alt="search"></td>
                </tr>
			<cfelse>
                <tr>
                    <td  colspan="2" align="center">Sorry, student is not assigned to a placing representative.</td>
                </tr>
                <tr style="background-color:##E2EFC7;">
                    <td  colspan="2" align="center"><img border="0" src="pics/back.gif" onClick="javascript:history.back()"></td>
                </tr>
			</cfif>
        </table>

    </form>
    
    <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=selectPayment">
        <input type="hidden" name="studentID" value="#qGetStudentInfo.studentID#" />
        
        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;"> 
            <tr>
                <td colspan="2" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Second Visit Representative</td>
            </tr>    
            
            <cfif VAL(qGetStudentInfo.secondVisitRepID)>	
                <tr bgcolor="###iif(qGetStudentInfo.currentrow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                    <td width="45%" align="right" style="font-weight:bold; vertical-align:top;">
                    	Second Visit Representative
                    </td>                
                    <td>
                        <select name="secondVisitRepID" class="xLargeField">
                        	<cfloop query="qGetSecondVisitReps">
                            	<option value="#qGetSecondVisitReps.userID#">
                                	#qGetSecondVisitReps.lastName#, #qGetSecondVisitReps.firstName# (###qGetSecondVisitReps.userID#)
                                    <cfif qGetStudentInfo.secondVisitRepID EQ qGetSecondVisitReps.userID>
                                    	*
                                    </cfif>
                                </option>
                            </cfloop>
                       	</select>
                        <p>* Current representative</p>
                    </td>
                </tr>
                <tr style="background-color:##E2EFC7;">
                    <td colspan="2" align="center"> <input name="submit" type="image" src="pics/next.gif" border="0" alt="search"></td>
                </tr>
			<cfelse>
                <tr>
                    <td  colspan="2" align="center">Sorry, student is not assigned to a placing representative.</td>
                </tr>
                <tr style="background-color:##E2EFC7;">
                    <td  colspan="2" align="center"><img border="0" src="pics/back.gif" onClick="javascript:history.back()"></td>
                </tr>
			</cfif>
        </table>

    </form>
    
</cfoutput>