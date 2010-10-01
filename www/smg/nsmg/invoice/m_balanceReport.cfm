
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Balance Report Per Program, includes Credit Notes</title>

<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfsetting requesttimeout="9999">

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

<cfparam name="FORM.selectPrograms" default="0">

<cfscript>

	qTotalAgentBalance = APPCFC.INVOICE.totalAgentBalance(programChoice = FORM.selectPrograms);						<!--- returns total balance per agent --->
	qTotalAgentRefund = APPCFC.INVOICE.totalAgentBalance(programChoice = FORM.selectPrograms, balanceType = 0);		<!--- returns total balance per agent per program --->

</cfscript>

<cfquery name="getPrograms" datasource="MySQL">
SELECT 
	*
FROM 
	smg_programs
WHERE
	companyID IN (1,7,8,9,10,12)
AND
	type NOT IN (6,10,13,14,15,16,17,18,19,20,21)
ORDER BY 
	companyid, 
	startdate DESC
</cfquery>

<body>

<cfif NOT ISDEFINED('form.submitted')>
<div align="center">
<strong><small>Outstanding Balances Report</small></strong>
    <cfform>
        
        <cfinput type="hidden" name="submitted">
    
        <select name="selectPrograms" multiple="multiple" size="30">
            <option value="All" selected="selected">Select All</option>
            <option value="0">Charges not related to a program</option>
            <cfoutput query="getPrograms">
                <cfswitch expression="#companyid#">
                    <cfcase value="1"><cfset compId = 'High School'></cfcase>
<!---                     <cfcase value="2"><cfset compId = 'MARGARITA'></cfcase>
                    <cfcase value="3"><cfset compId = 'DIANA'></cfcase>
                    <cfcase value="4"><cfset compId = 'GARY'></cfcase>
                    <cfcase value="12"><cfset compId = 'BRIAN'></cfcase> --->
                    <cfcase value="7"><cfset compId = 'Trainee'></cfcase>
                    <cfcase value="8"><cfset compId = 'W&T'></cfcase>
                    <cfcase value="9"><cfset compId = 'H2B'></cfcase>
					<cfcase value="10"><cfset compId = 'CASE'></cfcase>
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

<cfoutput>
<div align="center"><h2>Outstanding balances as of #DateFormat(now(), 'mm-dd-yyyy')# at #TimeFormat(now(),'h:mm:ss tt')#<br></h2></div>
</cfoutput>

<strong><small>Programs Selected:</small></strong><br/>

<cfloop list="#form.selectPrograms#" index="programsSelected">

    <cfif programsSelected IS "All">
    
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
                    <cfcase value="1"><cfset compId = 'High School'></cfcase>
                    <cfcase value="2"><cfset compId = 'MARGARITA'></cfcase>
                    <cfcase value="3"><cfset compId = 'DIANA'></cfcase>
                    <cfcase value="4"><cfset compId = 'GARY'></cfcase>
                    <cfcase value="12"><cfset compId = 'BRIAN'></cfcase>
                    <cfcase value="7"><cfset compId = 'Trainee'></cfcase>
                    <cfcase value="8"><cfset compId = 'W&T'></cfcase>
                    <cfcase value="9"><cfset compId = 'H2B'></cfcase>
					<cfcase value="10"><cfset compId = 'CASE'></cfcase>
                </cfswitch>
                
                <small>#variables.compId# - #getProgramsSelected.programname# (###getProgramsSelected.programid#)</small> <br/>
                
                </cfoutput>
        
    </cfif>
    
</cfloop>


<!--- <cfif form.selectPrograms IS NOT "All" AND form.selectPrograms NEQ 0>

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
<cfloop query="qTotalAgentBalance">
	<cfset aEmailAgent = #arrayAppend(arrayEmailAgent, "#qTotalAgentBalance.agentid#")#>
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
        <cfinput type="image" name="sendEmail" src="../pics/send-email.gif">
    </div>
</cfif>

<br/><br/>

<strong><small>RECEIVABLES</small></strong>
<br/>

