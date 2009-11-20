<?php
/***********************************************************************
| Cerberus Helpdesk(tm) developed by WebGroup Media, LLC. 
|-----------------------------------------------------------------------
| All source code & content (c) Copyright 2002, WebGroup Media LLC 
|   unless specifically noted otherwise.
|
| This source code is released under the Cerberus Public License.
| The latest version of this license can be found here:
| http://www.cerberusweb.com/license.php
|
| By using this software, you acknowledge having read this license
| and agree to be bound thereby.
|
| File: attachment_send.php
|
| Purpose: Sends a file from the database to the users computer through 
|   the browser.  Uses browser to prompt for filename to "Save As".
|
| Developers involved with this file: 
|		Jeff Standen  (jeff@webgroupmedia.com)   [JAS]
|           Jeremy Johnstone  (jeremy@webgroupmedia.com) [JSJ]
|
| ______________________________________________________________________
|	http://www.cerberusweb.com	  http://www.webgroupmedia.com/
***********************************************************************/

define("NO_OB_CALLBACK",true); // [JAS]: Leave this true

require_once("config.php");
require_once("session.php");

@$file_id = intval($_REQUEST["file_id"]);
@$thread_id = intval($_REQUEST["thread_id"]); // Require thread_id too for added security [JSJ]

if($cer_session->is_logged_in == false) {
	die("Cerberus [ERROR]: You must be logged in to view attachments.");
}

if(!isset($file_id) || !isset($thread_id)) {
	die("Cerberus [ERROR]: File/Thread ID not valid.");
}

$sql = sprintf("SELECT a.public_user_id ".
	"FROM thread th ".
	"INNER JOIN ticket t on (th.ticket_id = t.ticket_id) ".
	"INNER JOIN requestor r on (t.ticket_id = r.ticket_id) ".
	"INNER JOIN address a ON (a.address_id = r.address_id) ".
	"WHERE th.thread_id = '%d' ".
	"AND a.public_user_id = '%d' ",
		$thread_id,
		$cer_session->user_id
	);
$access_check = $cerberus_db->query($sql, false);

if($cerberus_db->num_rows($access_check) == 0) {
	die("Cerberus [ERROR]: You are not authorized to view this attachment.  Logging attempt.");
}

$sql = sprintf("SELECT a.file_name, a.file_size " .
	"FROM thread_attachments a " .
	"WHERE a.file_id = '%d' ".
	"AND a.thread_id = '%d'",
		$file_id,
		$thread_id
	);
$file_dump = $cerberus_db->query($sql, false);

if($cerberus_db->num_rows($file_dump) > 0) $file_info = $cerberus_db->fetch_row($file_dump);
$attachment = (strstr($_SERVER["HTTP_USER_AGENT"], "MSIE")) ? "" : "attachment";
$fexp=explode('.',$file_info[0]);
$ext=$fexp[sizeof($fexp)-1];
 
header("Expires: Mon, 26 Nov 1962 00:00:00 GMT\n");
header("Last-Modified: " . gmdate("D,d M YH:i:s") . " GMT\n");
header("Cache-control: private\n");
header('Pragma: no-cache\n');

$mimetype = array( 
    'bmp'=>'image/bmp',
    'doc'=>'application/msword', 
    'gif'=>'image/gif',
    'gz'=>'application/x-gzip-compressed',
    'htm'=>'text/html', 
    'html'=>'text/html', 
    'jpg'=>'image/jpeg', 
    'mp3'=>'audio/x-mp3',
    'pdf'=>'application/pdf', 
    'php'=>'text/plain', 
    'swf'=>'application/x-shockwave-flash',
    'tar'=>'application/x-tar',
    'tgz'=>'application/x-gzip-compressed',
    'tif'=>'image/tiff',
    'tiff'=>'image/tiff',
    'txt'=>'text/plain', 
    'vsd'=>'application/vnd.visio',
    'vss'=>'application/vnd.visio',
    'vst'=>'application/vnd.visio',
    'vsw'=>'application/vnd.visio',
    'wav'=>'audio/x-wav',
    'xls'=>'application/vnd.ms-excel',
    'xml'=>'text/xml',
    'zip'=>'application/x-zip-compressed' 
    ); 
        
if(isset($mimetype[$ext]))
	header("Content-Type: " . $mimetype[$ext] . "\n");
else
	header("Content-Type: application/octet-stream\n");


$sql = "SELECT part_content FROM thread_attachments_parts WHERE file_id = $file_id";
$file_parts_res = $cerberus_db->query($sql,false);

header("Content-transfer-encoding: binary\n"); 

$tmp_dir = FILESYSTEM_PATH . "tempdir";
$temp_file_name = tempnam($tmp_dir,"cerbfile_");
$fp = fopen($temp_file_name,"wb");

while($file_part = $cerberus_db->fetch_row($file_parts_res))
{
	$chunk_len = strlen(str_replace(chr(0)," ",$file_part[0])); // [JAS]: Don't stop counting on a NULL
	fwrite($fp,$file_part[0],$chunk_len);
}

// Make sure all data is written to disk before getting the file size [gavin@eleventeenth.com]
fflush($fp);

//$temp_file_size = filesize($temp_file_name);
$fstat = fstat($fp);
$temp_file_size = $fstat["size"];
header("Content-Length: " . $temp_file_size . "\n");

$head = "Content-Disposition: $attachment; filename=\"".$file_info[0]."\"\n";
header($head);

if(@$fp) fclose($fp);
$fp = fopen($temp_file_name,"rb");

fpassthru($fp);

if(@$fp) @fclose($fp);
@unlink($temp_file_name);

unset($file_part);
unset($file_parts_res);

exit;
?>
