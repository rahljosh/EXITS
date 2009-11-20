<?php
define("NO_SESSION",true); // [JAS]: Leave this true

require_once("site.config.php");
require_once(FILESYSTEM_PATH . "cerberus-api/database/cer_Database.class.php");
require_once(FILESYSTEM_PATH . "cerberus-api/log/gui_parser_log.php");
include_once(FILESYSTEM_PATH . "cerberus-api/parser/CerPop3RawEmail.class.php");
include_once(FILESYSTEM_PATH . "cerberus-api/parser/CerProcessEmail.class.php");

        $process = new CerProcessEmail();
        $email = "";
        $stdin = fopen('php://stdin', 'r');
        while (!feof($stdin)) {
                $email .= fread($stdin, 8192);
        }

        if(!empty($email)) {
                $pop3email = new CerPop3RawEmail($email);
                $result = $process->process($pop3email);
                if(!$result) { // re-fail...
                        exit("Unable to parse message.");
                }
        }
?>
