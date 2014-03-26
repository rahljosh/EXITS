

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    
    <link rel="stylesheet" href="../smg.css" type="text/css">
    <link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css"> <!-- BaseStyle -->
    <link media="screen" rel="stylesheet" href="../linked/css/colorbox.css" /> <!-- Modal ColorBox -->
    <link media="screen" rel="stylesheet" href="../linked/css/buttons.css" /> <!-- Css Buttons -->
    <cfoutput>
		<link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab Style Sheet --> 
    	<script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
		<script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
	</cfoutput>        
	<script type="text/javascript" src="../linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker -->
	<script type="text/javascript" src="../linked/js/jquery.cfjs.js"></script> <!-- Coldfusion functions for jquery -->
    <script type="text/javascript" src="../linked/js/basescript.js "></script> <!-- BaseScript -->
</head>
<body>

  <div class="rdholder" style="width:90%; margin:30px; float:left;"> 
    
    <div class="emergencyTop"> 
        <span class="rdtitle">Emergency Contact Number</span> 
    </div> <!-- end top --> 
    
    <div class="rdbox">
    <cfif isDefined('form.addNumber')>
	<cfquery datasource="#application.dsn#">
    update smg_users
    set emergency_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.emergency_phone#">
    where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    </cfquery>
	 <table width="90%" align="center" cellpadding="4">
            <tr>
                <td rowspan=3 valign="middle"><img src="../pics/icons/emergency-icon.png" height="100"></td><td colspan=2 align="left"><Strong> Thank You!</strong> Your records have been updated.<br><br>
                Close this window to continue.
               </td>
            </tr>
           
           
        </table>
    <cfelse>
    <form method="post" action="emergencyNumber.cfm">
    <input type="hidden" name="AddNumber" value=1>
        <table width="90%" align="center" cellpadding="4">
            <tr>
                <td rowspan=3 valign="middle"><img src="../pics/icons/emergency-icon.png" height="100"></td><td colspan=2 align="left"> We are now requiring all International Agents to have an emergency contact number on file.<br>This number should have someone available 24 hours a day.</td>
            </tr>
            <tr>
                <td><strong>Your Emergency Number:</strong> <input type="text" name="emergency_phone" size=25 placeholder="No number on file"/></td>
                <td></td>
            </tr>
            <tr>
                <td align="center" colspan=2><input type="submit" value="Update" class="basicOrangeButton"></td>
            </tr>
        </table>
    </form>
    </cfif>
    </div>
    
    <div class="rdbottom"></div> <!-- end bottom --> 

</div>
</body>
                <!--- End of Online Reports --->