<cfif qTotalAgentBalance.recordCount EQ 0>
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
        <td class="right">WILLIAM</td>
        <td class="right">MARGARITA</td>
        <td class="right">DIANA</td>
        <td class="right">GARY</td>
        <td class="right">BRIAN</td>
        <td class="right">SMG</td>
        <td class="right">TRAINEE</td>
        <td class="right" width="5%">W & T</td>
        <td class="right">H2B</td>
        <td class="right">CASE</td>
        <td class="right">TOTAL</td>
    </tr>    

<cfparam name="totaliseBal" default="0">
<cfparam name="totalBlueBal" default="0">
<cfparam name="totalGreenBal" default="0">
<cfparam name="totalYellowBal" default="0">
<cfparam name="totalBrianBal" default="0">
<cfparam name="totalSmgBal" default="0">
<cfparam name="totalTraineeBal" default="0">
<cfparam name="totalWandtBal" default="0">
<cfparam name="totalH2bBal" default="0">
<cfparam name="totalCASEBal" default="0"> 
<cfparam name="getBalancePerAgent.totalPerAgent" default="0">    
<cfparam name="grandTotalBal" default="0">

<cfoutput query="qTotalAgentBalance">

    <cfinput type="hidden" name="agentId" value="#qTotalAgentBalance.agentid#">
    <cfinput type="hidden" name="balPerAgent#qTotalAgentBalance.agentid#" value="#qTotalAgentBalance.totalPerAgent#">    
    <cfset intlAgentId = #qTotalAgentBalance.agentid#>
        
    <cfset iseBal = 0>
    <cfset blueBal = 0>
    <cfset greenBal = 0>
    <cfset yellowBal = 0>
    <cfset brianBal = 0>
    <cfset smgBal = 0>
    <cfset traineeBal = 0>
    <cfset wandtBal = 0>
    <cfset h2bBal = 0>
	<cfset caseBal = 0>            

    <cfloop index="indexCompId" list="1,2,3,4,5,6,7,8,9,10,12">
    
    	<!--- query qProgramBalance returns the balance per agent per program --->
		<cfscript>
			qProgramBalance = APPCFC.INVOICE.programBalance(agentId = qTotalAgentBalance.agentId, programChoice = FORM.selectPrograms, companyId = indexCompId);
		</cfscript>
        
        <cfif qProgramBalance.recordCount NEQ 0>          
    
            <cfswitch expression="#indexCompId#">
                <cfcase value="1">
                    <cfset iseBal = #qProgramBalance.totalPerAgent#>
                    <cfset totaliseBal = #variables.totaliseBal# + #variables.iseBal#>
                </cfcase>
                <cfcase value="2">
                    <cfset blueBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalBlueBal = #variables.totalBlueBal# + #variables.BlueBal#>
                </cfcase>
                <cfcase value="3">
                    <cfset greenBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalGreenBal = #variables.totalGreenBal# + #variables.GreenBal#>
                </cfcase>
                <cfcase value="4">
                    <cfset yellowBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalYellowBal = #variables.totalYellowBal# + #variables.YellowBal#>
                </cfcase>
                <cfcase value="12">
                    <cfset brianBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalbrianBal = #variables.totalbrianBal# + #variables.brianBal#>
                </cfcase>
                <cfcase value="5">
                    <cfset smgBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalSmgBal = #variables.totalSmgBal# + #variables.smgBal#>
                </cfcase>
                <cfcase value="7">
                    <cfset traineeBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalTraineeBal = #variables.totalTraineeBal# + #variables.TraineeBal#>
                </cfcase>
                <cfcase value="8">
                    <cfset wandtBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalWandtBal = #variables.totalWandtBal# + #variables.WandtBal#>
                </cfcase>
                <cfcase value="9">
                    <cfset h2bBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalH2bBal = #variables.totalH2bBal# + #variables.H2bBal#>
                </cfcase>
                <cfcase value="10">
                    <cfset caseBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalCaseBal = #variables.totalCaseBal# + #variables.CaseBal#>
                </cfcase>
            </cfswitch>
    
        </cfif>
    
    </cfloop>
            
    <cfset grandTotalBal = #variables.grandTotalBal# + #qTotalAgentBalance.totalPerAgent#>
            
    <tr <cfif qTotalAgentBalance.currentRow MOD 2>bgcolor="##FFFFFF"</cfif>>
    	<cfif NOT ISDEFINED('form.printFormat')>
            <td align="center">
                <cfinput name="email#qTotalAgentBalance.agentid#" id="email#qTotalAgentBalance.agentid#" type="checkbox" checked="yes" align="absmiddle">
            </td>
        </cfif>
        <td class="two">#qTotalAgentBalance.businessname# (#qTotalAgentBalance.agentid#)</td> 
        <td class="two <cfif variables.iseBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.iseBal)#</td>
        <td class="two <cfif variables.blueBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.blueBal)#</td>
        <td class="two <cfif variables.greenBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.greenBal)#</td>
        <td class="two <cfif variables.yellowBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.yellowBal)#</td>
        <td class="two <cfif variables.brianBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.brianBal)#</td>
        <td class="two <cfif variables.smgBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.smgBal)#</td>
        <td class="two <cfif variables.traineeBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.traineeBal)#</td>
        <td class="two <cfif variables.wandtBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.wandtBal)#</td>
        <td class="two <cfif variables.h2bBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.h2bBal)#</td>
        <td class="two <cfif variables.caseBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.caseBal)#</td>
        <td class="two <cfif qTotalAgentBalance.totalPerAgent LT 0>style1</cfif>">#LsCurrencyFormat(qTotalAgentBalance.totalPerAgent)#</td>
    </tr>

