<!--- ------------------------------------------------------------------------- ----
	
	File:		_list.cfm
	Author:		Marcus Melo
	Date:		December 11, 2009
	Desc:		ISEUSA.com Host Family Leads

	Updated:	02/01/2011 - Ability to assign a host lead to a region
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.keyword" default="";
		param name="FORM.followUpID" default=0;	
		param name="FORM.regionID" default=99999;	
		param name="FORM.stateID" default=0;	
		param name="FORM.statusID" default="";	
		param name="FORM.sortBy" default="dateCreated";		
		param name="FORM.sortOrder" default="DESC";	
		param name="FORM.pageSize" default=30;	
		param name="FORM.active_rep" default="";
		param name="FORM.area_rep" default = "";
		param name="FORM.city" default = "";
		
		// Make sure records have a valid hashID and the initial record in the history table
		// APPLICATION.CFC.HOST.setHostLeadDataIntegrity();
	
		// Follow Up User List
		qGetFollowUpUserList = APPLICATION.CFC.USER.getUsers(userType=26);
	
		// Get User Regions
		qGetRegions = APPLICATION.CFC.REGION.getUserRegions(
			companyID=CLIENT.companyID,
			userID=CLIENT.userID,
			userType=CLIENT.userType
		);
		
		// Get List of States
		qGetStates = APPLICATION.CFC.LOOKUPTABLES.getState();

		// Get List of Status
		qGetStatus = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='hostLeadStatus');
	</cfscript>	
	
	<Cfif isDefined('url.status')>
   		<cfset FORM.statusID = #url.status#>
    </Cfif>

	 <cfif APPLICATION.CFC.USER.isOfficeUser()>
			<cfscript>
				qGetAreaRepList = APPLICATION.CFC.USER.getUsers(
					userType = ('5,6,7'),
					isActive = 1,
					companyID = CLIENT.companyID
				);
			</cfscript>
	<cfelse>
			<cfscript>
				qGetAreaRepList = APPLICATION.CFC.USER.getUsers(
					userType = ('5,6,7'),
					isActive = 1,
					companyID = CLIENT.companyID,
					regionID = CLIENT.regionID
				);
			</cfscript>
	</cfif>

	   <cfquery name="qGetCities" datasource="#APPLICATION.DSN#">
			SELECT DISTINCT TRIM(city) AS city
			FROM smg_hosts 
			WHERE city <> ''  
				AND active = 1
				AND companyID = #CLIENT.companyID#
			<cfif NOT APPLICATION.CFC.USER.isOfficeUser()>
				AND smg_hosts.regionID = #CLIENT.regionID#  
			</cfif>  
			ORDER BY city ASC
		</cfquery>


	<!--- Ajax Call to the Component --->
    <cfajaxproxy cfc="nsmg.extensions.components.host" jsclassname="hostFamily">

    
