<!--- ------------------------------------------------------------------------- ----
	
	File:		insertFLSID.cfm
	Author:		Marcus Melo
	Date:		June 30, 2011
	Desc:		Inserts FLS ID

	Updated:	
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param FORM Variable --->
    <cfparam name="FORM.action" default="">
    <cfparam name="FORM.excelFile" default="">

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
	<cfscript>
		// Data Validation
		switch(FORM.action) {
			
			case 'importExcel': {

				// File Name
				if ( NOT LEN(FORM.excelFile) ) {
					SESSION.formErrors.Add("Please select a file");
				}
				
				// Check if there are no errors
				if ( NOT SESSION.formErrors.length() ) {				
					// Process File
					APPLICATION.CFC.STUDENT.importFLSFile(excelFile=FORM.excelFile);
					// Set Page Message
					SESSION.pageMessages.Add("Excel file successfully imported.");
					// Clear Action
					FORM.action = '';
				}
				
				break;
			}

		}
    </cfscript>

</cfsilent>

<style type="text/css">
	table.report {
		width:100%;
		border-spacing: 0px;
		border-collapse: collapse;
	}

	table.report td.top, th.top {
		border-top:1px solid #999;
		padding: 5px;
		-moz-border-radius: 0px 0px 0px 0px;
	}
	
	table.report td, th {
		border-bottom:1px solid #999;
		border-left:1px solid #999;
		border-right:1px solid #999;
		padding: 5px;
		-moz-border-radius: 0px 0px 0px 0px;
	}
</style>
	
<!--- Display Forms --->        
<cfoutput>

	<!--- Table Header --->
	<gui:tableHeader
		imageName="students.gif"
		tableTitle="FLS Import Tool"
		width="100%"
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
		
		<table border="0" cellpadding="8" cellspacing="2" width="100%" class="section">
			<tr>
				<td>
                
                    <!--- Import --->
					<table cellpadding="4" cellspacing="0" align="center" width="96%">
                        <tr>
                            <td width="50%" valign="top">
                                <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="action" value="importExcel" />
                                    <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                                        <tr><th colspan="2" bgcolor="e2efc7">FLS ID - Import Excel File</th></tr>
                                        <tr align="left">
                                            <td valign="top" align="right"><label for="excelFile">File:</label></td>
                                            <td><input type="file" name="excelFile" id="excelFile" /></td>		
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                Required Columns: ID | FLS ID 
                                            </td>
                                        </tr>                                                
                                        <tr>
                                            <td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                                        </tr>
                                    </table>
                                </form>
                            </td>
                            <td width="50%" valign="top">
                            
                            </td>		
                        </tr>
                    </table>
					
				</td>
			</tr>
		</table>
		
	<!--- Table Footer --->
	<gui:tableFooter 
		width="100%"
	/>

</cfoutput>
   