</cfoutput>

<cfoutput>

    <tr class="darkBlue">
    	<cfif NOT ISDEFINED('form.printFormat')>
    		<td></td>
        </cfif>
        <td class="right">TOTAL</td>
        <td class="right">#LsCurrencyFormat(variables.totaliseBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalBlueBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalGreenBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalYellowBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalbrianBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalSmgBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalTraineeBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalWandtBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalH2bBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalCaseBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.grandTotalBal)#</td>
    </tr>

</cfoutput>

</table>

</cfif>

<br/>
<strong><small>REFUNDS DUE</small></strong>
<br/>

<cfif qTotalAgentRefund.recordCount EQ 0>
	<small>There are not refunds due for the selected programs</small>
	<cfabort>
</cfif>

<table class="frame">

    <tr class="darkBlue">
        <td class="right">AGENT</td>
        <td class="right">WILLIAM</td>
        <td class="right">MARGARITA</td>
        <td class="right">DIANA</td>
        <td class="right">GARY</td>
        <td class="right">BRIAN</td>
        <td class="right">SMG</td>
        <td class="right">TRAINEE</td>
        <td class="right" width="5%">W & T</td>
        <td class="right">H2B</td>
        <td class="right">CASE</td>
        <td class="right">TOTAL</td>
    </tr>    

<cfset totaliseBal =0>
<cfset totalBlueBal =0>
<cfset totalGreenBal =0>
<cfset totalYellowBal =0>
<cfset totalbrianBal =0>
<cfset totalSmgBal =0>
<cfset totalTraineeBal =0>
<cfset totalWandtBal =0>
<cfset totalH2bBal =0>
<cfset totalCaseBal =0>
<cfset getBalancePerAgent.totalPerAgent =0>
<cfset grandTotalBal =0>   

