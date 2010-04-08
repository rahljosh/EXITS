<SCRIPT LANGUAGE="JavaScript">
<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->
<!-- Begin
var fatherlast = "";
var motherlast = "";

function InitSaveVariables(form) {
fatherlast = form.fatherlast.value;
motherlast = form.motherlast.value;
}

function lastname(form) {
InitSaveVariables(form);
form.fatherlast.value = form.familyname.value;
form.motherlast.value = form.familyname.value;

}

//  End -->


function testForm(){
	with (document.frmPhone) {
		if (familyname.value == '') {
			alert("Family Name is Required!");
			familyname.focus();
			return false;
		}
		if (address.value == '') {
			alert("Address is Required!");
			address.focus();
			return false;
		}
		if (city.value == '') {
			alert("City is Required!");
			city.focus();
			return false;
		}
		if (state.value == '0') {
			alert("State is Required!");
			state.focus();
			return false;
		}
		if (zip.value == '') {
			alert("Zip Code is Required!");
			zip.focus();
			return false;
		}
		if (phone.value == '') {
			alert("Phone Number is Required!");
			phone.focus();
			return false;
		}
			if (region.value == '0') {
			alert("Region is Required!");
			region.focus();
			return false;
		}
		if (fatherssn.value != '') {
			ssn = fatherssn.value;
			var matchArr = ssn.match(/^(\d{3})-?\d{2}-?\d{4}$/);
			var numDashes = ssn.split('-').length - 1;
			if (matchArr == null || numDashes == 1) {
				alert('Invalid Father`s SSN. Must be 9 digits or in the form XXX-XX-XXXX.');
				msg = "does not appear to be valid";
				fatherssn.focus();
				return false;
			} else if (parseInt(matchArr[1],10)==0) {
				alert("Invalid Father`s SSN: SSN's can't start with 000.");
				msg = "does not appear to be valid";
				fatherssn.focus();
				return false;
			}
		}
		if (motherssn.value != '') {
			ssn = motherssn.value;
			var matchArr = ssn.match(/^(\d{3})-?\d{2}-?\d{4}$/);
			var numDashes = ssn.split('-').length - 1;
			if (matchArr == null || numDashes == 1) {
				alert('Invalid Mother`s SSN. Must be 9 digits or in the form XXX-XX-XXXX.');
				msg = "does not appear to be valid";
				motherssn.focus();
				return false;
			} else if (parseInt(matchArr[1],10)==0) {
				alert("Invalid Mother`s SSN: SSN's can't start with 000.");
				msg = "does not appear to be valid";
				motherssn.focus();
				return false;
			}
		}
	}
}


<!-- Begin SSN Validation
function SSNValidation(ssn) {

}
//  End -->
</script>

<SCRIPT LANGUAGE="JavaScript">
<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->
<!-- Original:  Roman Feldblum (web.developer@programmer.net) -->

<!-- Begin
var n;
var p;
var p1;
function ValidatePhone(){
p=p1.value
if(p.length==3){
	//d10=p.indexOf('(')
	pp=p;
	d4=p.indexOf('(')
	d5=p.indexOf(')')
	if(d4==-1){
		pp="("+pp;
	}
	if(d5==-1){
		pp=pp+")";
	}
	//pp="("+pp+")";
	document.frmPhone.phone.value="";
	document.frmPhone.phone.value=pp;
}
if(p.length>3){
	d1=p.indexOf('(')
	d2=p.indexOf(')')
	if (d2==-1){
		l30=p.length;
		p30=p.substring(0,4);
		//alert(p30);
		p30=p30+")"
		p31=p.substring(4,l30);
		pp=p30+p31;
		//alert(p31);
		document.frmPhone.phone.value="";
		document.frmPhone.phone.value=pp;
	}
	}
if(p.length>5){
	p11=p.substring(d1+1,d2);
	if(p11.length>3){
	p12=p11;
	l12=p12.length;
	l15=p.length
	//l12=l12-3
	p13=p11.substring(0,3);
	p14=p11.substring(3,l12);
	p15=p.substring(d2+1,l15);
	document.frmPhone.phone.value="";
	pp="("+p13+")"+p14+p15;
	document.frmPhone.phone.value=pp;
	//obj1.value="";
	//obj1.value=pp;
	}
	l16=p.length;
	p16=p.substring(d2+1,l16);
	l17=p16.length;
	if(l17>3&&p16.indexOf('-')==-1){
		p17=p.substring(d2+1,d2+4);
		p18=p.substring(d2+4,l16);
		p19=p.substring(0,d2+1);
		//alert(p19);
	pp=p19+p17+"-"+p18;
	document.frmPhone.phone.value="";
	document.frmPhone.phone.value=pp;
	//obj1.value="";
	//obj1.value=pp;
	}
}
//}
setTimeout(ValidatePhone,100)
}
function getIt(m){
n=m.name;
//p1=document.forms[0].elements[n]
p1=m
ValidatePhone()
}
function testphone(obj1){
p=obj1.value
//alert(p)
p=p.replace("(","")
p=p.replace(")","")
p=p.replace("-","")
p=p.replace("-","")
//alert(isNaN(p))
if (isNaN(p)==true){
alert("Check phone");
return false;
}
}hjk
//  End -->
</script> 

</HEAD>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>


<cfoutput>

