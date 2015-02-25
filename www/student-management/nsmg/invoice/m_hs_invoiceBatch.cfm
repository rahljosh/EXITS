
<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfsetting requesttimeout="99999999999">

<cfinclude template="../querys/get_seasons.cfm">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>HIGH SCHOOL INVOICE BATCH FOR STANDARD FEES</title>
<style type="text/css">
<!--
    table.frame
    {
    border-style:solid;
    border-width:thin;
    border-color:#004080;
    border-collapse:collapse;
    background-color:#FFFFE1;
    }
   
    td.right
    {
    border-right-style:solid;
    border-right-width:thin;
    border-right-color:#004080;
    border-right-collapse:collapse;
    padding:4px;
    }
   
    .box
    {
    border-style:solid;
    border-width:thin;
    border-color:#004080;
    border-collapse:collapse;
    background-color:#FFFFFF;
    }
   
    tr.darkBlue
    {
    background-color:#0052A4;
    }
.style11 {
    font-weight: bold;
    color: #FFFFFF;
}
-->
</style>
</head>

<body>

<cfparam name="form.placed" default="0">

<cfform method="post">

<cfinput type="hidden" name="check">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
    <tr valign=middle height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
        <td background="pics/header_background.gif"><h2>HIGH SCHOOL INVOICE BATCH FOR STANDARD FEES</h2></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<table width="100%" align="center" style="padding-top:3cm" class="section">
    <tr>
        <td align="right">
        Select Program:
        </td>
        <td>
            <select name="seasonId" size="1">
                <cfoutput query="get_seasons">
                    <option value="#seasonid#">#season#</option>
                </cfoutput>
            </select>
        </td>
    </tr>

    <tr>
        <td align="right" style="padding-top:1cm">
        Select charge:
        </td>
        <td style="padding-top:1cm">
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
        <td align="right" style="padding-top:1cm">
        
        </td>
        <td style="padding-top:1cm">
			<input type="checkbox" name="placed" value="1" checked="checked"/> Invoice only Placed students
        </td>
    </tr>
    
    <tr>
        <td></td>
        <td align="left" style="padding-top:1cm"><cfinput type="image" src="pics/update.gif" name="submit"></td>
    </tr>  

</table>

</cfform>

<cfinclude template="../table_footer.cfm">

<cfif NOT ISDEFINED('form.seasonId') OR NOT ISDEFINED('form.chooseCharge')>
    <h1 align="center" style="padding-top:1cm">Please make sure you select at least on program AND one charge</h1>
    <cfabort>
</cfif>


<cfquery name="getLastCharge" datasource="MySQL">
SELECT 
	MAX(invoiceid) AS invoiceid
FROM 
smg_charges
</cfquery>

<cfset lastOldInvoice = #getLastCharge.invoiceid#>