</cfsilent>    
  
           
<script language="javascript">
	// Function to find the index in an array of the first entry with a specific value. 
	// It is used to get the index of a column in the column list. 
	Array.prototype.findIdx = function(value){ 
		for (var i=0; i < this.length; i++) { 
			if (this[i] == value) { 
				return i; 
			} 
		} 
	} 

	// Create an instance of the proxy. 
	var hf = new hostFamily();

	// Load the list when page is ready
	$(document).ready(function() {
		getHostLeadList();
	});
	
	// --- START OF HOST LEADS LIST --- //

	// Use an asynchronous call to get the student details. The function is called when the user selects a student. 
	var getHostLeadList = function(pageNumber, titleSortBy) { 
		
		// pageNumber could be passed to the function, if not set it to 1
		if ( pageNumber == '' ) {
			var pageNumber = 1;
		}

		// FORM Variables
		var keyword = $("#keyword").val();
		var regionID = $("#regionID").val();
		var stateID = $("#stateID").val();
		var statusID = $("#statusID").val();
		var sortBy = $(".selectSortBy").val();	
		var sortOrder = $(".selectSortOrder").val();		
		var pageSize = $("#pageSize").val();
		var active_rep = $("#active_rep").val();
		var area_rep= $("#area_rep").val();
		var city = $("#city").val();
		
		if( typeof titleSortBy != 'undefined' ) {
			// SortBy was passed by the sort title function
			
			// Set sortOrder if sorting same column
			if ( sortBy == titleSortBy && sortOrder == 'ASC' ) {
				sortOrder = 'DESC';
			} else { 
				// ASC is the default sort order for the columns
				sortOrder = 'ASC';
			}
			
			//.addClass('selectedLink');
			
			// Update FORM values
			$(".selectSortBy").val(titleSortBy);
			$(".selectSortOrder").val(sortOrder);
			sortBy = titleSortBy;
		}

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		hf.setCallbackHandler(populateList); 
		hf.setErrorHandler(myErrorHandler); 
		// This time, pass the intRep ID to the getHostLeadList CFC function. 
		hf.getHostLeadsRemote(pageNumber,keyword,regionID,stateID,statusID,sortBy,sortOrder,pageSize,active_rep,area_rep,city);
	} 

	// Callback function to handle the results returned by the getHostLeadList function and populate the table. 
	var populateList = function(hostLeadData) { 
		
		// Set Pagination Information		
		var numberOfRecordsOnPage = hostLeadData.NUMBEROFRECORDSONPAGE;
		var numberOfPages = hostLeadData.NUMBEROFPAGES;
		var numberOfRecords = hostLeadData.NUMBEROFRECORDS;
		var recordFrom = hostLeadData.RECORDFROM;
		var recordTo = hostLeadData.RECORDTO;
		var pageNumber = hostLeadData.PAGENUMBER;
		var nextPageNumber = pageNumber + 1;
		var prevPageNumber = pageNumber - 1;

		/*** 
			Start building page links
		***/
		if ( numberOfRecords > 0 ) {
		
		
			//Display query set info
			var paginationInfo = '<td id="topPageNavigation" colspan="12" align="center"> <p> Displaying <strong>' + recordFrom + '</strong> to: <strong>' + recordTo + '</strong> of <strong>' + numberOfRecords + '</strong> records <br />';
				paginationInfo += 'Total Number of Pages: <strong>' + numberOfPages + '</strong></p></td>';
	
			// Clear current information and append pagination info
			$("#loadPaginationInfo").empty().append(paginationInfo);
		
			var $pager = $('<div class="pager" align="center" width="100%"></div>');
			for ( var page = 1; page < numberOfPages + 1; page++ ) {
					
				//expression ensures no more than 20 page links are shown at one time   
				if( (pageNumber > (page - 10)) && (pageNumber < (page + 10)) ) 	{
					//for each page link build a span tag and bind a click handler to each one that will call build table each time it is clicked
					$('<span class="page-number"></span>').html('<a id="' + page + '" href="javascript:void(0);" title="Go to ' + page + '">' + page + ' </a>').bind('click', {newPage: page}, function(event) {
						currentPage = event.data['newPage'];
						getHostLeadList(currentPage);//builds table each time a page link is clicked
					  }).appendTo($pager);// append each span tag/link to pager div
	
				}
			}
			
			if ( numberOfPages > 1 ) {
			
				//highlight current pageNumber  
				$pager.find('#' + pageNumber).addClass('selectedLink');
				 
				//the links that will take user one place forward and on place back
				var $previousLink = $('<a href="" id="prev" class="previousPage" title="Go To Previous Page"> [Previous Page] </a>');
				var $nextLink = $('<a href="" id="next" class="nextPage" title="Go To Next Page"> [Next Page] </a>');
				//previous and next links with handler that prevents the default event of hyperlink, and calls buildTable() on each click;
				if ( pageNumber != 1 ) {
					$previousLink.prependTo($pager).click(function(event){event.preventDefault();getHostLeadList(prevPageNumber);});
				}
				if ( pageNumber != numberOfPages ) {
					$nextLink.appendTo($pager).click(function(event){event.preventDefault();getHostLeadList(nextPageNumber);});
				}
				
				//place paging links before and after table
				$("#topPageNavigation").append($pager);
				//$pager.clone(true).insertBefore("#loadHostLeadList");
				//$pager.insertAfter("#loadPaginationInfo");

			}
		} else {
			
			// Clear current
			$("#loadPaginationInfo").empty();
			
		}
		/*** 
			End of building page links
		***/

		// Create Table Header
		var tableHeader = '<thead>';
			tableHeader += '<tr>';
        	tableHeader += '<th id="firstName" class="listTitle"><a href="javascript:void(0);" title="Sort By First Name">First Name</a></th>';
        	tableHeader += '<th id="lastName" class="listTitle"><a href="javascript:void(0);" title="Sort By Last Name">Last Name</a></th>';
        	tableHeader += '<th id="host_city" class="listTitle"><a href="javascript:void(0);" title="Sort By City">City</a></th>';
        	tableHeader += '<th id="state" class="listTitle"><a href="javascript:void(0);" title="Sort By State">State</a></th>'; 
		
            // tableHeader += '<td id="zipCode" class="listTitle"><a href="javascript:void(0);" title="Sort By Zip Code">Zip Code</a></td>';                                                          
            tableHeader += '<th id="phone" class="listTitle"><a href="javascript:void(0);" title="Sort By Phone">Phone</a></th>';                                                           
            tableHeader += '<th id="email" class="listTitle"><a href="javascript:void(0);" title="Sort By Email">Email</a></th>'; 
           
            tableHeader += '<th id="regionAssigned" class="listTitle"><a href="javascript:void(0);" title="Sort By Region">Region</a></th>';  
            tableHeader += '<th id="areaRepAssigned" class="listTitle"><a href="javascript:void(0);" title="Sort By Area Rep.">Area Rep.</a></th>';  		
            tableHeader += '<th id="statusAssigned" class="listTitle"><a href="javascript:void(0);" title="Sort By Status">Status</a></th>';  
		 	tableHeader += '<th id="dateCreated" class="listTitle"><a href="javascript:void(0);" title="Sort By Submitted On">Submitted</a></th>'; 
			tableHeader += '<th id="dateUpdated" class="listTitle"><a href="javascript:void(0);" title="Sort By Last Updated">Updated</a></th>'; 
            tableHeader += '<th class="listTitle" align="center" colspan=4></th>';                                                          
			tableHeader += '</tr>';
			tableHeader += '<thead>';	
		
		
		// Clear current result and append Table Header to HTML
		$("#loadHostLeadList").empty().append(tableHeader);
		
		// Add click handlers to handle sorting by. They cause query to be returned in the order selected by the user. Update sortBy value
		$('#firstName').click(function (){getHostLeadList(pageNumber,this.id);});
		$('#lastName').click(function (){getHostLeadList(pageNumber,this.id);});
		$('#host_city').click(function (){getHostLeadList(pageNumber,this.id);});
		$('#state').click(function (){getHostLeadList(pageNumber,this.id);});
		// $('#zipCode').click(function (){getHostLeadList(pageNumber,this.id);});
		$('#phone').click(function (){getHostLeadList(pageNumber,this.id);});
		$('#email').click(function (){getHostLeadList(pageNumber,this.id);});
		$('#dateCreated').click(function (){getHostLeadList(pageNumber,this.id);});
		$('#dateUpdated').click(function (){getHostLeadList(pageNumber,this.id);});
		$('#regionAssigned').click(function (){getHostLeadList(pageNumber,this.id);});
		$('#areaRepAssigned').click(function (){getHostLeadList(pageNumber,this.id);});
		$('#statusAssigned').click(function (){getHostLeadList(pageNumber,this.id);});
		
		
		
		// No data returned, display message
		if( hostLeadData.QUERY.DATA.length == 0) {			
			$("#loadHostLeadList").append("<tr bgcolor='#FFFFE6'><th colspan='12'>Your search did not return any results.</th></tr>");
		}
		
		// Loop over results and build the grid
		for(i=0; i<hostLeadData.QUERY.DATA.length; i++) { 
			
			var id = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('ID')];		
			var hashID = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('HASHID')];
			var firstName = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('FIRSTNAME')];
			var lastName = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('LASTNAME')];
			var city = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('CITY')];
			var state = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('STATE')];
			// var zipCode = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('ZIPCODE')];
			var phone = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('PHONE')];
			var email = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('EMAIL')];
			var dateCreated = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('DATECREATED')];
			var dateUpdated = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('DATEUPDATED')];
			var regionAssigned = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('REGIONASSIGNED')];
			var areaRepAssigned = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('AREAREPASSIGNED')];
			var statusAssigned = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('STATUSASSIGNED')];
		
			
			// Create Table Rows
			var tableBody = "";	
			
				tableBody = '<tr id="' + id + '">';
			
				tableBody += '<td><a href="hostLeads/index.cfm?action=detail&id=' + id + '&key=' + hashID + '" class="modalDialog">' + firstName + '</a></td>';
				tableBody += '<td><a href="hostLeads/index.cfm?action=detail&id=' + id + '&key=' + hashID + '" class="jQueryModal">' + lastName + '</a></td>';
				tableBody += '<td>' + city + '</a></td>';
				tableBody += '<td>' + state + '</td>';
				// tableBody += '<td>' + zipCode + '</td>';
				tableBody += '<td>' + phone + '</td>';
				tableBody += '<td><a href="mailto:' + email + '">' + email + '</a></td>';
				
				
				tableBody += '<td>' + regionAssigned + '</td>';
				tableBody += '<td>' + areaRepAssigned + '</td>';
				tableBody += '<td>' + statusAssigned + '</td>';
				tableBody += '<td>' + dateCreated + '</td>';
				tableBody += '<td>' + dateUpdated + '</td>';
				if (statusAssigned == 'Converted to Host'){
				tableBody += '<td align="center"> <a href="hostLeads/index.cfm?action=detail&id=' + id + '&key=' + hashID + '" class="jQueryModal"><button type="button" class="btn-u btn-u-orange">Details</button></a>';
				}else{
					tableBody += '<td align="center"><a href="hostLeads/convert_lead.cfm?leadID=' + id + '&key=' + hashID + '" class="jQueryModal"><button type="button" class="btn-u btn-u-green">Convert</button></a>  <a href="hostLeads/index.cfm?action=detail&id=' + id + '&key=' + hashID + '" class="jQueryModal"><button type="button" class="btn-u btn-u-orange">Update</button></a>';
					tableBody += ' <a href="javascript:confirmDeleteHostLead(' + id + ');"><button type="button" class="btn-u btn-u-red">Not Interested</button></a>';
						
				}
				tableBody += '</td></tr>';
			// Append table rows
			$("#loadHostLeadList").append(tableBody);
		} 

		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"60%", 
			height:"90%", 
			iframe:true,
			overlayClose:true,
			escKey:true,
			closeButton:true,
			
		});		

	}
	// --- END OF HOST LEADS LIST --- //


	// --- START OF DELETE LEAD --- //
	var confirmDeleteHostLead = function(ID) {
		// Are you sure you would like to check DS-2019 verification for student #" + studentID + " as received?
		var answer = confirm("Are you sure would you like to mark this lead as not interested in hosting?")
		if (answer){
			deleteHostFamilyLead(ID);
		} 
	}	

	var deleteHostFamilyLead = function(ID) {
		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		hf.setCallbackHandler(hostLeadDeleted(ID)); 
		hf.setErrorHandler(myErrorHandler); 
		hf.deleteHostLeadRemote(ID);
	}
	
	var hostLeadDeleted = function(ID) {
		// Set up page message, fade in and fade out after 2 seconds
		$("#hostLeadPageMessage").text("Host Lead #" + ID + " has been deleted");
		$(".pageMessages").fadeIn().fadeOut(3000);

		// Fade out record from search list
		$("#" + ID).fadeOut("slow");
	}
	// --- END OF DELETE LEAD --- //


	// Error handler for the asynchronous functions. 
	var myErrorHandler = function(statusCode, statusMsg) { 
		alert('Status: ' + statusCode + ', ' + statusMsg); 
	} 
	
	function checkSearchFields() {
	$("#regionid_export").val($("#regionID").val());
	$("#keyword_export").val($("#keyword").val());
	$("#stateID_export").val($("#stateID").val());
	$("#statusID_export").val($("#statusID").val());
	$("#sortBy_export").val($("#sortBy").val());
	$("#sortOrder_export").val($("#sortOrder").val());
	$("#area_rep_export").val($("#area_rep").val());
	$("#city_export").val($("#city").val());


	//console.log($("#HFstatus_export").val());
	
	return true;
	}
	
