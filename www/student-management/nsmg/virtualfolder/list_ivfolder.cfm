<!--- ------------------------------------------------------------------------- ----
	
	File:		list_ivfolder.cfm
	Author:		James Griffiths
	Date:		September 28, 2012
	Desc:		Displays, upload and delete files in internal virtual folder (only available for office users)

----- ------------------------------------------------------------------------- --->

<!--- DO NOT DISPLAY THIS PAGE IF THIS IS NOT AN OFFICE USER --->
<cfif NOT APPLICATION.CFC.USER.isOfficeUser()>
	<link rel="stylesheet" href="../smg.css" type="text/css">    
    <br />
    <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
        <tr valign=middle height=24>
            <td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
            <td width=26 background="../pics/header_background.gif"><img src="../pics/helpdesk.gif"></td>
            <td background="../pics/header_background.gif"><h2>Students View - Error </h2></td>
            <td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
        </tr>
    </table>
    <table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
        <tr>
            <td align="center">
                <br />
                <div align="justify">
                	<img src="../pics/error_exclamation.gif" align="left">
                    <h3>
                		<p>I am sorry but you do not have the rights to see this page.</p>
                        <p>If you think this is a mistake please contact <cfoutput>#APPLICATION.EMAIL.support#</cfoutput></p>
                 	</h3>
             	</div>
            </td>
        </tr>
    <tr><td align="center"><input type="image" value="Back" onClick="history.go(-1)" src="../pics/back.gif"></td></tr>
    </table>
    <table width=100% cellpadding=0 cellspacing=0 border=0>
        <tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
            <td width=100% background="../pics/header_background_footer.gif"></td>
            <td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
        </tr>
    </table>
	<cfabort>
</cfif>

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <!--- Param URL Variables --->
    <cfparam name="URL.unqID" type="string" default="">
    <cfparam name="URL.placement" type="integer" default="0">

	<cfscript>
        // Make sure there is a unqID
		if ( NOT LEN(URL.unqID) ) { 
			include "error_message.cfm";
			abort;
		}
		
		// Get Student Info
        qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(uniqueID=URL.unqID);
		
		// Get Student Placements
		qGetStudentPlacements = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=qGetStudentInfo.studentID);
		
		// Set the currently selected placement
		if (URL.placement EQ 0) {
			selectedPlacement = qGetStudentPlacements.historyID; // Select the first returned placement if nothing is selected.
		} else {
			selectedPlacement = URL.placement;
		}
		
		// Get Selected Placement details
		qGetSelectedPlacementDetails = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=qGetStudentInfo.studentID,historyID=selectedPlacement);
    
        // Get Folder Path 
        flightInfoDirectory = "#APPLICATION.PATH.onlineApp.internalVirtualFolder##qGetStudentInfo.studentid#/#selectedPlacement#/flightInformation";
    
        // Make sure the folder Exists
        AppCFC.UDF.createFolder(flightInfoDirectory);
    </cfscript>

	<cfdirectory directory="#flightInfoDirectory#" name="flightDocs" sort="datelastmodified DESC" filter="*.*">
    
