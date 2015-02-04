<!--- ------------------------------------------------------------------------- ----
	
	File:		religiousPreference.cfm
	Author:		Marcus Melo
	Date:		November 19, 2012
	Desc:		Community Profile Page

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
    
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">   
    <cfparam name="FORM.churchTrans" default=""> <!--- yes/no --->
    <cfparam name="FORM.informReligiousPref" default=""> <!--- int --->
    <cfparam name="FORM.hostingDiff" default=""> <!--- int --->
    <cfparam name="FORM.religion" default=""> <!--- int --->
    <cfparam name="FORM.religious_participation" default=""> <!--- varchar --->
    <cfparam name="FORM.churchFam" default=""> <!--- yes/no --->

    <cfquery name="qGetReligionList" datasource="#APPLICATION.DSN.Source#">
		SELECT
        	religionID,
            religionName
    	FROM
        	smg_religions
        ORDER BY
        	religionName
    </cfquery>

	<!--- FORM Submitted --->
	<cfif VAL(FORM.submitted)>
    	
		<cfscript>
            // Data Validation
            
            // Student Transportation
            if  ( NOT LEN(TRIM(FORM.churchTrans)) ) {
				SESSION.formErrors.Add("Please indicate if you will provide transportation to the students religious services if they are different from your own.");
            }
			
            // Religious Affiliation
            if  ( NOT LEN(FORM.informReligiousPref) ) {
				SESSION.formErrors.Add("Please indicate will voluntarily provide your religious affiliation.");
            }
			
			// Religious Preference
			if ( VAL(FORM.informReligiousPref) AND NOT VAL(FORM.religion) ) {
				SESSION.formErrors.Add("Please indicate your religious preference");
			}
			if ( VAL(FORM.religion) is 21 and NOT LEN(FORM.religionOther) ) {
				SESSION.formErrors.Add("You indicated Other as a religious preference, but didn't specify what Other indicates.");
			}
            // Difficult different religion
            if  ( NOT LEN(FORM.hostingDiff) ) {
				SESSION.formErrors.Add("Please indicate if anyone in your household has difficulty with hosting a student whoms religious differs from your own.");
            }
			
			// Religious Attandance
			if ( NOT LEN(FORM.religious_participation) ) {
				SESSION.formErrors.Add("Please indicate How often do you go to your religious place of worship?");
			}
			
			// Expect Student
			if ( FORM.religious_participation NEQ 'Inactive' AND NOT LEN(FORM.churchFam) ) {
				SESSION.formErrors.Add("Please indicate if Would you expect your exchange student to attend services with your family?");
			}
        </cfscript>

		<!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>
			
            <cfscript>
				// Reset hidden options
				if ( FORM.informReligiousPref EQ 'no' ) {
					FORM.religion = "";	
				}
				
				// Reset hidden options
				if ( FORM.religious_participation EQ 'Inactive' ) {
					FORM.churchfam = "";
				}
			</cfscript>
            
              <Cfif len(form.religionOther)>
           		<Cfquery name="updateReligionList" datasource="#APPLICATION.DSN.Source#">
                insert into smg_religions(religionName)
                		values(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.religionOther#">)
                </Cfquery> 
                <cfquery name=ReligionID datasource="#APPLICATION.DSN.Source#">
                select max(religionID) newReligionID
                from smg_religions
               
                </cfquery>
            </Cfif>
            
            <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE 
                    smg_hosts
                SET
                    churchtrans = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.churchTrans#" null="#NOT IsBoolean(FORM.churchTrans)#">,
                    informReligiousPref = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.informReligiousPref#" null="#NOT LEN(FORM.informReligiousPref)#">,
                    hostingDiff = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.hostingDiff)#" null="#NOT LEN(FORM.hostingDiff)#">,
                    religious_participation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.religious_participation#">,
                    <Cfif len(form.religionOther)>
                     religion = <cfqueryparam cfsqltype="cf_sql_integer" value="#ReligionID.newReligionID#">,
                    <cfelse>
                     religion = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.religion#" null="#NOT LEN(FORM.religion)#">,
                    </Cfif>
                    churchfam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.churchfam#" null="#NOT IsBoolean(FORM.churchfam)#">
                WHERE 
                    hostID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
            </cfquery>
            
          
                
            <cfscript>
				// Successfully Updated - Set navigation page
				Location(APPLICATION.CFC.UDF.setPageNavigation(section=URL.section), "no");
			</cfscript>
            
		</cfif>

    <cfelse>
    
		<cfscript>
			// Set FORM Values   
			FORM.religious_participation = qGetHostFamilyInfo.religious_participation;
			FORM.churchTrans = qGetHostFamilyInfo.churchtrans;
			FORM.churchFam = qGetHostFamilyInfo.churchfam;
			FORM.religion =  qGetHostFamilyInfo.religion;
			FORM.informReligiousPref = qGetHostFamilyInfo.informReligiousPref;
			FORM.hostingDiff = qGetHostFamilyInfo.hostingDiff;
        </cfscript>
        
    </cfif>

