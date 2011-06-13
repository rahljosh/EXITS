<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Second Host Family Visit</title>
<style type="text/css">
body{
font-family:"Lucida Grande", "Lucida Sans Unicode", Verdana, Arial, Helvetica, sans-serif;
font-size:12px;
}
p, h1, form, button{border:0; margin:0; padding:0;}
.spacer{clear:both; height:1px;}
/* ----------- My Form ----------- */
.myform{
margin:0 auto;
width:600px;
padding:14px;
}

/* ----------- stylized ----------- */
#stylized{
border:solid 2px #b7ddf2;
background:#ebf4fb;
}
#stylized h1 {
font-size:14px;
font-weight:bold;
margin-bottom:8px;
}
#stylized p{
font-size:11px;
color:#666666;
margin-bottom:20px;
border-bottom:solid 1px #b7ddf2;
padding-bottom:10px;
}
#stylized label{
display:block;
font-weight:bold;
text-align:right;
width:190px;
float:left;
padding-right:15px;
}
#stylized .small{
color:#666666;
display:block;
font-size:11px;
font-weight:normal;
text-align:right;
width:190px;
}

#stylized .inputLabel{
padding-right: 15px;
}

#stylized button{
clear:both;
margin-left:150px;
width:125px;
height:31px;
background:#666666 url(img/button.png) no-repeat;
text-align:center;
line-height:31px;
color:#FFFFFF;
font-size:11px;
font-weight:bold;
}
</style>
</head>

<body>

	<cfscript>

		// Get Student By UniqueID
		if ( LEN(URL.studentid) ) {
					qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentid=URL.studentid);
					CLIENT.studentID = qGetStudentInfo.studentID;
				} else {
					qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=studentID);	
				}
		
		// Program Information
		qGetProgramInfo = APPLICATION.CFC.PROGRAM.getPrograms(programid=qGetStudentInfo.programid);
		
		//Host Family Info
		qGetHosts = APPLICATION.CFC.HOST.getHosts(hostID=qGetStudentInfo.hostID);
	</cfscript>
   
    <cfoutput>
<div id="stylized" class="myform">
<form id="form" name="form" method="post" action="index.html">
<h1>Second Host Family Home Visit</h1>
<p><strong>Student:</strong> #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (#qGetStudentInfo.studentid#)<br />
<strong>Program:</strong> #qGetProgramInfo.programName#
</p>
<p>
<strong>Family:</strong> #qGetHosts.fatherfirstname# <cfif qGetHosts.fatherfirstname is not ''>&amp;</cfif> #qGetHosts.motherfirstname# #qGetHosts.familylastname# <br />
#qGetHosts.address#<br />
<cfif #qGetHosts.address2# is not ''>#qGetHosts.address2#<br /></cfif>
#qGetHosts.city# #qGetHosts.state#, #qGetHosts.zip#</p>

<label>Neighborhood Appearance
<span class="small">General look and feel</span>
</label>
<input type="radio" name="neighborhoodAppearance" id="name" value='Excellent' /> <span class="inputLabel">Excellent</span>
<input type="radio" name="neighborhoodAppearance" id="name" value='Average' /> <span class="inputLabel">Average</span>
<input type="radio" name="neighborhoodAppearance" id="name" value='Poor' /> <span class="inputLabel">Poor</span>
<br /><br /><br />
<label>Neighborhood Location
<span class="small">Is home in or near an area to be avoided.</span>
</label>
<input type="radio" value=1 name="avoid" /> <span class="inputLabel">Yes</span> 
<input type="radio" value=0 name="avoid" /> <span class="inputLabel">No</span>
<br /><br /><br />
<label>Home Appearance
<span class="small">Cleanliness, Maintenance</span>
</label>
<input type="radio" name="neighborhoodAppearance" id="name" value='Excellent' /> <span class="inputLabel">Excellent</span>
<input type="radio" name="neighborhoodAppearance" id="name" value='Average' /> <span class="inputLabel">Average</span> 
<input type="radio" name="neighborhoodAppearance" id="name" value='Poor' /> <span class="inputLabel">Poor</span>

