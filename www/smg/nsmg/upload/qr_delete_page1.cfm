<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [01] - Delete Passport Photo</title>
</head>

<body>

<cftry>
    
    <cfdirectory directory="#AppPath.onlineApp.picture#" name="file" filter="#url.studentid#.*">	
    
    <cffile action="delete" file="#AppPath.onlineApp.picture##file.name#">
    
    <cfoutput>
    
		<script language="JavaScript">
            <!-- 
            alert("You have successfully deleted the passport photo.");
                location.replace("#AppPath.onlineApp.URL#index.cfm?curdoc=section1/page1&id=1&p=1");
            //-->
        </script>
    
    </cfoutput>
    
    <cfcatch type="any">
        <cfinclude template="error_message.cfm">	
    </cfcatch>
    
</cftry>
	
</body>
</html>
