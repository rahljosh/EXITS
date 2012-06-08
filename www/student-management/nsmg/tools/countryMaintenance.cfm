<!--- ------------------------------------------------------------------------- ----
	
	File:		countryMaintenance.cfm
	Author:		Marcus Melo
	Date:		Jun 06, 2012
	Desc:		Country Maintenance

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />
    
    <cfscript>
		// Set Continent List
		vContinentList = "Africa,Asia,Europe,North America,South America,Oceania";
		
		// Get Country List
		qGetCountryList = APPLICATION.CFC.LOOKUPTABLES.getCountryList();
	
		// Param Form Variables
		param name="FORM.submitted" default=0;	
		for ( i=1; i LTE qGetCountryList.recordCount; i=i+1 ) {
			param name="FORM.#qGetCountryList.countryID[i]#_sevisCode" default="";
			param name="FORM.#qGetCountryList.countryID[i]#_continent" default="";
			param name="FORM.#qGetCountryList.countryID[i]#_funFact" default="";
			param name="FORM.#qGetCountryList.countryID[i]#_picture" default="";
		}
    </cfscript>

	<!--- FORM Submitted --->
	<cfif FORM.submitted>
    	
		<!--- Update Countries --->
        <cfloop query="qGetCountryList">
        
            <!--- Upload Picture --->
			<cfif LEN(FORM[qGetCountryList.countryID & '_picture'])> 
            
            	<cffile action="upload" 
            		destination="#APPLICATION.PATH.profileFactPics#" 
            		filefield="FORM.#qGetCountryList.countryID#_picture" nameconflict="makeunique">
            
            	<cfimage action="convert" 
            		isbase64="false" 
                    overwrite="true" 
            		destination="#APPLICATION.PATH.profileFactPics##qGetCountryList.countryID#.jpg" 
                    source="#APPLICATION.PATH.profileFactPics##file.serverfile#">
            
            	<cffile action="delete" file="#APPLICATION.PATH.profileFactPics##file.serverfile#">
            
            </cfif>
            
            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE  
                	smg_countrylist 
                SET  
                	sevisCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM[qGetCountryList.countryID & '_sevisCode']#">,
                	continent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM[qGetCountryList.countryID & '_continent']#">,
	                funFact =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM[qGetCountryList.countryID & '_funFact']#">
                WHERE 
                	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCountryList.countryID#">
            </cfquery>
            
        </cfloop> 
        
        <cfscript>
		  // Set Page Message
		  SESSION.pageMessages.Add("Form successfully submitted.");
		  
		  // Reload page
		  location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
		</cfscript>

    <cfelse>

		<cfscript>
            // Default Value Forms
            for ( i=1; i LTE qGetCountryList.recordCount; i=i+1 ) {
                FORM[qGetCountryList.countryID[i] & "_sevisCode"] = qGetCountryList.sevisCode[i];
                FORM[qGetCountryList.countryID[i] & "_continent"] = qGetCountryList.continent[i];
                FORM[qGetCountryList.countryID[i] & "_funFact"] = qGetCountryList.funFact[i];
            }
        </cfscript> 
    
    </cfif>
    
</cfsilent>

<cfoutput>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="students.gif"
        tableTitle="Country Maintenance"
    />

	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="tableSection"
        width="100%"
        />
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="tableSection"
        width="100%"
        />

    <!--- Form to choose which seasons to show allocation for --->
    <form name="countryMaintenance" id="countryMaintenance" action="#CGI.SCRIPT_NAME#?curdoc=tools/countries" method="post" enctype="multipart/form-data">
        <input type="hidden" name="submitted" value="1">

        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
            <tr style="font-weight:bold;">
                <td>Country</td>
                <td>Official Language</td>
                <td>SEVIS Code</td>
                <td>Continent</td>
                <td>Fun Fact</td>
                <td>Image</td>
            </tr>
            
			<cfloop query="qGetCountryList">
            	
                <cfscript>
					// Languages
					qGetCountryLanguages = APPLICATION.CFC.LOOKUPTABLES.getCountryLanguage(countryID=qGetCountryList.countryID);
				</cfscript>
                
                <tr bgcolor="#iif(qGetCountryList.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#" style="vertical-align:top">
                	<td><strong>#qGetCountryList.countryname#</strong></td>
                    <td>
                    	<cfif qGetCountryLanguages.recordCount>
                        	#ValueList(qGetCountryLanguages.name, "<br />")#
                        <cfelse>
                        	n/a
                        </cfif>
                    </td>
                    <td><input type="text" name="#qGetCountryList.countryID#_sevisCode" value="#FORM[qGetCountryList.countryID & '_sevisCode']#" size="1" maxlength="2" class="xSmallField"></td>                    
                    <td>
                        <select name="#qGetCountryList.countryID#_continent" class="mediumField">
                            <option value="0"></option>
                            <cfloop list="#vContinentList#" index="i">
                            	<option value="#i#" <cfif FORM[qGetCountryList.countryID & '_continent'] EQ i>Selected</cfif> >#i#</option>
                            </cfloop>
                        </select> 
                    </td>                    
                    <td>
                        <textarea name="#qGetCountryList.countryID#_funFact" id="#qGetCountryList.countryID#_funFact" class="xxLargeTextArea">#FORM[qGetCountryList.countryID & '_funFact']#</textarea>
                    </td>
                    <td>
                        <cfdirectory directory="#APPLICATION.PATH.profileFactPics#" name="profileFactPics" filter="#qGetCountryList.countryID#.*">
                        
                        <cfif FileExists('#APPLICATION.PATH.profileFactPics##qGetCountryList.countryID#.jpg')>
                        	<cfimage source="../uploadedfiles/profileFactPics/#qGetCountryList.countryID#.jpg" name="myImage">
                        <cfelse>
                        	<cfif FileExists('#APPLICATION.PATH.pics#flags/#qGetCountryList.countryID#.jpg')>
                        		<cfimage source="../pics/flags/#qGetCountryList.countryID#.jpg" name="myImage">
                        	<cfelse>                                                    
                        		<cfimage source="../pics/flags/0.jpg" name="myImage">
	                        </cfif>
                        </cfif>
                        
                        <cfset ImageScaleToFit(myimage, 75,50)>
                        
                        <cfimage source="#myImage#" action="writeToBrowser" border="0">
                        
                        <br />
                        
                        <input type="file" name="#qGetCountryList.countryID#_picture" />                        
                    </td>
                </tr>
            
            </cfloop>
		</table>
        
		<cfif listFind("1,2,3,4", CLIENT.userType)>
            <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
                <tr>
                    <td colspan="6" align="center"><input type="image" name="submit" src="pics/buttons_submit.png" border="0"></td>
                </tr>
            </table>
        </cfif> 	

	</form>

	<!--- Table Header --->
    <gui:tableFooter
        imageName="students.gif"
        tableTitle="Countries Maintenance"
    />
    
</cfoutput>	    
