#!/usr/bin/php
<?php

$ARG_DEBUG = true;

$ARG_TITLE = "clodo wordpress preset";

$ARG_NAME = "admin";
if (isset($argv[1])) $ARG_NAME = $argv[1];

$ARG_PASS = "adminadmin";
if (isset($argv[2])) $ARG_PASS = $argv[2];

$ARG_EMAIL = "admin@clodo.ru";
if (isset($argv[3])) $ARG_EMAIL = $argv[3];

$ARG_URL = "http://".gethostbyaddr('127.0.0.1').".clodo.ru";
if (isset($argv[4])) $ARG_URL = $argv[4];

$ARG_COOKIE = "cookie.txt";
if (isset($argv[5])) $ARG_COOKIE = $argv[5];

$DATA = array(
	'weblog_title' => $ARG_TITLE, 'user_name' => $ARG_NAME,
	'admin_password' => $ARG_PASS, 'admin_password2' => $ARG_PASS,
	'admin_email' => $ARG_EMAIL, 'blog_public' => 1, 'Submit' => 'Install WordPress');

foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);

$POST_HEADERS = array(
	'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);

$ch = curl_init();
curl_setopt ($ch, CURLOPT_URL, $ARG_URL . "/wp-admin/install.php?step=2");

curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 60);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_HTTPHEADER, $POST_HEADERS);

if ($ARG_DEBUG) {
  curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt ($ch, CURLOPT_HEADER, 1);
  curl_setopt ($ch, CURLOPT_VERBOSE, 1);
}

curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARG_URL . "/wp-admin/install.php");

curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_POST, 1);
$result = curl_exec ($ch);
curl_close($ch);

?>

