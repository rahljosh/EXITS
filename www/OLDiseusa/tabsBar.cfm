<cfoutput>

<cfif CGI.SCRIPT_NAME EQ "/index.cfm">
	
	<!--- Include These for Index.cfm only --->
    <div class="tabsBar">
        <span onmouseover="HideDIV('initDiv');HideDIV('webstore');HideDIV('studentTrips');HideDIV('travelAbroad');HideDIV('hostFam');HideDIV('blog');DisplayDIV('meetStudents')"  style="cursor:pointer;">
            <a href="#APPLICATION.siteURL#meet-our-students.cfm" class="tabs1"></a>
        </span>
        
        <span onmouseover="HideDIV('initDiv');HideDIV('webstore');HideDIV('studentTrips');HideDIV('travelAbroad');HideDIV('meetStudents');HideDIV('blog');DisplayDIV('hostFam')"  style="cursor:pointer;">
            <a href="#APPLICATION.siteURL#become-a-host-family.cfm" class="tabs2"></a>
        </span>
        
        <span onmouseover="HideDIV('initDiv');HideDIV('webstore');HideDIV('studentTrips');HideDIV('hostFam');HideDIV('meetStudents');HideDIV('blog');DisplayDIV('travelAbroad')"  style="cursor:pointer;">
            <a href="mailto:john@iseusa.com" class="tabs3" target="_blank"></a>
        </span>
        
        <span onmouseover="HideDIV('initDiv');HideDIV('webstore');HideDIV('travelAbroad');HideDIV('hostFam');HideDIV('meetStudents');HideDIV('blog');DisplayDIV('studentTrips')"   style="cursor:pointer;">
            <a href="#APPLICATION.siteURL#trips/exchange-student-trips.cfm" class="tabs4" target="_blank"></a>
        </span>
        
        <span onmouseover="HideDIV('initDiv');HideDIV('studentTrips');HideDIV('travelAbroad');HideDIV('hostFam');HideDIV('meetStudents');HideDIV('blog');DisplayDIV('webstore')"   style="cursor:pointer;">
            <a href="#APPLICATION.siteURL#webstore.cfm" class="tabs5"></a>
        </span>
        
        <span onmouseover="HideDIV('initDiv');HideDIV('webstore');HideDIV('studentTrips');HideDIV('travelAbroad');HideDIV('hostFam');HideDIV('meetStudents');HideDIV('blog');DisplayDIV('blog')"   style="cursor:pointer;">
            <a href="http://blog.iseusa.com/" class="tabs6" target="_blank"></a>
        </span>
    </div><!-- end tabsBar -->
    
<cfelse>

	<!--- All other pages --->
    <div class="tabsBar">
        <a href="#APPLICATION.siteURL#meet-our-students.cfm" class="tabs1"></a>
        <Cfif cgi.SCRIPT_NAME is '/become-a-host-family.cfm'>
            <a href="#APPLICATION.siteURL#become-a-host-family.cfm" class="tabs2selected"></a>
        <cfelse>
            <a href="#APPLICATION.siteURL#become-a-host-family.cfm" class="tabs2"></a>
        </Cfif>
        <a href="http://outbound.iseusa.com/" class="tabs3" target="_blank"></a>
        <a href="#APPLICATION.siteURL#trips/exchange-student-trips.cfm" class="tabs4"></a>
        <a href="#APPLICATION.siteURL#webstore.cfm" class="tabs5"></a>
        <a href="http://blog.iseusa.com/" class="tabs6" target="_blank"></a>
    </div> <!-- end tabsBar -->

</cfif>

</cfoutput>    