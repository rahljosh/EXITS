<!--- ------------------------------------------------------------------------- ----
	
	File:		_studentList.cfm
	Author:		Marcus Melo
	Date:		November 10, 2010
	Desc:		Display Student Application List

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
	
    <!--- Param FORM variables --->
    <cfparam name="FORM.keyword" default="">
    <cfparam name="FORM.applicationStatusID" default="0">
    <cfparam name="FORM.countryCitizenID" default="0">
    <cfparam name="FORM.countryHomeID" default="0">
    
	<cfscript>
		// Application Status
		qGetApplicationStatus = APPLICATION.CFC.ONLINEAPP.getApplicationStatus();
		
		// Get Current Student Information
		qGetCountry = APPLICATION.CFC.LOOKUPTABLES.getCountry();
	</cfscript>
	
        <cfquery name="qGetStudents" 
            datasource="#APPLICATION.DSN.Source#">
            SELECT
            	ID
            FROM
            	student
        </cfquery>
        <cfloop query="qGetStudents">
            <cfquery 
                datasource="#APPLICATION.DSN.Source#">
                UPDATE
                    student
                SET
                    hashID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.generateHashID(qGetStudents.ID)#">
                WHERE
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.ID#">
            </cfquery>
		</cfloop>
</cfsilent>

<cfoutput>

<!--- Page Header --->
<gui:pageHeader
	headerType="adminTool"
/>
    
    <!--- Side Bar --->
    <div class="fullContent ui-corner-all">
        
        <div class="insideBar">

            <!--- Application Body --->
			<div class="form-container-noBorder">
            	
                <cfform>
                
                <fieldset>
                   
                    <legend>Search Criteria</legend>

                    <div class="field">
                        <label for="firstName">First / Last Name / Email </label> 
                        <input type="text" name="keyword" id="keyword" value="#FORM.keyword#" class="mediumField" maxlength="100" />
                    </div>

                    <div class="field">
                        <label for="firstName">Application Status </label> 
                        <select name="applicationStatusID" id="applicationStatusID" class="mediumField">
                            <option value=""></option>
                            <cfloop query="qGetApplicationStatus">
                                <option value="#qGetApplicationStatus.ID#" <cfif FORM.applicationStatusID EQ qGetApplicationStatus.ID> selected="selected" </cfif> >#qGetApplicationStatus.name#</option>
                            </cfloop>
                        </select>
                    </div>

                    <div class="field">
                        <label for="firstName">Home Country </label> 
                        <select name="countryHomeID" id="countryHomeID" class="mediumField">
                            <option value=""></option>
                            <cfloop query="qGetCountry">
                                <option value="#qGetCountry.ID#" <cfif FORM.countryHomeID EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                            </cfloop>
                        </select>
                    </div>

                    <div class="field">
                        <label for="firstName">Citizen Country </label> 
                        <select name="countryCitizenID" id="countryCitizenID" class="mediumField">
                            <option value=""></option>
                            <cfloop query="qGetCountry">
                                <option value="#qGetCountry.ID#" <cfif FORM.countryCitizenID EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                            </cfloop>
                        </select>
                    </div>

                </fieldset>

                <div class="buttonrow">
                    <input type="Button" value="Seach" class="button ui-corner-top" />
                </div>
            
                <fieldset>
                   
                    <legend>Student List</legend>
                    
                        <div align="center">
                        
                            <cfgrid name="studentList" 
                                format="html"
                                bind="cfc:extensions.components.student.getStudentList({keyword},{applicationStatusID},{countryHomeID},{countryCitizenID},{cfgridPage},{cfgridPageSize},{cfgridSortColumn},{cfgridSortDirection})"                    
                                width="1000"
                                pagesize="50"
                                bgcolor="##FFFFFF" 
                                highlighthref="yes"
                                align="left">
                                                    
                                <cfgridcolumn name="ID" display="no">
                                <cfgridcolumn name="firstName" header="First Name" width="130" dataalign="left">
                                <cfgridcolumn name="lastName" header="Last Name" width="130" dataalign="left">
                                <cfgridcolumn name="gender" header="Gender" width="50" dataalign="left">
                                <cfgridcolumn name="homeCountry" header="Home Country" width="140" dataalign="left">
                                <cfgridcolumn name="CitizenCountry" header="Citizen Country" width="140" dataalign="left">
                                <cfgridcolumn name="email" header="Email" width="150" dataalign="left">
                                <cfgridcolumn name="statusName" header="Status" width="60" dataalign="left">
                                <cfgridcolumn name="displayDateCreated" header="Date Created" width="80" dataalign="left">
                                <cfgridcolumn name="dateLastLoggedIn" header="Last Login" width="60" dataalign="left">
                                <cfgridcolumn name="action" header="Actions" width="60">
                            </cfgrid>
        
                        </div>
                                        					
                </fieldset>
                            
            </div>
            
            </cfform>  
            
        </div>

    </div>

<!--- Page Footer --->
<gui:pageFooter
	footerType="adminTool"
/>

</cfoutput>