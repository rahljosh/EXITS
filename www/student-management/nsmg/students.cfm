<!--- ------------------------------------------------------------------------- ----
	
	File:		students.cfm
	Author:		Marcus Melo
	Date:		July 29, 2011
	Desc:		Student's list / search

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param Variables --->
    <cfparam name="submitted" default="0">
    <cfparam name="regionID" default="#CLIENT.regionID#">
    <cfparam name="keyword" default="">
    <cfparam name="orderby" default="familyLastName">
    <cfparam name="recordsToShow" default="25">

	<cfif CLIENT.usertype GT 4>
        <!--- Field --->
        <cfparam name="cancelled" default="0">
        <cfparam name="hold_status_id" default="0">
        <cfparam name="active" default="1">    
    <cfelse>
        <!--- Office USERS --->
        <cfparam name="cancelled" default="">
        <cfparam name="hold_status_id" default="">
        <cfparam name="active" default="">
    </cfif>

    <cfparam name="placement_status" default="">
    <cfparam name="priority_student" default="">
    <cfparam name="double_placement" default="">
    
    <!--- advanced search items. --->
    <cfparam name="searchStudentID" default="">
    <cfparam name="adv_search" default="0">
    <cfparam name="familyLastName" default="">
    <cfparam name="firstName" default="">
    <cfparam name="preayp" default="">
    <cfparam name="direct" default="">
    <cfparam name="age" default="">
    <cfparam name="sex" default="">
    <cfparam name="grade" default="">
    <cfparam name="graduate" default="">
    <cfparam name="religionid" default="">
    <cfparam name="interestid" default="">
    <cfparam name="sports" default="">
    <cfparam name="interests_other" default="">
    <cfparam name="countryID" default="">
    <cfparam name="intrep" default="">
    <cfparam name="stateid" default="">
    <cfparam name="state_placed_id" default="">
    <cfparam name="programID" default="[]">
    <cfparam name="privateschool" default="">
    <cfparam name="placementStatus" default="">
    
    <cfscript>
		// Get Private Schools Prices
		qPrivateSchools = APPCFC.SCHOOL.getPrivateSchools();
		
		if ( NOT APPLICATION.CFC.USER.isOfficeUser() ) {
			submitted = 1;
		}
		
		// Set placed = yes if selecting approved/pending status
		if ( ListFindNoCase("Approved,Pending", placementStatus) ) {
			placed = 1;
		}
		
		// Default Value
		vAdvancedSearchLink = '';
		
		// Advanced Search Link
		if ( CLIENT.userType NEQ 27 ) {
			
			vAdvancedSearchLink = '<a href="index.cfm?curdoc=students&adv_search=1">Advanced Search</a>';
			
			if ( VAL(adv_search) ) {
				vAdvancedSearchLink = '<a href="index.cfm?curdoc=students&adv_search=0">Hide Advanced Search</a>';
			}
			
		}

        qCurrentSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason();

        qGetAllSeasons = APPLICATION.CFC.LOOKUPTABLES.getSeason();
    </cfscript>
    
	<!--- GET ALL REGIONS --->
    <cfquery name="qListRegions" datasource="#application.dsn#">
        SELECT 
        	regionID AS ID, 
            regionName
        FROM 
        	smg_regions
        WHERE 
        	company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
            AND subofregion = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            AND active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND regionname <> 'Office'
        ORDER BY 
        	regionName
    </cfquery>
	
    <!--- Advanced Search --->
	<cfif VAL(adv_search)>
    
        <cfquery name="qGetReligionList" datasource="#application.dsn#">
            SELECT 
                *
            FROM 
                smg_religions
            WHERE 
                religionname != ''
                AND isActive = 1
            ORDER BY 
                religionname
        </cfquery>
    
        <cfquery name="qGetInterestList" datasource="#application.dsn#">
            SELECT 
                *
            FROM 
                smg_interests
            ORDER BY 
                interest
        </cfquery>
        
        <cfquery name="qGetCountryList" datasource="#application.dsn#">
            SELECT 
                countryname, 
                countryID
            FROM 
                smg_countrylist
            ORDER BY 
                countryname
        </cfquery>
    
        <cfquery name="qGetIntlRepList" datasource="#application.dsn#">
            SELECT 
            	smg_students.intrep, 
                smg_users.businessname
            FROM 
            	smg_students 
            INNER JOIN 
            	smg_users ON smg_students.intrep = smg_users.userid 
            <cfif CLIENT.companyID NEQ 5>
                AND 
                	smg_students.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
            </cfif>
            GROUP BY 
            	intrep
            ORDER BY 
            	businessname
        </cfquery>

        <cfquery name="qGetStateList" datasource="#application.dsn#">
            SELECT 
            	id, 
                statename,
                state
            FROM 
            	smg_states
            ORDER BY 
            	statename
        </cfquery>
    
        <cfquery name="qGetProgramList" datasource="#application.dsn#">
            SELECT 
                p.programID, 
                p.programname,
                c.companyShort,
                CONCAT(c.companyShort, ' ', p.programname) AS companyProgram
            FROM 
                smg_programs p
            INNER JOIN 
                smg_companies c ON p.companyID = c.companyID
            WHERE 
                p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            <cfif CLIENT.companyID EQ 5>
                AND          
                    c.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
            <cfelseif client.companyID eq 14>
                 AND 
                    p.is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                AND 
                    p.companyID = (<cfqueryparam cfsqltype="cf_sql_integer" value="14" list="yes">)           
            <cfelse>
                AND 
                    p.is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                AND 
                    p.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12,13" list="yes">)
            </cfif>
            ORDER BY 
            	p.startdate DESC, 
                p.programname
        </cfquery>

	</cfif>

