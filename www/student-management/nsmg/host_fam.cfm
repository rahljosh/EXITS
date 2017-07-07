<!--- ------------------------------------------------------------------------- ----
    
    File:       host_fam.cfm
    Author:     Marcus Melo
    Date:       August 6, 2012
    Desc:       Host Family List / search

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
    
    <!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />   
    
    <!--- Param Variables --->
    <cfparam name="FORM.regionid" default="0">
    <cfparam name="submitted" default="0">
    <cfparam name="keyword" default="">
    <cfparam name="hosting" default="">
    <cfparam name="active" default="">
    <cfparam name="active_rep" default="">
    <cfparam name="available_to_host" default="1">
    <cfparam name="area_rep" default="" />
    <cfparam name="HFstatus" default="" />
    <cfparam name="HFyear" default="" />
    <cfparam name="school_ID" default="" />
    <cfparam name="stateID" default="" />
    <cfparam name="HFcity" default="" />
    <cfparam name="accepts_double" default="" />
    <cfparam name="sortBy" default="lastName">
    <cfparam name="sortOrder" default="ASC">
    <cfparam name="recordsToShow" default="100">
    
    <cfparam name="URL.regionID" default="0">
    <cfif VAL(URL.regionID)>
        <cfset FORM.regionID = URL.regionID>
    </cfif>

    <cfscript>
        // Get User Regions
        qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(
            companyID=CLIENT.companyID,
            userID=CLIENT.userID,
            userType=CLIENT.userType
        );

        qGetStates = APPLICATION.CFC.LOOKUPTABLES.getState();
    
        // Store List of Supervised Users
        vSupervisedUserIDList = '';
        vHostIDList = '';
    </cfscript>

    <cfif APPLICATION.CFC.USER.isOfficeUser()>

        <cfscript>
            qGetAreaRepList = APPLICATION.CFC.USER.getUsers(
                userType = ('5,6,7'),
                isActive = 1,
                companyID = CLIENT.companyID
            );
        </cfscript>

        <cfquery name="qGetHFyear" datasource="#APPLICATION.DSN#">
            SELECT DISTINCT DATE_FORMAT(dateCreated,'%Y') AS dateCreated
            FROM smg_hosts              
            ORDER BY dateCreated ASC
        </cfquery>
    <cfelse>

        <cfscript>
            qGetAreaRepList = APPLICATION.CFC.USER.getUsers(
                userType = ('5,6,7'),
                isActive = 1,
                companyID = CLIENT.companyID,
                regionID = CLIENT.regionID
            );
        </cfscript>

        <cfquery name="qGetHFyear" datasource="#APPLICATION.DSN#">
            SELECT DISTINCT DATE_FORMAT(dateCreated,'%Y') AS dateCreated
            FROM smg_hosts          
            WHERE smg_hosts.regionID = #CLIENT.regionID#    
            ORDER BY dateCreated ASC
        </cfquery>

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

</cfsilent>

<cfhtmlhead text="<title>EXITS - Host Families</title>">


