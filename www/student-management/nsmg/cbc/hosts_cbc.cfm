<!--- ------------------------------------------------------------------------- ----
	
	File:		hosts_cbc.cfm
	Author:		Marcus Melo
	Date:		October 12, 2009
	Desc:		Host CBC Management

	Updated:  	10/12/09 - Combined qr_hosts_cbc.cfm to this file.
				10/13/09 - Running CBCs on this page
				05/21/10 - Adding CBCs error messages
				05/24/10 - Adding run CBC without SSN option / Removing Flag CBC	

----- ------------------------------------------------------------------------- --->


  
<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfsetting requesttimeout="9999">

    <cftry>
	    <!--- param variables --->
	    <cfparam name="hostID" type="numeric" default="0">

		<!--- param FORM variables --->
        <cfparam name="FORM.submitted" type="numeric" default="0">
		<cfparam name="FORM.motherSeasonID" default="0">
		<cfparam name="FORM.fatherSeasonID" default="0">
		<cfparam name="FORM.memberIDs" default="0">
		
        <cfparam name="FORM.mothercompanyID" default="0">
        <cfparam name="FORM.motherSeasonID" default="0">
        <cfparam name="FORM.motherdate_authorized" default="">
        <cfparam name="FORM.motherDenied" default="">
        <cfparam name="FORM.motherIsNoSSN" default="0">
        <cfparam name="FORM.fathercompanyID" default="0">
        <cfparam name="FORM.fatherSeasonID" default="0">
        <cfparam name="FORM.fatherdate_authorized" default="">
        <cfparam name="FORM.fatherDenied" default="">
        <cfparam name="FORM.fatherIsNoSSN" default="0">
        
	    <cfcatch type="any">
        
			<cfscript>
				// set default values
				hostID = 0;
				FORM.submitted = 0;
			</cfscript>
            
		</cfcatch>
	</cftry>        

	<cfscript>
		// Gets List of Companies
		qGetCompanies = APPCFC.COMPANY.getCompanies();
	
		// Gets Host Family Information
		qGetHost = APPCFC.HOST.getHosts(hostID=hostID);

		// Get Host Mother CBC
		qGetCBCMother = APPCFC.CBC.getCBCHostByID(
			hostID=hostID, 
			cbcType='mother'
		);
		
		// Get Mother Available Seasons
		qGetMotherSeason = APPCFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCMother.seasonID));
		
		// Gets Host Father CBC
		qGetCBCFather = APPCFC.CBC.getCBCHostByID(
			hostID=hostID, 
			cbcType='father'
		);
		
		// Get Father Available Seasons
		qGetFatherSeason = APPCFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCFather.seasonID));

		// Get Family Member CBC
		qGetHostMembers = APPCFC.CBC.getEligibleHostMember(hostID=hostID);

		// Set Variables
		motherIDs = ValueList(qGetCBCMother.cbcfamID);
		fatherIDs = ValueList(qGetCBCFather.cbcfamID);
		memberIDs = ValueList(qGetHostMembers.childID);
		
		// Get number of denied CBCs for this host family
		vNumberDeniedCBCs = APPLICATION.CFC.CBC.getNumberDeniedCBCs(hostID=hostID);
	</cfscript>
    
    <!--- Form Submitted --->
	<cfif VAL(FORM.submitted)>
    	
		<cfscript>		
            // Check if we have valid data for host mother
            if ( VAL(FORM.motherSeasonID) AND LEN(FORM.motherdate_authorized) ) {
				// Insert Host Mother CBC
				APPCFC.CBC.insertHostCBC(
					hostID=FORM.hostID,
					familyMemberID=0,
					cbcType='mother',
					seasonID=FORM.motherSeasonID, 
					companyID=FORM.mothercompanyID,
					dateAuthorized=FORM.motherdate_authorized,
					isNoSSN=FORM.motherIsNoSSN,
					dateNexitsApproved = FORM.motherdate_nexits_approved
				);		
			}
			
            // Check if we have valid data for host father
            if ( VAL(FORM.fatherSeasonID) AND LEN(FORM.fatherdate_authorized) ) {
				// Insert Host Father CBC
                APPCFC.CBC.insertHostCBC(
                    hostID=FORM.hostID,
                    familyMemberID=0,
                    cbcType='father',
                    seasonID=FORM.fatherSeasonID, 
                    companyID=FORM.fathercompanyID,
                    dateAuthorized=FORM.fatherdate_authorized,
					isNoSSN=FORM.fatherIsNoSSN,
					dateNexitsApproved = FORM.fatherdate_nexits_approved
                );	
            }
        </cfscript>
        
        <!--- FAMILY MEMBERS --->
        <cfif VAL(FORM.memberIDs)>
        
            <cfloop list="#FORM.memberIDs#" index="id">
            
                <!--- Param Form Variables / New Season --->
                <cfparam name="FORM.#id#companyID" default="0">
                <cfparam name="FORM.#id#seasonID" default="0">
                <cfparam name="FORM.#id#date_authorized" default="">
                <cfparam name="FORM.#id#memberDenied" default="">
                <cfparam name="FORM.#id#IsNoSSN" default="0">
                
                <cfscript>
                    // Check if we have valid data for family members
                    if ( VAL(FORM[id & 'seasonID']) AND LEN(FORM[id & 'date_authorized']) ) {
                        // Insert Host Member CBC
                        APPCFC.CBC.insertHostCBC(
                            hostID=FORM.hostID,
                            familyMemberID=id,
                            cbcType='member',
                            seasonID=FORM[id & 'seasonID'],
                            companyID=FORM[id & 'companyID'],
                            dateAuthorized=FORM[id & "date_authorized"],
							dateNexitsApproved=FORM[id & "date_nexits_approved"],
                            isNoSSN=FORM[id & "isNoSSN"]
                        );
                    }
                </cfscript>
                
            </cfloop>
            
        </cfif>
        
        <!--- CBC FLAG/SSN HOST MOTHER ---->
        <cfloop list="#FORM.motherIDs#" index="cbcID">
            
            <!--- Param Form Variables --->
            <cfparam name="FORM.#cbcID#motherIsNoSSN" default="0">
            <cfparam name="FORM.#cbcID#notesmother" default="0">
            <cfparam name="FORM.#cbcID#date_Approvedmother" default="0">
            <cfparam name="FORM.#cbcID#motherDenied" default="0">
            <cfparam name="FORM.#cbcID#motherflagCBC" default="0">
            <cfscript>
				// update Host Mother CBC Flag & SSN options
				APPCFC.CBC.updateHostOptions(
					cbcfamID=cbcID,
					isNoSSN=FORM[cbcID & "motherIsNoSSN"],
					notes=FORM[cbcID & "notesmother"],
					date_approved=FORM[cbcID & "date_Approvedmother"],
					flagCBC=FORM[cbcID & "motherflagCBC"],
					denied=FORM[cbcID & "motherDenied"]
				);			
			</cfscript>

        </cfloop>
        
        <!--- CBC FLAG/SSN HOST FATHER ---->
        <cfloop list="#FORM.fatherIDs#" index='cbcID'>
        
            <!--- Param Form Variables --->
            <cfparam name="FORM.#cbcID#fatherIsNoSSN" default="0">
            <cfparam name="FORM.#cbcID#notesfather" default="0">
            <cfparam name="FORM.#cbcID#date_Approvedfather" default="0">
            <cfparam name="FORM.#cbcID#fatherDenied" default="0">
            <cfparam name="FORM.#cbcID#fatherflagCBC" default="0">
            <cfscript>
				// update Host Father CBC Flag & SSN options
				APPCFC.CBC.updateHostOptions(
					cbcfamID=cbcID,
					isNoSSN=FORM[cbcID & "fatherIsNoSSN"],
					notes=FORM[cbcID & "notesfather"],
					date_approved=FORM[cbcID & "date_Approvedfather"],
					flagCBC=FORM[cbcID & "fatherflagCBC"],
					denied=FORM[cbcID & "fatherDenied"]
				);			
			</cfscript>

        </cfloop>
        
        <!--- CBC FLAG/SSN HOST MEMBERS ---->
        <cfloop list="#FORM.memberIDs#" index='cbcID'>
        
        	<cfscript>
				// Gets Host Member CBC
				qGetCBCMember = APPCFC.CBC.getCBCHostByID(
					hostID=hostID,
					familyMemberID=cbcID,
					cbcType='member'
				);		

				// Get Member Available Seasons
				qGetMemberSeason = APPCFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCMember.seasonID));
			</cfscript>
            
            <cfloop query="qGetCBCMember">
        
				<!--- Param Form Variables --->
                <cfparam name="FORM.#cbcFamID#memberCBCFamID" default="0">
                <cfparam name="FORM.#cbcFamID#memberIsNoSSN" default="0">
                <cfparam name="FORM.#cbcFamID#notesmember" default="0">
                <cfparam name="FORM.#cbcFamID#date_Approvedmember" default="0">
                <cfparam name="FORM.#cbcFamID#memberDenied" default="">
                <cfparam name="FORM.#cbcFamID#memberflagCBC" default="0">
                <cfscript>
                    // update Host Member CBC Flag & SSN options
                    APPCFC.CBC.updateHostOptions(
                        cbcfamID=cbcFamID,					
                        isNoSSN=FORM[cbcFamID & "memberIsNoSSN"],
                        notes=FORM[cbcFamID & "notesmember"],
                        date_approved=FORM[cbcFamID & "date_Approvedmember"],
                        flagCBC=FORM[cbcFamID & "memberflagCBC"],
						denied=FORM[cbcFamID & "memberDenied"]
                    );			
                </cfscript>
                
          	</cfloop>
			
        </cfloop>
        
        <!--- Submit Batch 10/20/2009 --->
		<cfscript>
			// Set errorCount used in data validation
			errorCount = 0;
			
			// Get CBCs Host Parents Updated
            qGetCBCHost = APPCFC.CBC.getPendingCBCHost(
                companyID=CLIENT.companyID,
				hostID=FORM.hostID,
				userType='mother,father'
            );	

			// Get CBCs Host Members Updated
			qGetCBCMember = APPCFC.CBC.getPendingCBCHostMember(
				companyID=CLIENT.companyID,
				hostID=FORM.hostID
			);	
        </cfscript>  

		<!--- Submit CBC Host Parents --->
		<cfloop query="qGetCBCHost">
			
            <cfscript>
				// Data Validation
				// First Name
				if ( NOT LEN(Evaluate(qGetCBCHost.cbc_type & "firstname")) ) {
					SESSION.formErrors.Add("Missing first name for host #qGetCBCHost.cbc_type# #Evaluate(qGetCBCHost.cbc_type & "lastname")# (###qGetCBCHost.hostid#).");
				}
				// Last Name
				if ( NOT LEN(Evaluate(qGetCBCHost.cbc_type & "lastname")) )  {
					SESSION.formErrors.Add("Missing last name for host #qGetCBCHost.cbc_type# #Evaluate(qGetCBCHost.cbc_type & "firstname")# (###qGetCBCHost.hostid#).");
				}
				// DOB
				if ( NOT LEN(Evaluate(qGetCBCHost.cbc_type & "dob")) OR NOT IsDate(Evaluate(qGetCBCHost.cbc_type & "dob")) )  {
					SESSION.formErrors.Add("DOB is missing or is not a valid date for host #qGetCBCHost.cbc_type# #Evaluate(qGetCBCHost.cbc_type & "firstname")# #Evaluate(qGetCBCHost.cbc_type & "lastname")# (###qGetCBCHost.hostid#).");
				}
				// SSN
				if ( NOT VAL(qGetCBCHost.isNoSSN) AND NOT LEN(Evaluate(qGetCBCHost.cbc_type & "ssn")) )  {
					SESSION.formErrors.Add("Missing SSN for host #qGetCBCHost.cbc_type# #Evaluate(qGetCBCHost.cbc_type & "firstname")# #Evaluate(qGetCBCHost.cbc_type & "lastname")# (###qGetCBCHost.hostid#).");
				}
				
				// Check if there are no errors 
				if ( NOT SESSION.formErrors.length() ) {

					// Get Company ID
					qGetCompanyID = APPCFC.COMPANY.getCompanies(companyID=qGetCBCHost.companyID);
				
                    // Process Batch
					APPCFC.CBC.processBatch(
                        companyID=qGetCBCHost.companyID,
                        companyShort=qGetCompanyID.companyShort,
                        userType=qGetCBCHost.cbc_type,
                        hostID=qGetCBCHost.hostid,
                        cbcID=qGetCBCHost.CBCFamID,
                        // XML variables
                        username=qGetCompanyID.gis_username,
                        password=qGetCompanyID.gis_password,
                        account=qGetCompanyID.gis_account,
                        SSN=Evaluate(qGetCBCHost.cbc_type & 'ssn'),
                        lastName=Evaluate(qGetCBCHost.cbc_type & 'lastname'),
                        firstName=Evaluate(qGetCBCHost.cbc_type & 'firstname'),
                        middleName=Left(Evaluate(qGetCBCHost.cbc_type & 'middlename'),1),
                        DOBYear=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'yyyy'),
                        DOBMonth=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'mm'),
                        DOBDay=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'dd'),
						noSSN=qGetCBCHost.isNoSSN
                    );

				}
			</cfscript>
		
        </cfloop>

		<!--- Submit CBC Host Member --->
		<cfloop query="qGetCBCMember">
			
            <cfscript>
				// Data Validation
				if ( NOT LEN(qGetCBCMember.name) ) {
					SESSION.formErrors.Add("Missing first name for #qGetCBCMember.lastname# member of (###qGetCBCMember.hostid#).");
				}
			
				if ( NOT LEN(qGetCBCMember.lastname) )  {
					SESSION.formErrors.Add("Missing last name for #qGetCBCMember.name# member of (###qGetCBCMember.hostid#).");
				}
				
				if ( NOT LEN(qGetCBCMember.birthdate) OR NOT IsDate(qGetCBCMember.birthdate) )  {
					SESSION.formErrors.Add("Missing DOB for #qGetCBCMember.name# #qGetCBCMember.lastname# member of (###qGetCBCMember.hostid#).");
				}
	
				if ( NOT VAL(qGetCBCMember.isNoSSN) AND NOT LEN(qGetCBCMember.ssn) )  {
					SESSION.formErrors.Add("Missing SSN for #qGetCBCMember.name# #qGetCBCMember.lastname# member of (###qGetCBCMember.hostid#).");
				}
				
				// Check if there are no errors 
				if ( NOT SESSION.formErrors.length() ) {

					// Get Company ID
					qGetCompanyID = APPCFC.COMPANY.getCompanies(companyID=qGetCBCMember.companyID);
				
                    // Process Batch
					APPCFC.CBC.processBatch(
                        companyID=qGetCompanyID.companyID,
                        companyShort=qGetCompanyID.companyShort,
                        userType='member',
                        hostID=qGetCBCMember.hostid,
                        cbcID=qGetCBCMember.CBCFamID,
                        // XML variables
                        username=qGetCompanyID.gis_username,
                        password=qGetCompanyID.gis_password,
                        account=qGetCompanyID.gis_account,
                        SSN=qGetCBCMember.ssn,
                        lastName=qGetCBCMember.lastName,
                        firstName=qGetCBCMember.name,
                        middleName=Left(qGetCBCMember.middleName,1),
                        DOBYear=DateFormat(qGetCBCMember.birthdate, 'yyyy'),
                        DOBMonth=DateFormat(qGetCBCMember.birthdate, 'mm'),
                        DOBDay=DateFormat(qGetCBCMember.birthdate, 'dd'),
						noSSN=qGetCBCMember.isNoSSN
                    );	

				}
			</cfscript>
            		
        </cfloop>
    
        <cfscript>
			// We are not refreshing the page in order to keep the error message information so refresh queries to get CBCs that were just ran.
			
			// Get Host Mother CBC
			qGetCBCMother = APPCFC.CBC.getCBCHostByID(
				hostID=hostID, 
				cbcType='mother'
			);
			
			// Get Mother Available Seasons
			qGetMotherSeason = APPCFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCMother.seasonID));
			
			// Gets Host Father CBC
			qGetCBCFather = APPCFC.CBC.getCBCHostByID(
				hostID=hostID, 
				cbcType='father'
			);
			
			// Get Father Available Seasons
			qGetFatherSeason = APPCFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCFather.seasonID));
	
			// Get Family Member CBC
			qGetHostMembers = APPCFC.CBC.getEligibleHostMember(hostID=hostID);
	
			// Set Variables
			motherIDs = ValueList(qGetCBCMother.cbcfamID);
			fatherIDs = ValueList(qGetCBCFather.cbcfamID);
			memberIDs = ValueList(qGetHostMembers.childID);
			
			// Check if there are no errors 
			if ( NOT SESSION.formErrors.length() ) {
                // Set Page Message
                SESSION.pageMessages.Add("Form successfully submitted.");
			}
			
			// Determines if the host is qualified based on the CBC
			if (vNumberDeniedCBCs LT APPLICATION.CFC.CBC.getNumberDeniedCBCs(hostID=hostID)) {
				APPLICATION.CFC.CBC.setIsNotQualifiedToHost(hostID=hostID,isNotQualifiedToHost=1);	
			}
			
			Location(CGI.SCRIPT_NAME & "?" & CGI.QUERY_STRING, "no");
		</cfscript>
        
    </cfif> <!--- VAL(FORM.submitted) --->

