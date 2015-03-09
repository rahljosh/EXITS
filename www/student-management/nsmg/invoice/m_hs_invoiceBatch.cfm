<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfparam name="FORM.submitted" default="0">
<cfparam name="FORM.send_emails" default="0">
<cfparam name="FORM.seasonID" default="#APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID#">
<cfparam name="FORM.companyID" default="1">
<cfparam name="FORM.chooseCharge" default="">

<cfsilent>

	<cfquery name="qGetSeasons" datasource="#APPLICATION.DSN#">
    	SELECT *
        FROM smg_seasons
        WHERE active = 1
    </cfquery>
    
    <cfquery name="qGetNonISECompanies" datasource="#APPLICATION.DSN#">
    	SELECT *
        FROM smg_companies
        WHERE companyshort_nocolor != "ISE"
    </cfquery>
    
    <cfif VAL(FORM.submitted)>
    
        <cfquery name="qGetLastCharge" datasource="#APPLICATION.DSN#">
            SELECT MAX(invoiceid) AS invoiceid
            FROM smg_charges
        </cfquery>
        
        <cfset previousInvoice = #qGetLastCharge.invoiceid#>

		<cfloop list="#FORM.chooseCharge#" index="chargeType">
        
            <cfquery name="qGetStudents" datasource="#APPLICATION.DSN#">
                SELECT
                    smg_students.*,
                    smg_programs.programName,
                    smg_programs.startDate,
                    smg_programs.endDate,
                    smg_regions.regionName,
                    smg_regions.regional_guarantee,
                    smg_states.stateName,
                    smg_states.guarantee_fee,
                    smg_users.insurance_typeid,
                    smg_users.10_month_price,
                    smg_users.12_month_price,
                    smg_users.5_month_price,
                    smg_users.accepts_sevis_fee,
                    smg_insurance_type.ayp12,
                    smg_insurance_type.ayp10,
                    smg_insurance_type.ayp5,
                    smg_hosthistory.datePlaced,
                    ( 
                    	SELECT COUNT(*)
                    	FROM smg_charges
                        WHERE smg_charges.stuid = smg_students.studentID
						AND smg_charges.programid = smg_programs.programid
                        AND smg_charges.companyID = smg_students.companyID
						AND smg_charges.active = 1
						AND smg_charges.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#chargeType#"> ) AS programCharges
                FROM smg_students
                INNER JOIN smg_programs ON smg_programs.programID = smg_students.programID
                    AND smg_programs.hold != 1
                    AND smg_programs.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
                INNER JOIN smg_hosthistory ON smg_hosthistory.studentID = smg_students.studentID
                    AND smg_hosthistory.isActive = 1
                    <cfif VAL(FORM.placed)>
                        AND smg_hosthistory.datePlaced != ""
                    </cfif>
                LEFT JOIN smg_regions ON smg_regions.regionID = smg_students.regionalguarantee
                LEFT JOIN smg_states ON smg_states.id = smg_students.state_guarantee
                LEFT JOIN smg_users ON smg_users.userID = smg_students.intrep
                LEFT JOIN smg_insurance_type ON smg_insurance_type.insutypeid = smg_users.insurance_typeid
                WHERE smg_students.active = 1
                AND smg_students.intrep != 0
                AND smg_students.app_current_status = 11
                <cfif FORM.companyID EQ 1>
                    AND smg_students.companyID IN (1,2,3,4,5,12)
                <cfelse>
                    AND smg_students.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyID#">
                </cfif>
                AND smg_students.studentID NOT IN (
                    SELECT sc.stuid
                    FROM smg_charges sc
                    INNER JOIN smg_students ss ON ss.studentid = sc.stuid
                    WHERE sc.agentid = ss.intrep
                    AND sc.programid = ss.programid
                    AND sc.companyid = ss.companyid
                    AND sc.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#chargeType#">
                    AND sc.active = 1 )
                ORDER BY studentid
            </cfquery>
            
            <cfloop query="qGetStudents">
            
				<cfif qGetStudents.programCharges EQ 0>
     
					<cfquery name="qCheckDeposit" datasource="#APPLICATION.DSN#">
						SELECT invoiceid, amount_due, type
						FROM smg_charges
						WHERE stuid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.studentid#">
						AND programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.programID#">
                        AND agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.intrep#">
                        AND companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.companyID#">
                        AND type = 'deposit'
                        AND active = 1
                   	</cfquery>
                    
                    <!--- Insurance Amount --->
                    <cfif month(qGetStudents.enddate) EQ 12>
						<cfset amount = #Val(qGetStudents.12_month_price)#>
					<cfelseif  dateDiff('m',qGetStudents.startdate, qGetStudents.enddate) GT 6>
					 	<cfset amount = #Val(qGetStudents.10_month_price)#>
					<cfelse>
						<cfset amount = #Val(qGetStudents.5_month_price)#>
					</cfif>
                    
                    <!--- Insurance Amount Due --->
                    <cfif NOT VAL(qCheckDeposit.recordCount)>
						<cfset amountDue = #variables.amount#>
					<cfelse>
						<cfset amountDue = #variables.amount# - #qCheckDeposit.amount_due#>
					</cfif>
                    
                    <!--- Insurance --->
                    <cfif qGetStudents.insurance_typeid NEQ 1>
						<cfif month(qGetStudents.enddate) EQ 12>
                            <cfset insurance = #qGetStudents.ayp12#>
                        <cfelseif dateDiff('m',qGetStudents.startdate, qGetStudents.enddate) GT 6>
                            <cfset insurance = #qGetStudents.ayp10#>
                        <cfelse>
                            <cfset insurance = #qGetStudents.ayp5#>
                        </cfif>
					</cfif>
                    
                    <!--- Insert Types of charges --->
                    <cfswitch expression="#chargeType#">
                    
                    	<!--- Insert Program Fee --->
                    	<cfcase value="program fee">
                        	<!--- insert charges ONLY IF program fee and insurance cost is not zero (except for the deposit charge, which is entered whenever selected --->
							<cfif (variables.amount NEQ 0 AND qGetStudents.insurance_typeid NEQ 1 AND variables.insurance NEQ 0) OR (variables.amount NEQ 0 AND qGetStudents.insurance_typeid EQ 1)>
				   
                                <cfquery name="insertProgramFee" datasource="#APPLICATION.DSN#">
                                    INSERT INTO smg_charges (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
                                    VALUES (#qGetStudents.intrep#, #qGetStudents.studentid#, 0, #qGetStudents.programid#, '#qGetStudents.programName#', '#chargeType#', #Now()#, #variables.amountDue#, #variables.amount#, #client.userid#, #Now()#, #qGetStudents.companyid#)   
                                </cfquery>
                           
                                <cfif qGetStudents.direct_placement EQ 1>
                                	<cfquery name="insertDiscount" datasource="#APPLICATION.DSN#">
                                		INSERT INTO smg_charges (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
                                		VALUES (#qGetStudents.intrep#, #qGetStudents.studentid#, 0, #qGetStudents.programid#, 'Direct Placement Discount', 'direct placement', #Now()#, -200, -200, #client.userid#, #Now()#, #qGetStudents.companyid#)   
                                	</cfquery>               
                            	</cfif>
					   
								<!--- program fee exceptions --->
                                <cfset thisYear = #year(qGetStudents.startdate)#>
                                <cfset lastYear = #thisYear# -1>
                                <cfset discDeadLine = '#lastYear#-12-31'>
                                <cfset may = '#thisYear#-05-01'>
                                <cfset october = '#thisYear#-10-01'>
					   
							</cfif>
                        </cfcase>
                        
                        <!--- Insert Insurance --->
                    	<cfcase value="insurance">
                        	<!--- insert charges ONLY IF program fee and insurance cost is not zero (except for the deposit charge, which is entered whenever select --->
							<cfif (variables.amount NEQ 0 AND qGetStudents.insurance_typeid NEQ 1 AND variables.insurance NEQ 0) OR (variables.amount NEQ 0 AND qGetStudents.insurance_typeid EQ 1)>
								<cfif qGetStudents.insurance_typeid NEQ 1>
					   				<cfquery name="insertInsurance" datasource="#APPLICATION.DSN#">
                                        INSERT INTO smg_charges (
                                            agentid, 
                                            stuid, 
                                            invoiceid, 
                                            programid, 
                                            description, 
                                            type, 
                                            date, 
                                            amount_due, 
                                            amount, 
                                            userinput, 
                                            invoicedate, 
                                            companyid)
                                        VALUES (
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.intrep#">,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.studentid#">, 
                                            0,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.programid#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetStudents.programName#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#chargeType#">,
                                            <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                                            <cfif LEN(variables.insurance)>
                                                <cfqueryparam cfsqltype="cf_sql_decimal" value="#variables.insurance#">,
                                                <cfqueryparam cfsqltype="cf_sql_decimal" value="#variables.insurance#">,
                                            <cfelse>
                                                <cfqueryparam cfsqltype="cf_sql_decimal" value="0.00">,
                                                <cfqueryparam cfsqltype="cf_sql_decimal" value="0.00">,
                                            </cfif>
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">,
                                            <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.companyid#">)   
                                    </cfquery>
								</cfif>
                         	</cfif>
                        </cfcase>
                        
                        <!--- Insert Sevis --->
                    	<cfcase value="sevis">
                        	<!--- insert charges ONLY IF program fee and insurance cost is not zero (except for the deposit charge, which is entered whenever select --->
							<cfif (variables.amount NEQ 0 AND qGetStudents.insurance_typeid NEQ 1 AND variables.insurance NEQ 0) OR (variables.amount NEQ 0 AND qGetStudents.insurance_typeid EQ 1)>
					   			<!--- US citizens country code is 232 don't pay sevis--->
                                <cfif qGetStudents.accepts_sevis_fee EQ 1 AND (qGetStudents.countrybirth NEQ 232 AND qGetStudents.countryresident NEQ 232 AND qGetStudents.countrycitizen NEQ 232)>
                                    <cfquery name="insertSevis" datasource="#APPLICATION.DSN#">
                                        INSERT INTO smg_charges (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
                                        VALUES (#qGetStudents.intrep#, #qGetStudents.studentid#, 0, #qGetStudents.programid#, '#qGetStudents.programName#', '#chargeType#', #Now()#, 180, 180, #client.userid#, #Now()#, #qGetStudents.companyid#)   
                                    </cfquery>
                                </cfif>
                          	</cfif>
                        </cfcase>
                        
                        <!--- Insert Guarantee --->
                    	<cfcase value="guarantee">
                        	<!--- insert charges ONLY IF program fee and insurance cost is not zero (except for the deposit charge, which is entered whenever select --->
							<cfif (variables.amount NEQ 0 AND qGetStudents.insurance_typeid NEQ 1 AND variables.insurance NEQ 0) OR (variables.amount NEQ 0 AND qGetStudents.insurance_typeid EQ 1)>
				   				<cfif qGetStudents.regionalguarantee GT 0 AND qGetStudents.direct_placement NEQ 1>
									<cfquery name="getHostState" datasource="#APPLICATION.DSN#">
                                        SELECT ss.hostid, IFNULL( sst.state, 0 ) AS statePlaced
                                        FROM smg_students ss
                                        LEFT JOIN smg_hosts sh ON sh.hostid = ss.hostid
                                        LEFT JOIN smg_states sst ON sst.state = sh.state
                                        WHERE ss.studentid = #qGetStudents.studentid#
                                	</cfquery>
                            
                            		<cfoutput query="getHostState">
                            			<cfswitch expression="#getHostState.statePlaced#">
                                       		<cfcase value="ME,VT,NH,MA,RI,CT,NJ,DE,MD,NY,PA,OH,WV,VA,KY,MI,IN,NC">
                                            	<cfset regionPlaced = 'East'>
                                            </cfcase>
                                            <cfcase value="OK,TX,AR,LA,TN,MS,AL,GA,SC,FL">
                                                <cfset regionPlaced = 'South'>
                                            </cfcase>
                                            <cfcase value="MN,WI,IA,NE,KS,MO,IL,ND,SD">
                                                <cfset regionPlaced = 'Central'>
                                            </cfcase>
                                            <cfcase value="WA,OR,NV,UT,AZ,MT,ID,WY,CO,NM,CA">
                                                <cfset regionPlaced = 'West'>
                                            </cfcase>
                                            <cfdefaultcase>
                                                <cfset regionPlaced = 0>
                                            </cfdefaultcase>
                                        </cfswitch>
                                	</cfoutput>
                            
                            		<cfif qGetStudents.regionname EQ variables.regionPlaced OR variables.regionPlaced EQ 0>
                                		<cfquery name="insertRegionalGuarantee" datasource="#APPLICATION.DSN#">
                                			INSERT INTO smg_charges (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
                                			VALUES (#qGetStudents.intrep#, #qGetStudents.studentid#, 0, #qGetStudents.programid#, 'Regional Guarantee: #qGetStudents.regionname#', '#chargeType#', #Now()#, #qGetStudents.regional_guarantee#, #qGetStudents.regional_guarantee#, #client.userid#, #Now()#, #qGetStudents.companyid#)   
                                		</cfquery>
                            		</cfif>
                            
                        		</cfif>
                    
                        		<cfif qGetStudents.state_guarantee GT 0 AND qGetStudents.direct_placement NEQ 1>
                        
                            		<cfquery name="getHostState" datasource="#APPLICATION.DSN#">
                                        SELECT ss.hostid, ss.state_guarantee, sst.id AS statePlaced
                                        FROM smg_students ss
                                        LEFT JOIN smg_hosts sh ON sh.hostid = ss.hostid
                                        LEFT JOIN smg_states sst ON sst.state = sh.state
                                        WHERE ss.studentid = #qGetStudents.studentid#
                                    </cfquery>
                            
                            		<cfif getHostState.hostid EQ 0 OR getHostState.state_guarantee EQ getHostState.statePlaced>
                                		<cfquery name="insertStateGuarantee" datasource="#APPLICATION.DSN#">
                                			INSERT INTO smg_charges (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
                                			VALUES (#qGetStudents.intrep#, #qGetStudents.studentid#, 0, #qGetStudents.programid#, 'State Guarantee: #qGetStudents.statename#', '#chargeType#', #Now()#, #qGetStudents.guarantee_Fee#, #qGetStudents.guarantee_Fee#, #client.userid#, #Now()#, #qGetStudents.companyid#)   
                                		</cfquery>  
                            		</cfif>
                            
                        		</cfif>
	
							</cfif>
                        </cfcase>
                                                
                        <!--- Insert Deposit --->
                    	<cfcase value="deposit">
                        	<cfquery name="checkProgFee" datasource="#APPLICATION.DSN#">
                                SELECT stuid
                                FROM smg_charges
                                WHERE stuid = #qGetStudents.studentid#
                                AND programid = #qGetStudents.programid#
                                AND agentid = #qGetStudents.intrep#
                    			<cfswitch expression="#qGetStudents.companyid#">
                    				<cfcase value="1,2,3,4,5,12">
                        				AND companyid IN (1,2,3,4,5,12)
                        			</cfcase>
                                    <cfdefaultcase>
                                        AND companyid = #qGetStudents.companyid#
                                    </cfdefaultcase>
                                </cfswitch>
                                AND type = 'program fee'
                                AND active = 1
							</cfquery>
				   
							<cfif checkProgFee.recordCount EQ 0>
								<cfquery name="insertDeposit" datasource="#APPLICATION.DSN#">
								INSERT INTO smg_charges (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
								VALUES (#qGetStudents.intrep#, #qGetStudents.studentid#, 0, #qGetStudents.programid#, '#qGetStudents.programName#', '#chargeType#', #Now()#, 500, 500, #client.userid#, #Now()#, #qGetStudents.companyid#)   
								</cfquery>               
							</cfif>
                        </cfcase>
                    
                    </cfswitch>
                     
                </cfif>
                
           	</cfloop>
            
      	</cfloop>
        
    </cfif>

</cfsilent>

<style type="text/css">
    table.frame {
		border-style:solid;
		border-width:thin;
		border-color:#004080;
		border-collapse:collapse;
		background-color:#FFFFE1;
    }
   
    td.right {
		border-right-style:solid;
		border-right-width:thin;
		border-right-color:#004080;
		border-right-collapse:collapse;
		padding:4px;
    }
   
    .box {
		border-style:solid;
		border-width:thin;
		border-color:#004080;
		border-collapse:collapse;
		background-color:#FFFFFF;
    }
   
    tr.darkBlue {
    	background-color:#0052A4;
    }
	
	.style11 {
		font-weight: bold;
		color: #FFFFFF;
	}
</style>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
    <tr valign=middle height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
        <td background="pics/header_background.gif"><h2>HIGH SCHOOL INVOICE BATCH FOR STANDARD FEES</h2></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<form action="" method="post">
	
    <input type="hidden" name="submitted" value="1">
    
    <table width="100%" align="center" class="section">
    	<tr>
        	<td align="right">Select Season:</td>
        	<td>
            	<select name="seasonID">
                	<cfoutput query="qGetSeasons">
                    	<option value="#seasonID#" <cfif seasonID EQ FORM.seasonID>selected="selected"</cfif>>#season#</option>
                	</cfoutput>
            	</select>
        	</td>
    	</tr>
        <tr>
        	<td align="right">Select Company:</td>
        	<td>
            	<select name="companyID">
                	<option value="1" <cfif 1 EQ FORM.companyID>selected="selected"</cfif>>ISE</option>
                	<cfoutput query="qGetNonISECompanies">
                    	<option value="#companyID#" <cfif companyID EQ FORM.companyID>selected="selected"</cfif>>#companyshort#</option>
                	</cfoutput>
            	</select>
        	</td>
    	</tr>
		<tr>
        	<td align="right">Select charge:</td>
        	<td>
            	<select name="chooseCharge" multiple="multiple" size="5">
                    <option>program fee</option>
                    <option>insurance</option>
                    <option>guarantee</option>
                    <option>sevis</option>
                    <option>deposit</option>
           	 	</select>
        	</td>
    	</tr>
    	<tr>
        	<td colspan="2" align="center">
				<input type="checkbox" name="placed" value="1" checked="checked"/> Invoice only Placed students
        	</td>
    	</tr>
        <tr>
        	<td colspan="2" align="center"><input type="submit" value="Show Invoices"></td>
        </tr>
	</table>
    
</form>

<cfinclude template="../table_footer.cfm">

<cfif VAL(FORM.submitted)>
	
	<cfif NOT LEN(FORM.chooseCharge)>
        <h1 align="center" style="padding-top:1cm">Please make sure you select at least one charge</h1>
        <cfabort>
    </cfif>

    <cfquery name="qGetAgents" datasource="#APPLICATION.DSN#">
    	SELECT 
        	agentid,
            companyid, 
			CASE 
                WHEN companyid IN (1,2,3,4,5,12) THEN 1
                ELSE companyid
				END AS groupCompId
        FROM smg_charges
        WHERE invoiceid = 0
        AND agentid != 0
        <cfif FORM.companyID EQ 1>
            AND companyID IN (1,2,3,4,5,12)
        <cfelse>
            AND companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyID#">
        </cfif>
        GROUP BY agentid, groupCompId
    </cfquery>
   
    <cfoutput query="qGetAgents">

        <cfquery name="getLastInvId" datasource="#APPLICATION.DSN#">
            SELECT MAX(invoiceid) AS invoiceid
            FROM smg_charges
        </cfquery>
       
        <cfset newInvId = #getLastInvId.invoiceid# + 1>
   
        <cfquery name="insertInvoiceId" datasource="#APPLICATION.DSN#">
        	UPDATE smg_charges
        	SET invoiceid = #variables.newInvId#
        	WHERE agentid = #qGetAgents.agentid#
        	AND invoiceid = 0
			<cfif qGetAgents.groupCompId EQ 1>
				AND (companyid < 5 OR companyid = 12)
        	<cfelse>
				AND companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetAgents.groupCompId#">
			</cfif>
        </cfquery>

    </cfoutput>

	<cfquery name="qGetNewInvoices" datasource="#APPLICATION.DSN#">
        SELECT
        	smg_charges.invoiceID,
            smg_charges.invoice_sent,
            smg_charges.date,
            smg_charges.companyID,
            SUM(smg_charges.amount_due) AS total,
            smg_users.businessname,
            smg_users.userID
      	FROM smg_charges
        INNER JOIN smg_users ON smg_users.userID = smg_charges.agentID
        WHERE smg_charges.invoice_sent = 0
        <cfif FORM.companyID EQ 1>
            AND smg_charges.companyID IN (1,2,3,4,5,12)
        <cfelse>
            AND smg_charges.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyID#">
        </cfif>
        GROUP BY smg_charges.invoiceid
        ORDER BY smg_users.businessname
	</cfquery>

	<br/><br/>
    
    <cfoutput>
    	<table class="frame" align="center">
        	<tr>
            	<td colspan="4" align="center">Displaying #qGetNewInvoices.recordCount# invoices</td>
            </tr>
            <tr class="darkBlue">
                <td><span class="style11">International Agent</span></td>
                <td><span class="style11">Invoice</span></td>
                <td><span class="style11">Total Amount</span></td>
                <td><span class="style11">Company</span></td>
            </tr>
            <cfloop query="qGetNewInvoices">
         		<tr>
       				<td>#qGetNewInvoices.businessname# (###qGetNewInvoices.userid#)</td>
                    <td><a href="invoice/invoice_view.cfm?id=#qGetNewInvoices.invoiceid#" target="_blank">#qGetNewInvoices.invoiceid#</a></td>
                    <td>#qGetNewInvoices.total#</td>
                    <td>
                        <cfswitch expression="#qGetNewInvoices.companyid#">
                            <cfcase value="1">ISE</cfcase>
                            <cfcase value="2">ISE</cfcase>
                            <cfcase value="3">ISE</cfcase>
                            <cfcase value="4">ISE</cfcase>
                            <cfcase value="5">SMG</cfcase>
                            <cfcase value="10">CASE</cfcase>
                            <cfcase value="12">ISE</cfcase>
                        </cfswitch>
                 	</td>
    			</tr>
            </cfloop>
            <tr>
            	<td colspan="4" align="center">
                	<form action="" method="post">
                    	<input type="hidden" name="send_emails" value="1" />
                        <input type="hidden" name="submitted" value="1" />
                        <input type="hidden" name="seasonID" value="#FORM.seasonID#" />
                        <input type="hidden" name="companyID" value="#FORM.companyID#" />
                        <input type="hidden" name="chooseCharge" value="#FORM.chooseCharge#" />
                        <input type="hidden" name="placed" value="#FORM.placed#" />
                        <cfif VAL(FORM.send_emails)>
                        	Invoices Sent
                      	<cfelse>
                        	<input type="submit" value="Send Invoices" />
                        </cfif>
                    </form>
                </td>
            </tr>
        </table>
    </cfoutput>

	<br/><br/>

	<cfquery name="getMissingAmounts" datasource="#APPLICATION.DSN#">
        SELECT 
            ss.intrep, 
            ss.studentid, 
            ss.firstname, 
            ss.familylastname, 
            ss.programid, 
            ss.companyid, 
            sp.programname, 
            sp.startdate, 
            sp.enddate, 
            su.userid, 
            su.businessname, 
            su.insurance_typeid, 
            ROUND( DATEDIFF( sp.enddate, sp.startdate ) /30, 0 ) AS datediffer, 
            EXTRACT(MONTH FROM sp.enddate ) AS endMonth,
            su.10_month_price, 
            su.12_month_price, 
            su.5_month_price, 
            si.ayp12,
            si.ayp10,
            si.ayp5,
            su.accepts_sevis_fee
        FROM smg_students ss
        INNER JOIN smg_programs sp ON ss.programid = sp.programid
        INNER JOIN smg_users su ON ss.intrep = su.userid
        INNER JOIN smg_insurance_type si ON si.insutypeid = su.insurance_typeid
        WHERE ss.active = 1
        AND sp.seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
        AND sp.hold != 1
        <cfif FORM.companyID EQ 1>
            AND ss.companyID IN (1,2,3,4,5,12)
        <cfelse>
            AND ss.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyID#">
        </cfif>
        ORDER BY businessname, endMonth, datediffer
	</cfquery>

	<table class="frame" align="center">
    	<tr class="darkBlue">
        	<td align="center"><span class="style11">Agent</span></td>
            <td colspan="2" align="center"><span class="style11">Problem</span></td>
    	</tr>

		<cfparam name="previous" default="0">

		<cfoutput query="getMissingAmounts">

			<cfif getMissingAmounts.endMonth EQ 12>
    			<cfset program = 12>
    		<cfelseif getMissingAmounts.datediffer GT 6 AND getMissingAmounts.endMonth NEQ 12>
        		<cfset program = 10>
        	<cfelseif getMissingAmounts.datediffer LTE 6>
        		<cfset program = 5>
			</cfif>

			<cfif (getMissingAmounts.intrep + variables.program) NEQ variables.previous>
				<cfif getMissingAmounts.endMonth EQ 12>
        			<cfif getMissingAmounts.12_month_price EQ 0 OR (getMissingAmounts.ayp12 EQ 0 AND getMissingAmounts.insurance_typeid NEQ 1)>           
            			<tr>
                			<td class="right">
                				<a href="..?curdoc=forms/program_discount&userid=#getMissingAmounts.intrep#" target="_blank">#getMissingAmounts.businessname# (###getMissingAmounts.intrep#)</a>
                			</td>
                			<td class="right">
								<cfif getMissingAmounts.12_month_price EQ 0>
                                    Missing 12 month price
                                </cfif>
                            </td>
                            <td class="right">
								<cfif getMissingAmounts.ayp12 EQ 0 AND getMissingAmounts.insurance_typeid NEQ 1>
                                    Missing 12 month insurance
                                </cfif>
                            </td>               
            			</tr>
        			</cfif>
    			</cfif>
   				<cfif getMissingAmounts.datediffer GT 6 AND getMissingAmounts.endMonth NEQ 12>
        			<cfif getMissingAmounts.10_month_price EQ 0 OR (getMissingAmounts.ayp10 EQ 0 AND getMissingAmounts.insurance_typeid NEQ 1)>
            			<tr>
               				<td class="right">
                				<a href="..?curdoc=forms/program_discount&userid=#getMissingAmounts.intrep#" target="_blank">#getMissingAmounts.businessname# (###getMissingAmounts.intrep#)</a>
                			</td>
                			<td class="right">
								<cfif getMissingAmounts.10_month_price EQ 0>
                                    Missing 10 month price
                                </cfif>
                            </td>
                            <td class="right">
								<cfif getMissingAmounts.ayp10 EQ 0 AND getMissingAmounts.insurance_typeid NEQ 1>
                                    Missing 10 month insurance
                                </cfif>
                            </td>           
                        </tr>
        			</cfif>
        		<cfelseif getMissingAmounts.datediffer LTE 6>
           	 		<cfif getMissingAmounts.5_month_price EQ 0 OR (getMissingAmounts.ayp5 EQ 0 AND getMissingAmounts.insurance_typeid NEQ 1)>
                		<tr>
                    		<td class="right">
                				<a href="..?curdoc=forms/program_discount&userid=#getMissingAmounts.intrep#" target="_blank">#getMissingAmounts.businessname# (###getMissingAmounts.intrep#)</a>
                            </td>
                            <td class="right">
								<cfif getMissingAmounts.5_month_price EQ 0>
                                    Missing 5 month price
                                </cfif>
                            </td>
                            <td class="right">
								<cfif getMissingAmounts.ayp5 EQ 0 AND getMissingAmounts.insurance_typeid NEQ 1>
                                    Missing 5 month insurance
                                </cfif>
                            </td>
                        </tr>
            		</cfif>      
    			</cfif>
			</cfif>

    		<cfset previous = #getMissingAmounts.intrep# + #variables.program#>
          
		</cfoutput>

	</table>

	<br/><br/>

	<!--- start emailing intl agents --->
    <cfif VAL(FORM.send_emails)>
    
		<cfif directoryExists("#AppPath.uploadedFiles#invoices_pdf")>
            <cfdirectory directory="#AppPath.uploadedFiles#invoices_pdf" action="delete" recurse="yes">
        </cfif>
        <cfdirectory action="create" directory="#AppPath.uploadedFiles#invoices_pdf" mode="777">
    
    
        <cfquery name="getAgentIds" datasource="#APPLICATION.DSN#">
            SELECT 
                agentid, 
                companyid, 
                CASE 
                    WHEN companyid IN(1,2,3,4,5,12) THEN 1
                    ELSE companyid
                    END AS testCompId
            FROM smg_charges
            WHERE invoice_sent = 0
            <cfif FORM.companyID EQ 1>
                AND companyID IN (1,2,3,4,5,12)
            <cfelse>
                AND companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyID#">
            </cfif>
            GROUP BY agentid, testCompid
        </cfquery>
        
        <cfloop query="getAgentIds">
    
            <cfquery name="getAgentInfo" datasource="#APPLICATION.DSN#">
                SELECT *
                FROM smg_users su
                WHERE su.userid = #getAgentIds.agentId#
            </cfquery>
            
            <cfif getAgentInfo.email IS NOT "" AND getAgentInfo.billing_email IS "">
                <cfquery name="getAgentInfoSecRun" datasource="#APPLICATION.DSN#">
                    UPDATE smg_users su
                    SET su.billing_email = su.email
                    WHERE userid = #getAgentIds.agentId#
                </cfquery>
                <cfquery name="getAgentInfo" datasource="#APPLICATION.DSN#">
                    SELECT *
                    FROM smg_users su
                    WHERE su.userid = #getAgentIds.agentId#
                </cfquery>
            </cfif>
    
            <cfquery name="getNewInvPerAgent" datasource="#APPLICATION.DSN#">
                SELECT DISTINCT(sc.invoiceid) AS invoiceId, sc.agentID, sc.companyID
                FROM smg_charges sc
                LEFT JOIN smg_programs sp ON sp.programid = sc.programid
                WHERE sc.invoice_sent = 0
                AND sc.agentid = #getAgentIds.agentId#
                <cfif FORM.companyID EQ 1>
                    AND sc.companyID IN (1,2,3,4,5,12)
                <cfelse>
                    AND sc.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyID#">
                </cfif>
            </cfquery>
               
            <cfswitch expression="#getAgentIds.testCompId#">
    
                <!--- CSB --->
                <cfcase value="7,8,9">
                    <cfset compName = "csb">
                    <cfset emailFrom = 'jennifer@iseusa.org'>
                </cfcase>
        
                <!--- Case --->
                <cfcase value="10">
                    <cfset compName = "case">
                    <cfset emailFrom = 'jennifer@case-usa.org'>
                </cfcase>
                
                <!--- SMG Canada --->
                <cfcase value="13">
                    <cfset compName = "smg">
                    <cfset emailFrom = 'jennifer@student-management.com'>
                </cfcase>
                
                <!--- ISE --->        
                <cfdefaultcase>
                    <cfset compName = "ise">
                    <cfset emailFrom = 'jennifer@iseusa.org'>
                </cfdefaultcase>
            
            </cfswitch>
    
            <!--- Remove "s" from https image links --->	
            <cfset linkSSL = ''>
                
            <cfloop query="getNewInvPerAgent">
            
                <cfset url.id = #getNewInvPerAgent.invoiceId#>
                
                <cfdocument format="PDF" filename="#AppPath.uploadedFiles#invoices_pdf/#variables.compName#_#getNewInvPerAgent.invoiceId#.pdf" overwrite="yes">
        
                    <cfinclude template="invoice_view.cfm">
                
                </cfdocument>
                
            </cfloop>
                
            <cfif APPLICATION.isServerLocal>
                <!--- Dev Server --->
                <cfset emailTo = 'jim@iseusa.org'>
            <cfelse>
                <!--- Production Server  --->
                <cfset emailTo = #getAgentInfo.billing_email#>
            </cfif> 	
                        
            <cfmail from="#variables.emailFrom#" to="#variables.emailTo#" bcc="#variables.emailFrom#" subject="#getAgentInfo.businessname#: #variables.compName# invoices - please find attached." type="html">
                
                <small>
                Dear Partner
                
                Please find attached your invoices.
                
                <font color="##FF0000"><strong>IMPORTANT</strong></font>: In order to avoid balance differences, please check if everything is being correctly charged. If you find something wrong please let me know as soon as possible so that I can adjust your account accordingly.
                <font color="##FF0000"><strong>PAYMENT INSTRUCTION</strong></font>: For every payment remitted, please send me an e-mail with the wire receipt for proper payment identification as well as include the invoice number and respective amounts being paid on all payment information so that we can keep both records, your and ours, on the same page.
                Payments by check should be mailed directly to our office address (Do not mail checks directly to our bank).
                Thank you for your cooperation,
                
                Jennifer
                Financial Department
                
                119 Cooper St
                Babylon, NY 11702
                800-766-4656-Toll Free
                631-893-4540-Phone
                631-893-4550-Fax
                
                jennifer@iseusa.org
                
                </small>
                
                <cfloop query="getNewInvPerAgent">
                    <cfmailparam disposition="attachment" type="html" file="#AppPath.uploadedFiles#invoices_pdf/#variables.compName#_#getNewInvPerAgent.invoiceId#.pdf">
                </cfloop>
                
            </cfmail>
        
        </cfloop>
        
        <!--- Mark invoices as sent --->
        <cfquery datasource="#APPLICATION.DSN#">
            UPDATE smg_charges
            SET invoice_sent = 1
            <cfif FORM.companyID EQ 1>
                WHERE companyID IN (1,2,3,4,5,12)
            <cfelse>
                WHERE companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyID#">
            </cfif>
        </cfquery>
        
   	</cfif>
    
</cfif>