<cfloop list="#form.chooseCharge#" index="chargeType">

    <!--- get High School students that:
    1. Are active;
    2. Have no charges created;
    3. Have charges created but changed programs;
    4. Have charges created but under the wrong agent;
    5. Don't have all standard fees charged (ex: program price AND insurance fee AND placement fee AND sevis fee
    6. Have had standard charges canceled
    7. Have been canceled and reactivated afterwards --->
    <cfquery name="getHSstud" datasource="#APPLICATION.DSN#">
        SELECT
            ss.studentid,
            ss.intrep,
            ss.programid,
            ss.countrybirth,
            ss.countryresident,
            ss.countrycitizen,
            ss.dateassigned,
            ss.regionassigned,
            ss.regionalguarantee,
            ss.regionguar,
            ss.state_guarantee,
            ss.direct_placement,
            ss.privateschool,
            ss.accepts_private_high,
            ss.app_school_name,
            ss.app_school_type,
            ss.aypenglish,
            ss.ayporientation,
            ss.scholarship,
            ss.convalidation_needed,
            ss.convalidation_completed,
            ss.companyid,
            ss.dateapplication,
            ss.hostID,
            ss.host_fam_approved,
            sp.programname,
            sp.startdate,
            sp.enddate,
            sr.regionname,
            sr.regional_guarantee,
            sst.statename,
            sst.guarantee_Fee,
            su.insurance_typeid,
            su.10_month_price,
            su.12_month_price,
            su.5_month_price,
            si.ayp12 AS 12_month_ins,
            si.ayp10 AS 10_month_ins,
            si.ayp5 AS 5_month_ins,
            su.accepts_sevis_fee,
            shist.datePlaced
        FROM smg_students ss
        LEFT JOIN smg_programs sp ON ss.programid = sp.programid
        LEFT JOIN smg_regions sr ON ss.regionalguarantee = sr.regionid
        LEFT JOIN smg_states sst ON ss.state_guarantee = sst.id
        LEFT JOIN smg_users su ON ss.intrep = su.userid
        LEFT JOIN smg_insurance_type si ON si.insutypeid = su.insurance_typeid
        LEFT JOIN smg_hosthistory shist ON shist.studentID = ss.studentID AND isActive = 1
        WHERE ss.active = 1
        AND intrep != 0
        <cfif form.placed EQ 1>
            AND shist.datePlaced != ''
        </cfif>
        AND ss.app_current_status = 11
        AND sp.seasonid = #form.seasonId#
        AND sp.hold != 1
        AND ss.companyid in (1,2,3,4,10,12)
        AND ss.studentid NOT IN (
            SELECT sc.stuid
            FROM smg_charges sc
            INNER JOIN smg_students ss ON ss.studentid = sc.stuid
            WHERE sc.agentid = ss.intrep
            AND sc.programid = ss.programid
            AND sc.companyid = ss.companyid
            AND sc.type = '#chargeType#'
            AND sc.active = 1)
        ORDER BY studentid
    </cfquery>

    <cfloop query="getHSstud">
		
		<!--- check if programid charges have already been created and are still active --->
		<cfquery name="checkProgramCharges" datasource="MYSQL">
		SELECT 
		   sc.stuid,   
		   sc.programid,
		(CASE 
		WHEN sc.companyid = 1 THEN 1
		WHEN sc.companyid = 2 THEN 1
		WHEN sc.companyid = 3 THEN 1
		WHEN sc.companyid = 4 THEN 1
		WHEN sc.companyid = 12 THEN 1
		ELSE sc.companyid
		END)
		AS 
			chargeCompanyid,   
		(CASE 
		WHEN ss.companyid = 1 THEN 1
		WHEN ss.companyid = 2 THEN 1
		WHEN ss.companyid = 3 THEN 1
		WHEN ss.companyid = 4 THEN 1
		WHEN ss.companyid = 12 THEN 1
		ELSE ss.companyid
		END)
		AS 
			currentCompanyid
		FROM
			smg_charges sc
		LEFT JOIN 
			 smg_students ss ON ss.studentid = sc.stuid
		WHERE 
			  sc.stuid = #getHSstud.studentid#
		AND 
			sc.programid = #getHSstud.programid#
		AND 
			sc.active = 1
		AND 
			sc.type = '#chargeType#'
		</cfquery>
		
		<!--- create charges for the current student programid only if
		student does not have charges
		or if 
		student changed from ISE to CASE
		or if
		student changed from CASE to ISE --->
		<cfif (checkProgramCharges.chargeCompanyid NEQ checkProgramCharges.currentCompanyid) OR checkProgramCharges.recordCount EQ 0>
   
			<!--- define program price --->
			<cfquery name="checkDeposit" datasource="MySQL">
			SELECT invoiceid, amount_due, type
			FROM smg_charges
			WHERE stuid = #getHSstud.studentid#
			AND type = 'deposit'
			AND programid = #getHSstud.programid#
			AND agentid = #getHSstud.intrep#
			<!--- AND companyid = #getHSstud.companyid# --->
			AND active = 1
			</cfquery> 
			  
			<cfif month(getHSstud.enddate) EQ 12>
				<cfset amount = #Val(getHSstud.12_month_price)#>
				<cfelseif  dateDiff('m',getHSstud.startdate, getHSstud.enddate) GT 6>
					 <cfset amount = #Val(getHSstud.10_month_price)#>
					 <cfelse>
						<cfset amount = #Val(getHSstud.5_month_price)#>
			</cfif>
		    
			<cfif checkDeposit.recordCount EQ 0>
				<cfset amountDue = #variables.amount#>
				<cfelse>
					<cfset amountDue = #variables.amount# - #checkDeposit.amount_due#>
			</cfif>
		   
			<!--- define insurance cost --->
			<cfif getHSstud.insurance_typeid NEQ 1>
		   
				<cfif month(getHSstud.enddate) EQ 12>
					<cfset insurance = #getHSstud.12_month_ins#>
					<cfelseif dateDiff('m',getHSstud.startdate, getHSstud.enddate) GT 6>
						<cfset insurance = #getHSstud.10_month_ins#>
						<cfelse>
							<cfset insurance = #getHSstud.5_month_ins#>
				</cfif>
			   
			</cfif>
		   
			<cfswitch expression="#chargeType#">
			   
					<cfcase value="program fee">
	
					<!--- insert charges ONLY IF program fee and insurance cost is not zero (except for the deposit charge, which is entered whenever selected --->
					<cfif (variables.amount NEQ 0 AND getHSstud.insurance_typeid NEQ 1 AND variables.insurance NEQ 0) OR (variables.amount NEQ 0 AND getHSstud.insurance_typeid EQ 1)>
				   
						<cfquery name="insertProgramFee" datasource="MySQL">
						INSERT INTO smg_charges
							(agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
						VALUES
							(#getHSstud.intrep#, #getHSstud.studentid#, 0, #getHSstud.programid#, '#getHSstud.programName#', '#chargeType#', #Now()#, #variables.amountDue#, #variables.amount#, #client.userid#, #Now()#, #getHSstud.companyid#)   
						</cfquery>
					   
						<cfif getHSstud.direct_placement EQ 1>
							<cfquery name="insertDiscount" datasource="MySQL">
							INSERT INTO smg_charges
								(agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
							VALUES
								(#getHSstud.intrep#, #getHSstud.studentid#, 0, #getHSstud.programid#, 'Direct Placement Discount', 'direct placement', #Now()#, -200, -200, #client.userid#, #Now()#, #getHSstud.companyid#)   
							</cfquery>               
						</cfif>
					   
						<!--- program fee exceptions --->
						<cfset thisYear = #year(getHSstud.startdate)#>
						<cfset lastYear = #thisYear# -1>
						<cfset discDeadLine = '#lastYear#-12-31'>
						<cfset may = '#thisYear#-05-01'>
						<cfset october = '#thisYear#-10-01'>
					   
						<!--- FOR AUGUST STUDENTS ONLY THAT ARE NOT DIRECT PLACEMENT!!! --->
						<cfif getHSstud.startdate GT may AND getHSstud.startdate LT october AND getHSstud.direct_placement NEQ 1>
						
							<!--- discount for early apps DISCONTINUED starting for AUG10 arriving students --->
						   <!---  <!--- If app is received before Jan 1st of previous year from Intl Home Stud--->
							<cfif #getHSstud.dateapplication# LTE #variables.discDeadLine#>
							   
								<cfif getHSstud.intrep EQ 33>
									<cfquery name="insertSpecAgreem" datasource="MySQL">
									INSERT INTO smg_charges
										(agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
									VALUES
										(#getHSstud.intrep#, #getHSstud.studentid#, 0, #getHSstud.programid#, 'Application received before Dec 31st', 'special discount', #Now()#, -100, -100, #client.userid#, #Now()#, #getHSstud.companyid#)   
									</cfquery>                            
								</cfif>
							   
								<!--- If app is received before Dec 31st of previous year from CLS--->
								<cfif getHSstud.intrep EQ 6381 AND getHSstud.scholarship EQ 0>
									<cfquery name="insertSpecAgreem" datasource="MySQL">
									INSERT INTO smg_charges
										(agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
									VALUES
										(#getHSstud.intrep#, #getHSstud.studentid#, 0, #getHSstud.programid#, 'Application received before Dec 31st', 'special discount', #Now()#, -150, -150, #client.userid#, #Now()#, #getHSstud.companyid#)   
									</cfquery>                     
								</cfif>
							   
							</cfif> --->
						   
							<!--- discount for scholarship students from CLS (DISCOUNT DISCONTINUED FOR FALL 2011 ON, as per Wayne's email Dec 15th 2010)--->
							<!--- <cfif getHSstud.intrep EQ 6381 AND getHSstud.scholarship EQ 1>
								<cfquery name="insertScholDisc" datasource="MySQL">
								INSERT INTO smg_charges
								(agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
								VALUES
								(#getHSstud.intrep#, #getHSstud.studentid#, 0, #getHSstud.programid#, 'Scholarship Student', 'scholarship discount', #Now()#, -200, -200, #client.userid#, #Now()#, #getHSstud.companyid#)   
								</cfquery>                               
							</cfif> --->
						   
						</cfif>
					   
					</cfif>
					<!--- END OF: insert charges ONLY IF program fee and insurance cost is not zero (except for the deposit charge, which is entered whenever select --->
				   
					</cfcase>
				   
					<cfcase value="insurance">
				   
					<!--- insert charges ONLY IF program fee and insurance cost is not zero (except for the deposit charge, which is entered whenever select --->
					<cfif (variables.amount NEQ 0 AND getHSstud.insurance_typeid NEQ 1 AND variables.insurance NEQ 0) OR (variables.amount NEQ 0 AND getHSstud.insurance_typeid EQ 1)>
								   
						<cfif getHSstud.insurance_typeid NEQ 1>
					   
							 <cfquery name="insertInsurance" datasource="MySQL">
							INSERT INTO smg_charges
								(agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
							VALUES
								(#getHSstud.intrep#, #getHSstud.studentid#, 0, #getHSstud.programid#, '#getHSstud.programName#', '#chargeType#', #Now()#, #variables.insurance#, #variables.insurance#, #client.userid#, #Now()#, #getHSstud.companyid#)   
							</cfquery>
											 
						</cfif>
	
					</cfif>
					<!--- END OF: insert charges ONLY IF program fee and insurance cost is not zero (except for the deposit charge, which is entered whenever select --->
					   
					</cfcase>
				   
					<cfcase value="sevis">
	
					<!--- insert charges ONLY IF program fee and insurance cost is not zero (except for the deposit charge, which is entered whenever select --->
					<cfif (variables.amount NEQ 0 AND getHSstud.insurance_typeid NEQ 1 AND variables.insurance NEQ 0) OR (variables.amount NEQ 0 AND getHSstud.insurance_typeid EQ 1)>
					   
						<!--- US citizens country code is 232 don't pay sevis--->
						<cfif getHSstud.accepts_sevis_fee EQ 1 AND (getHSstud.countrybirth NEQ 232 AND getHSstud.countryresident NEQ 232 AND getHSstud.countrycitizen NEQ 232)>
							<cfquery name="insertSevis" datasource="MySQL">
							INSERT INTO smg_charges
								(agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
							VALUES
								(#getHSstud.intrep#, #getHSstud.studentid#, 0, #getHSstud.programid#, '#getHSstud.programName#', '#chargeType#', #Now()#, 180, 180, #client.userid#, #Now()#, #getHSstud.companyid#)   
							</cfquery>
						</cfif>          
	
					</cfif>
					<!--- END OF: insert charges ONLY IF program fee and insurance cost is not zero (except for the deposit charge, which is entered whenever select --->
				   
					</cfcase>
				   
					<cfcase value="guarantee">
	
					<!--- insert charges ONLY IF program fee and insurance cost is not zero (except for the deposit charge, which is entered whenever select --->
					<cfif (variables.amount NEQ 0 AND getHSstud.insurance_typeid NEQ 1 AND variables.insurance NEQ 0) OR (variables.amount NEQ 0 AND getHSstud.insurance_typeid EQ 1)>
				   
						<cfif getHSstud.regionalguarantee GT 0 AND getHSstud.direct_placement NEQ 1>

                            <cfquery name="getHostState" datasource="MySQL">
                            SELECT ss.hostid, IFNULL( sst.state, 0 ) AS statePlaced
                            FROM smg_students ss
                            LEFT JOIN smg_hosts sh ON sh.hostid = ss.hostid
                            LEFT JOIN smg_states sst ON sst.state = sh.state
                            WHERE ss.studentid = #getHSstud.studentid#
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
                                    <!--- <cfcase value="MT,ID,WY,CO,NM">
                                        <cfset regionPlaced = 'Rocky Mountain'>
                                    </cfcase> --->
                                    <cfcase value="WA,OR,NV,UT,AZ,MT,ID,WY,CO,NM,CA">
                                        <cfset regionPlaced = 'West'>
                                    </cfcase>
                                    <cfdefaultcase>
                                        <cfset regionPlaced = 0>
                                    </cfdefaultcase>
                                </cfswitch>
                            
                            </cfoutput>
                            
                            <cfif getHSstud.regionname EQ variables.regionPlaced OR variables.regionPlaced EQ 0>
                       
                                <cfquery name="insertRegionalGuarantee" datasource="MySQL">
                                INSERT INTO smg_charges
                                    (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
                                VALUES
                                    (#getHSstud.intrep#, #getHSstud.studentid#, 0, #getHSstud.programid#, 'Regional Guarantee: #getHSstud.regionname#', '#chargeType#', #Now()#, #getHSstud.regional_guarantee#, #getHSstud.regional_guarantee#, #client.userid#, #Now()#, #getHSstud.companyid#)   
                                </cfquery>               

                            </cfif>
                                                        
                            <!--- This comment is to disable the regional guarantee discount for applications received prior to Jan 1st. This discount is no longer applicable --->
                            <!--- <cfset thisYear = #year(getHSstud.startdate)#>
                            <cfset lastYear = #thisYear# -1>
                            <cfset discDeadLine = '#lastYear#-12-31'>
                            <cfset may = '#thisYear#-05-01'>
                            <cfset october = '#thisYear#-10-01'>               
                            <!--- FOR AUGUST STUDENTS ONLY THAT ARE NOT DIRECT PLACEMENT!!! --->
                            <cfif getHSstud.startdate GT may AND getHSstud.startdate LT october AND getHSstud.direct_placement EQ 0>
                                <!--- If app is received before Jan 1st of previous year--->
                                <cfif #getHSstud.dateapplication# LTE #variables.discDeadLine#>
                                    <cfquery name="insertSpecAgreem" datasource="MySQL">
                                    INSERT INTO smg_charges
                                        (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
                                    VALUES
                                        (#getHSstud.intrep#, #getHSstud.studentid#, 0, #getHSstud.programid#, 'Free Regional Guarantee', '#chargeType#', #Now()#, -#getHSstud.regional_guarantee#, -#getHSstud.regional_guarantee#, #client.userid#, #Now()#, #getHSstud.companyid#)   
                                    </cfquery>                   
                                </cfif>
                            </cfif> --->
                            
                        </cfif>
                    
                        <cfif getHSstud.state_guarantee GT 0 AND getHSstud.direct_placement NEQ 1>
                        
                            <cfquery name="getHostState" datasource="MySQL">
                            SELECT ss.hostid, ss.state_guarantee, sst.id AS statePlaced
                            FROM smg_students ss
                            LEFT JOIN smg_hosts sh ON sh.hostid = ss.hostid
                            LEFT JOIN smg_states sst ON sst.state = sh.state
                            WHERE ss.studentid = #getHSstud.studentid#
                            </cfquery>
                            
                            <!--- getHostState.hostid EQ 0: charge unplaced students OR 
                             getHostState.state_guarantee EQ getHostState.statePlaced: if student is placed, check State placed before charging --->
                            <cfif getHostState.hostid EQ 0 OR getHostState.state_guarantee EQ getHostState.statePlaced>
                                <cfquery name="insertStateGuarantee" datasource="MySQL">
                                INSERT INTO smg_charges
                                    (agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
                                VALUES
                                    (#getHSstud.intrep#, #getHSstud.studentid#, 0, #getHSstud.programid#, 'State Guarantee: #getHSstud.statename#', '#chargeType#', #Now()#, #getHSstud.guarantee_Fee#, #getHSstud.guarantee_Fee#, #client.userid#, #Now()#, #getHSstud.companyid#)   
                                </cfquery>  
                            </cfif>
                            
                        </cfif>
	
					</cfif>
					<!--- END OF: insert charges ONLY IF program fee and insurance cost is not zero (except for the deposit charge, which is entered whenever select --->
						  
					</cfcase>
					   
				<cfcase value="deposit">
			   
					<cfquery name="checkProgFee" datasource="MySQL">
					SELECT stuid
					FROM smg_charges
					WHERE stuid = #getHSstud.studentid#
					AND programid = #getHSstud.programid#
					AND agentid = #getHSstud.intrep#
                    <cfswitch expression="#getHSstud.companyid#">
                    	<cfcase value="1,2,3,4,12">
                        	AND companyid IN (1,2,3,4,12)
                        </cfcase>
                        <cfdefaultcase>
                        	AND companyid = #getHSstud.companyid#
                        </cfdefaultcase>
                    </cfswitch>
					AND type = 'program fee'
					AND active = 1
					</cfquery>
				   
					<cfif checkProgFee.recordCount EQ 0>
						<cfquery name="insertDeposit" datasource="MySQL">
						INSERT INTO smg_charges
							(agentid, stuid, invoiceid, programid, description, type, date, amount_due, amount, userinput, invoicedate, companyid)
						VALUES
							(#getHSstud.intrep#, #getHSstud.studentid#, 0, #getHSstud.programid#, '#getHSstud.programName#', '#chargeType#', #Now()#, 500, 500, #client.userid#, #Now()#, #getHSstud.companyid#)   
						</cfquery>               
					</cfif>
			   
				</cfcase>
			   
			</cfswitch>
		
		</cfif><!--- create charges for the current student programid only if student does not have charges or if 
		student changed from ISE to CASE or if student changed from CASE to ISE --->
     
    </cfloop>
   
</cfloop>
<!--- end of creating charges --->

<!--- <cfquery name="getCompId" datasource="MySQL">
SELECT DISTINCT(companyid) AS companyid
FROM smg_charges
WHERE agentid != 0
AND invoiceid = 0
ORDER BY companyid
</cfquery>

<cfloop query="getCompId"> --->

    <cfquery name="getAgent" datasource="MySQL">
    SELECT agentid, companyid, 
		(CASE 
			WHEN companyid = 1 THEN 1
			WHEN companyid = 2 THEN 1
			WHEN companyid = 3 THEN 1
			WHEN companyid = 4 THEN 1
			WHEN companyid = 12 THEN 1
			ELSE companyid
			END) AS groupCompId
    FROM smg_charges
    WHERE invoiceid = 0
    AND agentid != 0
    AND companyid IN (1,2,3,4,10,12)
	GROUP BY agentid, groupCompId
    <!--- AND companyid = #getCompId.companyid# --->
    </cfquery>
   
    <cfoutput query="getAgent">

        <cfquery name="getLastInvId" datasource="MySQL">
        SELECT MAX(invoiceid) AS invoiceid
        FROM smg_charges
        </cfquery>
       
        <cfset newInvId = #getLastInvId.invoiceid# + 1>
   
        <cfquery name="insertInvoiceId" datasource="MySQL">
        UPDATE smg_charges
        SET invoiceid = #variables.newInvId#
        WHERE agentid = #getAgent.agentid#
        AND invoiceid = 0
			<cfif getAgent.groupCompId EQ 1>
				AND (companyid < 5 OR companyid = 12)
        		<cfelse>
					AND companyid = #getAgent.groupCompId#
			</cfif>
		<!--- AND companyid = #getAgent.companyid# --->
        </cfquery>

    </cfoutput>
   
<!--- </cfloop> --->

<cfquery name="getNewInv" datasource="MySQL">
SELECT su.businessname, su.userid, s.invoiceid, s.date, SUM(s.amount_due) AS total, s.companyid
FROM smg_charges s
INNER JOIN smg_users su ON s.agentid = su.userid
WHERE s.invoiceid > #variables.lastOldInvoice#
GROUP BY s.invoiceid
ORDER BY su.businessname<!--- , s.companyid --->
</cfquery>

<br/><br/>

<table class="frame" align="center">
    <tr>
        <td colspan="4" align="center">Displaying 
<cfoutput>#getNewInv.recordCount#</cfoutput> invoices</td>
    </tr>
    <tr class="darkBlue">
        <td><span class="style11">International Agent</span></td>
        <td><span class="style11">Invoice</span></td>
        <td><span class="style11">Total Amount</span></td>
        <td><span class="style11">Company</span></td>
    </tr>
<cfoutput query="getNewInv">
    <tr>
        <td>#getNewInv.businessname# (###getNewInv.userid#)</td>
        <td><a href="invoice/invoice_view.cfm?id=#getNewInv.invoiceid#" target="_blank">#getNewInv.invoiceid#</a></td>
        <td>#getNewInv.total#</td>
        <td>
            <cfswitch expression="#getNewInv.companyid#">
                <cfcase value="1">ISE</cfcase>
                <cfcase value="2">ISE</cfcase>
                <cfcase value="3">ISE</cfcase>
                <cfcase value="4">ISE</cfcase>
                <cfcase value="5">SMG</cfcase>
				<cfcase value="10">CASE</cfcase>
				<cfcase value="12">ISE</cfcase>
            </cfswitch></td>
    </tr>
</cfoutput>
</table>

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
        si.ayp12 AS 12_month_ins,
        si.ayp10 AS 10_month_ins,
        si.ayp5 AS 5_month_ins,
        su.accepts_sevis_fee
    FROM smg_students ss
    INNER JOIN smg_programs sp ON ss.programid = sp.programid
    INNER JOIN smg_users su ON ss.intrep = su.userid
    INNER JOIN smg_insurance_type si ON si.insutypeid = su.insurance_typeid
    WHERE ss.active =1
    AND sp.seasonid =#form.seasonId#
    AND sp.hold !=1
    AND ss.companyid IN (1,2,3,4,10,12)
    ORDER BY businessname, endMonth, datediffer
</cfquery>

<table class="frame" align="center">
    <tr class="darkBlue">
        <td align="center"><span class="style11">Agent</span></td><td 
colspan="2" align="center"><span class="style11">Problem</span></td>
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
        <cfif getMissingAmounts.12_month_price EQ 0 OR (getMissingAmounts.12_month_ins EQ 0 AND getMissingAmounts.insurance_typeid NEQ 1)>           
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
                <cfif getMissingAmounts.12_month_ins EQ 0 AND getMissingAmounts.insurance_typeid NEQ 1>
                    Missing 12 month insurance
                </cfif>
                </td>               
            </tr>
        </cfif>
    </cfif>
   
    <cfif getMissingAmounts.datediffer GT 6 AND getMissingAmounts.endMonth NEQ 12>
        <cfif getMissingAmounts.10_month_price EQ 0 OR (getMissingAmounts.10_month_ins EQ 0 AND getMissingAmounts.insurance_typeid NEQ 1)>
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
                <cfif getMissingAmounts.10_month_ins EQ 0 AND getMissingAmounts.insurance_typeid NEQ 1>
                    Missing 10 month insurance
                </cfif>
                </td>           
            </tr>
        </cfif>
        <cfelseif getMissingAmounts.datediffer LTE 6>
            <cfif getMissingAmounts.5_month_price EQ 0 OR (getMissingAmounts.5_month_ins EQ 0 AND getMissingAmounts.insurance_typeid NEQ 1)>
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
                    <cfif getMissingAmounts.5_month_ins EQ 0 AND getMissingAmounts.insurance_typeid NEQ 1>
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

</body>
</html>

<!--- start emailing intl agents --->

<cfif directoryExists("#AppPath.uploadedFiles#invoices_pdf")>
	<cfdirectory directory="#AppPath.uploadedFiles#invoices_pdf" action="delete" recurse="yes">
</cfif>

<cfdirectory action="create" directory="#AppPath.uploadedFiles#invoices_pdf" mode="777">


<cfquery name="getAgentIds" datasource="MySQL">
SELECT sc.agentid, companyid, 
		(CASE 
			WHEN sc.companyid = 1 THEN 1
			WHEN sc.companyid = 2 THEN 1
			WHEN sc.companyid = 3 THEN 1
			WHEN sc.companyid = 4 THEN 1
			WHEN sc.companyid = 12 THEN 1
			ELSE sc.companyid
			END) AS testCompId
FROM smg_charges sc
WHERE sc.invoiceid > #variables.lastOldInvoice#
GROUP BY agentid, testCompid
</cfquery>



<cfloop query="getAgentIds">

        <cfquery name="getAgentInfo" datasource="MySQL">
        SELECT *
        FROM smg_users su
        WHERE su.userid = #getAgentIds.agentId#
        </cfquery>
        
        <cfif getAgentInfo.email IS NOT "" AND getAgentInfo.billing_email IS "">
        	<cfquery name="getAgentInfoSecRun" datasource="MySQL">
            UPDATE smg_users su
            SET su.billing_email = su.email
            WHERE userid = #getAgentIds.agentId#
            </cfquery>
            
            <cfquery name="getAgentInfo" datasource="MySQL">
            SELECT *
            FROM smg_users su
            WHERE su.userid = #getAgentIds.agentId#
            </cfquery>
        </cfif>

    <cfquery name="getNewInvPerAgent" datasource="MySQL">
    SELECT DISTINCT(sc.invoiceid) AS invoiceId
    FROM smg_charges sc
    LEFT JOIN smg_programs sp ON sp.programid = sc.programid
    WHERE sc.invoiceid > #variables.lastOldInvoice#
    AND sc.agentid = #getAgentIds.agentId#
		<cfif getAgentIds.testCompId EQ 1>
			AND (sc.companyid < 5 OR sc.companyid = 12)
			<cfelse>
				AND sc.companyid = #getAgentIds.testCompId#
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
		<cfset emailTo = 'bmccready@iseusa.org'>
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
	
</cfloop> <!--- end of loop query="getAgentIds" --->
<!--- end of emailing intl agents --->