</cfsilent>

<script type="text/javascript">
		function zp(n){
		return n<10?("0"+n):n;
		}
		function insertDate(t,format){
		var now=new Date();
		var DD=zp(now.getDate());
		var MM=zp(now.getMonth()+1);
		var YYYY=now.getFullYear();
		var YY=zp(now.getFullYear()%100);
		format=format.replace(/DD/,DD);
		format=format.replace(/MM/,MM);
		format=format.replace(/YYYY/,YYYY);
		format=format.replace(/YY/,YY);
		t.value=format;
		}
		
		function insertDateByID(ID,format,boxToDisable) {
			if ($("#"+ID+"CheckBox").is(':checked')) {
				var now=new Date();
				var DD=zp(now.getDate());
				var MM=zp(now.getMonth()+1);
				var YYYY=now.getFullYear();
				var YY=zp(now.getFullYear()%100);
				format=format.replace(/DD/,DD);
				format=format.replace(/MM/,MM);
				format=format.replace(/YYYY/,YYYY);
				format=format.replace(/YY/,YY);
				$("#"+ID).attr("value",format);
				$("#"+boxToDisable).attr("disabled", true);
			} else {
				$("#"+ID).attr("value","");
				$("#"+boxToDisable).removeAttr("disabled");
			}
		}