</script>

<style>
	a:hover{
		text-decoration: underline;
	}

	input { 
		border: 1px solid #CCC; 
		margin-bottom: .5em; 		
	}
	
	select {
		border: 1px solid #CCC; 
		margin-bottom: .5em;
	}
	
	.listTitle { 
		font-weight:bold;
	}
	
	.listTitleUp { 
		background-position:right;
		background-repeat:no-repeat;
		background-image:url(pics/arrowUp.jpg);
	}

	.listTitleDown {
		background-position:right;
		background-repeat:no-repeat;
		background-image:url(pics/arrowDown.jpg);
	}

	.pageMessage {
		display:none;
		margin-bottom:10px;
		text-align:center;
		font-weight:bold;
		color:#006699;
	}

	.loadHostLeadList {
		display:none;
	}

	/* Page Navigation */
	.nextPage {
		padding-left:10px;		
	}
	
	.previousPage {
		padding-right:10px;		
	}
	
	.selectedLink { 
		background-color: #E2EFC7; 
		font-family:Arial, Helvetica, sans-serif; 
		font-size:18px; 
		font-weight:bold;
		padding-left:4px;
		margin:0px 5px 0px 3px;
		text-align:center;
	}
	
	.notSelectedLinks { 
		font-family:Arial, Helvetica, sans-serif; 
		font-size:14px;
	}