<!--- Ajax Call to the Component --->
<cfajaxproxy cfc="nsmg.extensions.components.host" jsclassname="hostFamily">


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
        getHostList();
    });
    
    // --- START OF HOST LIST --- //

    // Use an asynchronous call to get the student details. The function is called when the user selects a student. 
    var getHostList = function(pageNumber,titleSortBy) { 

        $("#loadingDiv").show();
        $("#loadHostList").hide();
        $("#loadPaginationInfo").hide();
        
        // pageNumber could be passed to the function, if not set it to 1
        if ( pageNumber == '' ) {
            var pageNumber = 1;
        }

        // FORM Variables
        var regionID = $("#regionID").val();
        var keyword = $("#keyword").val();
        var active_rep = $("#active_rep").val();
        var hosting = $("#hosting").val();
        var active = $("#active").val();
        var available_to_host = $("#available_to_host").val();
        var vHostIDList = $("#vHostIDList").val();
        var area_rep = $("#area_rep").val();
        var sortBy = $(".selectSortBy").val();  
        var sortOrder = $(".selectSortOrder").val();        
        var pageSize = $("#pageSize").val();
        var school_id = $("#school_id").val();
        var stateID = $("#stateID").val();
        var HFcity = $("#HFcity").val();
        var accepts_double = $("#accepts_double").val();
        var HFstatus = $("#HFstatus").val();
        var HFyear = $("#HFyear").val();
        
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
        // This time, pass the intRep ID to the getHostList CFC function. 
        hf.getHostsRemote(pageNumber,regionID,keyword,active_rep,hosting,active,available_to_host,area_rep,vHostIDList,HFstatus,HFyear,school_id,stateID,HFcity,accepts_double, sortBy,sortOrder,pageSize);

    } 

    // Callback function to handle the results returned by the getHostList function and populate the table. 
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
                        getHostList(currentPage);//builds table each time a page link is clicked
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
                    $previousLink.prependTo($pager).click(function(event){event.preventDefault();getHostList(prevPageNumber);});
                }
                if ( pageNumber != numberOfPages ) {
                    $nextLink.appendTo($pager).click(function(event){event.preventDefault();getHostList(nextPageNumber);});
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
            tableHeader += '<td id="hostID" class="listTitle"><a href="javascript:void(0);" title="Sort By ID">ID</a></td>';
            tableHeader += '<td id="nexitsID" class="listTitle"><a href="javascript:void(0);" title="Sort By ID">NX ID</a></td>';
            tableHeader += '<td id="lastName" class="listTitle"><a href="javascript:void(0);" title="Sort By Last Name">Last Name</a></td>';
            tableHeader += '<td id="father" class="listTitle"><a href="javascript:void(0);" title="Sort By Father">Father</a></td>';
            tableHeader += '<td id="mother" class="listTitle"><a href="javascript:void(0);" title="Sort By Mother">Mother</a></td>';
            tableHeader += '<td id="phone" class="listTitle"><a href="javascript:void(0);" title="Sort By Phone">Phone</a></td>';   
            tableHeader += '<td id="email" class="listTitle"><a href="javascript:void(0);" title="Sort By Email">Email</a></td>';   
            tableHeader += '<td id="city" class="listTitle"><a href="javascript:void(0);" title="Sort By City">City</a></td>';
            tableHeader += '<td id="state" class="listTitle"><a href="javascript:void(0);" title="Sort By State">State</a></td>';
            tableHeader += '<td id="areaRep" class="listTitle"><a href="javascript:void(0);" title="Sort By Area Rep.">Area Rep.</a></td>'; 
            tableHeader += '<td id="lastHosted" class="listTitle"><a href="javascript:void(0);" title="Sort By Last Hosted">Last Hosted</a></td>';
            tableHeader += '<td id="hostStatus" class="listTitle"><a href="javascript:void(0);" title="Sort By Status">Status</a></td>';
            tableHeader += '<td id="hostStatusUpdated" class="listTitle"><a href="javascript:void(0);" title="Sort By Status">Status Updated</a></td>';
            // tableHeader += '<td id="zipCode" class="listTitle"><a href="javascript:void(0);" title="Sort By Zip Code">Zip Code</a></td>';                                                                                                                 
            tableHeader += '</tr>';
        
        // Clear current result and append Table Header to HTML
        $("#loadingDiv").hide();
        $("#loadHostList").show();
        $("#loadPaginationInfo").show();
        $("#loadHostList").empty().append(tableHeader);
        
        // Add click handlers to handle sorting by. They cause query to be returned in the order selected by the user. Update sortBy value
        $('#hostID').click(function (){getHostList(pageNumber,this.id);});
        $('#nexitsID').click(function (){getHostList(pageNumber,this.id);});
        $('#lastName').click(function (){getHostList(pageNumber,this.id);});
        $('#father').click(function (){getHostList(pageNumber,this.id);});
        $('#mother').click(function (){getHostList(pageNumber,this.id);});
        $('#phone').click(function (){getHostList(pageNumber,this.id);});
        $('#email').click(function (){getHostList(pageNumber,this.id);});
        $('#city').click(function (){getHostList(pageNumber,this.id);});
        $('#state').click(function (){getHostList(pageNumber,this.id);});
        $('#areaRep').click(function (){getHostList(pageNumber,this.id);});
        $('#lastHosted').click(function (){getHostList(pageNumber,this.id);});
        $('#hostStatus').click(function (){getHostList(pageNumber,this.id);});
        $('#hostStatusUpdated').click(function (){getHostList(pageNumber,this.id);});
        
        // No data returned, display message
        if( hostData.QUERY.DATA.length == 0) {          
            $("#loadHostList").append("<tr bgcolor='#FFFFE6'><th colspan='13'>Your search did not return any results.</th></tr>");
        }
        
        // Loop over results and build the grid
        for(i=0; i<hostData.QUERY.DATA.length; i++) { 
            
            var id = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('ID')];      
            var hostID = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('HOSTID')];
            var nexits_id = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('NEXITS_ID')];
            var familylastname = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('FAMILYLASTNAME')];
            var father = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('FATHERFIRSTNAME')];
            var mother = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('MOTHERFIRSTNAME')];
            var city = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('CITY')];
            var state = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('STATE')];
            var isNotQualifiedToHost = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('ISNOTQUALIFIEDTOHOST')];
            var isHosting = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('ISHOSTING')];
            var phone = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('PHONE')];
            var email = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('EMAIL')];
            var call_back = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('CALL_BACK')];
            var area_rep_firstname = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('AREA_REP_FIRSTNAME')];
            var area_rep_lastname = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('AREA_REP_LASTNAME')];
            var programName = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('PROGRAMNAME')];
            var call_back_updated = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('CALL_BACK_UPDATED')];
            var HFstatus = hostData.QUERY.DATA[i][hostData.QUERY.COLUMNS.findIdx('HFSTATUS')];

            if (call_back_updated != '') {
                var call_back_updated_date = new Date(call_back_updated);   
                call_back_updated = (call_back_updated_date.getMonth() + 1) + "/" + call_back_updated_date.getDate() + "/" + call_back_updated_date.getFullYear();
            }
            
            
            // Create Table Rows
            var tableBody = ""; 
            if (i % 2 == 0) {
                tableBody = '<tr bgcolor="#FFFFE6" id="' + hostID + '">';
            } else {
                tableBody = '<tr bgcolor="#FFFFFF" id="' + hostID + '">';
            }
                tableBody += '<td><a href="?curdoc=host_fam_info&hostid=' + hostID + '" target="_blank">' + hostID + '</a></td>';
                tableBody += '<td>' + nexits_id + '</a></td>';
                tableBody += '<td>' + familylastname + '</a></td>';
                tableBody += '<td>' + father + '</a></td>';
                tableBody += '<td>' + mother + '</td>';
                tableBody += '<td>' + phone + '</td>';
                tableBody += '<td>' + email + '</td>';
                tableBody += '<td>' + city + '</td>';
                tableBody += '<td>' + state + '</td>';
                tableBody += '<td>' + area_rep_firstname + ' ' + area_rep_lastname + '</td>';
                tableBody += '<td>' + programName + '</td>';
                tableBody += '<td>' + HFstatus + '</td>';
                tableBody += '<td>' + call_back_updated + '</td>';
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
            onClosed:function(){ getHostList(); }
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
        $("#hosting_export").val($("#hosting").val());
        $("#active_export").val($("#active").val());
        $("#orderby_export").val($("#orderby").val());
        $("#active_rep_export").val($("#active_rep").val());
        $("#area_rep_export").val($("#area_rep").val());
        $("#vHostIDList_export").val($("#vHostIDList").val());
        $("#HFstatus_export").val($("#HFstatus").val());
        $("#HFyear_export").val($("#HFyear").val());
        $("#school_id_export").val($("#school_id").val());
        $("#stateID_export").val($("#stateID").val());
        $("#sortBy_export").val($("#sortBy").val());

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
        imageName="family.gif"
        tableTitle="Host Families"
        tableRightTitle='<a href="index.cfm?curdoc=forms/new_host_fam_form">Add Host Family</a>'
    />

    <!---<cfform action="?curdoc=host_fam" method="post">--->
        <input name="submitted" type="hidden" value="1">
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr>
                <td><input name="send" type="submit" value="Submit" onClick="getHostList();" /></td>
                <cfif APPLICATION.CFC.USER.isOfficeUser()>
                    <td>
                        Region<br />
                        <select name="regionID" id="regionID">
                            <option value="0" <cfif NOT VAL(FORM.regionID)>selected="selected"</cfif>>All</option>
                            <cfloop query="qGetRegionList">
                                <option value="#regionID#" <cfif regionID EQ FORM.regionID>selected="selected"</cfif>>#regionName#</option>
                            </cfloop>
                        </select>
                    </td>
                <cfelse>
                    <input type="hidden" name="regionID" id="regionID" value="#CLIENT.regionID#" />
                </cfif>
                <td>
                    Keyword / ID<br />
                    <input type="text" name="keyword" id="keyword" value="#keyword#" size="10" maxlength="50">         
                </td>
                <cfif APPLICATION.CFC.USER.isOfficeUser()>
                    <!--- Removed per Milo's Request
                    <td>
                        Hosting<br />
                        <select name="hosting">
                            <option value="">All</option>
                            <option value="1" <cfif hosting EQ 1>selected</cfif>>Yes</option>
                            <option value="0" <cfif hosting EQ 0>selected</cfif>>No</option>
                        </select>
                    </td>
                    <td>
                        Active<br />
                        <select name="active">
                            <option value="">All</option>
                            <option value="1" <cfif active EQ 1>selected</cfif>>Yes</option>
                            <option value="0" <cfif active EQ 0>selected</cfif>>No</option>
                        </select>            
                    </td>
                    --->
                </cfif>
                <td>
                    Available<br />
                    <select name="available_to_host" id="available_to_host">
                        <option value="">All</option>
                        <option value="1" <cfif available_to_host EQ 1>selected</cfif>>Yes</option>
                        <option value="0" <cfif available_to_host EQ 0>selected</cfif>>No</option>
                    </select>    
                </td>
                <cfif CLIENT.usertype NEQ 7>
                    <td>
                        With Active Rep<br />
                        <select name="active_rep" id="active_rep">
                            <option value="">All</option>
                            <option value="1" <cfif active_rep EQ 1>selected</cfif>>Yes</option>
                            <option value="0" <cfif active_rep EQ 0>selected</cfif>>No</option>
                        </select>    
                    </td>
                    <td>
                        Area Rep<br />
                        <select name="area_rep" id="area_rep">
                            <option value="">All</option>
                            <cfloop query="qGetAreaRepList">
                                <option value="#qGetAreaRepList.userID#" <cfif area_rep EQ qGetAreaRepList.userID>selected</cfif>>

                                    <cfif LEN(qGetAreaRepList.firstname) + LEN(qGetAreaRepList.lastname) GT 20>
                                        #qGetAreaRepList.firstname# #qGetAreaRepList.lastname#...
                                    <cfelse>
                                        #qGetAreaRepList.firstname# #qGetAreaRepList.lastname# (###qGetAreaRepList.userID#)
                                    </cfif>

                                    
                                </option>
                            </cfloop>
                        </select>
                    </td>
                <cfelse>
                    <input type="hidden" name="area_rep" id="area_rep" value="#CLIENT.userID#" />
                </cfif>

                <td>
                    Double<br />
                    <select name="accepts_double" id="accepts_double">
                        <option value="">All</option>
                        <option value="1">Yes</option>
                        <option value="0">No</option>
                    </select>
                </td>

                <td>
                    City<br />
                    <select name="HFcity" id="HFcity">
                        <option value="" >All</option>
                        <cfloop query="qGetCities">
                            <option value="#qGetCities.city#" <cfif qGetCities.city EQ HFcity>selected</cfif>>
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
                    <select name="HFstatus" id="HFstatus">
                        <option value="">All</option>
                        <option value="Available to Host" <cfif HFstatus EQ "Available to Host">selected</cfif>>Available to Host</option>
                        <option value="Call Back" <cfif HFstatus EQ "Call Back">selected</cfif>>Call Back</option>
                        <option value="Call Back Next SY" <cfif HFstatus EQ "Call Back Next SY">selected</cfif>>Call Back Next SY</option>
                        <option value="Current Season" <cfif HFstatus EQ "Current Season">selected</cfif>>Current Season</option>
                        <option value="Decided Not to Host" <cfif HFstatus EQ "Decided Not to Host">selected</cfif>>Decided Not to Host</option>
                        <option value="Dropped - School Issue" <cfif HFstatus EQ "Dropped - School Issue">selected</cfif>>Dropped - School Issue</option>
                        <option value="Email Back" <cfif HFstatus EQ "Email Back">selected</cfif>>Email Back</option>
                        <option value="Not Qualified to Host" <cfif HFstatus EQ "Not Qualified to Host">selected</cfif>>Not Qualified to Host</option>
                        <option value="With Other Sponsor" <cfif HFstatus EQ "With Other Sponsor">selected</cfif>>With Other Sponsor</option>
                    </select>
                    
                    <input type="hidden" name="sortBy" class="selectSortBy" value="#sortBy#" /> 
                    <input type="hidden" name="sortOrder" class="selectSortOrder" value="#sortOrder#" />     
                </td>
                <td>
                    State<br />
                    <select name="stateID" id="stateID">
                        <option value="">All</option>
                        <cfloop query="qGetStates">
                            <option value="#qGetStates.state#" <cfif stateID EQ qGetStates.state>selected="selected"</cfif> >#qGetStates.state#</option>
                        </cfloop>
                    </select>    
                </td>
                <td>
                    School ID<br />
                    <input type="text" name="school_id" id="school_id" value="#school_id#" size="10" maxlength="10">         
                </td>
                <td>
                    Year Added<br />
                    <select name="HFyear" id="HFyear">
                        <option value="">All</option>
                        <cfloop query="qGetHFyear">
                            <option value="#qGetHFyear.dateCreated#" <cfif HFyear EQ qGetHFyear.dateCreated>selected</cfif>>#qGetHFyear.dateCreated#</option>
                        </cfloop>
                    </select> 
                </td>
                <!---<td>
                    Order By<br />
                    <select name="orderby" id="orderby">
                        <option value="hostid" <cfif orderby EQ 'hostid'>selected</cfif>>ID</option>
                        <option value="familylastname" <cfif orderby EQ 'familylastname'>selected</cfif>>Last Name</option>
                        <option value="fatherfirstname" <cfif orderby EQ 'fatherfirstname'>selected</cfif>>Father</option>
                        <option value="motherfirstname" <cfif orderby EQ 'motherfirstname'>selected</cfif>>Mother</option>
                        <option value="city" <cfif orderby EQ 'city'>selected</cfif>>City</option>
                        <option value="state" <cfif orderby EQ 'state'>selected</cfif>>State</option>
                    </select>            
                </td>--->
                <td>
                    Records Per Page<br />
                    <select name="recordsToShow" id="pageSize">
                        <option <cfif recordsToShow EQ 25>selected</cfif>>25</option>
                        <option <cfif recordsToShow EQ 50>selected</cfif>>50</option>
                        <option <cfif recordsToShow EQ 100>selected</cfif>>100</option>
                        <option <cfif recordsToShow EQ 250>selected</cfif>>250</option>
                        <option <cfif recordsToShow EQ 500>selected</cfif>>500</option>
                    </select>            
                </td>
            </tr>
            
        
    <!---</cfform>--->

