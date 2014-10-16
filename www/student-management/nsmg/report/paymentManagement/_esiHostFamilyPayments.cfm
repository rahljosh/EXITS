<!--- ------------------------------------------------------------------------- ----
	
	File:		_esiHostFamilyPayments.cfm
	Author:		James Griffiths
	Date:		July 1, 2014
	Desc:		ESI Host Family Payments
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=esiHostFamilyPayments
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />
    
    <cfscript>
		param name="FORM.submitted" default=0;
		param name="FORM.programID" default=0;
		param name="FORM.month" default=9;
	</cfscript>
    
    <cfquery name="qGetProgramList" datasource="#APPLICATION.DSN#">
    	SELECT *
        FROM smg_programs
        WHERE companyID = 14
        ORDER BY startDate
    </cfquery>

    <!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>
    	
        <!--- This will just get the first program in the list - it is used for calculating what period this payment is for --->
        <cfquery name="qGetProgram" datasource="#APPLICATION.DSN#">
        	SELECT programID, startDate, endDate
            FROM smg_programs
            WHERE programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
            ORDER BY programID
            LIMIT 1
        </cfquery>
    
    	<cfscript>
			vStartDate = CreateDate(YEAR(qGetProgram.startDate),FORM['month'],1);
			if (vStartDate LT DateAdd('m',-1,qGetProgram.startDate)) {
				vStartDate = CreateDate(YEAR(qGetProgram.endDate),FORM['month'],1);
			}
			vNextMonth = FORM['month']+1;
			vYear = YEAR(vStartDate);
			if (vNextMonth EQ 13) {
				vNextMonth = 1;	
				vYear = vYear + 1;
			}
			vEndDate = DateAdd('d',-1,CreateDate(vYear,vNextMonth,1));
		</cfscript>

        <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
        	SELECT
            	hh.datePlacedEnded,
                s.studentID,
                p.programName,
                p.startDate AS programStartDate,
                p.endDate AS programEndDate,
                r.regionName,
                r.regional_stipend,
            	CASE
                	WHEN h.w9_for = "father" THEN CONCAT(h.fatherfirstname, " ", h.familylastname, " (##", h.hostID, ")")
                    ELSE CONCAT(h.motherfirstname, " ", h.familylastname, " (##", h.hostID, ")")
              		END AS hostName,
             	s.familylastname,
                s.firstname,
                s.studentID,
                CASE
                	WHEN hh.isRelocation = 0 AND arrival.dep_date IS NOT NULL THEN CASE WHEN arrival.overnight = 1 THEN DATE_ADD(arrival.dep_date,INTERVAL 1 DAY) ELSE arrival.dep_date END
                    WHEN hh.isRelocation = 1 AND hh.dateRelocated IS NOT NULL THEN hh.dateRelocated
                    END AS startDate,
              	CASE
                	WHEN hh.historyID = (SELECT MAX(historyID) FROM smg_hosthistory WHERE studentID = s.studentID) AND departure.dep_date IS NOT NULL THEN departure.dep_date
                    WHEN hh.datePlacedEnded IS NOT NULL THEN hh.datePlacedEnded
                    WHEN s.cancelDate IS NOT NULL THEN s.cancelDate
                    ELSE p.endDate
                    END AS endDate
          	FROM smg_hosts h
          	INNER JOIN smg_hosthistory hh ON hh.hostID = h.hostID
            INNER JOIN smg_students s ON s.studentID = hh.studentID
            	AND s.companyID = 14
            INNER JOIN smg_programs p ON p.programID = s.programID
            	AND p.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
          	LEFT JOIN smg_regions r ON r.regionID = s.regionAssigned
          	LEFT JOIN smg_flight_info arrival ON arrival.studentID = s.studentID
                AND arrival.flight_type = "arrival"
                AND arrival.isDeleted = 0
                AND arrival.dep_date = (SELECT MAX(dep_date) FROM smg_flight_info WHERE studentID = s.studentID AND flight_type = "arrival" AND isDeleted = 0)
          	LEFT JOIN smg_flight_info departure ON departure.studentID = s.studentID
                AND departure.flight_type = "departure"
                AND departure.isDeleted = 0
                AND departure.dep_date = (SELECT MIN(dep_date) FROM smg_flight_info WHERE studentID = s.studentID AND flight_type = "departure" AND isDeleted = 0)
           	WHERE arrival.dep_date IS NOT NULL
            AND (
            	(
                	hh.datePlacedEnded >= 
                    	CASE
                            WHEN hh.isRelocation = 0 AND arrival.dep_date IS NOT NULL THEN CASE WHEN arrival.overnight = 1 THEN DATE_ADD(arrival.dep_date,INTERVAL 1 DAY) ELSE arrival.dep_date END
                            WHEN hh.isRelocation = 1 AND hh.dateRelocated IS NOT NULL THEN hh.dateRelocated
                            END 
                    AND hh.datePlacedEnded >= p.startDate
              	) 
          	OR datePlacedEnded IS NULL
            )
            AND ( 
            	(
                	<cfqueryparam cfsqltype="cf_sql_date" value="#vStartDate#"> <= 
                    	CASE
                            WHEN hh.isRelocation = 0 AND arrival.dep_date IS NOT NULL THEN CASE WHEN arrival.overnight = 1 THEN DATE_ADD(arrival.dep_date,INTERVAL 1 DAY) ELSE arrival.dep_date END
                            WHEN hh.isRelocation = 1 AND hh.dateRelocated IS NOT NULL THEN hh.dateRelocated
                            END 
                    AND <cfqueryparam cfsqltype="cf_sql_date" value="#vEndDate#"> >= 
                    	CASE
                            WHEN hh.isRelocation = 0 AND arrival.dep_date IS NOT NULL THEN CASE WHEN arrival.overnight = 1 THEN DATE_ADD(arrival.dep_date,INTERVAL 1 DAY) ELSE arrival.dep_date END
                            WHEN hh.isRelocation = 1 AND hh.dateRelocated IS NOT NULL THEN hh.dateRelocated
                            END
              	)
           		OR (
            		<cfqueryparam cfsqltype="cf_sql_date" value="#vStartDate#"> >= 
                    	CASE
                            WHEN hh.isRelocation = 0 AND arrival.dep_date IS NOT NULL THEN CASE WHEN arrival.overnight = 1 THEN DATE_ADD(arrival.dep_date,INTERVAL 1 DAY) ELSE arrival.dep_date END
                            WHEN hh.isRelocation = 1 AND hh.dateRelocated IS NOT NULL THEN hh.dateRelocated
                            END 
                    AND <cfqueryparam cfsqltype="cf_sql_date" value="#vEndDate#"> <= 
                    	CASE
                            WHEN hh.historyID = (SELECT MAX(historyID) FROM smg_hosthistory WHERE studentID = s.studentID) AND departure.dep_date IS NOT NULL THEN departure.dep_date
                            WHEN hh.datePlacedEnded IS NOT NULL THEN hh.datePlacedEnded
                            WHEN s.cancelDate IS NOT NULL THEN s.cancelDate
                            ELSE p.endDate
                            END
              	)
            	OR (
                	<cfqueryparam cfsqltype="cf_sql_date" value="#vStartDate#"> <= 
                    	CASE
                            WHEN hh.historyID = (SELECT MAX(historyID) FROM smg_hosthistory WHERE studentID = s.studentID) AND departure.dep_date IS NOT NULL THEN departure.dep_date
                            WHEN hh.datePlacedEnded IS NOT NULL THEN hh.datePlacedEnded
                            WHEN s.cancelDate IS NOT NULL THEN s.cancelDate
                            ELSE p.endDate
                            END 
                    AND <cfqueryparam cfsqltype="cf_sql_date" value="#vEndDate#"> >= 
                    	CASE
                            WHEN hh.historyID = (SELECT MAX(historyID) FROM smg_hosthistory WHERE studentID = s.studentID) AND departure.dep_date IS NOT NULL THEN departure.dep_date
                            WHEN hh.datePlacedEnded IS NOT NULL THEN hh.datePlacedEnded
                            WHEN s.cancelDate IS NOT NULL THEN s.cancelDate
                            ELSE p.endDate
                            END
              	) 
           	)
            GROUP BY hh.historyID
           	ORDER BY s.familyLastName, s.firstName, startDate, h.familyLastName
        </cfquery>

	</cfif>
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

	<cfoutput>

        <form action="report/index.cfm?action=esiHostFamilyPayments" name="esiHostFamilyPayments" id="esiHostFamilyPayments" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">Payment Reports - ESI Host Family Payments</th></tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Program: <span class="required">*</span></td>
                    <td>
                        <select name="programID" id="programID" class="xLargeField" multiple="multiple" size="5" required>
                            <cfloop query="qGetProgramList">
                            	<option value="#qGetProgramList.programID#">#qGetProgramList.programName#</option>
                           	</cfloop>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                	<td class="subTitleRightNoBorder">Month: <span class="required">*</span></td>
                    <td>
                    	<select name="month" id="month" class="xLargeField">
                            <option value="7" <cfif MONTH(NOW())-1 EQ 7>selected="selected"</cfif>>July</option>
                            <option value="8" <cfif MONTH(NOW())-1 EQ 8>selected="selected"</cfif>>August</option>
                            <option value="9" <cfif MONTH(NOW())-1 EQ 9>selected="selected"</cfif>>September</option>
                            <option value="10" <cfif MONTH(NOW())-1 EQ 10>selected="selected"</cfif>>October</option>
                            <option value="11" <cfif MONTH(NOW())-1 EQ 11>selected="selected"</cfif>>November</option>
                            <option value="12" <cfif MONTH(NOW())-1 EQ 0>selected="selected"</cfif>>December</option>
                            <option value="1" <cfif MONTH(NOW())-1 EQ 1>selected="selected"</cfif>>January</option>
                            <option value="2" <cfif MONTH(NOW())-1 EQ 2> selected="selected"</cfif>>February</option>
                            <option value="3" <cfif MONTH(NOW())-1 EQ 3>selected="selected"</cfif>>March</option>
                            <option value="4" <cfif MONTH(NOW())-1 EQ 4>selected="selected"</cfif>>April</option>
                            <option value="5" <cfif MONTH(NOW())-1 EQ 5>selected="selected"</cfif>>May</option>
                            <option value="6" <cfif MONTH(NOW())-1 EQ 6>selected="selected"</cfif>>June</option>
                    	</select>
                    </td>
                </tr>
                <tr class="on">
                    <td>&nbsp;</td>
                    <td class="required noteAlert">* Required Fields</td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Description:</td>
                    <td>
                        This report will provide a list of all the ESI Host Family payments.
                        <br/>
                        -Please note that the payment start and end dates are calculated based on the year of the earliest program chosen.
                    </td>		
                </tr>
                <tr>
                    <th colspan="2"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                </tr>
            </table>
        </form>	

	</cfoutput>
    
