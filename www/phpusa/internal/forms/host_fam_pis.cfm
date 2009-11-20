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
		if (state.value == '') {
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
}
//  End -->
</script>

</HEAD>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>

<form method="post" action="querys/insert_pis_1.cfm" name="frmPhone" onSubmit="return testForm();">
<div class="row"><br>
<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><span class="application_section_header">
      <h2>Host Parents Infomation</h2>
    </span> </td>
    <td>&nbsp;</td>
  </tr>
</table>
	
				 		
<table width="92%"  border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="#C7CFDC" bgcolor="#FFFFFF">
  <tr class="box">
    <td><table border=0 cellspacing="0" width=100% cellpadding=4 align="center" bgcolor=#ffffff class=box>
	<tr>
        <td width="50%" class="label style1">* Required Fields </td>
        <td align="left" >&nbsp;</td>
      </tr>
      <tr>
        <td width="50%" class="label">Family Name:<span class="style1"> *</span> </td>
        <td align="left" ><input type="text" name="familyname" size="20"  onblur="javascript:lastname(this.form);" /></td>
      </tr>
      <tr>
        <td width="50%" class="label">Address: <span class="style1">*</span></td>
        <td ><input type="text" name="address" size="20" /></td>
      </tr>
      <tr>
        <td width="50%"></td>
        <td><input type="text" name="address2" size="20" />        </td>
      </tr>
      <tr>
        <td width="50%" class="label">City: <span class="style1">*</span></td>
        <td  ><input type="text" name="city" size="20" />        </td>
      </tr>
      <tr>
        <td width="50%" class="label"> State: <span class="style1">*</span></td>
        <td width=364><select name="state">
            <option selected> </option>
          <option value="AL">AL </option>
          <option value="AK">AK </option>
          <option value="AZ">AZ </option>
          <option value="AR">AR </option>
          <option value="CA">CA </option>
          <option value="CO">CO </option>
          <option value="CT">CT </option>
          <option value="DE">DE </option>
          <option value="FL">FL </option>
          <option value="GA">GA </option>
          <option value="HI">HI </option>
          <option value="ID">ID </option>
          <option value="IL">IL </option>
          <option value="IN">IN </option>
          <option value="IA">IA </option>
          <option value="KS">KS </option>
          <option value="KY">KY </option>
          <option value="LA">LA </option>
          <option value="MA">MA </option>
          <option value="MD">MD </option>
          <option value="ME">ME </option>
          <option value="MI">MI </option>
          <option value="MN">MN </option>
          <option value="MS">MS </option>
          <option value="MO">MO </option>
          <option value="MT">MT </option>
          <option value="NE">NE </option>
          <option value="NV">NV </option>
          <option value="NH">NH </option>
          <option value="NJ">NJ </option>
          <option value="NM">NM </option>
          <option value="NY">NY </option>
          <option value="NC">NC </option>
          <option value="ND">ND </option>
          <option value="OH">OH </option>
          <option value="OK">OK </option>
          <option value="OR">OR </option>
          <option value="PA">PA </option>
          <option value="RI">RI </option>
          <option value="SC">SC </option>
          <option value="SD">SD </option>
          <option value="TN">TN </option>
          <option value="TX">TX </option>
          <option value="UT">UT </option>
          <option value="VT">VT </option>
          <option value="VA">VA </option>
          <option value="WA">WA </option>
          <option value="DC">DC </option>
          <option value="WV">WV </option>
          <option value="WI">WI </option>
          <option value="WY">WY </option>
        </select>        </td>
      </tr>
      <tr>
        <td width="50%" class="label">Zip: <span class="style1">*</span></td>
        <td><input type="text" name="zip" size="5" maxlength="5" /></td>
      </tr>
      <tr>
        <td width="50%" class="label">Phone:<span class="style1"> *</span></td>
        <td  ><input type=text name=phone maxlength="13" onclick="javascript:getIt(this)" />        </td>
      </tr>
      <tr>
        <td width="50%" class="label">Email:</td>
        <td  ><input type="text" name="email" size=20 />        </td>
      </tr>
      <tr bgcolor="#C2D1EF">
        <td width="50%" class="label">Fathers First Name:</td>
        <td bgcolor="#C2D1EF"><input type="text" name="fatherfirst" size="20" />        </td>
      </tr>
      <tr bgcolor="#C2D1EF">
        <td width="50%" class="label">Fathers Last Name:</td>
        <td bgcolor="#C2D1EF"><input type="text" name="fatherlast" size="20" />        </td>
      </tr>
      <tr bgcolor="#C2D1EF">
        <td width="50%" class="label">Fathers Cell Phone:</td>
        <td bgcolor="#C2D1EF"><input type="text" name="fathercell" size="13" />        </td>
      </tr>
      <tr bgcolor="#C2D1EF">
        <td width="50%" class="label">Fathers SSN:</td>
        <td bgcolor="#C2D1EF"><input type="text" name="fatherssn" size="20" />
          XXX-XX-XXXX </td>
      </tr>
      <tr bgcolor="#C2D1EF">
        <td width="50%" class="label">Year of Birth:</td>
        <td bgcolor="#C2D1EF"><input type="text" name="fatherdob" size="8" maxlength="4" />
          yyyy </td>
      </tr>
      <tr bgcolor="#C2D1EF">
        <td width="50%" class="label">Occupation:</td>
        <td bgcolor="#C2D1EF"><input type="text" size=20 name="fatherocc" />        </td>
      </tr>
      <tr>
        <td width="50%" class="label">Mothers First Name:</td>
        <td><span class="formw">
          <input type="text" name="motherfirst" size="20" />
        </span> </td>
      </tr>
      <tr>
        <td width="50%" class="label">Mothers Last Name:</td>
        <td><span class="formw">
          <input type="text" name="motherlast" size="20" />
        </span> </td>
      </tr>
      <tr>
        <td width="50%" class="label">Mothers Cell Phone:</td>
        <td ><input type="text" name="mothercell" size="20" />        </td>
      </tr>
      <tr>
        <td width="50%" class="label">Mothers SSN:</td>
        <td ><input type="text" name="motherssn" size="20" />
          XXX-XX-XXXX </td>
      </tr>
      <tr>
        <td width="50%" class="label">Year of Birth:</td>
        <td><span class="formw">
          <input type="text" name="motherdob"  size="8" maxlength="4" />
          yyyy</span> </td>
      </tr>
      <tr>
        <td width="50%" class="label">Occupation:</td>
        <td><span class="formw">
          <input type="text" size=20 name="motherocc" />
        </span> </td>
      </tr>
      <!----
	<tr>
		<Td align="right">Region:</Td><td> 
		<cfoutput>
		<select name="region">
		<option>Select Region</option>
		<cfif client.usertype LTE '4'> <!--- all regions --->
      <cfquery name="regions" datasource="mysql">
        SELECT regionid, regionname FROM smg_regions WHERE company = '#client.companyid#' AND subofregion = '0' ORDER BY regionname
        </cfquery>
      <cfelse>
      <cfquery name="regions" datasource="mysql">
        SELECT smg_regions.regionid, smg_regions.regionname FROM smg_users INNER JOIN user_access_rights ON smg_users.userid = user_access_rights.userid INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid WHERE user_access_rights.userid = '#client.userid#' AND user_access_rights.companyid = '#client.companyid#' ORDER BY regionname
        </cfquery>
  <td width="50%"><cfloop query="regions">
    <option value="#regions.regionid#">#regions.regionname# &nbsp;</option>
  </cfloop>  </td>
      <td width="50%"></td>
    <td width="50%"></td>
    <td width="50%"></td>
    <td width="50%"></td>
  </tr>
      ---->
    </table></td>
  </tr>
</table>
</div>

<div class="button"><br>
  <center><input name="Submit" type="image" src="pics/next.gif" alt= "next" align="middle" border=0></center>
</div>
</form>
</body> 
</html>