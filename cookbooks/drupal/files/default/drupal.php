#!/usr/bin/php
<?php

$ARG_DEBUG = true;
$ARG_DB = "drupaldb";
$ARG_DBUSER = "drupaluser";
$ARG_DBPASS = "test";
$ARG_DBHOST = "localhost";
$ARG_DBPORT = "";
$ARG_DBPREF = "";

$ARG_TITLE = "clodo drupal preset";

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
	'db_type' => 'mysqli', 'db_path' => $ARG_DB,
	'db_user' => $ARG_DBUSER, 'db_pass' => $ARG_DBPASS,
	'db_host' => $ARG_DBHOST, 'db_port' => $ARG_DBPORT,
	'db_prefix' => $ARG_DBPREF, 'op' => 'Save and continue',
	'form_id' => 'install_settings_form');

foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);

$POST_HEADERS = array(
	'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);


$ch = curl_init();
curl_setopt ($ch, CURLOPT_URL, $ARG_URL . "/install.php?locale=en&profile=default");
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARG_URL . "/install.php?profile=default&locale=en");
$result = curl_exec ($ch);
var_dump($result);
sleep(2);

curl_setopt ($ch, CURLOPT_URL, $ARG_URL . "/install.php?locale=en&profile=default&op=start&id=1");
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_HTTPHEADER, $POST_HEADERS);

if ($ARG_DEBUG) {
  curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt ($ch, CURLOPT_HEADER, 1);
  curl_setopt ($ch, CURLOPT_VERBOSE, 1);
}

curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARG_URL . "/install.php?profile=default&locale=en");
curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_POST, 1);
$result = curl_exec ($ch);
var_dump($result);
sleep(2);

curl_setopt ($ch, CURLOPT_URL, $ARG_URL."/install.php?profile=default&locale=en&op=do_nojs&id=1");
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_HTTPGET, 1);
curl_setopt ($ch, CURLOPT_POST, 0);
if ($ARG_DEBUG) {
  curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt ($ch, CURLOPT_HEADER, 1);
  curl_setopt ($ch, CURLOPT_VERBOSE, 1);
}

curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARG_URL . "/install.php?profile=default&locale=en");
$result = curl_exec ($ch);
var_dump($result);
sleep(2);
$result = curl_exec ($ch);
var_dump($result);
sleep(2);
$result = curl_exec ($ch);
var_dump($result);
sleep(2);

curl_setopt ($ch, CURLOPT_URL, $ARG_URL."/install.php?profile=default&locale=en&op=finished&id=1");
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_HTTPGET, 1);
curl_setopt ($ch, CURLOPT_POST, 0);
if ($ARG_DEBUG) {
  curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt ($ch, CURLOPT_HEADER, 1);
  curl_setopt ($ch, CURLOPT_VERBOSE, 1);
}
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARG_URL . "/install.php?profile=default&locale=en");
$result = curl_exec ($ch);
var_dump($result);
sleep(1);

$DATA = array(
        'site_name' => $ARG_TITLE, 'site_mail' => $ARG_EMAIL,
        'account[name]' => $ARG_NAME, 'account[mail]' => $ARG_EMAIL,
        'account[pass][pass1]' => $ARG_PASS, 'account[pass][pass2]' => $ARG_PASS,
        'date_default_timezone' => "50400", 'clean_url' => '1',
        'form_id' => 'install_configure_form', 'update_status_module[1]' => '1');
$POST_DATA=array();
foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);

$POST_HEADERS = array(
        'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);
curl_setopt ($ch, CURLOPT_URL, $ARG_URL."/install.php?locale=en&profile=default");
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_HTTPHEADER, $POST_HEADERS);

if ($ARG_DEBUG) {
  curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt ($ch, CURLOPT_HEADER, 1);
  curl_setopt ($ch, CURLOPT_VERBOSE, 1);
}

curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARG_URL . "/install.php?profile=default&locale=en");
curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_POST, 1);
$result = curl_exec ($ch);
var_dump($result);

curl_close($ch);

?>
