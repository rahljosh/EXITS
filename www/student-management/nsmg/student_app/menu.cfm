<cfparam name="url.id" default="0">
<cfparam name="url.p" default="0">

<style type="text/css">
body {
	font: 11px tahoma;
	background: #ffffff;
	margin: 0;
}    
</style>

<link rel="stylesheet" type="text/css" href="menu.css">

<script type="text/javascript" src="ie5.js"></script>
<script type="text/javascript" src="DropDownMenuX.js"></script>

<cfinclude template="querys/get_latest_status.cfm">

<!--- print version if app has been submitted  --->
<cfif (client.usertype EQ 10 AND (get_latest_status.status GTE 3 AND get_latest_status.status NEQ 4 AND get_latest_status.status NEQ 6))  <!--- STUDENT ---->
	OR (client.usertype EQ 11 AND (get_latest_status.status GTE 4 AND get_latest_status.status NEQ 6))  <!--- BRANCH ---->
	OR (client.usertype EQ 8 AND (get_latest_status.status GTE 6 AND get_latest_status.status NEQ 9)) <!--- INTL. AGENT ---->
	OR (client.usertype GTE 5 AND client.usertype LTE 7 OR client.usertype EQ 9)> <!--- FIELD --->
    <!--- Office users should be able to edit online apps --->
    <!--- OR (client.usertype LTE 4 AND get_latest_status.status GTE 7) <!--- OFFICE USERS ---> --->
	<cfset print = 'print'>
<cfelse>
	<cfset print = ''>
</cfif>

<cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border="0" id="menu1" bgcolor=<Cfif client.companyid eq 11>"##f7941d" <cfelse>"#bgcolor#"</cfif>>
	<tr>
		<td height=31 width=13 background="pics/menuback.gif"></td>
        <td width="75" background="pics/menuback.gif">
            <a class="item1" href="?curdoc=initial_welcome" onClick="return CheckLink();"><cfif url.curdoc EQ "initial_welcome" AND url.id EQ '0'><img border="0" src="pics/menuhomeselected.gif"><cfelse><img border="0" src="pics/menuhome.gif"></cfif></a>
        </td>
        <td width="142" background="pics/menuback.gif">
            <a class="item1" href="?curdoc=section1&id=1" onClick="return CheckLink();"><cfif url.id EQ '1'><img border="0" src="pics/menu1selected.gif"><cfelse><img border="0" src="pics/menu1.gif"></cfif></a>
        </td>
        <td width="170" background="pics/menuback.gif">
            <a class="item1" href="?curdoc=section2&id=2" onClick="return CheckLink();"><cfif url.id EQ '2'><img border="0" src="pics/menu2selected.gif"><cfelse><img border="0" src="pics/menu2.gif"></cfif></a>
        </td>
        <td  width="150" background="pics/menuback.gif">
            <a class="item1" href="?curdoc=section3&id=3" onClick="return CheckLink();"><cfif url.id EQ '3'><img border="0" src="pics/menu3selected.gif"><cfelse><img border="0" src="pics/menu3.gif"></cfif></a>
        </td>
        <td  width="75" background="pics/menuback.gif">
            <a class="item1" href="?curdoc=section4&id=4" onClick="return CheckLink();"><cfif url.id EQ '4'><img border="0" src="pics/menu4selected.gif"><cfelse><img border="0" src="pics/menu4.gif"></cfif></a>
        </td>
		<td width="90"  background="pics/menuback.gif">
            <a class="item1" href="?curdoc=check_list&id=cl" onClick="return CheckLink();"><cfif url.id EQ 'cl'><img border="0" src="pics/menu5selected.gif"><cfelse><img border="0" src="pics/menu5.gif"></cfif></a>
		</td>
		<td  width="108" background="pics/menuback.gif">
            <a class="item1" href="?curdoc=printoptions&id=pr" onClick="return CheckLink();"><cfif url.id EQ 'pr'><img border="0" src="pics/menu6selected.gif"><cfelse><img border="0" src="pics/menu6.gif"></cfif></a>
		</td>
		<td  width="79" background="pics/menuback.gif">
            <a class="item1" href="?curdoc=support&id=su" onClick="return CheckLink();"><cfif url.id EQ 'su'><img border="0" src="pics/menu7selected.gif"><cfelse><img border="0" src="pics/menu7.gif"></cfif></a>
		</td>
		<td width="100%" background="pics/menuback.gif"></td>
    </tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border="0" id="menu1" align="center">
	<cfif url.id EQ '1'>
	<tr>
		<cfif url.p EQ '1'>
			<td align="center" class="selected menuline"><a class="item2" href="?curdoc=section1/page1#print#&id=1&p=1" onClick="return CheckLink();"><div class="selectedlink">Page [01] &nbsp; Student's Information </div></a></td>
		<cfelse>
			<td align="center" class="ddmx menuline"><a class="item2" href="?curdoc=section1/page1#print#&id=1&p=1" onClick="return CheckLink();">Page [01] &nbsp; Student's Information </a></td>
		</cfif>
		<cfif url.p EQ '2'>
			<td align="center" class="selected menuline"><a class="item2" href="?curdoc=section1/page2#print#&id=1&p=2" onClick="return CheckLink();"><div class="selectedlink">Page [02] &nbsp; Brothers & Sisters </div></a></td>
		<cfelse>
			<td align="center" class="ddmx menuline"><a class="item2" href="?curdoc=section1/page2#print#&id=1&p=2" onClick="return CheckLink();">Page [02] &nbsp; Brothers & Sisters </a></td>
		</cfif>
		<cfif url.p EQ '3'>
			<td align="center" class="selected menuline"><a class="item2" href="?curdoc=section1/page3#print#&id=1&p=3" onClick="return CheckLink();"><div class="selectedlink">Page [03] &nbsp; Personal Data </div></a></td>
		<cfelse>
			<td align="center" class="ddmx menuline"><a class="item2" href="?curdoc=section1/page3#print#&id=1&p=3" onClick="return CheckLink();">Page [03] &nbsp; Personal Data </a></td>
		</cfif>
	</tr>
	<tr>
		<cfif url.p EQ '4'>
			<td align="center" class="selected"><a class="item2" href="?curdoc=section1/page4#print#&id=1&p=4" onClick="return CheckLink();"><div class="selectedlink">Page [04] &nbsp; Family Album </div></a></td>
		<cfelse>
			<td align="center" class="ddmx"><a class="item2" href="?curdoc=section1/page4#print#&id=1&p=4" onClick="return CheckLink();">Page [04] &nbsp; Family Album  </a></td>
		</cfif>			
		<cfif url.p EQ '5'>
			<td align="center" class="selected"><a class="item2" href="?curdoc=section1/page5#print#&id=1&p=5" onClick="return CheckLink();"><div class="selectedlink">Page [05] &nbsp; Student's Letter </div></a></td>
		<cfelse>
			<td align="center" class="ddmx"><a class="item2" href="?curdoc=section1/page5#print#&id=1&p=5" onClick="return CheckLink();">Page [05] &nbsp; Student's Letter </a></td>
		</cfif>			
		<cfif url.p EQ '6'>
			<td align="center" class="selected"><a class="item2" href="?curdoc=section1/page6#print#&id=1&p=6" onClick="return CheckLink();"><div class="selectedlink">Page [06] &nbsp; Parent's Letter </div></a></td>
		<cfelse>
			<td align="center" class="ddmx"><a class="item2" href="?curdoc=section1/page6#print#&id=1&p=6" onClick="return CheckLink();">Page [06] &nbsp; Parent's Letter </a></td>
		</cfif>
	</tr>
	</cfif>
    
	<cfif url.id EQ '2'>
	<tr>
		<cfif url.p EQ '7'>
			<td align="center" class="selected menuline"><a class="item2" href="?curdoc=section2/page7#print#&id=2&p=7" onClick="return CheckLink();"><div class="selectedlink">Page [07] &nbsp; School Information </div></a></td>
		<cfelse>
			<td align="center" class="ddmx menuline"><a class="item2" href="?curdoc=section2/page7#print#&id=2&p=7" onClick="return CheckLink();">Page [07] &nbsp; School Information </a></td>
		</cfif>
		<cfif url.p EQ '8'>
			<td align="center" class="selected"><a class="item2" href="?curdoc=section2/page8#print#&id=2&p=8" onClick="return CheckLink();"><div class="selectedlink">Page [08] &nbsp; Transcript of Grades </div></a></td>
		<cfelse>
			<td align="center" class="ddmx"><a class="item2" href="?curdoc=section2/page8#print#&id=2&p=8" onClick="return CheckLink();">Page [08] &nbsp; Transcript of Grades </a></td>
		</cfif>
		<cfif url.p EQ '9'>
			<td align="center" class="selected"><a class="item2" href="?curdoc=section2/page9#print#&id=2&p=9" onClick="return CheckLink();"><div class="selectedlink">Page [09] &nbsp; Language Evaluation </div></a></td>
		<cfelse>
			<td align="center" class="ddmx"><a class="item2" href="?curdoc=section2/page9#print#&id=2&p=9" onClick="return CheckLink();">Page [09] &nbsp; Language Evaluation </a></td>
		</cfif>	
		<cfif url.p EQ '10'>
			<td align="center" class="selected"><a class="item2" href="?curdoc=section2/page10#print#&id=2&p=10" onClick="return CheckLink();"><div class="selectedlink">Page [10] &nbsp; Social Skills </div></a></td>
		<cfelse>
			<td align="center" class="ddmx"><a class="item2" href="?curdoc=section2/page10#print#&id=2&p=10" onClick="return CheckLink();">Page [10] &nbsp; Social Skills </a></td>
		</cfif>	
	</tr>						
	</cfif>

	<cfif url.id EQ '3'>
	<tr>
		<cfif url.p EQ '11'>
			<td align="center" class="selected"><a class="item2" href="?curdoc=section3/page11#print#&id=3&p=11" onClick="return CheckLink();"><div class="selectedlink">Page [11] &nbsp; Medical History </div></a></td>
		<cfelse>
			<td align="center" class="ddmx"><a class="item2" href="?curdoc=section3/page11#print#&id=3&p=11" onClick="return CheckLink();">Page [11] &nbsp; Medical History </a></td>
		</cfif>			
		<cfif url.p EQ '12'>
			<td align="center" class="selected"><a class="item2" href="?curdoc=section3/page12#print#&id=3&p=12" onClick="return CheckLink();"><div class="selectedlink">Page [12] &nbsp; Clinical Evaluation </div></a></td>
		<cfelse>
			<td align="center" class="ddmx"><a class="item2" href="?curdoc=section3/page12#print#&id=3&p=12" onClick="return CheckLink();">Page [12] &nbsp; Clinical Evaluation </a></td>
		</cfif>		
		<cfif url.p EQ '13'>
			<td align="center" class="selected"><a class="item2" href="?curdoc=section3/page13#print#&id=3&p=13" onClick="return CheckLink();"><div class="selectedlink">Page [13] &nbsp; Immunization Record </div></a></td>
		<cfelse>
			<td align="center" class="ddmx"><a class="item2" href="?curdoc=section3/page13#print#&id=3&p=13" onClick="return CheckLink();">Page [13] &nbsp; Immunization Record </a></td>
		</cfif>		
		<cfif url.p EQ '14'>
			<td align="center" class="selected"><a class="item2" href="?curdoc=section3/page14#print#&id=3&p=14" onClick="return CheckLink();"><div class="selectedlink">Page [14] &nbsp; Authorization to Treat a Minor </div></a></td>
		<cfelse>
			<td align="center" class="ddmx"><a class="item2" href="?curdoc=section3/page14#print#&id=3&p=14" onClick="return CheckLink();">Page [14] &nbsp; Authorization to Treat a Minor </a></td>
		</cfif>
	</tr>							
	</cfif>
	
	<cfif url.id EQ '4'>
	<tr>
		<cfif url.p EQ '15'>
			<td align="center" class="selectedline menuline"><a class="item2" href="?curdoc=section4/page15#print#&id=4&p=15" onClick="return CheckLink();"><div class="selectedlink">Page [15] &nbsp; Program Agreement </div></a></td>
		<cfelse>
			<td align="center" class="ddmx menuline"><a class="item2" href="?curdoc=section4/page15#print#&id=4&p=15" onClick="return CheckLink();">Page [15] &nbsp; Program Agreement </a></td>
		</cfif>				
		<cfif url.p EQ '16'>
			<td align="center" class="selectedline menuline"><a class="item2" href="?curdoc=section4/page16#print#&id=4&p=16" onClick="return CheckLink();"><div class="selectedlink">Page [16] &nbsp; Liability Release </div></a></td>
		<cfelse>
			<td align="center" class="ddmx menuline"><a class="item2" href="?curdoc=section4/page16#print#&id=4&p=16" onClick="return CheckLink();">Page [16] &nbsp; Liability Release </a></td>
		</cfif>				
		<cfif url.p EQ '17'>
			<td align="center" class="selectedline menuline"><a class="item2" href="?curdoc=section4/page17#print#&id=4&p=17" onClick="return CheckLink();"><div class="selectedlink">Page [17] &nbsp; Travel Authorization </div></a></td>
		<cfelse>
			<td align="center" class="ddmx menuline"><a class="item2" href="?curdoc=section4/page17#print#&id=4&p=17" onClick="return CheckLink();">Page [17] &nbsp; Travel Authorization </a></td>
		</cfif>				
		<cfif url.p EQ '18'>
			<td align="center" class="selectedline menuline"><a class="item2" href="?curdoc=section4/page18#print#&id=4&p=18" onClick="return CheckLink();"><div class="selectedlink">Page [18] &nbsp; Private School </div></a></td>
		<cfelse>
			<td align="center" class="ddmx menuline"><a class="item2" href="?curdoc=section4/page18#print#&id=4&p=18" onClick="return CheckLink();">Page [18] &nbsp; Private School </a></td>
          </tr>
	<tr>
		</cfif>
        <cfif url.p EQ '19'>
			<tr  ><td align="center" class="selected"><a class="item2" href="?curdoc=section4/page19#print#&id=4&p=19" onClick="return CheckLink();"><div class="selectedlink">Page [19] &nbsp; Intl. Rep. Questionnaire </div></a></td>
		<cfelse>
			<td align="center" class="ddmx"><a class="item2" href="?curdoc=section4/page19#print#&id=4&p=19" onClick="return CheckLink();">Page [19] &nbsp; Intl. Rep. Questionnaire </a></td>
		</cfif>	
	
    	<cfif CLIENT.companyID NEQ 13>
			<cfif url.p EQ '20'>
                <tr  ><td align="center" class="selected" <cfif CLIENT.companyID EQ 13>colspan="2"</cfif>><a class="item2" href="?curdoc=section4/page20#print#&id=4&p=20" onClick="return CheckLink();"><div class="selectedlink">Page [20] &nbsp; Regional Choice </div></a></td>
            <cfelse>
                <td align="center" class="ddmx" <cfif CLIENT.companyID EQ 13>colspan="2"</cfif>><a class="item2" href="?curdoc=section4/page20#print#&id=4&p=20" onClick="return CheckLink();">Page [20] &nbsp; Regional Choice </a></td>
            </cfif>
            
			<cfif url.p EQ '21'>
                <tr  ><td align="center" class="selected"><a class="item2" href="?curdoc=section4/page21#print#&id=4&p=21" onClick="return CheckLink();"><div class="selectedlink">Page [21] &nbsp; <cfif CLIENT.companyID NEQ 14>State Choice<Cfelse>District Choice</cfif> </div></a></td>
            <cfelse>
                <td align="center" class="ddmx"><a class="item2" href="?curdoc=section4/page21#print#&id=4&p=21" onClick="return CheckLink();">Page [21] &nbsp; <cfif CLIENT.companyID NEQ 14>State Choice<Cfelse>District Choice</cfif> </a></td>
            </cfif>	
       	</cfif>
  
		<cfif url.p EQ '22'>
			<tr  ><td align="center" class="selected" <cfif CLIENT.companyID EQ 13>colspan="2"</cfif>><a class="item2" href="?curdoc=section4/page22&id=4&p=22" onClick="return CheckLink();"><div class="selectedlink">Page [22] &nbsp; Supplements </div></a></td>
		<cfelse>
			<td align="center" class="ddmx" <cfif CLIENT.companyID EQ 13>colspan="2"</cfif>><a class="item2" href="?curdoc=section4/page22&id=4&p=22" onClick="return CheckLink();">Page [22] &nbsp; Supplements </a></td>
		</cfif>
               	</tr>
    <tr>
		<!--- Canada is not using pages 23 or 24 --->
        <cfif CLIENT.companyID NEQ 13 AND CLIENT.companyID NEQ 14>
			<cfif url.p EQ '23'>
				<td align="center" class="selected"><a class="item2" href="?curdoc=section4/page23&id=4&p=23" onClick="return CheckLink();"><div class="selectedlink">Page [23] &nbsp; Double Placement Authorization </div></a></td>
			<cfelse>
				<td align="center" class="ddmx"><a class="item2" href="?curdoc=section4/page23&id=4&p=23" onClick="return CheckLink();">Page [23] &nbsp; Double Placement Authorization </a></td>
			</cfif>
      	</cfif>
 
    <!----
        <cfif CLIENT.companyID NEQ 13>
	        <cfif url.p EQ '24'>
				<td align="center" class="selected" bgcolor="##fff">&nbsp;<!----<a class="item2" href="?curdoc=section4/page24&id=4&p=24" onClick="return CheckLink();"><div class="selectedlink">Page [24] &nbsp; HIPAA Release </div></a>----></td>
			<cfelse>
				<td align="center" class="ddmx" bgcolor="##fff">&nbsp;<!----<a class="item2" href="?curdoc=section4/page24&id=4&p=24" onClick="return CheckLink();">Page [24] &nbsp; HIPAA Release </a>----></td>
			</cfif>
		</cfif>
