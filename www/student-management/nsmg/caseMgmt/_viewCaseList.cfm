<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>View All Cases for Student</title>
        <style type="text/css">
.boxWithTitle {
	font-family: Arial, Helvetica, sans-serif;
	margin: 15px;
	padding: 15px;
	height: auto;
	width: 70%;
	border: medium solid #CCC;
	Margin-right: auto;
	Margin-left: auto;
	min-width:600px;
}

#title {
font-family: Arial, Helvetica, sans-serif;
font-size: 16px;
color: #999;
background-color: #FFF;
position: relative;
z-index: 25;
top: -25px;
min-width:200px;
width:15%;

padding-right: 10px;
padding-left: 10px;
}
.dottedLineAbove {
	padding-top: 8px;
	border-top-width: thin;
	border-top-style: dashed;
	border-top-color: #CCC;
	width: 100%;
}
.dottedLineBelow {
	padding-bottom: 8px;
	border-bottom-width: thin;
	border-bottom-style: dashed;
	border-bottom-color: #CCC;
	width: 100%;
}


</style>
</head>
<body>


<div class="rdholder" style="width:100%; float:right;"> 
                
    <div class="rdtop"> 
        <span class="rdtitle">All Cases</span> 
        <div style="float:right;"><img src="pics/betaTesting.png"></div> 
        <em></em>
    </div>
    <div class="rdbox">
    <br />
    <cfif qBasicCaseDetails.recordcount eq 0>
    	There are no cases for this student.
    <cfelse>
    <cfloop query="qBasicCaseDetails">
    	<cfinclude template="basicCaseDetails.cfm">
    </cfloop>
    </cfif>
    <br />
    <cfoutput>
    <div align="center" class="dottedLineAbove" ><A href="index.cfm?curdoc=caseMgmt/index&action=basics&studentid=#url.studentid#&new=1" class="basicOrangeButton">Add New Case</a></div>
    </cfoutput>
 </div>
  <div class="rdbottom"></div> <!-- end bottom --> 

    
</body>
</html>