<span class="application_section_header">Host Parents Information</span>
<form method="post" action="querys/insert_pis_1.cfm" name="frmPhone" onSubmit="return testForm();">
<input type="hidden" name="userid" value="#client.userid#">
<div class="row">
  <span class="label"><span class="style1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields </span></span>
  <Table border=0>
	<Tr>
		<td class="label">Family Name: <span class="style1">*</span></td>
		<td colspan=3><input type="text" name="familyname" size="20"  onBlur="javascript:lastname(this.form);" required="yes" message="Last name must be completed">
	</tr>
	<tr>
		<td class="label">Address:<span class="style1"> *</span></td>
		<td colspan=3> <input type="text" name="address" size="20" required="yes" message="Address must be completed."></td>
	</tr>
	<tr>
		<td></td>
		<td  colspan=3> <input type="text" name="address2" size="20">
	</tr>
	<tr>			 
		<td class="label">City: <span class="style1">*</span></td>
		<td  colspan=3><input type="text" name="city" size="20" required="yes" message="City must be completed.">
	</tr>
	<tr>	
		<td class="label">State: <span class="style1">*</span></td>
		<td width=10>
			<cfinclude template="../querys/states.cfm">
			<select name="state" required="yes" message="State must be selected.">
				<option value="0"></option>
				<cfloop query = states>
				<option value="#state#">#State#</option>
				</cfloop>
			</select>
		</td>
		<td class="zip">Zip:<span class="label"><span class="style1"> *</span></span> </td>
		<td><input type="text" name="zip" size="5" maxlength="5" required="yes" message="Zip Code must be completed."></td>
	</tr>
	<tr>
		<td class="label">Phone: <span class="style1">*</span></td>
		<td  colspan=3> <input type="text" name="phone" maxlength="13" onclick="javascript:getIt(this)" required="yes" message="Phone must be completed"> 
	</tr>
	<tr>
		<td class="label">Email:</td>
		<td  colspan=3> <input type="text" name="email" size=20>
	</tr>
</table>
</div>

<div class="row1">
<table>
	<tr><td class="label">Fathers Last Name:</td><td>  <input type="text" name="fatherlast" size="20"></td></tr>
	<tr><td class="label">Fathers First Name:</td><td>  <input type="text" name="fatherfirst" size="20"></td></tr>
	<tr><td class="label">Fathers Middle Name:</td><td><input type="text" name="fathermiddle" size="20"></td></tr>
	<tr><td class="label">Year of Birth:</td><td>  <input type="text" name="fatherbirth" size="6" maxlength="4"> yyyy</td></tr>
	<tr><td class="label">Date of Birth:</td><td><input type="text" name="fatherdob" size="8" validate="date" maxlength="10" message="This is not a valid DOB. Please enter the mother dob in the following format mm/dd/yyyy"> mm/dd/yyyy</td></tr>
	<tr><td class="label">SSN:</td><td><input type="text" name="fatherssn" size=10 value="" maxlength="11" >  xxx-xx-xxxx</td></tr>	
	<tr><td class="label">Occupation:</td><td> <input type="text" size=20 name="fatherocc"></td></tr>
</table>
</div>
<div class="row">
<table>
	<Tr><td class="label">Mothers Last Name:</span></td><td><span class="formw">  <input type="text" name="motherlast" size="20"></span></tr>
	<tr><td class="label">Mothers First Name:</span></td><td><span class="formw">  <input type="text" name="motherfirst" size="20"></span></tr>
	<Tr><td class="label">Mothers Middle Name:</span></td><td><span class="formw"><input type="text" name="mothermiddle" size="20"></span></td></tr>			
	<Tr><td class="label">Year of Birth:</span></td><td><span class="formw">  <input type="text" name="motherbirth" size="6" maxlength="4"> yyyy</span></td></tr>
	<tr><td class="label">Date of Birth:</td><td><input type="text" name="motherdob" size="8" validate="date" maxlength="10" message="This is not a valid DOB. Please enter the mother dob in the following format mm/dd/yyyy"> mm/dd/yyyy</td></tr>
	<tr><td class="label">SSN:</td><td><input type="text" name="motherssn" size=10 value="" maxlength="11">  xxx-xx-xxxx</td></tr>		
	<Tr><td class="label">Occupation:</span></td><td><span class="formw"> <input type="text" size=20 name="motherocc"></span></td></tr>
	
	<tr>
		<Td align="right">Region:</Td><td> 
		<select name="region" required="yes" message="Region must be selected.">
		<cfif client.usertype LTE '4'> <!--- all regions --->
			<cfquery name="regions" datasource="caseusa">
				SELECT regionid, regionname  FROM smg_regions 
				WHERE company = '#client.companyid#' AND subofregion = '0' ORDER BY regionname
			</cfquery>
			<option value="0">Select Region</option>
		<cfelse>
			<cfquery name="regions" datasource="caseusa">
				SELECT smg_regions.regionid, smg_regions.regionname 
				FROM smg_users
				INNER JOIN user_access_rights ON smg_users.userid = user_access_rights.userid
				INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
				WHERE user_access_rights.userid = '#client.userid#' 
					AND user_access_rights.companyid = '#client.companyid#'
			</cfquery>
		</cfif>
		<cfloop query="regions">
		<option value="#regions.regionid#">#regions.regionname# &nbsp;</option>
		</cfloop>
		</select>
		</td>
	</tr>
</table> 		
</div>

<div class="button"><input name="Submit" type="image" src="pics/next.gif" align="right" border=0></div>
</form>

</cfoutput>		
</body> 
</html>