<cfoutput query="qTotalAgentRefund">

    <cfset intlAgentId = #qTotalAgentRefund.agentid#>
        
    <cfset iseBal = 0>
    <cfset blueBal = 0>
    <cfset greenBal = 0>
    <cfset yellowBal = 0>
    <cfset brianBal = 0>
    <cfset smgBal = 0>
    <cfset traineeBal = 0>
    <cfset wandtBal = 0>
    <cfset h2bBal = 0>
    <cfset caseBal = 0>         

    <cfloop index="indexCompId" list="1,2,3,4,5,6,7,8,9,10,12">
    
    	<!--- query qProgramBalance returns the balance per agent per program --->
		<cfscript>
			qProgramBalance = APPCFC.INVOICE.programBalance(agentId = qTotalAgentBalance.agentId, programChoice = FORM.selectPrograms, companyId = indexCompId);
		</cfscript>
        
        <cfif qProgramBalance.recordCount NEQ 0>          
    
            <cfswitch expression="#indexCompId#">
                <cfcase value="1">
                    <cfset iseBal = #qProgramBalance.totalPerAgent#>
                    <cfset totaliseBal = #variables.totaliseBal# + #variables.iseBal#>
                </cfcase>
                <cfcase value="2">
                    <cfset blueBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalBlueBal = #variables.totalBlueBal# + #variables.BlueBal#>
                </cfcase>
                <cfcase value="3">
                    <cfset greenBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalGreenBal = #variables.totalGreenBal# + #variables.GreenBal#>
                </cfcase>
                <cfcase value="4">
                    <cfset yellowBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalYellowBal = #variables.totalYellowBal# + #variables.YellowBal#>
                </cfcase>
                <cfcase value="12">
                    <cfset brianBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalbrianBal = #variables.totalbrianBal# + #variables.brianBal#>
                </cfcase>
                <cfcase value="5">
                    <cfset smgBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalSmgBal = #variables.totalSmgBal# + #variables.smgBal#>
                </cfcase>
                <cfcase value="7">
                    <cfset traineeBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalTraineeBal = #variables.totalTraineeBal# + #variables.TraineeBal#>
                </cfcase>
                <cfcase value="8">
                    <cfset wandtBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalWandtBal = #variables.totalWandtBal# + #variables.WandtBal#>
                </cfcase>
                <cfcase value="9">
                    <cfset h2bBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalH2bBal = #variables.totalH2bBal# + #variables.H2bBal#>
                </cfcase>
                <cfcase value="10">
                    <cfset caseBal = #qProgramBalance.totalPerAgent#>
                    <cfset totalCaseBal = #variables.totalCaseBal# + #variables.caseBal#>
                </cfcase>
            </cfswitch>
        
        </cfif>
    
    </cfloop>
            
    <cfset grandTotalBal = #variables.grandTotalBal# + #qTotalAgentRefund.totalPerAgent#>
            
    <tr <cfif qTotalAgentRefund.currentRow MOD 2>bgcolor="##FFFFFF"</cfif>>
        <td class="two">#qTotalAgentRefund.businessname# (#qTotalAgentRefund.agentid#)</td> 
        <td class="two <cfif variables.iseBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.iseBal)#</td>
        <td class="two <cfif variables.blueBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.blueBal)#</td>
        <td class="two <cfif variables.greenBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.greenBal)#</td>
        <td class="two <cfif variables.yellowBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.yellowBal)#</td>
        <td class="two <cfif variables.brianBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.brianBal)#</td>
        <td class="two <cfif variables.smgBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.smgBal)#</td>
        <td class="two <cfif variables.traineeBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.traineeBal)#</td>
        <td class="two <cfif variables.wandtBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.wandtBal)#</td>
        <td class="two <cfif variables.h2bBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.h2bBal)#</td>
        <td class="two <cfif variables.caseBal LT 0>style1</cfif>">#LsCurrencyFormat(variables.caseBal)#</td>
        <td class="two <cfif qTotalAgentRefund.totalPerAgent LT 0>style1</cfif>">#LsCurrencyFormat(qTotalAgentRefund.totalPerAgent)#</td>
    </tr>

</cfoutput>

<cfoutput>

    <tr class="darkBlue">
        <td class="right">TOTAL</td>
        <td class="right">#LsCurrencyFormat(variables.totaliseBal)#</td>
       <td class="right">#LsCurrencyFormat(variables.totalBlueBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalGreenBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalYellowBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalbrianBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalSmgBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalTraineeBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalWandtBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalH2bBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.totalCaseBal)#</td>
        <td class="right">#LsCurrencyFormat(variables.grandTotalBal)#</td>
    </tr>

</cfoutput>

</table>

</cfform>

</body>
</html>