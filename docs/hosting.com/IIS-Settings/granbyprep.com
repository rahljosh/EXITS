﻿<?xml version ="1.0"?>
<configuration xmlns="urn:microsoft-catalog:XML_Metabase_V64_0">
<MBProperty>
<IIS_Global	Location ="."
		SessionKey="496353625000000034000000100000000b02000001680000016800002e43034a3dd63a2b7ed5deccf065216127b4c9895dcded9279875fdf4b6278c622d6934bd4ad5bc5000000004a74a5931377bcf5d88c9df11dac9be5"
	>
</IIS_Global>
<IIsWebServer	Location ="/LM/W3SVC/810059259"
		AuthFlags="0"
		ServerAutoStart="TRUE"
		ServerBindings="204.12.118.243:80:www.granbyprep.com"
		ServerComment="www.granbyprep.com"
	>
</IIsWebServer>
<IIsFilters	Location ="/LM/W3SVC/810059259/filters"
		AdminACL="49634462f0000000a4000000400000008cc1561889936b1fd6223a898dbd77b174d76a584ec71b6ff84a99b6d08c6b9c520c86bd3f898534c136b9927ffe2ccec585be79100b4002f8e75529decba584617a1c47181d6bb3c382ad27fe8f873590bbedd3e8cd047ce875a9be4f5b7fe6d8d99a91da8b2ff73f5e1667416ff5cb89971ffcce3029f623f09ed35ac37aa48fe5a35cfc7047157056e9e8fabbc83c512e605c937ce469643bbba885d4479a5a6bebb20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
	>
</IIsFilters>
<IIsWebVirtualDir	Location ="/LM/W3SVC/810059259/root"
		AccessFlags="AccessRead"
		AppFriendlyName="Default Application"
		AppIsolated="2"
		AppRoot="/LM/W3SVC/810059259/Root"
		AuthFlags="AuthAnonymous | AuthNTLM"
		DirBrowseFlags="DirBrowseShowDate | DirBrowseShowTime | DirBrowseShowSize | DirBrowseShowExtension | DirBrowseShowLongDate | EnableDefaultDoc"
		Path="C:\websites\granbyprep"
		UNCPassword="496344625000000006000000400000008cc1561888930000a0920068000000005028016800000000003001680000000030fa006800000000c0050168000000001097006800000000c0ec35020000000070a754db2c175ae3"
	>
