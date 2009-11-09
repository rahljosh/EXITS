<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfsetting requesttimeout="9999">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Balance Report Per Program, includes Credit Notes</title>

<style type="text/css">

	table.frame 
	{
	border-style:solid;
	border-width:thin;
	border-color:#004080;
	border-collapse:collapse;
	background-color:#FFFFE1;
	padding:2px;
	}
	
	td.right
	{
	font:Arial, Helvetica, sans-serif;
	font-style:normal;
	font-size:small;
	color:#FFFFFF;
	font-weight:bold;
	border-right-style:solid;
	border-right-width:thin;
	border-right-color:#004080;
	border-right-collapse:collapse;
	padding:4px;
	}
	
	td.two
	{
	font:Arial, Helvetica, sans-serif;
	font-style:normal;
	font-size:small;
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

.style1 {color: #FF0000}
</style>

</head>

<cfquery name="getPrograms" datasource="MySQL">
SELECT *
FROM smg_programs
WHERE active = 1
AND (companyid = 1
	OR companyid = 2
    OR companyid = 3
    OR companyid = 4
    OR companyid = 7
    OR companyid = 8
    OR companyid = 9)
ORDER BY companyid, startdate DESC
</cfquery>

<body>

<cfif NOT ISDEFINED('form.submitted')>
<div align="center">
<strong><small>Outstanding Balances Report</small></strong>
    <cfform>
        
        <cfinput type="hidden" name="submitted">
    
        <select name="selectPrograms" multiple="multiple" size="30">
            <option selected="selected">Select All</option>
            <option value="0">Charges not related to a program</option>
            <cfoutput query="getPrograms">
                <cfswitch expression="#companyid#">
                    <cfcase value="1"><cfset compId = 'Red'></cfcase>
                    <cfcase value="2"><cfset compId = 'Blue'></cfcase>
                    <cfcase value="3"><cfset compId = 'Green'></cfcase>
                    <cfcase value="4"><cfset compId = 'Yellow'></cfcase>
                    <cfcase value="7"><cfset compId = 'Trainee'></cfcase>
                    <cfcase value="8"><cfset compId = 'W&T'></cfcase>
                    <cfcase value="9"><cfset compId = 'H2B'></cfcase>
                </cfswitch>
                <option value="#programid#">#variables.compId# - #getPrograms.programname#</option>
            </cfoutput>
        </select>
        <br/>
        <cfinput name="printFormat" type="checkbox" checked="yes"> <strong><small>Display print format?</small></strong>
        <br/>
        <cfinput name="submit" type="image" src="../pics/update.gif">
    
    </cfform>

	<cfif NOT ISDEFINED('form.submitted')>
        <cfabort>
    </cfif>

</div>
</cfif>
    
<cfquery name="getAgentsReceivable" datasource="MySQL"> 
SELECT t.agentid, t.businessname, SUM( t.total ) AS totalPerAgent
FROM (
SELECT sch.agentid, su.businessname, IFNULL( SUM( sch.amount_due ) , 0 ) AS total
FROM smg_charges sch
LEFT JOIN smg_users su ON su.userid = sch.agentid
<cfif form.selectPrograms IS NOT 'Select All'>
    WHERE (
    <cfloop list="#form.selectPrograms#" index="progId">
        <cfif progId EQ 0>
            sch.programid = 0
            <cfelse>
            sch.programid = #progId#
        </cfif>
        <cfif progId IS NOT #listLast(form.selectPrograms)#>
            OR
        </cfif>
    </cfloop>)
    <cfelse>
        WHERE (sch.programid = 0 OR
        <cfoutput query="getPrograms">
            sch.programid = #getPrograms.programid#
            <cfif getPrograms.currentRow NEQ getPrograms.recordCount>
                OR
            </cfif>
        </cfoutput>)	
</cfif>
GROUP BY agentid
UNION ALL
SELECT sch.agentid, su.businessname, IFNULL( SUM( spc.amountapplied ) * -1, 0 ) AS total
FROM smg_payment_charges spc
LEFT JOIN smg_charges sch ON sch.chargeid = spc.chargeid
LEFT JOIN smg_users su ON su.userid = sch.agentid
<cfif form.selectPrograms IS NOT 'Select All'>
    WHERE (
    <cfloop list="#form.selectPrograms#" index="progId">
        <cfif progId EQ 0>
            sch.programid = 0
            <cfelse>
            sch.programid = #progId#
        </cfif>
        <cfif progId IS NOT #listLast(form.selectPrograms)#>
            OR
        </cfif>
    </cfloop>)
    <cfelse>
        WHERE (sch.programid = 0 OR
        <cfoutput query="getPrograms">
            sch.programid = #getPrograms.programid#
            <cfif getPrograms.currentRow NEQ getPrograms.recordCount>
                OR
            </cfif>
        </cfoutput>)
</cfif>
GROUP BY sch.agentid
UNION ALL
SELECT sc.agentid, su.businessname, IFNULL( SUM( sc.amount - sc.amount_applied ) * -1, 0 ) AS total
FROM smg_credit sc
LEFT JOIN smg_charges sch ON sch.chargeid = sc.chargeid
LEFT JOIN smg_users su ON su.userid = sc.agentid
WHERE sc.active =1
<cfif form.selectPrograms IS NOT 'Select All'>
    AND (
    <cfloop list="#form.selectPrograms#" index="progId">
        <cfif progId EQ 0>
            sch.programid IS NULL
            <cfelse>
            sch.programid = #progId#
        </cfif>
        <cfif progId IS NOT #listLast(form.selectPrograms)#>
            OR
        </cfif>
    </cfloop>)
    <cfelse>
        AND (sch.programid IS NULL OR
        <cfloop query="getPrograms">
            sch.programid = #getPrograms.programid#
            <cfif getPrograms.currentRow NEQ getPrograms.recordCount>
                OR
            </cfif>
        </cfloop>)
</cfif>
GROUP BY sc.agentid
) t
GROUP BY t.agentid HAVING totalPerAgent > 0
ORDER BY totalPerAgent DESC    
</cfquery>

<cfquery name="getAgentsRefund" datasource="MySQL"> 
SELECT t.agentid, t.businessname, SUM( t.total ) AS totalPerAgent
FROM (
SELECT sch.agentid, su.businessname, IFNULL( SUM( sch.amount_due ) , 0 ) AS total
FROM smg_charges sch
LEFT JOIN smg_users su ON su.userid = sch.agentid
<cfif form.selectPrograms IS NOT 'Select All'>
    WHERE (
    <cfloop list="#form.selectPrograms#" index="progId">
        <cfif progId EQ 0>
            sch.programid = 0
            <cfelse>
            sch.programid = #progId#
        </cfif>
        <cfif progId IS NOT #listLast(form.selectPrograms)#>
            OR
        </cfif>
    </cfloop>)
    <cfelse>
        WHERE (sch.programid = 0 OR
        <cfoutput query="getPrograms">
            sch.programid = #getPrograms.programid#
            <cfif getPrograms.currentRow NEQ getPrograms.recordCount>
                OR
            </cfif>
        </cfoutput>)	
</cfif>
GROUP BY agentid
UNION ALL
SELECT sch.agentid, su.businessname, IFNULL( SUM( spc.amountapplied ) * -1, 0 ) AS total
FROM smg_payment_charges spc
LEFT JOIN smg_charges sch ON sch.chargeid = spc.chargeid
LEFT JOIN smg_users su ON su.userid = sch.agentid
<cfif form.selectPrograms IS NOT 'Select All'>
    WHERE (
    <cfloop list="#form.selectPrograms#" index="progId">
        <cfif progId EQ 0>
            sch.programid = 0
            <cfelse>
            sch.programid = #progId#
        </cfif>
        <cfif progId IS NOT #listLast(form.selectPrograms)#>
            OR
        </cfif>
    </cfloop>)
    <cfelse>
        WHERE (sch.programid = 0 OR
        <cfoutput query="getPrograms">
            sch.programid = #getPrograms.programid#
            <cfif getPrograms.currentRow NEQ getPrograms.recordCount>
                OR
            </cfif>
        </cfoutput>)
</cfif>
GROUP BY sch.agentid
UNION ALL
SELECT sc.agentid, su.businessname, IFNULL( SUM( sc.amount - sc.amount_applied ) * -1, 0 ) AS total
FROM smg_credit sc
LEFT JOIN smg_charges sch ON sch.chargeid = sc.chargeid
LEFT JOIN smg_users su ON su.userid = sc.agentid
WHERE sc.active =1
<cfif form.selectPrograms IS NOT 'Select All'>
    AND (
    <cfloop list="#form.selectPrograms#" index="progId">
        <cfif progId EQ 0>
            sch.programid IS NULL
            <cfelse>
            sch.programid = #progId#
        </cfif>
        <cfif progId IS NOT #listLast(form.selectPrograms)#>
            OR
        </cfif>
    </cfloop>)
    <cfelse>
        AND (sch.programid IS NULL OR
        <cfloop query="getPrograms">
            sch.programid = #getPrograms.programid#
            <cfif getPrograms.currentRow NEQ getPrograms.recordCount>
                OR
            </cfif>
        </cfloop>)
</cfif>
GROUP BY sc.agentid
) t
GROUP BY t.agentid HAVING totalPerAgent < 0
ORDER BY totalPerAgent ASC    
</cfquery>

<cfoutput>
<div align="center"><h2>Outstanding balances as of #DateFormat(now(), 'mm-dd-yyyy')# at #TimeFormat(now(),'h:mm:ss tt')#<br></h2></div>
</cfoutput>

<strong><small>Programs Selected:</small></strong><br/>

<cfloop list="#form.selectPrograms#" index="programsSelected">

    <cfif programsSelected IS "Select All">
    
        <small>All programs were selected</small><br/>
        
        <cfelseif programsSelected EQ 0>
        
            <small>Charges not related to a program</small><br/>
        
            <cfelse>
            
                <cfquery name="getProgramsSelected" datasource="MySQL">
                SELECT *
                FROM smg_programs sp
                WHERE sp.programid = #programsSelected#
                ORDER BY companyid ASC, startdate DESC
                </cfquery>
                
                <cfoutput query="getProgramsSelected">
                
                <cfswitch expression="#getProgramsSelected.companyid#">
                    <cfcase value="1"><cfset compId = 'Red'></cfcase>
                    <cfcase value="2"><cfset compId = 'Blue'></cfcase>
                    <cfcase value="3"><cfset compId = 'Green'></cfcase>
                    <cfcase value="4"><cfset compId = 'Yellow'></cfcase>
                    <cfcase value="7"><cfset compId = 'Trainee'></cfcase>
                    <cfcase value="8"><cfset compId = 'W&T'></cfcase>
                    <cfcase value="9"><cfset compId = 'H2B'></cfcase>
                </cfswitch>
                
                <small>#variables.compId# - #getProgramsSelected.programname# (###getProgramsSelected.programid#)</small> <br/>
                
                </cfoutput>
        
    </cfif>
    
</cfloop>


<!--- <cfif form.selectPrograms IS NOT "Select All" AND form.selectPrograms NEQ 0>

    <cfquery name="getProgramsSelected" datasource="MySQL">
    SELECT *
    FROM smg_programs sp
    WHERE (<cfloop list="#form.selectPrograms#" index="programsSelected">
                sp.programid = #programsSelected#
            <cfif programsSelected IS NOT #listLast(form.selectPrograms)#>
                OR
            </cfif>
        </cfloop>)
    ORDER BY companyid ASC, startdate DESC
    </cfquery>
    
	<cfoutput query="getProgramsSelected">
    
        <cfswitch expression="#getProgramsSelected.companyid#">
            <cfcase value="1"><cfset compId = 'Red'></cfcase>
            <cfcase value="2"><cfset compId = 'Blue'></cfcase>
            <cfcase value="3"><cfset compId = 'Green'></cfcase>
            <cfcase value="4"><cfset compId = 'Yellow'></cfcase>
            <cfcase value="7"><cfset compId = 'Trainee'></cfcase>
            <cfcase value="8"><cfset compId = 'W&T'></cfcase>
            <cfcase value="9"><cfset compId = 'H2B'></cfcase>
        </cfswitch>
    
        <small>#variables.compId# - #getProgramsSelected.programname# (###getProgramsSelected.programid#)</small> <br/>
    </cfoutput>
    
    <cfelseif form.selectPrograms EQ 0>
    	<small>Charges not related to a program</small>
		<cfelse>
            <small>All programs were selected</small>    
</cfif> --->

<br/>

<cfset arrayEmailAgent = ArrayNew(1)>
<cfloop query="getAgentsReceivable">
	<cfset aEmailAgent = #arrayAppend(arrayEmailAgent, "#getAgentsReceivable.agentid#")#>
</cfloop>
<cfoutput>
	<script type="text/javascript">
		var #toScript(arrayEmailAgent, "jsArrayEmailAgent")#;
		var i=0;
		
		function checkUncheck() {
			if (document.getElementById("emailAgent").checked == false) {
				for (i in jsArrayEmailAgent) {	
					document.getElementById("email"+jsArrayEmailAgent[i]).checked = false;
				}
			}
			else {
				for (i in jsArrayEmailAgent) {	
					document.getElementById("email"+jsArrayEmailAgent[i]).checked = true;
				}
			}
		}	
	</script>
</cfoutput>

<cfform method="post" action="m_sendEmailNotification.cfm">

<cfif NOT ISDEFINED('form.printFormat')>
    <div align="center">
        <cfinput type="submit" name="sendEmail" src="../pics/send-email.gif">
    </div>
</cfif>

<br/><br/>

<strong><small>RECEIVABLES</small></strong>
<br/>

<cfif getAgentsReceivable.recordCount EQ 0>
	<small>There are not receivables for the selected programs</small>
<cfelse>
<table class="frame">

    <tr class="darkBlue">
    	<cfif NOT ISDEFINED('form.printFormat')>
            <td align="center">
                <cfinput name="emailAgent" id="emailAgent" type="checkbox" onClick="javaScript:checkUncheck();" checked="true">
            </td>
        </cfif>
        <td class="right">AGENT</td>
        <td class="right">RED</td>
        <td class="right">BLUE</td>
        <td class="right">GREEN</td>
        <td class="right">YELLOW</td>
        <td class="right">SMG</td>
        <td class="right">TRAINEE</td>
        <td class="right" width="5%">W & T</td>
        <td class="right">H2B</td>
        <td class="right">TOTAL</td>
    </tr>    

<cfparam name="totalRedBal" default="0">
<cfparam name="totalBlueBal" default="0">
<cfparam name="totalGreenBal" default="0">
<cfparam name="totalYellowBal" default="0">
<cfparam name="totalSmgBal" default="0">
<cfparam name="totalTraineeBal" default="0">
<cfparam name="totalWandtBal" default="0">
<cfparam name="totalH2bBal" default="0"> 
<cfparam name="getBalancePerAgent.totalPerAgent" default="0">    
<cfparam name="grandTotalBal" default="0">

<cfoutput query="getAgentsReceivable">

    <cfinput type="hidden" name="agentId" value="#getAgentsReceivable.agentid#">
    <cfinput type="hidden" name="balPerAgent#getAgentsReceivable.agentid#" value="#getAgentsReceivable.totalPerAgent#">    
    <cfset intlAgentId = #getAgentsReceivable.agentid#>
        
    <cfset redBal = 0>
    <cfset blueBal = 0>
    <cfset greenBal = 0>
    <cfset yellowBal = 0>
    <cfset smgBal = 0>
    <cfset traineeBal = 0>
    <cfset wandtBal = 0>
    <cfset h2bBal = 0>            

    <cfloop index="indexCompId" list="1,2,3,4,5,6,7,8,9">
    
        <cfquery name="getBalancePerAgentReceivable" datasource="MySQL"> 
        SELECT t.agentid, t.businessname, SUM(t.total) AS totalPerAgent
        FROM (
        SELECT sch.agentid, su.businessname, sch.programid, IFNULL(SUM(sch.amount_due),0) AS total, (CASE 
WHEN sp.type = 7 THEN 7
WHEN sp.type = 8 THEN 7
WHEN sp.type = 9 THEN 7
WHEN sp.type = 11 THEN 8
ELSE sch.companyid
END) AS testCompId
        FROM smg_charges sch
        LEFT JOIN smg_programs sp ON sp.programid = sch.programid
        LEFT JOIN smg_users su ON su.userid = sch.agentid
        WHERE sch.agentid = #variables.intlAgentId#
        <cfif form.selectPrograms IS NOT 'Select All'>
            AND (
                <cfloop list="#form.selectPrograms#" index="progId">
                    <cfif progId EQ 0>
                        sch.programid = 0
                        <cfelse>
                        sch.programid = #progId#
                    </cfif>
                    <cfif progId IS NOT #listLast(form.selectPrograms)#>
                        OR
                    </cfif>
                </cfloop>)
            <cfelse>
                AND (sch.programid = 0 OR
                <cfloop query="getPrograms">
                    sch.programid = #getPrograms.programid#
                    <cfif getPrograms.currentRow NEQ getPrograms.recordCount>
                        OR
                    </cfif>
                </cfloop>)
        </cfif>
        GROUP BY testCompId HAVING testCompId = #indexCompId#
        UNION ALL
        SELECT sch.agentid, su.businessname, sch.programid, IFNULL(SUM(spc.amountapplied)*-1,0) AS total,  
(CASE 
WHEN sp.type = 7 THEN 7
WHEN sp.type = 8 THEN 7
WHEN sp.type = 9 THEN 7
WHEN sp.type = 11 THEN 8
ELSE sch.companyid
END) AS testCompId
        FROM smg_payment_charges spc
        LEFT JOIN smg_charges sch ON sch.chargeid = spc.chargeid
        LEFT JOIN smg_programs sp ON sp.programid = sch.programid
        LEFT JOIN smg_users su ON su.userid = sch.agentid
        WHERE  sch.agentid = #variables.intlAgentId#
        <cfif form.selectPrograms IS NOT 'Select All'>
            AND (
                <cfloop list="#form.selectPrograms#" index="progId">
                    <cfif progId EQ 0>
                        sch.programid = 0
                        <cfelse>
                        sch.programid = #progId#
                    </cfif>
                    <cfif progId IS NOT #listLast(form.selectPrograms)#>
                        OR
                    </cfif>
                </cfloop>)
            <cfelse>
                AND (sch.programid = 0 OR
                <cfloop query="getPrograms">
                    sch.programid = #getPrograms.programid#
                    <cfif getPrograms.currentRow NEQ getPrograms.recordCount>
                        OR
                    </cfif>
                </cfloop>)
        </cfif>
        GROUP BY testCompId HAVING testCompId = #indexCompId#
        UNION ALL
        SELECT sc.agentid, su.businessname, sch.programid, IFNULL(SUM(sc.amount - sc.amount_applied)* -1,0) AS total, 
(CASE 
WHEN sp.type = 7 THEN 7
WHEN sp.type = 8 THEN 7
WHEN sp.type = 9 THEN 7
WHEN sp.type = 11 THEN 8
ELSE sc.companyid
END) AS testCompId
        FROM smg_credit sc
        LEFT JOIN smg_charges sch ON sch.chargeid = sc.chargeid
        LEFT JOIN smg_programs sp ON sp.programid = sch.programid
        LEFT JOIN smg_users su ON su.userid = sc.agentid
        WHERE sc.active =1
        AND sc.agentid = #variables.intlAgentId#
        <cfif form.selectPrograms IS NOT 'Select All'>
            AND (
            <cfloop list="#form.selectPrograms#" index="progId">
                <cfif progId EQ 0>
                    sch.programid IS NULL
                    <cfelse>
                    sch.programid = #progId#
                </cfif>
                <cfif progId IS NOT #listLast(form.selectPrograms)#>
                    OR
                </cfif>
            </cfloop>)
            <cfelse>
                AND (sch.programid IS NULL OR
                <cfloop query="getPrograms">
                    sch.programid = #getPrograms.programid#
                    <cfif getPrograms.currentRow NEQ getPrograms.recordCount>
                        OR
                    </cfif>
                </cfloop>)
        </cfif>
        GROUP BY testCompId HAVING testCompId = #indexCompId#
        ) t
        GROUP BY t.agentid    
        </cfquery>
        
        <cfif getBalancePerAgentReceivable.recordCount NEQ 0>          
    
            <cfswitch expression="#indexCompId#">
                <cfcase value="1">
                    <cfset redBal = #getBalancePerAgentReceivable.totalPerAgent#>
                    <cfset totalRedBal = #variables.totalRedBal# + #variables.redBal#>
                </cfcase>
                <cfcase value="2">
                    <cfset blueBal = #getBalancePerAgentReceivable.totalPerAgent#>
                    <cfset totalBlueBal = #variables.totalBlueBal# + #variables.BlueBal#>
                </cfcase>
                <cfcase value="3">
                    <cfset greenBal = #getBalancePerAgentReceivable.totalPerAgent#>
                    <cfset totalGreenBal = #variables.totalGreenBal# + #variables.GreenBal#>
                </cfcase>
                <cfcase value="4">
                    <cfset yellowBal = #getBalancePerAgentReceivable.totalPerAgent#>
                    <cfset totalYellowBal = #variables.totalYellowBal# + #variables.YellowBal#>
                </cfcase>
                <cfcase value="5">
                    <cfset smgBal = #getBalancePerAgentReceivable.totalPerAgent#>
                    <cfset totalSmgBal = #variables.totalSmgBal# + #variables.smgBal#>
                </cfcase>
                <cfcase value="7">
                    <cfset traineeBal = #getBalancePerAgentReceivable.totalPerAgent#>
                    <cfset totalTraineeBal = #variables.totalTraineeBal# + #variables.TraineeBal#>
                </cfcase>
                <cfcase value="8">
                    <cfset wandtBal = #getBalancePerAgentReceivable.totalPerAgent#>
                    <cfset totalWandtBal = #variables.totalWandtBal# + #variables.WandtBal#>
                </cfcase>
                <cfcase value="9">
                    <cfset h2bBal = #getBalancePerAgentReceivable.totalPerAgent#>
                    <cfset totalH2bBal = #variables.totalH2bBal# + #variables.H2bBal#>
                </cfcase>
            </cfswitch>
        
        </cfif>
    
    </cfloop>
            
    <cfset grandTotalBal = #variables.grandTotalBal# + #getAgentsReceivable.totalPerAgent#>
            
    <tr <cfif getAgentsReceivable.currentRow MOD 2>bgcolor="##FFFFFF"</cfif>>
    	<cfif NOT ISDEFINED('form.printFormat')>
            <td align="center">
                <cfinput name="email#getAgentsReceivable.agentid#" id="email#getAgentsReceivable.agentid#" type="checkbox" checked="yes" align="absmiddle">
            </td>
        </cfif>
        <td class="two">#getAgentsReceivable.businessname# (###getAgentsReceivable.agentid#)</td> 
        <td class="two <cfif variables.redBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.redBal)#</td>
        <td class="two <cfif variables.blueBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.blueBal)#</td>
        <td class="two <cfif variables.greenBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.greenBal)#</td>
        <td class="two <cfif variables.yellowBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.yellowBal)#</td>
        <td class="two <cfif variables.smgBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.smgBal)#</td>
        <td class="two <cfif variables.traineeBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.traineeBal)#</td>
        <td class="two <cfif variables.wandtBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.wandtBal)#</td>
        <td class="two <cfif variables.h2bBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.h2bBal)#</td>
        <td class="two <cfif getAgentsReceivable.totalPerAgent LT 0>style1</cfif>">#LsCurrencyFormat(getAgentsReceivable.totalPerAgent)#</td>
    </tr>

</cfoutput>

<cfoutput>

    <tr class="darkBlue">
    	<cfif NOT ISDEFINED('form.printFormat')>
    		<td></td>
        </cfif>
        <td class="right">TOTAL</td>
        <td class="right">#LsCurrencyFormat(variables.totalRedBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalBlueBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalGreenBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalYellowBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalSmgBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalTraineeBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalWandtBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalH2bBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.grandTotalBal)#</td>
    </tr>

</cfoutput>

</table>

</cfif>

<br/>
<strong><small>REFUNDS DUE</small></strong>
<br/>

<cfif getAgentsRefund.recordCount EQ 0>
	<small>There are not refunds due for the selected programs</small>
	<cfabort>
</cfif>

<table class="frame">

    <tr class="darkBlue">
    	<td></td>
        <td class="right">AGENT</td>
        <td class="right">RED</td>
        <td class="right">BLUE</td>
        <td class="right">GREEN</td>
        <td class="right">YELLOW</td>
        <td class="right">SMG</td>
        <td class="right">TRAINEE</td>
        <td class="right" width="5%">W & T</td>
        <td class="right">H2B</td>
        <td class="right">TOTAL</td>
    </tr>    

<cfset totalRedBal =0>
<cfset totalBlueBal =0>
<cfset totalGreenBal =0>
<cfset totalYellowBal =0>
<cfset totalSmgBal =0>
<cfset totalTraineeBal =0>
<cfset totalWandtBal =0>
<cfset totalH2bBal =0>
<cfset getBalancePerAgent.totalPerAgent =0>
<cfset grandTotalBal =0>   

<cfoutput query="getAgentsRefund">

    <cfset intlAgentId = #getAgentsRefund.agentid#>
        
    <cfset redBal = 0>
    <cfset blueBal = 0>
    <cfset greenBal = 0>
    <cfset yellowBal = 0>
    <cfset smgBal = 0>
    <cfset traineeBal = 0>
    <cfset wandtBal = 0>
    <cfset h2bBal = 0>            

    <cfloop index="indexCompId" list="1,2,3,4,5,6,7,8,9">
    
        <cfquery name="getBalancePerAgentRefund" datasource="MySQL"> 
        SELECT t.agentid, t.businessname, SUM(t.total) AS totalPerAgent
        FROM (
        SELECT sch.agentid, su.businessname, sch.programid, IFNULL(SUM(sch.amount_due),0) AS total, (CASE 
WHEN sp.type = 7 THEN 7
WHEN sp.type = 8 THEN 7
WHEN sp.type = 9 THEN 7
WHEN sp.type = 11 THEN 8
ELSE sch.companyid
END) AS testCompId
        FROM smg_charges sch
        LEFT JOIN smg_programs sp ON sp.programid = sch.programid
        LEFT JOIN smg_users su ON su.userid = sch.agentid
        WHERE sch.agentid = #variables.intlAgentId#
        <cfif form.selectPrograms IS NOT 'Select All'>
            AND (
                <cfloop list="#form.selectPrograms#" index="progId">
                    <cfif progId EQ 0>
                        sch.programid = 0
                        <cfelse>
                        sch.programid = #progId#
                    </cfif>
                    <cfif progId IS NOT #listLast(form.selectPrograms)#>
                        OR
                    </cfif>
                </cfloop>)
            <cfelse>
                AND (sch.programid = 0 OR
                <cfloop query="getPrograms">
                    sch.programid = #getPrograms.programid#
                    <cfif getPrograms.currentRow NEQ getPrograms.recordCount>
                        OR
                    </cfif>
                </cfloop>)
        </cfif>
        GROUP BY testCompId HAVING testCompId = #indexCompId#
        UNION ALL
        SELECT sch.agentid, su.businessname, sch.programid, IFNULL(SUM(spc.amountapplied)*-1,0) AS total,  
(CASE 
WHEN sp.type = 7 THEN 7
WHEN sp.type = 8 THEN 7
WHEN sp.type = 9 THEN 7
WHEN sp.type = 11 THEN 8
ELSE sch.companyid
END) AS testCompId
        FROM smg_payment_charges spc
        LEFT JOIN smg_charges sch ON sch.chargeid = spc.chargeid
        LEFT JOIN smg_programs sp ON sp.programid = sch.programid
        LEFT JOIN smg_users su ON su.userid = sch.agentid
        WHERE  sch.agentid = #variables.intlAgentId#
        <cfif form.selectPrograms IS NOT 'Select All'>
            AND (
                <cfloop list="#form.selectPrograms#" index="progId">
                    <cfif progId EQ 0>
                        sch.programid = 0
                        <cfelse>
                        sch.programid = #progId#
                    </cfif>
                    <cfif progId IS NOT #listLast(form.selectPrograms)#>
                        OR
                    </cfif>
                </cfloop>)
            <cfelse>
                AND (sch.programid = 0 OR
                <cfloop query="getPrograms">
                    sch.programid = #getPrograms.programid#
                    <cfif getPrograms.currentRow NEQ getPrograms.recordCount>
                        OR
                    </cfif>
                </cfloop>)
        </cfif>
        GROUP BY testCompId HAVING testCompId = #indexCompId#
        UNION ALL
        SELECT sc.agentid, su.businessname, sch.programid, IFNULL(SUM(sc.amount - sc.amount_applied)* -1,0) AS total, 
(CASE 
WHEN sp.type = 7 THEN 7
WHEN sp.type = 8 THEN 7
WHEN sp.type = 9 THEN 7
WHEN sp.type = 11 THEN 8
ELSE sc.companyid
END) AS testCompId
        FROM smg_credit sc
        LEFT JOIN smg_charges sch ON sch.chargeid = sc.chargeid
        LEFT JOIN smg_programs sp ON sp.programid = sch.programid
        LEFT JOIN smg_users su ON su.userid = sc.agentid
        WHERE sc.active =1
        AND sc.agentid = #variables.intlAgentId#
        <cfif form.selectPrograms IS NOT 'Select All'>
            AND (
            <cfloop list="#form.selectPrograms#" index="progId">
                <cfif progId EQ 0>
                    sch.programid IS NULL
                    <cfelse>
                    sch.programid = #progId#
                </cfif>
                <cfif progId IS NOT #listLast(form.selectPrograms)#>
                    OR
                </cfif>
            </cfloop>)
            <cfelse>
                AND (sch.programid IS NULL OR
                <cfloop query="getPrograms">
                    sch.programid = #getPrograms.programid#
                    <cfif getPrograms.currentRow NEQ getPrograms.recordCount>
                        OR
                    </cfif>
                </cfloop>)
        </cfif>
        GROUP BY testCompId HAVING testCompId = #indexCompId#
        ) t
        GROUP BY t.agentid    
        </cfquery>
        
        <cfif getBalancePerAgentRefund.recordCount NEQ 0>          
    
            <cfswitch expression="#indexCompId#">
                <cfcase value="1">
                    <cfset redBal = #getBalancePerAgentRefund.totalPerAgent#>
                    <cfset totalRedBal = #variables.totalRedBal# + #variables.redBal#>
                </cfcase>
                <cfcase value="2">
                    <cfset blueBal = #getBalancePerAgentRefund.totalPerAgent#>
                    <cfset totalBlueBal = #variables.totalBlueBal# + #variables.BlueBal#>
                </cfcase>
                <cfcase value="3">
                    <cfset greenBal = #getBalancePerAgentRefund.totalPerAgent#>
                    <cfset totalGreenBal = #variables.totalGreenBal# + #variables.GreenBal#>
                </cfcase>
                <cfcase value="4">
                    <cfset yellowBal = #getBalancePerAgentRefund.totalPerAgent#>
                    <cfset totalYellowBal = #variables.totalYellowBal# + #variables.YellowBal#>
                </cfcase>
                <cfcase value="5">
                    <cfset smgBal = #getBalancePerAgentRefund.totalPerAgent#>
                    <cfset totalSmgBal = #variables.totalSmgBal# + #variables.smgBal#>
                </cfcase>
                <cfcase value="7">
                    <cfset traineeBal = #getBalancePerAgentRefund.totalPerAgent#>
                    <cfset totalTraineeBal = #variables.totalTraineeBal# + #variables.TraineeBal#>
                </cfcase>
                <cfcase value="8">
                    <cfset wandtBal = #getBalancePerAgentRefund.totalPerAgent#>
                    <cfset totalWandtBal = #variables.totalWandtBal# + #variables.WandtBal#>
                </cfcase>
                <cfcase value="9">
                    <cfset h2bBal = #getBalancePerAgentRefund.totalPerAgent#>
                    <cfset totalH2bBal = #variables.totalH2bBal# + #variables.H2bBal#>
                </cfcase>
            </cfswitch>
        
        </cfif>
    
    </cfloop>
            
    <cfset grandTotalBal = #variables.grandTotalBal# + #getAgentsRefund.totalPerAgent#>
            
    <tr <cfif getAgentsRefund.currentRow MOD 2>bgcolor="##FFFFFF"</cfif>>
    	<td></td>
        <td class="two">#getAgentsRefund.businessname# (###getAgentsRefund.agentid#)</td> 
        <td class="two <cfif variables.redBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.redBal)#</td>
        <td class="two <cfif variables.blueBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.blueBal)#</td>
        <td class="two <cfif variables.greenBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.greenBal)#</td>
        <td class="two <cfif variables.yellowBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.yellowBal)#</td>
        <td class="two <cfif variables.smgBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.smgBal)#</td>
        <td class="two <cfif variables.traineeBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.traineeBal)#</td>
        <td class="two <cfif variables.wandtBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.wandtBal)#</td>
        <td class="two <cfif variables.h2bBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.h2bBal)#</td>
        <td class="two <cfif getAgentsRefund.totalPerAgent LT 0>style1</cfif>">#LsCurrencyFormat(getAgentsRefund.totalPerAgent)#</td>
    </tr>

</cfoutput>

<cfoutput>

    <tr class="darkBlue">
    	<td></td>
        <td class="right">TOTAL</td>
        <td class="right">#LsCurrencyFormat(variables.totalRedBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalBlueBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalGreenBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalYellowBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalSmgBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalTraineeBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalWandtBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalH2bBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.grandTotalBal)#</td>
    </tr>

</cfoutput>

</table>

</cfform>

</body>
</html>