</cfsilent>    

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

		<script type="text/javascript"> 
			// Reloads with the chosen placement (assumes that unqID is the only other url variable)
			function changePlacement(selected) {
				var place = selected.options[selected.selectedIndex].value;
				var newLocation = window.location.href;
				if (window.location.href.indexOf('&') > -1) {
					newLocation = window.location.href.substring(0,window.location.href.indexOf('&'));
				}
				newLocation = newLocation + "&placement=" + place;
				window.location.href = newLocation;
			}
			
			// print images
			function OpenApp(url)
			{ 
				newwindow=window.open(url, 'ViewFile', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
				if (window.focus) {newwindow.focus()}
			}
        </script>

		<!--- Table Header --->
        <gui:tableHeader
            imageName="helpdesk.gif"
            tableTitle="Internal Virtual Folder &nbsp; - &nbsp; #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)"
            width="98%"
            imagePath="../"
        />    
        
		<!--- Page Messages --->
        <gui:displayPageMessages 
            pageMessages="#SESSION.pageMessages.GetCollection()#"
            messageType="tableSection"
            width="98%"
            />

        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="98%"
            />

        <table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center" style="padding-bottom:15px;">
        	
            <tr>
                <th colspan="2" align="center">Placement:
                	<select onchange="changePlacement(this)">
                    	<cfloop query="qGetStudentPlacements">
                        	<option value="#historyID#"<cfif URL.placement EQ #historyID#>selected="selected"</cfif>>#familyLastName# (###hostID#)</option>
                        </cfloop>
                 	</select>
             	</th>
            </tr>
            
            <tr>
                <th colspan="5" align="center" style="border-bottom:thin solid black;">Documents</th>
            </tr>
            <tr bgcolor="##E2EBF0" style="font-weight:bold;">
                <td width="90%">Document</td>
                <td align="center" width="10%">View</td>
            </tr>
            
            <!--- Placement Information Sheet --->
            <tr>
            	<td style="border-bottom:1px solid gray;">Placement Information Sheet</td>
            	<td align="center" style="border-bottom:1px solid gray;">
                	<a href="../reports/placementInfoSheet.cfm?uniqueID=#URL.unqID#&historyID=#selectedPlacement#&profileType=pdf">
                        <img src="vfolderview.gif" border="0" alt="View File"></img>
                    </a>
                </td>
            </tr>
            
            <!--- Host Family Welcome Letter --->
            <tr>
            	<td style="border-bottom:1px solid gray;">Host Family Welcome Letter</td>
            	<td align="center" style="border-bottom:1px solid gray;">
                	<a href="../reports/host_welcome_letter.cfm?historyID=#selectedPlacement#&pdf=1">
                        <img src="vfolderview.gif" border="0" alt="View File"></img>
                    </a>
                </td>
            </tr>
            
            <!--- School Welcome Letter --->
            <tr>
            	<td style="border-bottom:1px solid gray;">School Welcome Letter</td>
            	<td align="center" style="border-bottom:1px solid gray;">
                	<a href="../reports/school_welcome_letter.cfm?historyID=#selectedPlacement#&pdf=1">
                        <img src="vfolderview.gif" border="0" alt="View File"></img>
                    </a>
                </td>
            </tr>
            
            <!--- School Acceptance Letter --->
            <tr>
            	<td style="border-bottom:1px solid gray;">School Acceptance Letter</td>
            	<td align="center" style="border-bottom:1px solid gray;">
                	<a href="school_acceptance.cfm?studentid=#qGetStudentInfo.studentid#&hostID=#qGetSelectedPlacementDetails.hostID#">
                        <img src="vfolderview.gif" border="0" alt="View File"></img>
                    </a>
                </td>
            </tr>
            
            <tr><td colspan="2"><br /></td></tr>
            
            <tr>
                <th colspan="5" align="center" style="border-bottom:thin solid black;">Flight Information</th>
            </tr>
            <tr bgcolor="##E2EBF0" style="font-weight:bold;">
                <td width="90%">File</td>
                <td align="center" width="10%">View</td>
            </tr>
            
            <cfloop query="flightDocs">
            	<tr>
                	<td style="border-bottom:1px solid gray;">#name# - #DateFormat(dateLastModified,'mm/dd/yyyy')#</td>
                    <td align="center" style="border-bottom:1px solid gray;">
                    	<a href="javascript:OpenApp('../uploadedfiles/internalVirtualFolder/#qGetStudentInfo.studentID#/#selectedPlacement#/flightInformation/#name#');">
                        	<img src="vfolderview.gif" border="0" alt="View File"></img>
                     	</a>
                  	</td>
              	</tr>
            </cfloop>
            
        </table>
        
	<cfset currentDirectory = "#AppPath.onlineApp.internalVirtualFolder##qGetStudentInfo.studentID#">
    
    <!--- Check to see if the Directory exists. --->
    <cfif NOT DirectoryExists(currentDirectory)>
       <!--- If TRUE, create the directory. --->
       <cfdirectory action = "create" directory = "#currentDirectory#" mode="777">
    </cfif>
    
    <table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center" style="padding-bottom:15px;">
        <tr><td align="center"><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
    </table>
                
    <!--- Table Footer --->
    <gui:tableFooter 
        width="98%"
        imagePath="../"
    />
    
    <!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />

</cfoutput>