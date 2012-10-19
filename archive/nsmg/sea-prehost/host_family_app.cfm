<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>PRE-APPLICATION</title> 
<!--     
<SCRIPT LANGUAGE="JavaScript">
         function getSelected(opt) {
            var selected = new Array();
            var index = 0;
            for (var intLoop = 0; intLoop < opt.length; intLoop++) {
               if ((opt[intLoop].selected) ||
                   (opt[intLoop].checked)) {
                  index = selected.length;
                  selected[index] = new Object;
                  selected[index].value = opt[intLoop].value;
                  selected[index].index = intLoop;
               }
            }
            return selected;
         }

         function outputSelected(opt) {
            var sel = getSelected(opt);
            var strSel = "";
            for (var item in sel)       
               strSel += sel[item].value + ",";
           "<input type='text' name='allinterest' value='" + strSel +"'>";
         }
      </SCRIPT> 
-->
<script language = "Javascript">

function echeck(str) {

		var at="@"
		var dot="."
		var lat=str.indexOf(at)
		var lstr=str.length
		var ldot=str.indexOf(dot)
		if (str.indexOf(at)==-1){
		   alert("Invalid Main Email Adress")
		   return false
		}

		if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
		   alert("Invalid Main Email Adress")
		   return false
		}

		if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr){
		    alert("Invalid Main Email Adress")
		    return false
		}

		 if (str.indexOf(at,(lat+1))!=-1){
		    alert("Invalid Main Email Adress")
		    return false
		 }

		 if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
		    alert("Invalid Main Email Adress")
		    return false
		 }

		 if (str.indexOf(dot,(lat+2))==-1){
		    alert("Invalid E-mail ID")
		    return false
		 }
		
		 if (str.indexOf(" ")!=-1){
		    alert("Invalid Main Email Adress")
		    return false
		 }

 		 return true					
	}

function ValidateForm(){
	var emailID=document.frm.mainemail
	
	if ((emailID.value==null)||(emailID.value=="")){
		alert("Please Enter your main Email Adress")
		emailID.focus()
		return false
	}
	if (echeck(emailID.value)==false){
		emailID.value=""
		emailID.focus()
		return false
	}
	return true
 }
</script>
<style type="text/css">
body
{
background-color:#E7E5DF;
font-family: Arial, Helvetica, sans-serif;
font-size: 11px;
}

input.radio
{

}
h1
{
font-size:16px;
}
#instruction
{
width:760px;
padding:10px;
}
.style2
{
font-size:12px;
font-weight:bold;
}
#inputtext
{
border:1px solid #777;
}
</style>
</head>

<body>
<center>
<table width="800" border="0" cellspacing="0" cellpadding="0" bgcolor="#ffffff">
  <tr>
    <td width="796" height="131" align="center" background="app_header.jpg"><p>&nbsp;</p>
    <p>&nbsp;</p><br />
    <h1>CONFIDENTIAL HOST FAMILY <u>PRE-APPLICATION</u></h1></td>
  </tr>
  <tr>
    <td><div align="left" id="instruction">
      <p>Let your local representative help you in finding  that special son or daughter that matches your family. Your local  representative will check new student applications as they are processed in  their National Office and will assist by pre-selecting a student or students  that meet your family&rsquo;s interests, hobbies and lifestyle, on a first come first  serve basis. Your student match will be available to you for 3 days before  being offered to other families. By completing and submitting this form, you  are starting your intention to host an exchange student selected by you from  students matched to or selected by your family. The SEA program members will  support you, your family, and your school throughout your experience. <br />
          <br />
      </p>
      </div></td>
  </tr>
  <tr>
    <td valign="bottom"><p class="style2">
    <%IF request.querystring("msg")="" then%>
        The SEA member programs believe, together, we can make a difference.
