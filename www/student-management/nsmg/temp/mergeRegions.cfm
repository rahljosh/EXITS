<!--- ------------------------------------------------------------------------- ----
	
	File:		mergeRegions.cfm
	Author:		Marcus Melo
	Date:		July 29, 2011
	Desc:		Merge two regions, move students, reps and families
	
	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <cfsetting requesttimeout="9999">
    
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.regionFrom" default="">
    <cfparam name="FORM.regionTo" default="">

	<cfscript>
		// Get Regions
		qGetRegionList = APPLICATION.CFC.REGION.getRegions(companyID=CLIENT.companyID);
	</cfscript>
    
    <cfif FORM.submitted>

		<cfscript>
   			// Data Validation
			if ( NOT VAL(FORM.regionFrom) ) {
				// Get all the missing items in a list
				SESSION.formErrors.Add('You must select a region from');
			}		
			
			if ( NOT VAL(FORM.regionTo) ) {
				// Get all the missing items in a list
				SESSION.formErrors.Add('You must select a region to');
			}		
		</cfscript>
        
        <cfif NOT SESSION.formErrors.length()>
            
			<!--- Reps ---->
            <cfquery datasource="mysql">
                UPDATE
                    user_access_rights
                SET
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionTo#">
                WHERE
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionFrom#">
            </cfquery>
            
            <!--- Host Families --->
            <cfquery datasource="mysql">
                UPDATE
                    smg_hosts
                SET
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionTo#">
                WHERE
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionFrom#">
            </cfquery>
            
            <!--- Students --->
            <cfquery datasource="mysql">
                UPDATE
                    smg_students
                SET
                    regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionTo#">
                WHERE
                    regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionFrom#">
            </cfquery>
   			
            <cfscript>
				// Set Page Message
				SESSION.pageMessages.Add("Regions successfully merged.");
			</cfscript>
            
   		</cfif>
   
   </cfif>
   
</cfsilent>

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

		<!--- Table Header --->
        <gui:tableHeader
            imageName="current_items.gif"
            tableTitle="Merge Regions"
            width="50%"
            imagePath="../"
        />    
        
        <!--- Page Messages --->
        <gui:displayPageMessages 
            pageMessages="#SESSION.pageMessages.GetCollection()#"
            messageType="tableSection"
            width="50%"
            />
        
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="50%"
            />
		
        <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        	<input type="hidden" name="submitted" value="1" />
        
            <table width="50%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
                <tr class="projectHelpTitle">
                    <th colspan="2">Transfers Users, Students and Host Families from/to a region</th>
                </tr>
                <tr>
                    <td class="columTitleRight">Region From</td>
                    <td>
                        <select name="regionFrom">
                            <option value="0"></option>
                            <cfloop query="qGetRegionList">
                                <option value="#qGetRegionList.regionID#" <cfif qGetRegionList.regionID EQ FORM.regionFrom>selected="selected"</cfif> >#qGetRegionList.regionName#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="columTitleRight">Region To</td>
                    <td>
                        <select name="regionTo">
                            <option value="0"></option>
                            <cfloop query="qGetRegionList">
                                <option value="#qGetRegionList.regionID#" <cfif qGetRegionList.regionID EQ FORM.regionTo>selected="selected"</cfif> >#qGetRegionList.regionName#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <cfif ListFind("1,2,3,4", CLIENT.userType)>
                    <tr>
                        <th colspan="2">
                            <input type="submit" name="Submit" />
                        </th>
                    </tr>                
                </cfif>
            </table>     
        
        </form>
        
        <!--- Table Footer --->
        <gui:tableFooter 
  	        width="50%"
			imagePath="../"
        />

	<!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />

</cfoutput>                             