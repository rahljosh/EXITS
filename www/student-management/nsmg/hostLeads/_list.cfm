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
		// Param URL Variables
		param name="FORM.keyword" default="";
		param name="FORM.followUpID" default=0;	
		param name="FORM.regionID" default=0;	
		param name="FORM.stateID" default=0;	
		param name="FORM.statusID" default="";	
		param name="FORM.sortBy" default="dateCreated";		
		param name="FORM.sortOrder" default="DESC";	
		param name="FORM.pageSize" default=30;	
		
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
	var getHostLeadList = function(pageNumber,titleSortBy) { 
		
		// pageNumber could be passed to the function, if not set it to 1
		if ( pageNumber == '' ) {
			var pageNumber = 1;
		}

		// FORM Variables
		var keyword = $("#keyword").val();
		var followUpID = $("#followUpID").val();
		var regionID = $("#regionID").val();
		var stateID = $("#stateID").val();
		var statusID = $("#statusID").val();
		var sortBy = $(".selectSortBy").val();	
		var sortOrder = $(".selectSortOrder").val();		
		var pageSize = $("#pageSize").val();
		
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
		hf.getHostLeadsRemote(pageNumber,keyword,followUpID,regionID,stateID,statusID,sortBy,sortOrder,pageSize);
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
		var tableHeader = '<tr class="defaultTableStyle">';		
        	tableHeader += '<td id="firstName" class="listTitle"><a href="javascript:void(0);" title="Sort By First Name">First Name</a></td>';
        	tableHeader += '<td id="lastName" class="listTitle"><a href="javascript:void(0);" title="Sort By Last Name">Last Name</a></td>';
        	tableHeader += '<td id="city" class="listTitle"><a href="javascript:void(0);" title="Sort By City">City</a></td>';
        	tableHeader += '<td id="state" class="listTitle"><a href="javascript:void(0);" title="Sort By State">State</a></td>';                                                            
            // tableHeader += '<td id="zipCode" class="listTitle"><a href="javascript:void(0);" title="Sort By Zip Code">Zip Code</a></td>';                                                          
            tableHeader += '<td id="phone" class="listTitle"><a href="javascript:void(0);" title="Sort By Phone">Phone</a></td>';                                                           
            tableHeader += '<td id="email" class="listTitle"><a href="javascript:void(0);" title="Sort By Email">Email</a></td>'; 
            tableHeader += '<td id="dateCreated" class="listTitle"><a href="javascript:void(0);" title="Sort By Submitted On">Submitted On</a></td>'; 
			tableHeader += '<td id="dateUpdated" class="listTitle"><a href="javascript:void(0);" title="Sort By Last Updated">Last Updated</a></td>'; 
            tableHeader += '<td id="regionAssigned" class="listTitle"><a href="javascript:void(0);" title="Sort By Region">Region</a></td>';  
            tableHeader += '<td id="areaRepAssigned" class="listTitle"><a href="javascript:void(0);" title="Sort By Area Rep.">Area Rep.</a></td>';  		
            tableHeader += '<td id="statusAssigned" class="listTitle"><a href="javascript:void(0);" title="Sort By Status">Status</a></td>';  			
            tableHeader += '<td class="listTitle" align="center">Actions</td>';                                                          
			tableHeader += '</tr>';
		
		// Clear current result and append Table Header to HTML
		$("#loadHostLeadList").empty().append(tableHeader);
		
		// Add click handlers to handle sorting by. They cause query to be returned in the order selected by the user. Update sortBy value
		$('#firstName').click(function (){getHostLeadList(pageNumber,this.id);});
		$('#lastName').click(function (){getHostLeadList(pageNumber,this.id);});
		$('#city').click(function (){getHostLeadList(pageNumber,this.id);});
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
			var dateUpdated = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('dateUpdated')];
			var regionAssigned = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('REGIONASSIGNED')];
			var areaRepAssigned = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('AREAREPASSIGNED')];
			var statusAssigned = hostLeadData.QUERY.DATA[i][hostLeadData.QUERY.COLUMNS.findIdx('STATUSASSIGNED')];
			
			// Create Table Rows
			var tableBody = "";	
			if (i % 2 == 0) {
				tableBody = '<tr bgcolor="#FFFFE6" id="' + id + '">';
			} else {
				tableBody = '<tr bgcolor="#FFFFFF" id="' + id + '">';
			}
				tableBody += '<td><a href="hostLeads/index.cfm?action=detail&id=' + id + '&key=' + hashID + '" class="jQueryModal">' + firstName + '</a></td>';
				tableBody += '<td><a href="hostLeads/index.cfm?action=detail&id=' + id + '&key=' + hashID + '" class="jQueryModal">' + lastName + '</a></td>';
				tableBody += '<td>' + city + '</a></td>';
				tableBody += '<td>' + state + '</td>';
				// tableBody += '<td>' + zipCode + '</td>';
				tableBody += '<td>' + phone + '</td>';
				tableBody += '<td><a href="mailto:' + email + '">' + email + '</a></td>';
				tableBody += '<td>' + dateCreated + '</td>';
				tableBody += '<td>' + dateLastLoggedIn + '</td>';
				tableBody += '<td>' + regionAssigned + '</td>';
				tableBody += '<td>' + areaRepAssigned + '</td>';
				tableBody += '<td>' + statusAssigned + '</td>';
				<cfif ListFind('1,2', CLIENT.userType)>
					tableBody += '<td align="center"><a href="hostLeads/index.cfm?action=detail&id=' + id + '&key=' + hashID + '" class="jQueryModal">[Details]</a> &nbsp; | &nbsp; <a href="javascript:confirmDeleteHostLead(' + id + ');">[Delete]</a></td>';
				<cfelse>
					tableBody += '<td align="center"><a href="hostLeads/index.cfm?action=detail&id=' + id + '&key=' + hashID + '" class="jQueryModal">[Details]</a></td>';
				</cfif>
			tableBody += '</tr>';
			// Append table rows
			$("#loadHostLeadList").append(tableBody);
		} 

		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"60%", 
			height:"90%", 
			iframe:true,
			overlayClose:false,
			escKey:false,
			onClosed:function(){ getHostLeadList(); }
		});		

	}
	// --- END OF HOST LEADS LIST --- //


	// --- START OF DELETE LEAD --- //
	var confirmDeleteHostLead = function(ID) {
		// Are you sure you would like to check DS-2019 verification for student #" + studentID + " as received?
		var answer = confirm(" Are you sure would you like to delete this host family lead?")
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

	<!--- Table Header --->
    <gui:tableHeader
        imageName="family.gif"
        tableTitle="Host Family Leads"
        tableRightTitle=""
    />

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
    <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%" style="padding:15px;">
        <tr>
            <td class="listTitle">
                <label for="keyword">Keyword</label> <br />
                <input type="text" name="keyword" id="keyword" class="largeField" maxlength="50" />
            </td>  
            <cfif ListFind("1,2,3,4", CLIENT.userType)>
                <td class="listTitle">
                    <label for="followUpID">Follow Up Rep</label> <br />   
                    <select name="followUpID" id="followUpID" class="largeField">
                        <option value="0" <cfif NOT VAL(FORM.followUpID)>selected="selected"</cfif> ></option>
                        <cfloop query="qGetFollowUpUserList">
                            <option value="#qGetFollowUpUserList.userID#" <cfif FORM.followUpID EQ qGetFollowUpUserList.userID>selected="selected"</cfif> >#qGetFollowUpUserList.firstName# #qGetFollowUpUserList.lastName# (###qGetFollowUpUserList.userID#)</option>
                        </cfloop>
                    </select>
                </td> 
            </cfif>         
            <td class="listTitle">
                <label for="regionID">Region</label> <br />   
                <select name="regionID" id="regionID" class="mediumField">
                	<cfif ListFind("1,2,3,4", CLIENT.userType)>
                		<option value="0" <cfif NOT VAL(FORM.regionID)>selected="selected"</cfif> ></option>
                    </cfif>
                    <cfloop query="qGetRegions">
                    	<option value="#qGetRegions.regionID#" <cfif FORM.regionID EQ qGetRegions.regionID>selected="selected"</cfif> >#qGetRegions.regionName#</option>
                    </cfloop>
                </select>
            </td>                
            <td class="listTitle">
                <label for="stateID">State</label> <br />   
                <select name="stateID" id="stateID" class="mediumField">
                	<option value="0" <cfif NOT LEN(FORM.stateID)>selected="selected"</cfif> ></option>
                    <cfloop query="qGetStates">
                    	<option value="#qGetStates.ID#" <cfif FORM.stateID EQ qGetStates.ID>selected="selected"</cfif> >#qGetStates.stateName#</option>
                    </cfloop>
                </select>
            </td>                
            <td class="listTitle">
                <label for="statusID">Status</label> <br />   
                <select name="statusID" id="statusID" class="largeField">
                	<option value="All" <cfif FORM.statusID EQ 'All'>selected="selected"</cfif> >All</option>
                    <option value="" <cfif NOT LEN(FORM.statusID)>selected="selected"</cfif> >Pending Action</option>
                    <cfloop query="qGetStatus">
                    	<option value="#qGetStatus.fieldID#" <cfif FORM.statusID EQ qGetStatus.fieldID>selected="selected"</cfif> >#qGetStatus.name#</option>
                    </cfloop>
                </select>
            </td>   
                    
            <td class="listTitle">
                <label for="pageSize">Records per Page</label> <br />
                <select name="pageSize" id="pageSize" class="smallField">
                	<cfloop from="30" to="150" step="30" index="i">
	                    <option class="#i#" <cfif FORM.pageSize EQ i>selected="selected"</cfif> >#i#</option>
                    </cfloop>
                </select>
            </td>                
            <td><input name="send" type="submit" value="Search" class="submitButton" onClick="getHostLeadList();" /></td>            
        </tr>
        
        <cfif ListFind('1,2,3,4', CLIENT.userType)>
            <tr>
                <td align="center" colspan="12">
                    <a class="jQueryModal" href="hostLeads/index.cfm?action=export">[ Export to Constant Contact ]</a>
                </td>
            </tr>                        
        </cfif>
        
        <!--- Pagination information goes here --->
        <tr id="loadPaginationInfo"></tr>
    </table>

    <!--- Host Leads List --->
    <table id="loadHostLeadList" border="0" cellpadding="4" cellspacing="0" class="section" width="100%"></table>
       
    <!--- Table Footer --->
    <gui:tableFooter />

</cfoutput>