</IIsWebVirtualDir>
<IIsInheritedProperties	Location ="inherited:/LM/W3SVC/810059259"
		AdminACL="4963446210010000c8000000400000008cc1561889936b1ff2223a89a9bd77b174d76a584ec71b6ff84a65b6d18c6b9c520cb6bdbd898534c132b9927ffe2ccec385be79083840d3c33376897da7b7178e791c420c1d7fb34a828927748e873591beedd6fbcd0479fd75bdbede686b37690cb93178e63d61c65d1667416fc9cbab971bfcce3729f623f09ed36fc37aa4b7d4b78d4da664b5d23bfb7e37b8c83c712c785c397ee0696539bbada5d4479f5a69ebb2596dfd29a4be3d9f4332689a1cc16aec87f9813fc4d403430bb20c7b4757114e03e4fc436f007200460069006c00650073002c00410064006d0069006e00410043004c002c00410064006d0069006e00410043004c00420069006e0000004c0042006900"
		AllowKeepAlive="TRUE"
		AnonymousUserName="IUSR_202126-1"
		AnonymousUserPass="496344627000000022000000400000008cc15618ad93359f1a2279897fbd44b149d70b5865c77b6fb84ab7b6ac8c049c520c000001000000a086386bff07000080b7386bff07000003000000000000002c86386bff070000a086386bff0700009489386bff0700007491386bff070000a891386bff070000"
		AppAllowClientDebug="FALSE"
		AppAllowDebugging="FALSE"
		AppPoolId="DefaultAppPool"
		AspAllowOutOfProcComponents="TRUE"
		AspAllowSessionState="TRUE"
		AspAppServiceFlags="0"
		AspBufferingLimit="4194304"
		AspBufferingOn="TRUE"
		AspCalcLineNumber="TRUE"
		AspCodepage="0"
		AspDiskTemplateCacheDirectory="%windir%\system32\inetsrv\ASP Compiled Templates"
		AspEnableApplicationRestart="TRUE"
		AspEnableAspHtmlFallback="FALSE"
		AspEnableChunkedEncoding="TRUE"
		AspEnableParentPaths="FALSE"
		AspEnableTypelibCache="TRUE"
		AspErrorsToNTLog="FALSE"
		AspExceptionCatchEnable="TRUE"
		AspExecuteInMTA="0"
		AspKeepSessionIDSecure="0"
		AspLCID="2048"
		AspLogErrorRequests="TRUE"
		AspMaxDiskTemplateCacheFiles="2000"
		AspMaxRequestEntityAllowed="204800"
		AspProcessorThreadMax="25"
		AspQueueConnectionTestTime="3"
		AspQueueTimeout="4294967295"
		AspRequestQueueMax="3000"
		AspRunOnEndAnonymously="TRUE"
		AspScriptEngineCacheMax="250"
		AspScriptErrorMessage="An error occurred on the server when processing the URL.  Please contact the system administrator."
		AspScriptErrorSentToBrowser="TRUE"
		AspScriptFileCacheSize="500"
		AspScriptLanguage="VBScript"
		AspScriptTimeout="90"
		AspSessionMax="4294967295"
		AspSessionTimeout="20"
		AspTrackThreadingModel="FALSE"
		AuthChangeURL="/iisadmpwd/achg.asp"
		AuthExpiredURL="/iisadmpwd/aexp.asp"
		AuthExpiredUnsecureURL="/iisadmpwd/aexp3.asp"
		AuthNotifyPwdExpURL="/iisadmpwd/anot.asp"
		AuthNotifyPwdExpUnsecureURL="/iisadmpwd/anot3.asp"
		CGITimeout="300"
		CacheISAPI="TRUE"
		ConnectionTimeout="120"
		ContentIndexed="TRUE"
		DefaultDoc="index.cfm,index.htm,index.php"
		DirBrowseFlags="DirBrowseShowDate | DirBrowseShowTime | DirBrowseShowSize | DirBrowseShowExtension | DirBrowseShowLongDate | EnableDefaultDoc"
		DownlevelAdminInstance="1"
		HttpCustomHeaders="X-Powered-By: ASP.NET"
		HttpErrors="400,*,FILE,C:\WINDOWS\help\iisHelp\common\400.htm
			401,1,FILE,C:\WINDOWS\help\iisHelp\common\401-1.htm
			401,2,FILE,C:\WINDOWS\help\iisHelp\common\401-2.htm
			401,3,FILE,C:\WINDOWS\help\iisHelp\common\401-3.htm
			401,4,FILE,C:\WINDOWS\help\iisHelp\common\401-4.htm
			401,5,FILE,C:\WINDOWS\help\iisHelp\common\401-5.htm
			401,7,FILE,C:\WINDOWS\help\iisHelp\common\401-1.htm
			403,1,FILE,C:\WINDOWS\help\iisHelp\common\403-1.htm
			403,2,FILE,C:\WINDOWS\help\iisHelp\common\403-2.htm
			403,3,FILE,C:\WINDOWS\help\iisHelp\common\403-3.htm
			403,4,FILE,C:\WINDOWS\help\iisHelp\common\403-4.htm
			403,5,FILE,C:\WINDOWS\help\iisHelp\common\403-5.htm
			403,6,FILE,C:\WINDOWS\help\iisHelp\common\403-6.htm
			403,7,FILE,C:\WINDOWS\help\iisHelp\common\403-7.htm
			403,8,FILE,C:\WINDOWS\help\iisHelp\common\403-8.htm
			403,9,FILE,C:\WINDOWS\help\iisHelp\common\403-9.htm
			403,10,FILE,C:\WINDOWS\help\iisHelp\common\403-10.htm
			403,11,FILE,C:\WINDOWS\help\iisHelp\common\403-11.htm
			403,12,FILE,C:\WINDOWS\help\iisHelp\common\403-12.htm
			403,13,FILE,C:\WINDOWS\help\iisHelp\common\403-13.htm
			403,15,FILE,C:\WINDOWS\help\iisHelp\common\403-15.htm
			403,16,FILE,C:\WINDOWS\help\iisHelp\common\403-16.htm
			403,17,FILE,C:\WINDOWS\help\iisHelp\common\403-17.htm
			403,18,FILE,C:\WINDOWS\help\iisHelp\common\403.htm
			403,19,FILE,C:\WINDOWS\help\iisHelp\common\403.htm
			403,20,FILE,C:\WINDOWS\help\iisHelp\common\403-20.htm
			404,*,FILE,C:\WINDOWS\help\iisHelp\common\404b.htm
			404,2,FILE,C:\WINDOWS\help\iisHelp\common\404b.htm
			404,3,FILE,C:\WINDOWS\help\iisHelp\common\404b.htm
			405,*,FILE,C:\WINDOWS\help\iisHelp\common\405.htm
			406,*,FILE,C:\WINDOWS\help\iisHelp\common\406.htm
			407,*,FILE,C:\WINDOWS\help\iisHelp\common\407.htm
			412,*,FILE,C:\WINDOWS\help\iisHelp\common\412.htm
			414,*,FILE,C:\WINDOWS\help\iisHelp\common\414.htm
			415,*,FILE,C:\WINDOWS\help\iisHelp\common\415.htm
			500,12,FILE,C:\WINDOWS\help\iisHelp\common\500-12.htm
			500,13,FILE,C:\WINDOWS\help\iisHelp\common\500-13.htm
			500,15,FILE,C:\WINDOWS\help\iisHelp\common\500-15.htm
			500,16,FILE,C:\WINDOWS\help\iisHelp\common\500.htm
			500,17,FILE,C:\WINDOWS\help\iisHelp\common\500.htm
			500,18,FILE,C:\WINDOWS\help\iisHelp\common\500.htm
			500,19,FILE,C:\WINDOWS\help\iisHelp\common\500.htm"
		InProcessIsapiApps="C:\WINDOWS\system32\inetsrv\httpext.dll
			C:\WINDOWS\system32\inetsrv\httpodbc.dll
			C:\WINDOWS\system32\inetsrv\ssinc.dll
			C:\WINDOWS\system32\msw3prt.dll
			c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll"
		LogExtFileFlags="LogExtFileDate | LogExtFileTime | LogExtFileClientIp | LogExtFileSiteName | LogExtFileComputerName | LogExtFileServerIp | LogExtFileUriStem | LogExtFileUriQuery | LogExtFileHttpStatus | LogExtFileBytesSent | LogExtFileBytesRecv | LogExtFileTimeTaken | LogExtFileUserAgent | LogExtFileCookie | LogExtFileReferer"
		LogFileDirectory="C:\logs"
		LogFilePeriod="1"
		LogFileTruncateSize="20971520"
		LogOdbcDataSource="HTTPLOG"
		LogOdbcPassword="496344626000000012000000400000008cc15618fb931d9f3a22568972bd10b174d7100080000000ffffffff0000001882000000ffffffff010008101300000004000000000010001300000004000000800010001300000004000000000010011300000004000000"
		LogOdbcTableName="InternetLog"
		LogOdbcUserName="InternetAdmin"
		LogPluginClsid="{FF160663-DE82-11CF-BC0A-00AA006111E0}"
		LogType="1"
		MaxBandwidth="4294967295"
		MaxConnections="4294967295"
		MimeMap=".air,application/vnd.adobe.air-application-installer-package+zip"
		MinFileBytesPerSec="240"
		PasswordChangeFlags="AuthChangeDisable | AuthAdvNotifyDisable"
		ScriptMaps=".ad,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.adprototype,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.asa,C:\WINDOWS\system32\inetsrv\asp.dll,5,GET,HEAD,POST,TRACE
			.asax,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.ascx,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.ashx,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,1,GET,HEAD,POST,DEBUG
			.asmx,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,1,GET,HEAD,POST,DEBUG
			.asp,C:\WINDOWS\system32\inetsrv\asp.dll,5,GET,HEAD,POST,TRACE
			.aspx,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,1,GET,HEAD,POST,DEBUG
			.axd,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,1,GET,HEAD,POST,DEBUG
			.browser,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.cd,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.cdx,C:\WINDOWS\system32\inetsrv\asp.dll,5,GET,HEAD,POST,TRACE
			.cer,C:\WINDOWS\system32\inetsrv\asp.dll,5,GET,HEAD,POST,TRACE
			.compiled,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.config,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.cs,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.csproj,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.dd,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.exclude,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.idc,C:\WINDOWS\system32\inetsrv\httpodbc.dll,5,GET,POST
			.java,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.jsl,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.ldb,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.ldd,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.lddprototype,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.ldf,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.licx,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.master,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.mdb,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.mdf,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.msgx,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,1,GET,HEAD,POST,DEBUG
			.refresh,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.rem,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,1,GET,HEAD,POST,DEBUG
			.resources,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.resx,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.sd,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.sdm,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.sdmDocument,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.shtm,C:\WINDOWS\system32\inetsrv\ssinc.dll,5,GET,POST
			.shtml,C:\WINDOWS\system32\inetsrv\ssinc.dll,5,GET,POST
			.sitemap,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.skin,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.soap,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,1,GET,HEAD,POST,DEBUG
			.stm,C:\WINDOWS\system32\inetsrv\ssinc.dll,5,GET,POST
			.svc,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,1,GET,HEAD,POST,DEBUG
			.vb,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.vbproj,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.vjsproj,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			.vsdisco,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,1,GET,HEAD,POST,DEBUG
			.webinfo,c:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll,5,GET,HEAD,POST,DEBUG
			*,C:\ColdFusion9\runtime\lib\wsconfig\1\jrun_iis6_wildcard.dll,3
			.jsp,C:\ColdFusion9\runtime\lib\wsconfig\jrun_iis6.dll,3
			.jws,C:\ColdFusion9\runtime\lib\wsconfig\jrun_iis6.dll,3
			.cfm,C:\ColdFusion9\runtime\lib\wsconfig\jrun_iis6.dll,3
			.cfml,C:\ColdFusion9\runtime\lib\wsconfig\jrun_iis6.dll,3
			.cfc,C:\ColdFusion9\runtime\lib\wsconfig\jrun_iis6.dll,3
			.cfr,C:\ColdFusion9\runtime\lib\wsconfig\jrun_iis6.dll,3
			.cfswf,C:\ColdFusion9\runtime\lib\wsconfig\jrun_iis6.dll,3
			.hbmxml,C:\ColdFusion9\runtime\lib\wsconfig\jrun_iis6.dll,3
			.php,C:\WINDOWS\system32\inetsrv\fcgiext.dll,5,GET,HEAD,POST"
		UNCPassword="496344625000000006000000400000008cc1561888930000a0920068000000005028016800000000003001680000000030fa006800000000c0050168000000001097006800000000c0ec35020000000000bc51db2c175ae3"
		WAMUserName="IWAM_202126-1"
		WAMUserPass="496344627000000022000000400000008cc15618d2935f9f1c22698928bd04b128d71f5838c7526fac4a9fb6f88c199c520c000001000000a086386bff07000080b7386bff07000003000000000000002c86386bff070000a086386bff0700009489386bff0700007491386bff070000a891386bff070000"
	>
</IIsInheritedProperties>
</MBProperty>
</configuration>
