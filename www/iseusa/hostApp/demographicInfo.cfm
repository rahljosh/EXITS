<cfif isDefined('form.process')>
<cfquery name="insert_rules" datasource="MySQL">
update smg_hosts
	set
		income = #form.income#,
		publicAssitance = #form.publicAssitance#,
		crime = #form.crime#,
        crimeExpl = "#form.crimeExpl#"

	where
		hostid = #client.hostid#
</cfquery>
<cflocation url="index.cfm?page=hello">
</cfif>
<cfquery name="demoInfo" datasource="MySql">
select income, publicAssitance, crime, crimeExpl
from smg_hosts
where hostid = #client.hostid#
</cfquery>
<h2>Confidential Income & Finance Data</h2>
The following information is requried by the Department of State. This information will be kept confidential by the exchange company and will not be distributed to the student, the natural family, or the Internationl Agent. The income data collected will be used solely for the purposes of determining that the basic needs of the exchange student can be met, including three quality meals and transportation to and from school activities.<sup>&dagger;</sup>

<cfoutput>
<cfform method="post" action="index.cfm?page=demographicInfo">
<input type="hidden" name="process" />
  <table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr  bgcolor="##deeaf3">
    	<td class="label" valign="top"><h3>Is any member of your household receiving<br> any kind of public assistance?<sup>&dagger;&dagger;</sup></h3></td>
        <td><cfinput  checked="#demoInfo.publicAssitance eq 0#" type="radio" name="publicAssitance" value=0 />No <cfinput type="radio" checked="#demoInfo.publicAssitance eq 1#" name="publicAssitance" value=1 />Yes</td>
    </tr>
    <tr >
    	<td class="label" valign="top"><h3>Average annual income range<sup>&dagger;&dagger;</sup></h3></td>
        <td><cfinput checked="#demoInfo.income eq 25#" type="radio" name="income" value=25 />Less then $25,000<br />
        	<cfinput checked="#demoInfo.income eq 35#" type="radio" name="income" value=35 />$25,000 - $35,000<br />
      		<cfinput checked="#demoInfo.income eq 45#" type="radio" name="income" value=45 />$35,001 - $45,000<br />
            <cfinput checked="#demoInfo.income eq 55#" type="radio" name="income" value=55 />$45,001 - $55,000<br />
            <cfinput checked="#demoInfo.income eq 65#" type="radio" name="income" value=65 />$55,001 - $65,000<br />
            <cfinput checked="#demoInfo.income eq 75#" type="radio" name="income" value=75 />$65,001 - $75,000<br />
            <cfinput  checked="#demoInfo.income eq 85#"type="radio" name="income" value=85 />$75,000 and above<br />
       </td>
    </tr>
    <tr bgcolor="##deeaf3">
    	<td class="label" valign="top"><h3>Has any member of your household<Br> ever been charged with a crime?<sup>&dagger;&dagger;&dagger;</sup></h3></td>
        <td>   <label>
            <cfinput type="radio" name="crime" value="1"
            checked="#demoInfo.crime eq 1#" onclick="document.getElementById('crimeExpl').style.display='table-row';" 
            required="yes" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="crime" value="0"
           checked="#demoInfo.crime eq 0#" onclick="document.getElementById('crimeExpl').style.display='none';" 
           required="yes" message="Please answer: Has any member of your household
ever been charged with a crime?" />
            No
            </label>
            </td>
    </tr>
    <tr colspan=4>
    	<Td id="crimeExpl" <cfif demoInfo.crime eq 0>style="display: none;" bgcolor="##deeaf3"</cfif> >Please explain<br /><textarea name="crimeExpl" rows cols="50" rows="4">#demoinfo.crimeExpl#</textarea></Td>
    </tr>
   </table>
   
<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
       
        <td align="right"><input name="Submit" type="image" src="../images/buttons/Next.png" border=0></td>
    </tr>
</table>
<h3><u>Department Of State Regulations</u></h3>

<p>&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(2)</a></strong><br />
<em>Utilize a standard application form developed by the sponsor that includes, at a minimum, all data fields provided in Appendix F, “Information to be Collected on Secondary School Student Host Family Applications”. The form must include a statement stating that: “The income data collected will be used solely for the purposes of determining that the basic needs of the exchange student can be met, including three quality meals and transportation to and from school activities.” Such application form must be signed and dated at the time of application by all potential host family applicants. The host family application must be designed to provide a detailed summary and profile of the host family, the physical home environment (to include photographs of the host family home's exterior and grounds, kitchen, student's bedroom, bathroom, and family or living room), family composition, and community environment. Exchange students are not permitted to reside with their relatives.</em></p>

<p>&dagger;&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(6)</a></strong><br />
<em>Ensure that the host family has adequate financial resources to undertake hosting obligations and is not receiving needs-based government subsidies for food or housing;</em>

<p>&dagger;&dagger;&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(7)</a></strong><br />
       <em>Verify that each member of the host family household 18 years of age and older, as well as any new adult member added to the household, or any member of the host family household who will turn eighteen years of age during the exchange student's stay in that household, has undergone a criminal background check (which must include a search of the Department of Justice's National Sex Offender Public Registry);</em></p>


 

</cfform>
</cfoutput>

    