</cfsilent>   
<script type="text/javascript"> 
	$(document).ready(function(){
		$('.box').hide();
		
		$('#dropdown').change(function() {
			$('.box').hide();
			$('#div' + $(this).val()).show();
		});
		
	});
</script>
<cfoutput>

    <h2>Religious Affiliation</h2>
	
	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="section"
        />
	
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />

    <cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        <input type="hidden" name="submitted" value="1">
         
        <h3>Transportation</h3>
        
        <span class="required">* Required fields</span>
    
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td width="500">Would you provide transportation to the student's religious services if they are different from your own? <span class="required">*</span></td>
                <td> 
                    <cfinput type="radio" name="churchTrans" id="churchTransYes" value="yes" checked="#FORM.churchTrans EQ 'yes'#"/>
                    <label for="churchTransYes">Yes</label>      
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="churchTrans" id="churchTransNo" value="no" checked="#FORM.churchTrans EQ 'no'#"/>
                    <label for="churchTransNo">No</label>
                </td>
            </tr>
        </table> <br />
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr>
                <td width="500">Are you willing to voluntarily inform your exchange student of your religious affiliation? <span class="required">*</span></td>
                <td> 
                    <cfinput type="radio" name="informReligiousPref" id="informReligiousPrefYes" value="1" checked="#FORM.informReligiousPref eq 1#" onclick="document.getElementById('informReligiousPrefDiv').style.display='table-row';" />
                    <label for="informReligiousPrefYes">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="informReligiousPref" id="informReligiousPrefNo" value="0" checked="#FORM.informReligiousPref eq 0#" onclick="document.getElementById('informReligiousPrefDiv').style.display='none';" />
                    <label for="informReligiousPrefNo">No</label>
                </td>
			</tr>
            <tr bgcolor="##deeaf3">
                <td width="500">Does any member of your household have difficulty hosting a student with different religious beliefs? <span class="required">*</span></td>
                <td> 
                    <cfinput type="radio" name="hostingDiff" id="hostingDiffYes" value="1" checked="#FORM.hostingDiff eq 1#" />
                    <label for="hostingDiffYes">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="hostingDiff" id="hostingDiffNo" value="0" checked="#FORM.hostingDiff eq 0#" />
                    <label for="hostingDiffNo">No</label>
				</td>
            </tr>
        </table> <br />
        
        <div id="informReligiousPrefDiv" style="width:100%;" <cfif FORM.informReligiousPref NEQ 1>class="displayNone"</cfif>>
        
            <h3>Religious Preference</h3>
            
            <table width="100%" cellspacing="0" cellpadding="2" class="border">
                <tr bgcolor="##deeaf3" >
                    <td>What is your religious affiliation? <span class="required">*</span></td>
                    <td>                    
                        <select name="religion" onChange="ShowHide();" class="largeField" id="dropdown">
                            <option value="" <cfif NOT LEN(FORM.religion)> selected </cfif> ></option>
                            <cfloop query="qGetReligionList">
                                <option value="#qGetReligionList.religionid#" <cfif FORM.religion EQ qGetReligionList.religionid> selected </cfif>>#qGetReligionList.religionname#</option>
                            </cfloop>
                            
                        </select>
                      </td>
                </tr>     
				<Tr bgcolor="##deeaf3" >
                	<td colspan=2><cfif form.religion neq 21> <div id="div21" class="box" display="hidden"></cfif>If Other, please Specify: <input type="text" size=35 name='religionOther'/></div></td>
                </Tr>
            </table>
            	
        
            <br />
		
        </div> 
        
        <h3>Religious Attendance</h3>
        
        How often do you go to your religious place of worship?
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td colspan="2">
                    <cfinput type="radio" name="religious_participation" id="religious_participation1" onclick="document.getElementById('showname').style.display='table-row';" checked="#FORM.religious_participation is 'Active'#" value="Active" > 
                    <label for="religious_participation1">Two or more times per week</label></td>
            </tr>
            <tr>
                <td colspan="2">
                	<cfinput type="radio" name="religious_participation" id="religious_participation2" onclick="document.getElementById('showname').style.display='table-row';" value="Average" checked="#FORM.religious_participation is 'Average'#">
                    Once per week</td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td colspan="2">
                	<cfinput type="radio" name="religious_participation" id="religious_participation3" onclick="document.getElementById('showname').style.display='table-row';" value="Little Interest" checked="#FORM.religious_participation is 'Little Interest'#">
                	<label for="religious_participation3">Infrequently</label></td>
            </tr>
            <tr>
                <td colspan="2">
                    <cfinput type="radio" name="religious_participation" id="religious_participation4" value="Inactive" onclick="document.getElementById('showname').style.display='none';" checked="#FORM.religious_participation is 'Inactive'#" >
                    <label for="religious_participation4">Do not attend</label></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td colspan="2">
                	<cfinput type="radio" name="religious_participation" id="religious_participation5" onclick="document.getElementById('showname').style.display='table-row';" value="No Interest" checked="#FORM.religious_participation is 'No Interest'#">
                    <label for="religious_participation5">Religious Holidays</label>
                </td>
            </tr>
            <tr colspan="2" id="showname" <cfif FORM.religious_participation EQ "Inactive">class="displayNone"</cfif>>
                <td>Would you expect your exchange student to attend services with your family? <span class="required">*</span> </td>
                <td>
                    <cfinput type="radio" name="churchFam" id="churchFamYes" value="yes" checked="#FORM.churchFam eq 'yes'#" />
                    <label for="churchFamYes">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="churchFam" id="churchFamNo" value="no" checked="#FORM.churchFam eq 'no'#" />
                    <label for="churchFamNo">No</label>
                </td>
            </tr>
        </table>

        <!--- Check if FORM submission is allowed --->
        <cfif APPLICATION.CFC.UDF.allowFormSubmission(section=URL.section)>
            <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
                <tr>
                    <td align="right"><input name="Submit" type="image" src="images/buttons/Next.png" border="0"></td>
                </tr>
            </table>
		</cfif>
                
        <h3><u>Department Of State Regulations</u></h3>
        
        <p>
        	&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?type=simple;c=ecfr;cc=ecfr;sid=406e4a7eed2230e1d0c7300cdaa991eb;idno=22;region=DIV1;q1=religious%20services;rgn=div5;view=text;node=22%3A1.0.1.7.36##22:1.0.1.7.36.8.1.1.6" target="_blank" class=external>CFR Title 22, Part 62, Family Activities</a></strong><br />
       		Note: A host family may want the exchange visitor to attend one or more religious services or programs with the family. The exchange visitor cannot be required to do so, but may decide to experience this facet of U.S. culture at his or her discretion.
		</p>
	
    </cfform>

</cfoutput>