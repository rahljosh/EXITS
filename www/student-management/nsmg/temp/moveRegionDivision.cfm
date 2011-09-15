<!--- ------------------------------------------------------------------------- ----
	
	File:		moveRegionDivision.cfm
	Author:		Marcus Melo
	Date:		September 15, 2011
	Desc:		Moves region, users, host family and students from division to
				division.
	
	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <cfsetting requesttimeout="9999">
    
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.regionFrom" default="0">
    <cfparam name="FORM.divisionTo" default="0">

	<cfscript>
		// Get Regions
		qGetRegionList = APPLICATION.CFC.REGION.getRegions(isActive=1);
		
		// Get Companies
		qGetCompanyList = APPLICATION.CFC.COMPANY.getCompanies(companyIDList="1,2,3,4,5,12");
	</cfscript>
    
    <cfif FORM.submitted>

		<cfscript>
   			// Data Validation
			if ( NOT VAL(FORM.regionFrom) ) {
				// Get all the missing items in a list
				SESSION.formErrors.Add('You must select a region from');
			}		
			
			if ( NOT VAL(FORM.divisionTo) ) {
				// Get all the missing items in a list
				SESSION.formErrors.Add('You must select a division to');
			}		
		</cfscript>
        
        <cfif NOT SESSION.formErrors.length()>
            
            <!--- Region --->
            <cfquery datasource="mysql">
                UPDATE
                    smg_regions
                SET
                    company = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.divisionTo#">
                WHERE
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionFrom#">
            </cfquery>
			
            <!--- Region Guaranteed --->
            <!---
            <cfquery datasource="mysql">
                UPDATE
                    smg_regions
                SET
                    company = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.divisionTo#">
                WHERE
                    subOfRegion = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionFrom#">
            </cfquery>
			--->

			<!--- Users ---->
            <cfquery datasource="mysql">
                UPDATE
                    user_access_rights
                SET
                    companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.divisionTo#">
                WHERE
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionFrom#">
            </cfquery>
            
            <!--- Host Families --->
            <cfquery datasource="mysql">
                UPDATE
                    smg_hosts
                SET
                    companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.divisionTo#">
                WHERE
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionFrom#">
            </cfquery>
            
            <!--- Students --->
            <cfquery datasource="mysql">
                UPDATE
                    smg_students
                SET
                    companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.divisionTo#">
                WHERE
                    regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionFrom#">
            </cfquery>
   			
            <cfscript>
				// Set Page Message
				SESSION.pageMessages.Add("Region moved to new division successfully");
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
            tableTitle="Move Regions from Division To Division"
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
                    <th colspan="2">Transfers Region, Users, Students and Host Families from division to division</th>
                </tr>
                <tr>
                    <td class="columTitleRight">Select Region</td>
                    <td>
                        <select name="regionFrom">
                            <option value="0"></option>
                            <cfloop query="qGetRegionList">
                                <option value="#qGetRegionList.regionID#" <cfif qGetRegionList.regionID EQ FORM.regionFrom>selected="selected"</cfif> >#qGetRegionList.team_id# - #qGetRegionList.regionName#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="columTitleRight">Select New Division</td>
                    <td>
                        <select name="divisionTo">
                        	<option value="0"></option>
                            <cfloop query="qGetCompanyList">
                                <option value="#qGetCompanyList.companyID#" <cfif qGetCompanyList.companyID EQ FORM.divisionTo>selected="selected"</cfif> >#qGetCompanyList.team_id#</option>
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