</script>
<style>
	.columnHeader {
		font-weight:bold;
		vertical-align:top;
	}
</style>

<script type="text/javascript">	
    // Document Ready!
    $(document).ready(function() {

		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"60%", 
			height:"60%", 
			iframe:true,
			overlayClose:false,
			escKey:false 
		});		

	});
	
	var updateCounter = function(input) {
		var len = input.value.length;
		if (len > 254) {
			alert("The reason is too long, it can only be 255 characters long.");
			$(input).val(input.value.substring(0,254));
		}
	}
</script> 	

<cfoutput>

	<cfif NOT VAL(hostID)>
        Sorry, an error has ocurred. Please go back and try again.
        <cfabort>
    </cfif>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="school.gif"
        tableTitle="Criminal Background Check - Host Family and Members ###hostID#"
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

    <cfform action="?curdoc=cbc/hosts_cbc&hostID=#hostID#" method="post">
        <input type="hidden" name="submitted" value="1">
        <input type="hidden" name="hostID" value="#hostID#">
        <!--- list cbcs --->
        <input type="hidden" name="motherIDs" value="#motherIDs#">
        <input type="hidden" name="fatherIDs" value="#fatherIDs#">
        <input type="hidden" name="memberIDs" value="#memberIDs#">
    
        <table border="0" cellpadding="4" cellspacing="2" width="100%" class="section">
            <tr>
                <th colspan="10" bgcolor="##e2efc7">H O S T &nbsp; P A R E N T S</th>
                <th bgcolor="##e2efc7" colspan=2><a href="cbc/hostParentsInfo.cfm?hostID=#qGetHost.hostID#" class="jQueryModal">Edit Host Parents Info</a></th>
            </tr>
            <tr><td colspan="9">&nbsp;</td></tr>
            
            <!--- HOST MOTHER --->
            <cfif LEN(qGetHost.motherfirstname) AND LEN(qGetHost.motherlastname)>
                <tr><td colspan="12" bgcolor="##e2efc7"><b>Primary Host Parent - #qGetHost.motherfirstname# #qGetHost.motherlastname#</b></td></tr>
                <tr>
                    <td class="columnHeader">Company</td>
                    <td class="columnHeader">Season</td>		
                    <td class="columnHeader">Authorization Received <br><font size="-2">mm/dd/yyyy</font></td>	
                    <td class="columnHeader">Approved In NEXITS</td>
                    <td class="columnHeader">CBC Submitted <br><font size="-2">mm/dd/yyyy</font></td>
                    <td class="columnHeader">Expiration Date <br><font size="-2">mm/dd/yyyy</font></td>		
                    <td class="columnHeader">Request ID</td>
                    <td class="columnHeader">Flag</td>
                    <td class="columnHeader">Submit with<br> no SSN</td>
                    <td class="columnHeader">Notes</td>
                    <td class="columnHeader">Approved</td>
                    <td class="columnHeader">Denied</td>
                </tr>
                <cfloop query="qGetCBCMother">
                    <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                        <td>#qGetCBCMother.companyshort#</td>
                        <td>#qGetCBCMother.season#</td>
                        <td>#DateFormat(qGetCBCMother.date_authorized, 'mm/dd/yyyy')#</td>
                        <td><cfif isDate(qGetCBCMother.nexits_approved)>#DateFormat(qGetCBCMother.nexits_approved, 'mm/dd/yyyy')#</cfif></td>
                        <td><cfif isDate(qGetCBCMother.date_sent)>#DateFormat(qGetCBCMother.date_sent, 'mm/dd/yyyy')#<cfelse>in process</cfif></td>
                        <td><cfif isDate(qGetCBCMother.date_expired)>#DateFormat(qGetCBCMother.date_expired, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
                        <td><a href="cbc/view_host_cbc.cfm?hostID=#qGetCBCMother.hostID#&CBCFamID=#qGetCBCMother.CBCFamID#&file=batch_#qGetCBCMother.batchid#_host_mother_#qGetCBCMother.hostid#_rec.xml" target="_blank">#qGetCBCMother.requestID#</a></td>
                        <td><input type="checkbox" name="#cbcfamID#MotherflagCBC" value="1" <cfif VAL(flagCBC)>checked="checked"</cfif>></td>
                        <td>
                            <cfif LEN(qGetCBCMother.date_sent)>
                                #YesNoFormat(qGetCBCMother.isNoSSN)#
                            <cfelse>
                                <input type="checkbox" name="#cbcfamID#motherIsNoSSN" value="1" <cfif VAL(qGetCBCMother.isNoSSN)>checked="checked"</cfif>>
                            </cfif>
                        </td>
                         <td>
                         	<textarea rows="3" cols=15 name="#cbcfamID#notesmother" onkeypress="updateCounter(this);"><cfif isDefined('notes')>#notes#</cfif></textarea>
                         </td>
                        <td>
                        	<input type="hidden" name="#cbcfamID#date_approvedMother" id="#cbcfamID#date_approvedMother" value="#DateFormat(date_approved,'mm/dd/yyyy')#"/>
                        	<input type="checkbox" id="#cbcfamID#date_approvedMotherCheckBox" onclick="insertDateByID('#cbcfamID#date_approvedMother','MM/DD/YYYY','#cbcfamID#motherDeniedCheckBox')"
                            	<cfif date_approved IS NOT ''>checked="checked"</cfif>
                                <cfif denied IS NOT ''>disabled="disabled"</cfif> />
                        </td>
                  		<td>
                        	<input type="hidden" name="#cbcfamID#motherDenied" id="#cbcfamID#motherDenied" value="#DateFormat(denied,'mm/dd/yyyy')#"/>
                        	<cfif denied IS ''>
                            	<input type="checkbox" id="#cbcfamID#motherDeniedCheckBox" onclick="insertDateByID('#cbcfamID#motherDenied','MM/DD/YYYY','#cbcfamID#date_approvedMotherCheckBox')"
                                <cfif date_approved IS NOT ''>disabled="disabled"</cfif> />
                            <cfelse>
                            	<input type="checkbox" checked="checked" disabled="disabled" />
                            </cfif>
                        </td>
                    </tr>
                </cfloop>
            
                <!--- NEW CBC - HOST MOTHER --->
                <cfif VAL(qGetMotherSeason.recordcount)>
                    <tr>
                        <td>
                            <select name="mothercompanyID">
                                <cfloop query="qGetCompanies">
                                <option value="#companyID#" <cfif qGetCompanies.companyID EQ client.companyID>selected</cfif>>#companyshort#</option>
                                </cfloop>
                            </select>
                        </td>		
                        <td>
                            <select name="motherSeasonID">
                                <option value="0">Select a Season</option>
                                <cfloop query="qGetMotherSeason"><option value="#seasonID#">#season#</option></cfloop>
                            </select>
                        </td>
                        <td><input type="text" name="motherdate_authorized" value="" maxlength="10" class="datePicker"></td>
                        <td><input type="text" name="motherdate_nexits_approved" value="" maxlength="10" class="datePicker"></td>
                        <td>n/a</td>
                        <td>n/a</td>
                        <td>n/a</td>
                        <td><input type="checkbox" name="motherIsNoSSN" value="1"></td>
                        <td align="left" valign="top"></td>
                        <td></td>
                    </tr>
                    <tr><td colspan="4"><font size="-2" color="000099">* Season must be selected.</font></td></tr>
                </cfif>
                <tr><td colspan="7">&nbsp; <br></td></tr>
            </cfif>
            
            <!--- HOST FATHER --->
            <cfif LEN(qGetHost.fatherfirstname)>
                <tr><td colspan="12" bgcolor="##e2efc7"><b>Other Host Parent - #qGetHost.fatherfirstname# #qGetHost.fatherlastname#</b></td></tr>
                <tr>
                    <td class="columnHeader">Company</td>
                    <td class="columnHeader">Season</td>		
                    <td class="columnHeader">Authorization Received <br><font size="-2">mm/dd/yyyy</font></td>		
                    <td class="columnHeader">Approved In NEXITS</td>	
                    <td class="columnHeader">CBC Submitted <br><font size="-2">mm/dd/yyyy</font></td>	
                    <td class="columnHeader">Expiration Date <br><font size="-2">mm/dd/yyyy</font></td>		
                    <td class="columnHeader">Request ID</td>
                    <td class="columnHeader">Flag</td>
                    <td class="columnHeader">Submit with<br> no SSN</td>
                    <td class="columnHeader">Notes</td>
                    <td class="columnHeader">Approved</td>
                    <td class="columnHeader">Denied</td>
                </tr>
                <cfloop query="qGetCBCFather">
                    <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                        <td>#qGetCBCFather.companyshort#</td>
                        <td>#qGetCBCFather.season#</td>
                        <td>#DateFormat(qGetCBCFather.date_authorized, 'mm/dd/yyyy')#></td>
                        <td><cfif isDate(qGetCBCFather.nexits_approved)>#DateFormat(qGetCBCFather.nexits_approved, 'mm/dd/yyyy')#</cfif></td>
                        <td><cfif isDate(qGetCBCFather.date_sent)>#DateFormat(qGetCBCFather.date_sent, 'mm/dd/yyyy')#<cfelse>processing</cfif></td>
                        <td><cfif isDate(qGetCBCFather.date_expired)>#DateFormat(qGetCBCFather.date_expired, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
                        <td><a href="cbc/view_host_cbc.cfm?hostID=#qGetCBCFather.hostID#&CBCFamID=#qGetCBCFather.CBCFamID#&file=batch_#qGetCBCFather.batchid#_host_mother_#qGetCBCFather.hostid#_rec.xml" target="_blank">#qGetCBCFather.requestID#</a></td>
                        <td><input type="checkbox" name="#cbcfamID#fatherflagCBC" value="1" <cfif VAL(flagCBC)>checked="checked"</cfif>></td>
                        <td>
                            <cfif LEN(qGetCBCFather.date_sent)>
                                #YesNoFormat(qGetCBCFather.isNoSSN)#
                            <cfelse>
                                <input type="checkbox" name="#cbcfamID#fatherIsNoSSN" value="1" <cfif VAL(qGetCBCFather.isNoSSN)>checked="checked"</cfif>>
                            </cfif>
                        </td>
                         <td><textarea rows="3" cols=15 name="#cbcfamID#notesfather" onkeypress="updateCounter(this);"><cfif isDefined('notes')>#notes#</cfif></textarea></td>
                     	<td>
                        	<input type="hidden" name="#cbcfamID#date_approvedFather" id="#cbcfamID#date_approvedFather" value="#DateFormat(date_approved,'mm/dd/yyyy')#"/>
                        	<input type="checkbox" id="#cbcfamID#date_approvedFatherCheckBox" onclick="insertDateByID('#cbcfamID#date_approvedFather','MM/DD/YYYY','#cbcfamID#fatherDeniedCheckBox')"
                            	<cfif date_approved IS NOT ''>checked="checked"</cfif>
                                <cfif denied IS NOT ''>disabled="disabled"</cfif> />
                        </td>
                  		<td>
                        	<input type="hidden" name="#cbcfamID#fatherDenied" id="#cbcfamID#fatherDenied" value="#DateFormat(denied,'mm/dd/yyyy')#"/>
                        	<cfif denied IS ''>
                            	<input type="checkbox" id="#cbcfamID#fatherDeniedCheckBox" onclick="insertDateByID('#cbcfamID#fatherDenied','MM/DD/YYYY','#cbcfamID#date_approvedFatherCheckBox')"
                                <cfif date_approved IS NOT ''>disabled="disabled"</cfif> />
                            <cfelse>
                            	<input type="checkbox" checked="checked" disabled="disabled" />
                            </cfif>
                        </td>
                    </tr>
                </cfloop>
            
                <!--- NEW CBC --->
                <cfif VAL(qGetFatherSeason.recordcount)>
                    <tr>
                        <td>
                            <select name="fathercompanyID">
                                <cfloop query="qGetCompanies">
                                <option value="#companyID#" <cfif qGetCompanies.companyID EQ client.companyID>selected</cfif>>#companyshort#</option>
                                </cfloop>
                            </select>
                        </td>		
                        <td>
                            <select name="fatherSeasonID">
                                <option value="0">Select a Season</option>
                                <cfloop query="qGetFatherSeason"><option value="#seasonID#">#season#</option></cfloop>
                            </select>
                        </td>
                        <td><input type="Text" name="fatherdate_authorized" value="" maxlength="10" class="datePicker"></td>
                        <td><input type="Text" name="fatherdate_nexits_approved" value="" maxlength="10" class="datePicker"></td>
                        <td>n/a</td>
                        <td>n/a</td>
                        <td>n/a</td>
                        <td><input type="checkbox" name="fatherIsNoSSN" value="1"></td>
                         <td align="left" valign="top"></td>
                         <td></td>
                    </tr>
                    <tr><td colspan="4"><font size="-2" color="000099">* Season must be selected.</font></td></tr>
                </cfif>
                <tr><td colspan="7">&nbsp; <br></td></tr>
            </cfif>
            
            <!--- OTHER FAMILY MEMBERS ---> 	
            <tr>
                <th colspan="10" bgcolor="##e2efc7">O T H E R &nbsp; F A M I L Y &nbsp; M E M B E R S &nbsp; O V E R &nbsp; 16 &nbsp; Y E A R S &nbsp; O L D &nbsp; (Living at Home)</th>
                <th bgcolor="##e2efc7" colspan=2><a href="cbc/hostMemberInfo.cfm?hostID=#qGetHost.hostID#" class="jQueryModal">Edit Family Members Info</a></th>
            </tr>
            <tr><td colspan="7">&nbsp;</td></tr>
            <cfif NOT VAL(qGetHostMembers.recordcount)>
                <tr><td colspan="7">There are no family members.</td></tr>
                <tr><td colspan="7">&nbsp;</td></tr>
            <cfelse>	
                <cfloop query="qGetHostMembers">
                    
                    <cfscript>
                        // Set current Family ID
                        familyID = qGetHostMembers.childID;
                        
                        // Gets Host Member CBC
                        qGetCBCMember = APPCFC.CBC.getCBCHostByID(
                            hostID=hostID,
                            familyMemberID=familyID,
                            cbcType='member'
                        );		
    
                        // Get Member Available Seasons
                        qGetMemberSeason = APPCFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCMember.seasonID));
                    </cfscript>
                    
                    <cfinput type="hidden" name="#familyID#count" value="#qGetCBCMember.recordcount#">
       
                    <tr><td colspan="12" bgcolor="##e2efc7"><b>#name# #lastname#</b></td></tr>
                    <tr>
                        <td class="columnHeader">Company</td>
                        <td class="columnHeader">Season</td>		
                        <td class="columnHeader">Authorization Received <br><font size="-2">mm/dd/yyyy</font></td>	
                        <td class="columnHeader">Approved In NEXITS<br>
                      <font size="-2">mm/dd/yyyy</font></td>			
                      <td class="columnHeader">CBC Submitted <br><font size="-2">mm/dd/yyyy</font></td>
                        <td class="columnHeader">Expiration Date <br><font size="-2">mm/dd/yyyy</font></td>		
                        <td class="columnHeader">Request ID</td>
                       <td class="columnHeader">Flag</td>
                        <td class="columnHeader">Submit with<br> no SSN</td>
                        <td class="columnHeader">Notes</td>
                        <td class="columnHeader">Approved</td>
                        <td class="columnHeader">Denied</td>
                    </tr>
                    
                    <input type="hidden" name="#familyID#memberCBCFamID" value="#qGetCBCMember.cbcFamID#">
                    
                    <cfloop query="qGetCBCMember">
                        <tr bgcolor="#iif(qGetCBCMember.currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                            <td>#qGetCBCMember.companyshort#</td>
                            <td>#qGetCBCMember.season#</td>
                            <td>#DateFormat(qGetCBCMember.date_authorized, 'mm/dd/yyyy')#</td>
                            <td><cfif isDate(qGetCBCMember.nexits_approved)>#DateFormat(qGetCBCMember.nexits_approved, 'mm/dd/yyyy')#</cfif></td>
                            <td><cfif isDate(qGetCBCMember.date_sent)>#DateFormat(qGetCBCMember.date_sent, 'mm/dd/yyyy')#<cfelse>processing</cfif></td>
                            <td><cfif isDate(qGetCBCMember.date_expired)>#DateFormat(qGetCBCMember.date_expired, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
                            <td><a href="cbc/view_host_cbc.cfm?hostID=#qGetCBCMember.hostID#&CBCFamID=#qGetCBCMember.CBCFamID#&file=batch_#qGetCBCMember.batchid#_host_mother_#qGetCBCMember.hostid#_rec.xml" target="_blank">#qGetCBCMember.requestID#</a></td>
                            <td><input type="checkbox" name="#cbcFamID#memberflagCBC" value="1" <cfif VAL(flagCBC)>checked="checked"</cfif>></td>
                            <td>
                                <cfif LEN(qGetCBCMember.date_sent)>
                                    #YesNoFormat(qGetCBCMember.isNoSSN)#
                                <cfelse>
                                    <input type="checkbox" name="#cbcFamID#memberIsNoSSN" value="1" <cfif VAL(qGetCBCMember.isNoSSN)>checked="checked"</cfif>>
                                </cfif>
                            </td>
                             <td><textarea rows="3" cols=15 name="#cbcFamID#notesmember" onkeypress="updateCounter(this);"><cfif isDefined('notes')>#notes#</cfif></textarea></td>
                             <td>
                                <input type="hidden" name="#cbcfamID#date_approvedMember" id="#cbcfamID#date_approvedMember" value="#DateFormat(date_approved,'mm/dd/yyyy')#"/>
                                <input type="checkbox" id="#cbcfamID#date_approvedMemberCheckBox" onclick="insertDateByID('#cbcfamID#date_approvedMember','MM/DD/YYYY','#cbcfamID#memberDeniedCheckBox')"
                                    <cfif date_approved IS NOT ''>checked="checked"</cfif>
                                    <cfif denied IS NOT ''>disabled="disabled"</cfif> />
                            </td>
                            <td>
                                <input type="hidden" name="#cbcfamID#memberDenied" id="#cbcfamID#memberDenied" value="#DateFormat(denied,'mm/dd/yyyy')#"/>
                                <cfif denied IS ''>
                                    <input type="checkbox" id="#cbcfamID#memberDeniedCheckBox" onclick="insertDateByID('#cbcfamID#memberDenied','MM/DD/YYYY','#cbcfamID#date_approvedMemberCheckBox')"
                                    <cfif date_approved IS NOT ''>disabled="disabled"</cfif> />
                                <cfelse>
                                    <input type="checkbox" checked="checked" disabled="disabled" />
                                </cfif>
                            </td>
                        </tr>
                    </cfloop>
    
                    <!--- NEW CBC --->
                    <cfif qGetMemberSeason.recordcount>
                        <tr>
                            <td>
                                <cfselect name="#familyID#companyID" required="yes" message="You must select a company">
                                    <cfloop query="qGetCompanies">
                                        <option value="#companyID#" <cfif qGetCompanies.companyID EQ client.companyID>selected</cfif>>#companyshort#</option>
                                    </cfloop>
                                </cfselect>
                            </td>						
                            <td>
                                <cfselect name="#familyID#seasonID" required="yes" message="You must select a season">
                                    <option value="0">Select a Season</option>
                                    <cfloop query="qGetMemberSeason">
                                    <option value="#seasonID#">#season#</option>
                                    </cfloop>
                                </cfselect>
                            </td>
                            <td><input type="Text" name="#familyID#date_authorized" value="" maxlength="10" class="datePicker"></td>
                            <td><input type="Text" name="#familyID#date_nexits_approved" value="" maxlength="10" class="datePicker"></td>
                            <td>n/a</td>
                            <td>n/a</td>
                            <td>n/a</td>
                            <td><input type="checkbox" name="#familyID#IsNoSSN" value="1"></td>
                            <td align="left" valign="top"></td>
                        </tr>
                        <tr><td colspan="4"><font size="-2" color="##000099">* Season must be selected.</font></td></tr>
                    </cfif>
                <tr><td colspan="7">&nbsp; <br><br></td></tr>			
                </cfloop>
            </cfif>
        </table>
        
        <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
            <tr><td align="center">
                    <a href="?curdoc=host_fam_info&hostID=#hostID#"><img src="pics/back.gif" border="0"></a>
                    &nbsp;  &nbsp;  &nbsp;  &nbsp; &nbsp;  &nbsp;
                    <input name="Submit" type="image" src="pics/update.gif" border="0" alt="submit">
                </td>
        </table>
    </cfform>
    
    <!--- Table Footer --->
    <gui:tableFooter />

</cfoutput>