<br /><br /><br />

<label>Type of Home
<span class="small">&nbsp;</span>
</label>
<input type="radio" name="typeOfHome" id="name" value='Single Family' /> <span class="inputLabel">Single Family</span>
<input type="radio" name="typeOfHome" id="name" value='Condominium' /> <span class="inputLabel">Condominium</span> 
<input type="radio" name="typeOfHome" id="name" value='Apartment' /> <span class="inputLabel">Apartment</span><br />
<input type="radio" name="typeOfHome" id="name" value='Duplex' /> <span class="inputLabel">Duplex</span>
<input type="radio" name="typeOfHome" id="name" value='Mobile Home' /> <span class="inputLabel">Mobile Home</span> 
<br /><br /><br />
<label>Home Details
<span class="small">Short Descriptions<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /></span>
</label>
<span class="inputLabel">Bedrooms&nbsp;&nbsp;&nbsp;&nbsp;</span>
<select name="numberBedRooms">
	<option value=0>0</option>
    <option value=1>1</option>
    <option value=2>2</option>
    <option value=3>3</option>
    <option value=4>4</option>
    <option value=5>5</option>
    <option value=6>6</option>
    <option value=7>7</option>
    <option value=8>8</option>
    <option value=9>9</option>
    <option value=10>10</option>
 </select><br />
<span class="inputLabel">Bathrooms&nbsp;&nbsp;&nbsp;</span>     
 <select name="numberBathRooms">
	<option value=0>0</option>
    <option value=1>1</option>
    <option value=2>2</option>
    <option value=3>3</option>
    <option value=4>4</option>
    <option value=5>5</option>
    <option value=6>6</option>
    <option value=7>7</option>
    <option value=8>8</option>
    <option value=9>9</option>
    <option value=10>10</option>
 </select>
 <br />
 <span class="inputLabel">Living Room&nbsp;</span>
<input type="text" name="livingRoom" id="name" size=25/>
<br />
 <span class="inputLabel">Dining Room</span>
<input type="text" name="dinningRoom" id="name" size=25/>
 <br />
 <span class="inputLabel">Kitchen&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
<input type="text" name="kitchen" id="name" size=25/>
 <br />
 <span class="inputLabel">Other&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
<textarea cols=10 rows=3></textarea>
<br />
<hr width=60% />
<label>Does #qGetStudentInfo.firstname# have their own permanet bed? 
<span class="small">Bed may not be a futon or inflatable</span>
</label>
<input type="text" name="ownBed" size = 30/>
<br /><Br /><Br />
<label>Does #qGetStudentInfo.firstname# have access to a bathroom? 
<span class="small"></span>
</label>
<input type="text" name="bathRoom" size = 30/>
<br /><Br /><Br />
<label>Does #qGetStudentInfo.firstname# have access to the outdoors from their bedroom? 
<span class="small"></span>
</label>
<input type="text" name="outdoorsFromBedroom" size = 30/>
<br /><Br /><Br />
<label>Does #qGetStudentInfo.firstname# have adequete storage space? 
<span class="small"></span>
</label>
<input type="text" name="storageSpace" size = 30/>
<br /><Br /><Br />
<label>Does #qGetStudentInfo.firstname# have privacy? 
<span class="small">i.e. a door on their room</span>
</label>
<input type="text" name="privacy" size = 30/>
<br /><Br /><Br />
<label>Does #qGetStudentInfo.firstname# have adequate study space? 
<span class="small"></span>
</label>
<input type="text" name="studySpace" size = 30/>
<br /><Br /><Br />
<label>Are there pets present in the home? 
<span class="small">How many & what kind</span>
</label>
<input type="text" name="pets" size = 30/>
<br /><Br /><Br />
<label>Other Comments 
<span class="small"></span>
</label>
<textarea cols="50" rows=5></textarea>
<button type="submit">Submit</button>
<div class="spacer"></div>

</form>

</div>
</cfoutput>
</body>
</html>