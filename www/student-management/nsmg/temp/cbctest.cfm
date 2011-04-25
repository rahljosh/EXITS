<cfxml variable="requestXML">
<BGC>
<login>
    <user>23232</user>
    <password>232323</password>
    <account>2323232</account>
</login>
<product>
    <USOneValidate version="1">
        <order>
            <SSN>23232</SSN>
        </order>
    </USOneValidate>
</product>
<product>
    <USOneSearch version='1'>
        <order>
            <lastName>Melo</lastName>				
            <firstName>Marcus</firstName>
            <middleName>V</middleName>
            <DOB>
                <year>1978</year>
                <month>07</month>
                <day>20</day>
            </DOB>
        </order>
        <custom>
            <options>
                <noSummary>YES</noSummary>			
                <includeDetails>YES</includeDetails>
            </options>
        </custom>				
    </USOneSearch>
</product>
<product>	
    <USOneTrace version="1">
        <order>
            <SSN>23232</SSN>
            <lastName>Melo</lastName>
            <firstName>Marcus</firstName>
        </order>
    </USOneTrace>
</product>	
</BGC>
</cfxml>

<!---

https://direct.backgroundchecks.com/integration/bgcdirectpost.aspx

https://model.backgroundchecks.com/integration/bgcdirectpost.aspx

---->
<!---
<cfhttp url="https://model.backgroundchecks.com/integration/bgcdirectpost.aspx" method="post" throwonerror="yes">
	<cfhttpparam type="Header" name="charset" value="utf-8" />
	<cfhttpparam type="XML" value="#requestXML#" />                    
</cfhttp>

<cfdump var="#cfhttp.filecontent#">
---><br>

<br /><br /><br /> ---- PRODUCTION ---- <br /><br /><br />

<!--- Submit CBC --->
<cfhttp url="https://direct.backgroundchecks.com/integration/bgcdirectpost.aspx" method="post" throwonerror="yes" port="443" charset="utf-8">
	<cfhttpparam type="Header" name="charset" value="utf-8" />
	<cfhttpparam type="XML" value="#requestXML#" />                    
</cfhttp>

<cfdump var="#requestXML#"><br><br><br>
<cfdump var="#cfhttp.filecontent#">

<cfabort>