</style>

<cfoutput>


	<!--- This holds the student information messages --->
    <table width="100%" border="0" cellpadding="4" cellspacing="0" class="section pageMessages displayNone" align="center">
        <tr>
            <td align="center">
                <div class="pageMessages">
                     <p><em id="hostLeadPageMessage"></em></p>    
                </div>                                    
            </td>
        </tr>                        
    </table>
        
	<!--- Search Options --->
    <table border="0" cellpadding="4" cellspacing="4" class="table table-striped" width="100%" style="padding:15px;">
        <tr >
            <td><input name="send" type="submit" value="Search" class="submitButton" onClick="getHostLeadList();" /></td>
            <td>
               Region<br />   
                <select name="regionID" id="regionID">
              		 <option value="999999">All Regions</option>
                	<cfif ListFind("1,2,3,4", CLIENT.userType)>
                		<option value="0" <cfif NOT VAL(FORM.regionID)>selected="selected"</cfif> >Unassigned</option>
                    </cfif>
                    <cfloop query="qGetRegions">
                    	<option value="#qGetRegions.regionID#" <cfif FORM.regionID EQ qGetRegions.regionID>selected="selected"</cfif> >#qGetRegions.regionName#</option>
                    </cfloop>
                </select>
            </td>    
            <td>
                <label for="keyword">Keyword</label> <br />
                <input type="text" name="keyword" id="keyword" maxlength="50" />
            </td> 
            <td>
                    With Active Rep<br />
                    <select name="active_rep" id="active_rep">
                        <option value="2">All</option>
                        <option value="1" <cfif FORM.active_rep EQ 1>selected</cfif>>Yes</option>
                        <option value="0" <cfif FORM.active_rep EQ 0>selected</cfif>>No</option>
                    </select>    
            </td>    
            <td>
                        Area Rep<br />
                        <select name="area_rep" id="area_rep">
                            <option value="">All</option>
                            <cfloop query="qGetAreaRepList">
                                <option value="#qGetAreaRepList.userID#" <cfif FORM.area_rep EQ qGetAreaRepList.userID>selected</cfif>>

                                    <cfif LEN(qGetAreaRepList.firstname) + LEN(qGetAreaRepList.lastname) GT 20>
                                        #qGetAreaRepList.firstname# #qGetAreaRepList.lastname#...
                                    <cfelse>
                                        #qGetAreaRepList.firstname# #qGetAreaRepList.lastname# (###qGetAreaRepList.userID#)
                                    </cfif>

                                    
                                </option>
                            </cfloop>
                        </select>
                    </td>
		  <td>
				City<br />
				<select name="city" id="city">
					<option value="" >All</option>
					<cfloop query="qGetCities">
						<option value="#qGetCities.city#" <cfif qGetCities.city EQ FORM.city>selected</cfif>>
							<cfif LEN(qGetCities.city) GT 10>
								#LEFT(qGetCities.city, 10)#...
							<cfelse>
								#qGetCities.city#
							</cfif>
						</option>
					</cfloop>
				</select>
			</td>
             <td>
                Status<br />   
                <select name="statusID" id="statusID">
                	<option value="All" <cfif FORM.statusID EQ 'All'>selected="selected"</cfif> >All</option>
                    <option value="" <cfif NOT LEN(FORM.statusID)>selected="selected"</cfif> >Pending Action</option>
                    <cfloop query="qGetStatus">
                    	<option value="#qGetStatus.fieldID#" <cfif FORM.statusID EQ qGetStatus.fieldID>selected="selected"</cfif> >#qGetStatus.name#</option>
                    </cfloop>
                </select>
                
                <input type="hidden" name="sortBy" class="selectSortBy" /> 
                <input type="hidden" name="sortOrder" class="selectSortOrder" />    
            </td>               
            <td>
                State<br />   
                <select name="stateID" id="stateID">
                	<option value="0" <cfif NOT LEN(FORM.stateID)>selected="selected"</cfif> >All</option>
                    <cfloop query="qGetStates">
                    	<option value="#qGetStates.ID#" <cfif FORM.stateID EQ qGetStates.ID>selected="selected"</cfif> >#qGetStates.stateName#</option>
                    </cfloop>
                </select>
            </td>                
     
              
            <td>
             Records per Page<br />
                <select name="pageSize" id="pageSize" class="smallField">
                	<cfloop from="30" to="150" step="30" index="i">
	                    <option class="#i#" <cfif FORM.pageSize EQ i>selected="selected"</cfif> >#i#</option>
                    </cfloop>
                </select>
            </td>                
                       
        </tr>
       <!---- 
        <cfif ListFind('1,2,3,4', CLIENT.userType)>
            <tr>
                <td align="center" colspan="12">
                    <a class="jQueryModal" href="hostLeads/index.cfm?action=export">[ Export to Constant Contact ]</a>
                </td>
            </tr>                        
        </cfif>
        ---->
        <!--- Pagination information goes here --->
        <tr id="loadPaginationInfo"></tr>
    </table>

    <!--- Host Leads List --->
    <table id="loadHostLeadList" border="0" cellpadding="4" cellspacing="0" class="table table-striped table-hover" width="100%"></table>

 	<table width="100%">
 		<tr>
			<td colspan="13" style="text-align:center">
				<cfform action="?curdoc=hostLeads/host_lead_export" id="exportForm" name="exportForm" onsubmit="return checkSearchFields();">

					<input type="hidden" name="keyword" id="keyword_export" />
					<input type="hidden" name="keyword" id="keyword_export" />
					<input type="hidden" name="regionid" id="regionid_export" />
					<input type="hidden" name="stateID" id="stateID_export" />
					<input type="hidden" name="statusID" id="statusID_export" />
					<input type="hidden" name="sortBy" id="sortBy_export" />
					<input type="hidden" name="sortOrder" id="sortOrder_export" />
					<input type="hidden" name="active_rep" id="active_rep_export" />
					<input type="hidden" name="area_rep" id="area_rep_export" />
					<input type="hidden" name="city" id="city_export" />
					<input type="submit" value=" Export to Excel " class="btn-u btn-u-blue" />

				</cfform>
			</td>
		</tr>
 	</table>

</cfoutput>