<!--- FORM Submitted --->
<cfelse>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	
    
    <!--- FORM Submitted with errors --->
    <cfif SESSION.formErrors.length()> 
       
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="100%"
            />	
            
		<cfabort>            
	</cfif>
        
	<!--- set content type --->
    <cfcontent type="application/msexcel">
    
    <!--- suggest default name for XLS file --->
    <cfheader name="Content-Disposition" value="attachment; filename=ESI Host Family Payments Report.xls">
    
    <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
        <tr><th colspan="20">ESI Host Family Payments Report For <cfoutput>#DateFormat(vStartDate,'mm/dd/yyyy')# to #DateFormat(vEndDate,'mm/dd/yyyy')#</cfoutput></th></tr>
        <tr style="font-weight:bold; text-decoration:underline;">
            <td>Host Name</td>
            <td>Student Last Name</td>
            <td>Student First Name</td>
            <td>Student ID</td>
            <td>Region</td>
            <td>Placement Start</td>
            <td>Placement End</td>
            <td>Payment For</td>
            <td>Amount</td>
            <td>Program</td>
        </tr>
        
        <cfscript>
            vCurrentRow = 0;
        </cfscript>
    
        <cfoutput query="qGetResults">
        
        	<cfquery name="qGetResultsByStudent" dbtype="query">
            	SELECT *
                FROM qGetResults
                WHERE studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.studentID#">
            </cfquery>
        
            <cfscript>
                vCurrentRow++;
            
                vRowColor = '';	
                if ( vCurrentRow MOD 2 ) {
                    vRowColor = 'bgcolor="##E6E6E6"';
                } else {
                    vRowColor = 'bgcolor="##FFFFFF"';
                }
				
				vPaymentStart = vStartDate;
				vPaymentEnd = vEndDate;
				if (startDate GT vPaymentStart) {
					vPaymentStart = startDate;	
				}
				if (endDate LT vPaymentEnd) {
					vPaymentEnd = endDate;	
				}
				
				vNumDaysAtHost = DateDiff('d',vPaymentStart,vPaymentEnd)+1;
				vDaysInMonth = DaysInMonth(vPaymentStart);
				vPayment = DollarFormat((vNumDaysAtHost / vDaysInMonth) * regional_stipend);
            </cfscript>
            
            <tr>
                <td #vRowColor#>#toString(hostName)#</td>
                <td #vRowColor#>#familyLastName#</td>
                <td #vRowColor#>#firstName#</td>
                <td #vRowColor#>#studentID#</td>
                <td #vRowColor#>#toString(regionName)#</td>
                <td #vRowColor#>#DateFormat(startDate,'mm/dd/yyyy')#</td>
                <td #vRowColor#>#DateFormat(endDate,'mm/dd/yyyy')#</td>
                <td #vRowColor#>#DateFormat(vPaymentStart,'mm/dd/yyyy')# - #DateFormat(vPaymentEnd,'mm/dd/yyyy')#</td>
                <td #vRowColor#>#vPayment#</td>
                <td #vRowColor#>#programName#: #DateFormat(programStartDate,'mm/dd/yyyy')# - #DateFormat(programEndDate,'mm/dd/yyyy')#</td>
            </tr>
            
        </cfoutput>
        
    </table>

    <!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>