</cfsilent>



<!--- Ajax Call to the Component --->
<cfajaxproxy cfc="nsmg.extensions.components.student" jsclassname="studentCFC">
<cfajaxproxy cfc="nsmg.extensions.components.LOOKUPTABLES" jsclassname="LOOKUPCFC">


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
    var stu = new studentCFC();
    var lkcfc = new LOOKUPCFC();

    // Load the list when page is ready
    $(document).ready(function() {
        getStudentList();
        getCountriesList();

        var typingTimer;                //timer identifier
        var doneTypingInterval = 2000;  //time in ms, 5 second for example

        //on keyup, start the countdown
        $('.textSearch').on('keyup', function () {
          clearTimeout(typingTimer);
          typingTimer = setTimeout(getStudentList, doneTypingInterval);
        });

        //on keydown, clear the countdown 
        $('.textSearch').on('keydown', function () {
          clearTimeout(typingTimer);
        });
    });


    
    
    // --- START OF HOST LIST --- //

    var getCountriesList = function() {
        var seasonID        = $("#seasonID").val();

        lkcfc.setCallbackHandler(populateCountryList);
        lkcfc.getCountriesFromSeason(seasonID);
    }
    var populateCountryList = function(hostData) { 

        $("#countryID option").remove();
        $("#countryID").append('<option value="">All</option>');

        for(i=0; i<hostData.QUERY.DATA.length; i++) { 

            var countryID = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('COUNTRYID')];
            var countryName = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('COUNTRYNAME')];

            $("#countryID").append('<option value="' + countryID + '">' + countryName + '</option>');
        }
        
    }

    // Use an asynchronous call to get the student details. The function is called when the user selects a student. 
    var getStudentList = function(pageNumber,titleSortBy) { 

        $("#loadingDiv").show();
        $("#loadHostList").hide();
        $("#loadPaginationInfo").hide();
        
        // pageNumber could be passed to the function, if not set it to 1
        if ( pageNumber == '' ) {
            var pageNumber = 1;
        }

        // FORM Variables
        var regionID        = $("#regionID").val();
        var keyword         = $("#keyword").val();
        var placed          = $("#placed").val();

        var placement_status = $("#placement_status").val();
        var priority_student = $("#priority_student").val();
        var double_placement = $("#double_placement").val();
         
        var hold_status_id  = $("#hold_status_id").val();
        var cancelled       = $("#cancelled").val();
        var active          = $("#active").val();
        var seasonID        = $("#seasonID").val();
        var sortBy          = $(".selectSortBy").val();  
        var sortOrder       = $(".selectSortOrder").val();        
        var pageSize        = $("#pageSize").val();

        var adv_search      = $("#adv_search").val();
        var familyLastName  = $("#familyLastName").val();
        var firstName       = $("#firstName").val();
        var age             = $("#age").val();
        var sex             = $("#sex").val();
        var preayp          = $("#preayp").val();
        var direct          = $("#direct").val();
        var privateschool   = $("#privateschool").val();
        var grade           = $("#grade").val();
        var graduate        = $("#graduate").val();
        var religionid      = $("#religionid").val();
        var interestid      = $("#interestid").val();
        var sports          = $("#sports").val();
        var interests_other = $("#interests_other").val();
        var placementStatus = $("#placementStatus").val();
        var countryID       = $("#countryID").val();
        var intrep          = $("#intrep").val();
        var stateid         = $("#stateid").val();
        var state_placed_id = $("#state_placed_id").val();
        var programID       = $("#programID").val();

        if (programID != null) {
            programID = programID.toString();
        }

        var searchStudentID = $("#searchStudentID").val();
        

        
        if( typeof titleSortBy != 'undefined' ) {
            // SortBy was passed by the sort title function
            
            // Set sortOrder if sorting same column
            if ( sortBy == titleSortBy && sortOrder == 'ASC' ) {
                sortOrder = 'DESC';
            } else { 
                // ASC is the default sort order for the columns
                sortOrder = 'ASC';
            }
            
            // Update FORM values
            $(".selectSortBy").val(titleSortBy);
            $(".selectSortOrder").val(sortOrder);
            sortBy = titleSortBy;
        }

        // Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
        stu.setCallbackHandler(populateList); 
        stu.setErrorHandler(myErrorHandler); 

        // This time, pass the intRep ID to the getStudentList CFC function. 
        stu.getStudentsRemote(pageNumber,regionID,keyword,placed,placement_status,priority_student,double_placement,hold_status_id,cancelled,active,seasonID,sortBy,sortOrder,pageSize,adv_search,familyLastName,firstName,age,sex,preayp,direct,privateschool,grade,graduate,religionid,interestid,sports,interests_other,placementStatus,countryID,intrep,stateid,state_placed_id,programID,searchStudentID);

    } 

    // Callback function to handle the results returned by the getStudentList function and populate the table. 
    var populateList = function(hostData) { 
        
        // Set Pagination Information       
        var numberOfRecordsOnPage = hostData.NUMBEROFRECORDSONPAGE;
        var numberOfPages = hostData.NUMBEROFPAGES;
        var numberOfRecords = hostData.NUMBEROFRECORDS;
        var recordFrom = hostData.RECORDFROM;
        var recordTo = hostData.RECORDTO;
        var pageNumber = hostData.PAGENUMBER;
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
                if( (pageNumber > (page - 10)) && (pageNumber < (page + 10)) )  {
                    //for each page link build a span tag and bind a click handler to each one that will call build table each time it is clicked
                    $('<span class="page-number"></span>').html('<a id="' + page + '" href="javascript:void(0);" title="Go to ' + page + '">' + page + ' </a>').bind('click', {newPage: page}, function(event) {
                        currentPage = event.data['newPage'];
                        getStudentList(currentPage);//builds table each time a page link is clicked
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
                    $previousLink.prependTo($pager).click(function(event){event.preventDefault();getStudentList(prevPageNumber);});
                }
                if ( pageNumber != numberOfPages ) {
                    $nextLink.appendTo($pager).click(function(event){event.preventDefault();getStudentList(nextPageNumber);});
                }
                
                //place paging links before and after table
                $("#topPageNavigation").append($pager);

            }

        } else {
            
            // Clear current
            $("#loadPaginationInfo").empty();
            
        }
        /*** 
            End of building page links
        ***/

        // Create Table Header
        var tableHeader = '<thead><tr>';     
            tableHeader += '<th id="studentID" class="listTitle" style="text-align:left"><a href="javascript:void(0);" title="Sort By ID">ID</a></th>';
            tableHeader += '<th id="lastName" class="listTitle" style="text-align:left"><a href="javascript:void(0);" title="Sort By Last Name">Last Name</a></th>';
            tableHeader += '<th id="firstName" class="listTitle" style="text-align:left"><a href="javascript:void(0);" title="Sort By First Name">First Name</a></th>';
            tableHeader += '<th id="sex" class="listTitle" style="text-align:left"><a href="javascript:void(0);" title="Sort By Sex">Sex</a></th>';   
            tableHeader += '<th id="country" class="listTitle" style="text-align:left"><a href="javascript:void(0);" title="Sort By Country">Country</a></th>';   
            tableHeader += '<th id="requests" class="listTitle" style="text-align:left"><a href="javascript:void(0);" title="Sort By Requests">Requests</a></th>';
            tableHeader += '<th id="stu_status" class="listTitle" style="text-align:left"><a href="javascript:void(0);" title="Sort By Status">Status</a></th>';
            tableHeader += '<th id="hold_create_date" class="listTitle" style="text-align:left"><a href="javascript:void(0);" title="Sort By Hold Date">Hold Date</a></th>'; 
            tableHeader += '<th id="region" class="listTitle" style="text-align:left"><a href="javascript:void(0);" title="Sort By Region">Region</a></th>';
            tableHeader += '<th id="program" class="listTitle" style="text-align:left"><a href="javascript:void(0);" title="Sort By Program">Program</a></th>';
            tableHeader += '</tr></thead>';
        
        // Clear current result and append Table Header to HTML
        $("#loadingDiv").hide();
        $("#loadHostList").show();
        $("#loadPaginationInfo").show();
        $("#loadHostList").empty().append(tableHeader);
        
        // Add click handlers to handle sorting by. They cause query to be returned in the order selected by the user. Update sortBy value
        $('#studentID').click(function (){getStudentList(pageNumber,this.id);});
        $('#lastName').click(function (){getStudentList(pageNumber,this.id);});
        $('#firstName').click(function (){getStudentList(pageNumber,this.id);});
        $('#sex').click(function (){getStudentList(pageNumber,this.id);});
        $('#country').click(function (){getStudentList(pageNumber,this.id);});
        $('#requests').click(function (){getStudentList(pageNumber,this.id);});
        $('#stu_status').click(function (){getStudentList(pageNumber,this.id);});
        $('#hold_create_date').click(function (){getStudentList(pageNumber,this.id);});
        $('#region').click(function (){getStudentList(pageNumber,this.id);});
        $('#program').click(function (){getStudentList(pageNumber,this.id);});
        $('#hostName').click(function (){getStudentList(pageNumber,this.id);});
        
        // No data returned, display message
        if( hostData.QUERY.DATA.length == 0) {          
            $("#loadHostList").append("<tr bgcolor='#FFFFE6'><th colspan='13'>Your search did not return any results.</th></tr>");
        }
        
        // Loop over results and build the grid
        for(i=0; i<hostData.QUERY.DATA.length; i++) { 
            
            var studentID = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('STUDENTID')];
            var familylastname = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('FAMILYLASTNAME')];
            var firstname = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('FIRSTNAME')];
            var sex = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('SEX')];
            var country = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('COUNTRYNAME')];
            var requests = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('REQUESTS')];
            var stu_status = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('STU_STATUS')];
            var hold_status_date = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('HOLD_CREATE_DATE')];
            var regionname = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('REGIONNAME')];
            var programname = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('PROGRAMNAME')];
            var state1name = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('STATE1NAME')];
            var state2name = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('STATE2NAME')];
            var state3name = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('STATE3NAME')];
            var add_program = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('ADD_PROGRAM')];
            var app_region_guarantee = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('APP_REGION_GUARANTEE')]; 

            var ayporientation = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('AYPORIENTATION')]; 
            var aypenglish = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('AYPENGLISH')]; 

            var state_guarantee = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('STATE_GUARANTEE')];  
            var r_guarantee = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('R_GUARANTEE')];  

            var dateassigned = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('DATEASSIGNED')];
            var hostID = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('HOSTID')];

            var bgcolor = '';
            if (dateassigned != '') {

                var da1 = new Date();
                var da2 = new Date(dateassigned);
                var da3 = new Date()

                da3.setFullYear(<cfoutput>#DateFormat(CLIENT.lastlogin, 'YYYY')#</cfoutput>, <cfoutput>#DateFormat(DateAdd('m', -1, CLIENT.lastlogin), 'MM')#</cfoutput>, <cfoutput>#DateFormat(CLIENT.lastlogin, 'DD')#</cfoutput>);

                var da25 = new Date();
                var da34 = new Date();
                var da35 = new Date();
                var da49 = new Date();
                var da50 = new Date();
                da25.setDate(da1.getDate() - 25);
                da34.setDate(da1.getDate() - 34);
                da35.setDate(da1.getDate() - 35);
                da49.setDate(da1.getDate() - 49);
                da50.setDate(da1.getDate() - 50);

                /*console.log(studentID);
                console.log(da2);
                console.log(da3);
                console.log(da25);
                console.log(da34);
                console.log(da35);
                console.log(da49);
                console.log(da50);
                console.log('-----');*/

                if (da2.getTime() > da3.getTime()) {
                    bgcolor = "#eef5e1";
                } else if ((da2.getTime() < da25.getTime()) && (da2.getTime() > da34.getTime()) && (hostID == 0)) {
                    bgcolor = "#d7ebff";
                } else if ((da2.getTime() < da25.getTime()) && (da2.getTime() > da49.getTime()) && (hostID == 0)) {
                    bgcolor = "#ffffb9";
                } else if ((da2.getTime() < da50.getTime()) && (hostID == 0)) {
                    bgcolor = "#f9d9d9";
                }
            }          
            
            // Create Table Rows
            var tableBody = ""; 
                tableBody = '<tr style="background-color: ' + bgcolor + '">';
                tableBody += '<td><a href="?curdoc=student_info&studentID=' + studentID + '">' + studentID + '</a></td>';
                tableBody += '<td style="text-transform:capitalize">' + familylastname + '</td>';
                tableBody += '<td style="text-transform:capitalize">' + firstname + '</td>';
                tableBody += '<td style="text-transform:capitalize">' + sex + '</td>';
                tableBody += '<td style="text-transform:capitalize">' + country + '</td>';
                
                tableBody += '<td>';

                    var hasState = 0;
                    if (state1name != '') {   
                        tableBody += '<strong>State:</strong> ' + state1name;
                        hasState = 1;
                    }
                    if (state2name != '') {   
                        tableBody += ', ' + state2name;
                        hasState = 1;
                    }
                    if (state3name != '') {   
                        tableBody += ', ' + state3name;
                        hasState = 1;
                    }

                    var hasRegion = 0;
                    if (app_region_guarantee == 6) {
                        if (hasState == 1) { tableBody += '; '; }
                        tableBody += '<strong>Region:</strong> West Region';
                        hasRegion = 1;
                    }
                    if (app_region_guarantee == 7) {
                        if (hasState == 1) { tableBody += '; '; }
                        tableBody += '<strong>Region:</strong> Central Region ';
                        hasRegion = 1;
                    }
                    if (app_region_guarantee == 8) {
                        if (hasState == 1) { tableBody += '; '; }
                        tableBody += '<strong>Region:</strong> South Region ';
                        hasRegion = 1;
                    }
                    if (app_region_guarantee == 9) {
                        if (hasState == 1) { tableBody += '; '; }
                        tableBody += '<strong>Region:</strong> East Region';
                        hasRegion = 1;
                    }

                    if ((add_program != '') && (add_program != 'None')) {
                        if ((hasState == 1) || (hasRegion == 1)) {
                            tableBody += '; ';
                        }  

                        if (add_program == 'New York Orientation') {
                            tableBody += '<strong>NY Orientation</strong>';
                        } else if (add_program == 'Pre-AYP English') {
                            tableBody += '<strong>Pre-AYP</strong>';
                        } else {
                            tableBody += ' ' + add_program;
                        }
                    }

                    
                tableBody += '</td>';

                styleColor = '';

                if (hold_status_date != '') {
                    var d1 = new Date();
                    var d2 = new Date(hold_status_date);
                    d1.setDate(d1.getDate() - 3);

                    if ((d2.getTime() <= d1.getTime()) && (stu_status === 'Showing')) {
                        styleColor = 'style="color:#CC0000"';
                    } 
                } 

                tableBody += '<td ' + styleColor + '>';
                tableBody += stu_status + '</td>';
                if ((stu_status != 'Showing') && (stu_status != 'Committed')) {
                    tableBody += '<td></td>';
                } else {
                    tableBody += '<td ' + styleColor + '>';
                    tableBody += hold_status_date + '</td>';
                }
                
                tableBody += '<td>' + regionname;
                if (state_guarantee != '') {
                    tableBody += ' <span style="color:#CC0000; font-weight:bold">*' + state_guarantee +'</span>';
                }
                if (r_guarantee != '') {
                    tableBody += ' <span style="color:#CC0000; font-weight:bold">*' + r_guarantee +'</span>';
                }
                tableBody += '</td>';


                tableBody += '<td>' + programname;
                if (aypenglish != '') {
                    tableBody += ' <span style="color:#CC0000; font-weight:bold">* Pre-Ayp English</span>';
                } 
                if (ayporientation != '') {
                    tableBody += ' <span style="color:#CC0000; font-weight:bold">* NY Orient.</span>';
                } 
                tableBody += '</td>';


                tableBody += '</tr>';
            // Append table rows
            $("#loadHostList").append(tableBody);
        } 
        
        // JQuery Modal
        $(".jQueryModal").colorbox( {
            width:"60%", 
            height:"90%", 
            iframe:true,
            overlayClose:false,
            escKey:false,
            onClosed:function(){ getStudentList(); }
        });     

    }
    // --- END OF HOST LIST --- //


    // Error handler for the asynchronous functions. 
    var myErrorHandler = function(statusCode, statusMsg) { 
        alert('Status: ' + statusCode + ', ' + statusMsg); 
    } 

    function checkSearchFields() {
        $("#regionid_export").val($("#regionID").val());
        $("#keyword_export").val($("#keyword").val());

        $("#placed_export").val($("#placed").val());
        $("#placement_status_export").val($("#placement_status").val());
        $("#priority_student_export").val($("#priority_student").val());
        $("#double_placement_export").val($("#double_placement").val());
        $("#hold_status_id_export").val($("#hold_status_id").val());
        $("#cancelled_export").val($("#cancelled").val());
        $("#active_export").val($("#active").val());
        $("#seasonID_export").val($("#seasonID").val());
        $("#sortBy_export").val($("#sortBy").val());
        $("#sortOrder_export").val($("#sortOrder").val());
        $("#pageSize_export").val('10000');
        $("#adv_search_export").val($("#adv_search").val());
        $("#familyLastName_export").val($("#familyLastName").val());
        $("#firstName_export").val($("#firstName").val());
        $("#age_export").val($("#age").val());
        $("#sex_export").val($("#sex").val());
        $("#preayp_export").val($("#preayp").val());
        $("#direct_export").val($("#direct").val());
        $("#privateschool_export").val($("#privateschool").val());
        $("#grade_export").val($("#grade").val());
        $("#graduate_export").val($("#graduate").val());
        $("#religionid_export").val($("#religionid").val());
        $("#interestid_export").val($("#interestid").val());
        $("#sports_export").val($("#sports").val());
        $("#interests_other_export").val($("#interests_other").val());
        $("#placementStatus_export").val($("#placementStatus").val());
        $("#countryID_export").val($("#countryID").val());
        $("#intrep_export").val($("#intrep").val());
        $("#stateid_export").val($("#stateid").val());
        $("#state_placed_id_export").val($("#state_placed_id").val());
        $("#programID_export").val($("#programID").val());
        $("#searchStudentID_export").val($("#searchStudentID").val());

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

	<!--- Table Header --->
    <gui:tableHeader
        imageName="students.gif"
        tableTitle="Students"
        tableRightTitle="#vAdvancedSearchLink#"
    />

    <!---<cfform action="" method="post" onsubmit="return getStudentList;">
        <input type="hidden" name="submitted" value="1">
        --->
        <input type="hidden" name="adv_search" id="adv_search" value="#adv_search#">
    	
        <!--- Guest User Account | Student ID Option Only --->
        <cfif CLIENT.userType EQ 27>
        
            <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
                <tr>
                    <td>
                    
                        <table border="0" cellpadding="4" cellspacing="0" width="100%">
                            <tr>
                                <td>
                                    Student ID <br />
                                    <input type="text" name="searchStudentID" id="searchStudentID" size="10" maxlength="50">   
                                    <input name="send" type="submit" value="Submit"  onClick="getStudentList();" /> 
                                </td>
                            </tr>
                        </table>
            
                    </td>
                </tr>
            </table>
		
        <!--- All Other Users --->
        <cfelse>
        
            <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
                <tr>
                    <td>
                    
                        <table border="0" cellpadding="4" cellspacing="0" width="100%">
                            <tr>
                                <!---<td>
                                    <input name="send" type="submit" value="Submit" onClick="getStudentList();" /> 
                                </td>--->
                                <cfif listFind("1,2,3,4", CLIENT.userType)>
                                    <td>
                                        Region<br />
                                        <cfif listFind("1,2,3,4", CLIENT.userType)>
                                            <select name="regionID" id="regionID" display="regionName" onChange="getStudentList();">
                                                <option value="">All</option>
                                                <cfloop query="qListRegions">
                                                    <option value="#qListRegions.ID#" <Cfif qListRegions.ID EQ regionID>selected="selected"</Cfif>>#qListRegions.regionname#</option>
                                                </cfloop>
                                            </select>
                                        <cfelse>
                                            <select name="regionID" id="regionID" display="regionName" onChange="getStudentList();">
                                                <option value="" selected="selected">All</option>
                                                <cfloop query="qListRegions">
                                                    <option value="#qListRegions.ID#" <Cfif qListRegions.ID EQ regionID>selected="selected"</Cfif>>#qListRegions.regionname#</option>
                                                </cfloop>
                                            </select>
                                        </cfif>
                                    </td>
                                <cfelse>
                                    <input type="hidden" name="regionID" id="regionID" value="#CLIENT.regionID#" />
                                </cfif>
                                <td>
                                    Keyword / ID<br />
                                    <input type="text" name="keyword" id="keyword" value="#keyword#" size="10" maxlength="50" class="textSearch">         
                                </td>
                                <cfif CLIENT.usertype NEQ 9>
                                    <td>
                                        Placed<br />
                                        <select name="placed" id="placed" onChange="getStudentList();">
                                            <cfif listFind("1,2,3,4", CLIENT.userType)>
                                                <option value="">All</option>
                                            </cfif>
                                            <option value="1" >Yes</option>
                                            <option value="0" selected>No</option>
                                        </select>            
                                    </td>
                                    <td>
                                        Status<br />
                                        <select name="placement_status" id="placement_status" onChange="getStudentList();">
                                            <option value="">All</option>
                                            <option value="Cancelled" >Cancelled</option>
                                            <option value="Showing" >Showing</option>
                                            <option value="Committed" >Committed</option>
                                            <option value="Pending" >Pending</option>
                                            <option value="Placed" >Placed</option>
                                        </select>            
                                    </td>
                                    <td>
                                        Priority Student<br />
                                        <select name="priority_student" id="priority_student" onChange="getStudentList();">
                                            <option value="">All</option>
                                            <option value="1" >Yes</option>
                                            <option value="0" >No</option>
                                        </select>            
                                    </td>
                                </cfif>
                                <cfif listFind("1,2,3,4", CLIENT.userType)>
                                    <td>
                                        Hold<br />
                                        <select name="hold_status_id" id="hold_status_id" onChange="getStudentList();">
                                            <option value="">All</option>
                                            <option value="1" <cfif hold_status_id EQ 1>selected</cfif>>Yes</option>
                                            <option value="0" <cfif hold_status_id EQ 0>selected</cfif>>No</option>
                                        </select>
                                        
                                    </td>
                                    <!---<td>
                                        Cancelled<br />
                                        <select name="cancelled" id="cancelled">
                                            <option value="">All</option>
                                            <option value="1" <cfif cancelled EQ 1>selected</cfif>>Yes</option>
                                            <option value="0" <cfif cancelled EQ 0>selected</cfif>>No</option>
                                        </select>
                                        
                                    </td>
                                    <td>
                                        Active<br />
                                        <select name="active" id="active">
                                            <option value="">All</option>
                                            <option value="1" <cfif active EQ 1>selected</cfif>>Yes</option>
                                            <option value="0" <cfif active EQ 0>selected</cfif>>No</option>
                                        </select>            
                                    </td>--->
                                    <td>
                                        Season<br />
                                        <select name="seasonID" id="seasonID" onChange="getStudentList();getCountriesList();">
                                            <option value="">All</option>
                                            <cfloop query="qGetAllSeasons" >
                                                <option value="#qGetAllSeasons.seasonID#" <cfif qCurrentSeason.seasonID EQ qGetAllSeasons.seasonID>selected</cfif>>#qGetAllSeasons.season#</option>
                                            </cfloop>
                                        </select>            
                                    </td>
                                </cfif>
                                <!---<td>
                                    Order By<br />
                                    <select name="orderby" id="orderBy">
                                        <option value="studentID" <cfif orderby EQ 'studentID'>selected</cfif>>ID</option>
                                        <option value="familyLastName" <cfif orderby EQ 'familyLastName'>selected</cfif>>Last Name</option>
                                        <option value="firstName" <cfif orderby EQ 'firstName'>selected</cfif>>First Name</option>
                                        <option value="sex" <cfif orderby EQ 'sex'>selected</cfif>>Sex</option>
                                        <option value="country" <cfif orderby EQ 'country'>selected</cfif>>Country</option>
                                        <option value="regionName" <cfif orderby EQ 'regionName'>selected</cfif>>Region</option>
                                        <option value="programID" <cfif orderby EQ 'programID'>selected</cfif>>Program</option>
                                        <option value="hostID" <cfif orderby EQ 'hostID'>selected</cfif>>Family</option>
                                        <cfif CLIENT.companyID EQ 5>
                                            <option value="companyShort" <cfif orderby EQ 'companyShort'>selected</cfif>>Company</option>
                                        </cfif>
                                    </select>            
                                </td>--->
                                <td>
                                    Records Per Page<br />
                                    <select name="recordsToShow" id="pageSize" onChange="getStudentList();">
                                        <option <cfif recordsToShow EQ 25>selected</cfif>>25</option>
                                        <option <cfif recordsToShow EQ 50>selected</cfif>>50</option>
                                        <option <cfif recordsToShow EQ 100>selected</cfif>>100</option>
                                        <option <cfif recordsToShow EQ 250>selected</cfif>>250</option>
                                        <option <cfif recordsToShow EQ 500>selected</cfif>>500</option>
                                    </select>  

                                    <input type="hidden" name="sortBy" class="selectSortBy" /> 
                                    <input type="hidden" name="sortOrder" class="selectSortOrder" />             
                                </td>
                            </tr>
                        </table>
            
                        <!--- advanced search. --->
                        <cfif VAL(adv_search)>
                        
                            <hr align="center" noshade="noshade" size="1" width="95%" />
                            
                            <table border="0" cellpadding="4" cellspacing="0" width="100%">
                                <tr>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>
                                        Last Name<br />
                                        <input type="text" name="familyLastName" id="familyLastName" class="textSearch" size="10" maxlength="50">
                                    </td>
                                    <td>
                                        First Name<br />
                                        <input type="text" name="firstName" id="firstName" class="textSearch" size="10" maxlength="50" ">
                                    </td>
                                     <td>
                                        Age<br />
                                        <select name="age" id="age" onChange="getStudentList();">
                                            <option value="">All</option>
                                            <option <cfif age EQ 14>selected</cfif>>14</option>
                                            <option <cfif age EQ 15>selected</cfif>>15</option>
                                            <option <cfif age EQ 16>selected</cfif>>16</option>
                                            <option <cfif age EQ 17>selected</cfif>>17</option>
                                            <option <cfif age EQ 18>selected</cfif>>18</option>
                                        </select>
                                    </td>
                                    <Td>
                                        Sex<br />
                                        <select name="sex" id="sex" onChange="getStudentList();">
                                            <option value="">All</option>
                                            <option <cfif sex EQ 'Male'>selected</cfif>>Male</option>
                                            <option <cfif sex EQ 'Female'>selected</cfif>>Female</option>
                                        </select>
                                     </Td>
                                    <td>
                                        Pre-AYP<br />
                                        <select name="preayp" id="preayp" onChange="getStudentList();">
                                            <option value="">All</option>
                                            <option value="english" <cfif preayp EQ 'english'>selected</cfif>>English Camp</option>
                                            <option value="orient" <cfif preayp EQ 'orient'>selected</cfif>>Orientation Camp</option>
                                        </select>
                                    </td>
                                    <td>
                                        Direct Placement<br />
                                        <select name="direct" id="direct" onChange="getStudentList();">
                                            <option value="">All</option>
                                            <option value="1" <cfif direct EQ 1>selected</cfif>>Yes</option>
                                            <option value="0" <cfif direct EQ 0>selected</cfif>>No</option>
                                        </select>            
                                    </td>
                                    <td>
                                        Private School Tuition<br />
                                        <select name="privateschool" id="privateschool" onChange="getStudentList();">
                                            <option value="" <cfif NOT LEN(privateschool)>selected</cfif>>n/a</option>
                                            <option value="0" <cfif privateschool EQ 0>selected</cfif>>All Tuitions</option>
                                            <cfloop query="qPrivateSchools">
                                                <option value="#privateschoolid#" <cfif privateschool eq privateschoolid>selected</cfif>>#privateschoolprice#</option>
                                            </cfloop>
                                        </select>  
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>
                                        Last Grade Completed<br />
                                        <select name="grade" id="grade" onChange="getStudentList();">
                                            <option value="">All</option>
                                            <option <cfif grade EQ 7>selected</cfif>>7</option>
                                            <option <cfif grade EQ 8>selected</cfif>>8</option>
                                            <option <cfif grade EQ 9>selected</cfif>>9</option>
                                            <option <cfif grade EQ 10>selected</cfif>>10</option>
                                            <option <cfif grade EQ 11>selected</cfif>>11</option>
                                            <option <cfif grade EQ 12>selected</cfif>>12</option>
                                        </select>
                                    </td>
                                    <td>
                                        Graduated in Home Country<br />
                                        <select name="graduate" id="graduate" onChange="getStudentList();">
                                            <option value="">All</option>
                                            <option value="1" <cfif graduate EQ 1>selected</cfif>>Yes</option>
                                        </select>
                                    </td>
                                    <td>
                                        Religion<br />
                                        <select name="religionid" id="religionid"  onChange="getStudentList();">
                                            <option value="">All</option>

                                            <cfloop query="qGetReligionList">
                                                <option value="#religionid#" >#religionname#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                    <td>
                                        Interests<br />
                                        <select name="interestid" id="interestid" onChange="getStudentList();">
                                            <option value="">All</option>

                                            <cfloop query="qGetInterestList">
                                                <option value="#interestid#" >#interest#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                    <td>
                                        Play in Competitive Sports<br />
                                        <select name="sports" id="sports" onChange="getStudentList();">
                                            <option value="">All</option>
                                            <option <cfif sports EQ 'Yes'>selected</cfif>>Yes</option>
                                            <option <cfif sports EQ 'No'>selected</cfif>>No</option>
                                        </select>
                                    </td>
                                    <td>
                                        Text in the Narrative<br />
                                        <input type="text" name="interests_other" class="textSearch" id="interests_other" size="10" maxlength="50">
                                    </td>
                                    <td>
                                        Country of Origin<br />
                                        <select name="countryID" id="countryID" onChange="getStudentList();">
                                            <option value="">All</option>

                                            <cfloop query="qGetCountryList">
                                                <option value="#countryID#" >#countryname#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                    <!---
                                    <td>
                                        Double Placement<br />
                                        <select name="double_placement" id="double_placement" onChange="getStudentList();">
                                            <option value="">All</option>
                                            <option value="1">Yes</option>
                                            <option value="0">No</option>
                                        </select>
                                    </td>
                                    --->
                                </tr>
                                <tr>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    
                                    <td colspan="2">
                                        International Rep.<br />
                                        <select name="intrep" id="intrep" onChange="getStudentList();">
                                            <option value="">All</option>

                                            <cfloop query="qGetIntlRepList">
                                                <option value="#intrep#" >#businessname#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                    <td>
                                        State Preference<br />
                                        <select name="stateid" id="stateid" onChange="getStudentList();">
                                            <option value="">All</option>

                                            <cfloop query="qGetStateList">
                                                <option value="#id#" >#statename#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                    <td>
                                        State Placed<br />
                                        <select name="state_placed_id" id="state_placed_id" onChange="getStudentList();">
                                            <option value="">All</option>

                                            <cfloop query="qGetStateList">
                                                <option value="#state#" >#statename#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                    <td colspan="2">
                                        Program<br />
                                        <cfif CLIENT.companyID EQ 5>
                                            <select name="programID" id="programID" multiple="yes" size="5" onChange="getStudentList();">
                                                <option value="">All</option>

                                                <cfloop query="qGetProgramList">
                                                    <option value="#programID#" >#companyProgram#</option>
                                                </cfloop>
                                            </select>
                                        <cfelse>
                                            <select name="programID" id="programID" multiple="yes" size="5" onChange="getStudentList();">
                                                <option value="">All</option>

                                                <cfloop query="qGetProgramList">
                                                    <option value="#programID#" >#programname#</option>
                                                </cfloop>
                                            </select>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfif>
            
                    </td>
                </tr>
            </table>

		</cfif>
    
    <!---</cfform>--->

</cfoutput>



<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <!--- Pagination information goes here --->
    <tr id="loadPaginationInfo"></tr>

    <tr>
        <td colspan="13">
            <div id="loadingDiv" style="display: none; width: 100%; text-align: center">
                <img src="/nsmg/pics/loading.gif" />
            </div>
        </td>
    </tr>

    <tr>
        <td colspan="13">
            <!--- Host List --->
            <table id="loadHostList" border="0" cellpadding="4" cellspacing="0" class="table table-striped table-hover" width="100%"></table>
        </td>
    </tr>

    <tr>
        <td colspan="13" style="text-align:center">
            <cfform action="?curdoc=students_export" id="exportForm" name="exportForm" onsubmit="return checkSearchFields();">
                <input type="hidden" name="regionid" id="regionid_export" />
                <input type="hidden" name="keyword" id="keyword_export" />
                <input type="hidden" name="placed" id="placed_export" />
                <input type="hidden" name="placement_status" id="placement_status_export" />
                <input type="hidden" name="priority_student" id="priority_student_export" />
                <input type="hidden" name="double_placement" id="double_placement_export" />
                <input type="hidden" name="hold_status_id" id="hold_status_id_export" />
                <input type="hidden" name="cancelled" id="cancelled_export" />
                <input type="hidden" name="active" id="active_export" />
                <input type="hidden" name="seasonID" id="seasonID_export" />
                <input type="hidden" name="sortBy" id="sortBy_export" />
                <input type="hidden" name="sortOrder" id="sortOrder_export" />
                <input type="hidden" name="pageSize" id="pageSize_export" />
                <input type="hidden" name="adv_search" id="adv_search_export" />
                <input type="hidden" name="familyLastName" id="familyLastName_export" />
                <input type="hidden" name="firstName" id="firstName_export" />
                <input type="hidden" name="age" id="age_export" />
                <input type="hidden" name="sex" id="sex_export" />
                <input type="hidden" name="preayp" id="preayp_export" />
                <input type="hidden" name="direct" id="direct_export" />
                <input type="hidden" name="privateschool" id="privateschool_export" />
                <input type="hidden" name="grade" id="grade_export" />
                <input type="hidden" name="graduate" id="graduate_export" />
                <input type="hidden" name="religionid" id="religionid_export" />
                <input type="hidden" name="interestid" id="interestid_export" />
                <input type="hidden" name="sports" id="sports_export" />
                <input type="hidden" name="interests_other" id="interests_other_export" />
                <input type="hidden" name="placementStatus" id="placementStatus_export" />
                <input type="hidden" name="countryID" id="countryID_export" />
                <input type="hidden" name="intrep" id="intrep_export" />
                <input type="hidden" name="stateid" id="stateid_export" />
                <input type="hidden" name="state_placed_id" id="state_placed_id_export" />
                <input type="hidden" name="programID" id="programID_export" />
                <input type="hidden" name="searchStudentID" id="searchStudentID_export" />

                <input type="submit" value=" Export to Excel " class="buttonBlue smallerButton"  />
            </cfform>
        </td>
    </tr>
</table>

<table width="100%" bgcolor="#ffffe6" class="section">
    <tbody><tr>
        <td style="padding:10px">
            <table>
              <tbody><tr>
                <td bgcolor="eef5e1" width="15">&nbsp;</td>
                <td>&nbsp;Added since your last vist.</td>
              </tr>
            </tbody></table>
        </td>
        <td style="padding:10px">
            <table>
              <tbody><tr>
                <td bgcolor="d7ebff" width="15">&nbsp;</td>
                <td>&nbsp;Unplaced for 25-34 days.</td>
              </tr>
            </tbody></table>
        </td>
        <td style="padding:10px">
            <table>
              <tbody><tr>
                <td bgcolor="FFFF9D" width="15">&nbsp;</td>
                <td>&nbsp;Unplaced for 35-49 days.</td>
              </tr>
            </tbody></table>
        </td>
        <td style="padding:10px">
            <table>
              <tbody><tr>
                <td bgcolor="f9d9d9" width="15">&nbsp;</td>
                <td>&nbsp;Unplaced more than 50 days.</td>
              </tr>
            </tbody></table>
        </td>
        <td>
            <font color="CC0000"> * Regional / State Preference.</font>
        </td>
    </tr>
</tbody></table>

   
<cfinclude template="table_footer.cfm">