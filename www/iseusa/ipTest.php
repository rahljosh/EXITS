<?php
$response = http_get("http://api.ipinfodb.com/v3/ip-country/?key=0fc7fb53672eaf186d2c41db1c9b63224ef8f31e0270d8c351d2097794352bfb&ip=96.56.128.58", array("timeout"=>1), $info);
print_r($info);
?>