</cfoutput>

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
        <table id="loadHostList" border="0" cellpadding="4" cellspacing="0" class="section" width="100%"></table>
    </td>
</tr>

<tr>
    <td colspan="13" style="text-align:center">
        <cfform action="?curdoc=host_fam_export" id="exportForm" name="exportForm" onsubmit="return checkSearchFields();">
            <input type="hidden" name="regionid" id="regionid_export" />
            <input type="hidden" name="keyword" id="keyword_export" />
            <input type="hidden" name="hosting" id="hosting_export" />
            <input type="hidden" name="active" id="active_export" />
            <input type="hidden" name="orderby" id="orderby_export" />
            <input type="hidden" name="active_rep" id="active_rep_export" />
            <input type="hidden" name="available_to_host" id="available_to_host_export" />
            <input type="hidden" name="area_rep" id="area_rep_export" />
            <input type="hidden" name="vHostIDList" id="vHostIDList_export" />
            <input type="hidden" name="HFstatus" id="HFstatus_export" />
            <input type="hidden" name="HFyear" id="HFyear_export" />
            <input type="hidden" name="school_id" id="school_id_export" />
            <input type="hidden" name="HFcity" id="HFcity_export" />
            <input type="hidden" name="accepts_double" id="accepts_double_export" />
            <input type="hidden" name="stateID" id="stateID_export" />
            <input type="hidden" name="sortBy" id="sortBy_export" />

            <input type="submit" value=" Export to Excel " class="buttonBlue smallerButton"  />
        </cfform>
    </td>
</tr>
   
<!--- Table Footer --->
<gui:tableFooter />
