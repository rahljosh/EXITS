<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>

<!--- <cfscript>
function removeAcento( p_string )
{
  var v_string = '';
      v_string = ReplaceList( p_string, 'á,à,ä,â,ã,Â,Ä,Á,À,Ã,é,è,ê,ë,É,È,Ê,Ë,í,ì,ï,î,Í,Ì,Î,Ï,ó,ò,õ,ô,ö,Ó,Ò,Õ,Ô,Ö,ú,ù,ü,û,Ú,Ù,Ü,Û,ç,Ç,ñ,Ñ', 'a,a,a,a,a,A,A,A,A,A,e,e,e,e,E,E,E,E,i,i,i,i,I,I,I,I,o,o,o,o,o,O,O,O,O,O,u,u,u,u,U,U,U,U,c,C,n,N') ;
 
 return( v_string );
}

function eliminaAcentuacao(str)
{
  var regExps = ListToArray('[ÁÀÃ],[áàã],[Éê],[éê],[Í],[í],[ÔÓÕ],[ôóõ],[ÚÜ],[úü],[Ç],[ç]');
  var rpl = ListToArray('A,a,E,e,I,i,O,o,U,u,C,c');

  var s = str;
  for(i = 1; i LTE arraylen(regExps); i = i + 1) 
	{
	  s = rereplace(s, regExps[i], rpl[i], 'ALL');
	}
 }
</cfscript> --->

<cfif NOT IsDefined('form.name')>

	<cfscript>
	function removeAccent(str1)
	{
	  var v_string = '';
		  v_string = ReplaceList( str1, 'á,à,ä,â,ã,Â,Ä,Á,À,Ã,é,è,ê,ë,É,È,Ê,Ë,í,ì,ï,î,Í,Ì,Î,Ï,ó,ò,õ,ô,ö,Ó,Ò,Õ,Ô,Ö,ú,ù,ü,û,Ú,Ù,Ü,Û,ç,Ç,ñ,Ñ', 'a,a,a,a,a,A,A,A,A,A,e,e,e,e,E,E,E,E,i,i,i,i,I,I,I,I,o,o,o,o,o,O,O,O,O,O,u,u,u,u,U,U,U,U,c,C,n,N') ;
	 return( v_string );
	}
	document.test.name.value = 'v_string';
	</cfscript>

	Trying to ger rid of accents<br>
	This is a test:
	<cfform action="?curdoc=sevis/test" name="test" method="post">
		Name: <cfinput type="text" name="name" size="10">
		Last Name: <cfinput type="text" name="lastname" size="10" onchange="removeAccent(this, form.name)">
		<cfinput type="submit" name="submit" value="Submit">
	</cfform>
<cfelse>

<cfscript>
function eliminaAcentuacao(str)
{
  var regExps = ListToArray('[ÁÀÃ],[áàã],[Éê],[éê],[Í],[í],[ÔÓÕ],[ôóõ],[ÚÜ],[úü],[Ç],[ç]');
  var rpl = ListToArray('A,a,E,e,I,i,O,o,U,u,C,c');
  var s = str;
  for(i = 1; i LTE arraylen(regExps); i = i + 1) 
	{
	  s = rereplace(s, regExps[i], rpl[i], 'ALL');
	 }
	WriteOutput("<br>Replacing 1st function : #s#");
	return( s );
 }
	eliminaAcentuacao(#form.name#);
	eliminaAcentuacao(#form.lastname#);
	
function removeAcento(str1)
{
  var v_string = '';
      v_string = ReplaceList( str1, 'á,à,ä,â,ã,Â,Ä,Á,À,Ã,é,è,ê,ë,É,È,Ê,Ë,í,ì,ï,î,Í,Ì,Î,Ï,ó,ò,õ,ô,ö,Ó,Ò,Õ,Ô,Ö,ú,ù,ü,û,Ú,Ù,Ü,Û,ç,Ç,ñ,Ñ', 'a,a,a,a,a,A,A,A,A,A,e,e,e,e,E,E,E,E,i,i,i,i,I,I,I,I,o,o,o,o,o,O,O,O,O,O,u,u,u,u,U,U,U,U,c,C,n,N') ;
 WriteOutput("<br><br>Replacing 2nd function : #v_string#");
 return( v_string );
}
	removeAcento(#form.name#);
	removeAcento(#form.lastname#);
</cfscript>
	
	<cfoutput>
		<br><br>Form: #form.name# / #form.lastname#
	</cfoutput>

</cfif>

<!--- <cfoutput>
<br><br><br>
"this and (that)" => #REEscape("this and (that)")#<br>
"$1 + $2 = $3" => #REEscape("$1 + $2 = $3")#<br>
"\,+,*,?,.,[,],^,$,(,),{,},|,-" => #REEscape("\,+,*,?,.,[,],^,$,(,),{,},|,-")#<br>
<br>
<cfset price = "$3">
Escaped regular expression search string that works:<br>
"= #price#" found at character: #REFind("=.*#REEscape(price)#", "An example of simple financial math: $1 + $2 = $3")#<br>
<br>
Unescaped regular expression search string that doesn't work:<br>
"= #price#" not found (search returns zero): #REFind("=.*#price#", "An example of simple financial math: $1 + $2 = $3")#
</cfoutput>  --->

</body>
</html>