---->
        <cfif url.p EQ '25'>
			<td align="center" class="selected" colspan="2"><a class="item2" href="?curdoc=section4/page25&id=4&p=25" onClick="return CheckLink();"><div class="selectedlink">Page [24] &nbsp; Passport </div></a></td>
		<cfelse>
			<td align="center" class="ddmx" colspan="2"><a class="item2" href="?curdoc=section4/page25&id=4&p=25" onClick="return CheckLink();">Page [24] &nbsp; Passport </a></td>
		</cfif>	
        <!----
        <cfif url.p EQ '26'>
			<td align="center" class="selected"><a class="item2" href="?curdoc=section4/page26&id=4&p=26" onClick="return CheckLink();"><div class="selectedlink">Page [26] &nbsp; Birth Certificate - Birth Registration </div></a></td>
		<cfelse>
			<td align="center" class="ddmx"><a class="item2" href="?curdoc=section4/page26&id=4&p=26" onClick="return CheckLink();">Page [26] &nbsp; Birth Certificate - Birth Registration </a></td>
		</cfif>
		---->
        <cfif url.p EQ '27'>
			<td align="center" class="selected" colspan="2"><a class="item2" href="?curdoc=section4/page27&id=4&p=27" onClick="return CheckLink();"><div class="selectedlink">Page [25] &nbsp; ELTIS Test </div></a></td>
		<cfelse>
			<td align="center" class="ddmx" colspan="2" ><a class="item2" href="?curdoc=section4/page27&id=4&p=27" onClick="return CheckLink();">Page [25] &nbsp; ELTIS Test </a></td>
		</cfif>	
    </tr>
	</cfif>	
</table>
</cfoutput>

<script type="text/javascript">
	var ddmx = new DropDownMenuX('menu1');
	ddmx.delay.show = 0;
	ddmx.delay.hide = 400;
	ddmx.position.levelX.left = 2;
	ddmx.init();
</script>

</body>
</html>