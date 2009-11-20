<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script src="ajax.js" type="text/javascript"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>
<form name="myform" id="myform">
  <table width="250" border="0">
   <tr><td><strong>age:</strong></td></tr>
   <tr><td>
   <select name="age" onchange="showResults(this.value, document.myform.status.value, document.myform.gender.value)">
    <option value="20">20</option>
    <option value="30">30</option>
    <option value="40">40</option>
   </select></td></tr>
   <tr><td><strong>status:</strong></td></tr>
   <tr><td>
   <select name="status" onchange="showResults(document.myform.age.value, this.value, document.myform.gender.value)">
    <option value="unemployed">unemployed</option>
    <option value="employed">employed</option>
    <option value="student">student</option>
   </select>
   </td></tr>
   <tr><td><strong>gender:</strong></td></tr>
   <tr><td>
   <select name="gender" onchange="showResults(document.myform.age.value, document.myform.status.value, this.value)">
    <option value="male">male</option>
    <option value="female">female</option>
    <option value="any">any</option>
   </select>
   </td></tr>
 </table>
</form>
<div id="txtResults"><p style="font-style:italic">Results will be listed here.</p></div>
</body>
</html>