<cfabort>
    <center><form name="frm" action="applicationProcess.asp" method="post" onSubmit="return ValidateForm()">
    <table width="700" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td colspan="4"><span class="style2"><u>TELL US ABOUT YOUR FAMILY:</u></span><BR /><BR /></td>
    </tr>
    <tr>
        <td align="right">FATHER :</td><td colspan="2" align="left"><input type="text" id="inputtext" name="father" style="width:450px;" value="<%=request.querystring("father")%>" /></td><td >AGE :<input type="text" id="inputtext" name="fage"  value="<%=request.querystring("fage")%>" style="width:80px;"/></td>
    </tr>
    <tr>
        <td align="right">MOTHER :</td><td colspan="2" align="left"><input type="text" id="inputtext" name="mother"  style="width:450px;" value="<%=request.querystring("mother")%>"/></td><td >AGE :<input type="text" id="inputtext" name="mage"  value="<%=request.querystring("mage")%>" style="width:80px;"/></td>
    </tr>  
    <tr>
        <td align="right">ADDRESS :</td><td colspan="3" align="left"><input type="text" value="<%=request.querystring("address")%>" id="inputtext" name="address" style="width:575px;"/></td>
    </tr>
    <tr>
        <td align="right">CITY :</td><td align="left"><input type="text" id="inputtext" name="city" value="<%=request.querystring("city")%>" style="width:230px;"/></td><td align="left">STATE :<input type="text" id="inputtext" name="state"  style="width:150px;" value="<%=request.querystring("state")%>"/></td><td>ZIP :<input type="text" id="inputtext"name="zip" value="<%=request.querystring("zip")%>" style="width:80px;"/></td>
    </tr>    
    <tr>
        <td align="right">&nbsp;&nbsp;HOST E-MAIL :</td><td align="left"> Main<input type="text" id="inputtext" style="width:250px;" value="<%=request.querystring("")%>" name="mainemail"/></td><td colspan="2">2nd :<input type="text" id="inputtext" style="width:250px;" name="secndemail" value="<%=request.querystring("secndemail")%>"/></td>
    </tr>
      <tr>
        <td align="right">&nbsp;&nbsp;HOST PHONE :</td><td align="left"><input type="text" id="inputtext" style="width:273px;" name="homephone" value="<%=request.querystring("homephone")%>"/></td><td colspan="2">CELL :<input type="text" id="inputtext" style="width:250px;" name="cell" value="<%=request.querystring("cell")%>"/></td>
    </tr>  
    <tr>
        <td align="left" colspan="2">&nbsp;&nbsp;&nbsp;HAVE YOU EVER HOSTED BEFORE?
          <input name="radiobutton" type="radio" value="Yes" id="radio" />
          <label for="radiobutton">Yes</label>
          <input name="radiobutton" type="radio" value="No" id="radio" />
          <label for="radio">No</label></td><td align="left" colspan="2">WHAT COUNTRY: <input type="text" id="inputtext" style="width:100px;" value="<%=request.querystring("hostcountry")%>" name="hostcountry" /></td>
    </tr>
    <tr>
        <td align="left" colspan="4">&nbsp;&nbsp;&nbsp;LIST ANY PETS:<input type="text" id="inputtext" value="<%=request.querystring("pets")%>" style="width:575px;" name="pets" /></td>  
    </tr>
    </table>
    <BR /><BR />
        <table width="700" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td colspan="4"><span class="style2"><u>WHERE WOULD THE STUDENT ATTEND SCHOOL?</u></span><BR /><BR /></td>
    </tr>
    <tr>
        <td align="right">SCHOOL NAME:</td><td align="left" colspan="3"><input type="text" id="inputtext" style="width:575px;" value="<%=request.querystring("school")%>"name="school" /></td>  
    </tr>
      <tr>
        <td align="right">CITY :</td><td align="left"><input type="text" id="inputtext" style="width:273px;" value="<%=request.querystring("schoolcity")%>" name="schoolcity"/></td><td >STATE :</td><td align="left"><input type="text" id="inputtext" style="width:200px;" value="<%=request.querystring("schoolstate")%>" name="schoolstate" /></td>
    </tr> 
    </table>
    
    </center>
    </td>
  </tr>
  <tr>
    <td><div align="left" id="instruction">
      <p><u><b>IMPORTANT: This is the most important form  needed to complete in order to find a good match for your FAMILY! </b></u><BR />
        With this completed preliminary application,  your local representative will work to find a student that will match with your  interests, hobbies and lifestyle. He/she will then present you with profiles of  students that you may review to select your new son or daughter!</p>
      <p><b><u>NO PLACEMENT IS MADE UNTIL YOU SELECT YOUR  STUDENT</u>.</b>The best experience in HOSTING will result from  this way of selecting a student. Please use the experience of your local representative  in your selection process. </p>
    </div></td>
  </tr>
  <tr>
    <td><p>&nbsp;&nbsp;PPlease check the interests that your family has</p>
      <table width="700" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Art&amp;Craft" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Arts&amp;craft</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Hiking" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Hiking</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Sewing" id="checkbox" /></td>
          <td align="left"><label for="label">Sewing</label></td>
        </tr>
        <tr>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Art_painting" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Art/painting</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="History" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">History</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Shopping" id="checkbox" /></td>
          <td align="left"><label for="label">Shopping</label></td>
        </tr>
        <tr>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Back packing" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Back packing</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Hunting" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Hunting</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Snow sports" id="checkbox" /></td>
          <td align="left"><label for="label">Snow sports</label></td>
        </tr>
        <tr>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Baseball" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Baseball</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Ice Hockey" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Ice Hockey</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Soccer" id="checkbox" /></td>
          <td align="left"><label for="label">Soccer</label></td>
        </tr>
        <tr>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Biking" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Biking</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Jogging" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Jogging</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Swimming" id="checkbox" /></td>
          <td align="left"><label for="label">Swimming</label></td>
        </tr>
        <tr>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Bowing" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Bowing</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Movies" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Movies</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Table games" id="checkbox" /></td>
          <td align="left"><label for="label">Table Games</label></td>
        </tr>
        <tr>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Camping" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Camping</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Museums" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Museums</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Tennis" id="checkbox" /></td>
          <td align="left"><label for="label">Tennis</label></td>
        </tr>
        <tr>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Church&nbsp;Activities" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Church Activities</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Music" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Music</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Theater" id="checkbox" /></td>
          <td align="left"><label for="label">Theater</label></td>
        </tr>
        <tr>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Collecting" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Collecting</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Photography" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Photography</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Visiting&nbsp;relatives" id="checkbox" /></td>
          <td align="left"><label for="label">Visiting relatives</label></td>
        </tr>
        <tr>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Community&nbsp;work" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Community Work</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Picnics" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Picnics</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Walking" id="checkbox" /></td>
          <td align="left"><label for="label">Walking</label></td>
        </tr>
        <tr>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Computers" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Computers</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Raising Animals" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Raising Animals</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Watching TV" id="checkbox" /></td>
          <td align="left"><label for="label">Watching TV</label></td>
        </tr>
        <tr>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Cooking" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Cooking</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Reading" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Reading</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Water&nbsp;Sking" id="checkbox" /></td>
          <td align="left"><label for="label">Water Sking</label></td>
        </tr>
        <tr>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Family&nbsp;activities" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Family/activities</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Riding&nbsp;horses" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Riding horses</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Woodworking" id="checkbox" /></td>
          <td align="left"><label for="label">Woodworking</label></td>
        </tr>
        <tr>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Fishing" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Fishing</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Sailing&nbsp;boating" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Sailing/boating</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Writing" id="checkbox" /></td>
          <td align="left"><label for="label">Writing</label></td>
        </tr>
          <tr>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Golf" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">Golf</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="School&nbsp;activities" id="checkbox" /></td>
          <td width="180" align="left"><label for="label">School activities</label></td>
          <td width="50" align="center"><input type="checkbox" name="checkbox" value="Others" id="checkbox" /></td>
          <td align="left"><label for="label">Others</label></td>
        </tr>
        <tr>
          <td align="center" colspan="6"><BR />(Your local represntative will talk to you about any additional interest.)</td>
        </tr>
      </table>      
      <p>&nbsp;</p></td>
  </tr>
  <tr>
    <td>
       <table width="700" align="center" cellpadding="0" cellspacing="0" border="0">
       <tr>
       <td width="300" align="left">Does anyone play in a Band or an Orchestra?</td>
       <td align="left"><input name="Band" type="radio" value="Yes" id="radio" />
          <label for="Band">Yes</label></td>
       <td align="left"><input name="Band" type="radio" value="No" id="radio" />
          <label for="Band">No</label></td>
       <td></td>
       </tr>
       <tr>
       <td width="300" align="left">Does anyone play in competitive sport?</td>
       <td align="left"><input name="sport" type="radio" value="Yes" id="radio" />
          <label for="sport">Yes</label></td>
       <td align="left"><input name="sport" type="radio" value="No" id="radio" />
          <label for="sport">No</label></td>
       <td></td>
       </tr>    
       <tr>
       <td width="300" align="left">Does anyone in your family Smoke?</td>
       <td align="left"><input name="smoke" type="radio" value="Yes" id="radio" />
          <label for="smoke">Yes</label></td>
       <td align="left"><input name="smoke" type="radio" value="No" id="radio" />
          <label for="smoke">No</label></td>
       <td align="left"><input name="smoke" type="radio" value="Sometimes" id="radio" />
          <label for="smoke">Sometimes</label></td>
       </tr>   
       <tr>
       <td width="300" align="left">Would you be willing to host a student who smokes?</td>
       <td align="left"><input name="hostsmoker" type="radio" value="Yes" id="radio" />
          <label for="hostsmoker">Yes</label></td>
       <td align="left"><input name="hostsmoker" type="radio" value="No" id="radio" />
          <label for="hostsmoker">No</label></td>
       <td align="left"><input name="hostsmoker" type="radio" value="Maybe" id="radio" />
          <label for="hostsmoker">Maybe</label></td>
       </tr>        
        <tr>
       <td width="300" align="left">Will student share a bedroom?</td>
       <td align="left"><input name="shareroom" type="radio" value="Yes" id="radio" />
          <label for="shareroom">Yes</label></td>
       <td align="left"><input name="shareroom" type="radio" value="No" id="radio" />
          <label for="shareroom">No</label></td>
       <td></td>
       </tr>
       <tr>
        <td colspan="4"><br />NOTE: A student may share a bedroom with one of the same sex and within a reasonable age difference.</td>
       </tr>                   
       </table><BR /><BR />
    </td>
  </tr>
  <tr>
    <td>
        <table align="center" width="700" cellpadding="0" cellspacing="0" border="0">
            <tr>
            <td colspan="4" align="left">Please list any children :</td>
            </tr>
            <tr>
                <td widht="250">Boys</td><td width="100">Age</td><td width="250">Girls</td><td width="100">Age</td>
            </tr>
            <tr>
                <td widht="275"><input id="inputtext" style="width:270px;" type="text" name="boy1name"/></td>
                <td width="75"><input id="inputtext" style="width:70px;" type="text" name="boy1age" /></td>
                <td width="275"><input id="inputtext" style="width:270px;" type="text" name="Girl1name"/></td>
                <td width="75"><input id="inputtext" style="width:70px;" type="text" name="girl1age" /></td>
            </tr>
           <tr>
                <td widht="275"><input id="inputtext" style="width:270px;" type="text" name="boy2name"/></td>
                <td width="75"><input id="inputtext" style="width:70px;" type="text" name="boy2age" /></td>
                <td width="275"><input id="inputtext" style="width:270px;" type="text" name="Girl2name"/></td>
                <td width="75"><input id="inputtext" style="width:70px;" type="text" name="girl2age" /></td>
            </tr>
           <tr>
                <td widht="275"><input id="inputtext" style="width:270px;" type="text" name="boy3name"/></td>
                <td width="75"><input id="inputtext" style="width:70px;" type="text" name="boy3age" /></td>
                <td width="275"><input id="inputtext" style="width:270px;" type="text" name="Girl3name"/></td>
                <td width="75"><input id="inputtext" style="width:70px;" type="text" name="girl3age" /></td>
            </tr>
           <tr>
                <td widht="275"><input id="inputtext" style="width:270px;" type="text" name="boy4name"/></td>
                <td width="75"><input id="inputtext" style="width:70px;" type="text" name="boy4age" /></td>
                <td width="275"><input id="inputtext" style="width:270px;" type="text" name="Girl4name"/></td>
                <td width="75"><input id="inputtext" style="width:70px;" type="text" name="girl4age" /></td>
            </tr>                                                
        </table><BR /><BR />
    </td>
  </tr>  
  <tr>
    <td><table align="center" width="700" cellpadding="0" cellspacing="0" border="0">
            <tr>
            <td colspan="3" align="right">Degree of participation in church and related activities :</td>
            <td align="left">
                <select name="participation">
                    <option value="Active">Active</option>
                    <option value="Average">Average</option>
                    <option value="Little Interest">Little Interest</option>
                    <option value="Inactive">Inactive</option>
                    <option value="Never attend">Never attend</option>
                    <option value="Willing to show respect by attending">Willing to show respect by attending</option>
                </select>
            </td>
            </tr>
            <tr>
                <td colspan="3" align="right">Religious affiliation :</td><td align="left"><input type="text" id="inputtext" name="religion" style="width:240px;" /></td>
            </tr>    
            <tr>
                <td colspan="3" align="right">Would you expect your exchange student to attend services with your family? 
                <br /><b>Suggested:</b> 1 Service a weekend and 1 Youth Group Meeting a week
                </td><td align="left" valign="top">
                <input name="attendwfam" type="radio" value="Yes" id="radio1" />
          <label for="attendwfam">Yes</label>
          <input name="attendwfam" type="radio" value="No" id="radio2" />
          <label for="attendwfam">No</label></td></td>
            </tr>    
            <tr>
                <td colspan="3" align="right">Would you provide transportation to student's religious service if different than yours?
                </td><td align="left" valign="top">
                <input name="transport" type="radio" value="Yes" id="radio3" />
          <label for="transport">Yes</label>
          <input name="transport" type="radio" value="No" id="radio4" />
          <label for="transport">No</label></td></td>
            </tr>    
             <tr>
                <td colspan="3" align="right">Would you be willing to host a student who is allergic to animals?
                </td><td align="left" valign="top">
                <input name="allergy" type="radio" value="Yes" id="radio5" />
          <label for="allergy">Yes</label>
          <input name="allergy" type="radio" value="No" id="radio6" />
          <label for="allergy">No</label></td></td>
            </tr>                           
        </table></td>
  </tr>
  <tr>
    <td><BR /><BR /><center><input type="submit" value="Submit your application"/></center><BR /><BR /></form></td>
  </tr>  
</table></center>
</body>
</html>
