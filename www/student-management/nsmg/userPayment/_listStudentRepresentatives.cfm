<!--- ------------------------------------------------------------------------- ----
	
	File:		_searchRepresentative.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Searches for a representative
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
    
    <cfquery name="qGetStudentInfo" datasource="MySql">
        SELECT 	
            s.studentID,
            s.firstName,
            s.familyLastName,
            sr.userID AS superUserID,
            sr.firstName AS superFirstName, 
            sr.lastname AS superLastName,
            pl.userID AS placeUserID, 
            pl.firstName AS placeFirstName, 
            pl.lastname AS placeLastName                
        FROM 
            smg_students s 
        LEFT OUTER JOIN
        	smg_users sr ON s.areaRepID = sr.userID
        LEFT OUTER JOIN
        	smg_users pl ON s.areaRepID = pl.userID
        WHERE
        	s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.studentID)#">
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
            
            <cfif VAL(qGetStudentInfo.superUserID)>	
                <tr bgcolor="###iif(qGetStudentInfo.currentrow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                    <td width="45%" align="right" style="font-weight:bold;">
                    	Supervising Representative
                    </td>
                    <td>
                        <select name="areaRepID" class="largeField">
                        	<option value="#qGetStudentInfo.superUserid#">#qGetStudentInfo.superLastName#, #qGetStudentInfo.superFirstName# (###qGetStudentInfo.superUserID#)</option>
                       	</select>
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
            
            <cfif VAL(qGetStudentInfo.superUserID)>	
                <tr bgcolor="###iif(qGetStudentInfo.currentrow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                    <td width="45%" align="right" style="font-weight:bold;">
                    	Placing Representative
                    </td>                
                    <td>
                        <select name="placeRepID" class="largeField">
                        	<option value="#qGetStudentInfo.placeUserid#">#qGetStudentInfo.placeLastName#, #qGetStudentInfo.placeFirstName# (###qGetStudentInfo.placeUserID#)</option>
                       	</select>
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