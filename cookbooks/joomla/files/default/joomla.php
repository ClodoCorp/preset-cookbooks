#!/usr/bin/php
<?php

$ARG_DEBUG = true;
$ARG_DB = "joomladb";
$ARG_DBUSER = "joomlauser";
$ARG_DBPASS = "test";
$ARG_DBHOST = "localhost";
$ARG_DBPORT = "";
$ARG_DBPREF = "";

$ARG_TITLE = "clodo joomla preset";

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

$ch = curl_init();
curl_setopt ($ch, CURLOPT_URL, $ARG_URL . "/installation/index.php");
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARG_URL . "/installation/index.php");
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$result = curl_exec ($ch);
if ($ARG_DEBUG) var_dump($result);
$spoof = array();
if (!preg_match('/name="([a-zA-z0-9]{32})"/', $result, $spoof)) {
  preg_match("/name='([a-zA-z0-9]{32})'/", $result, $spoof);
}
$DATA = array(
        'jform[language]' => 'ru-RU', 'task' => 'setup.setlanguage',
        $spoof[1] => '1');

foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);

$POST_HEADERS = array(
        'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);

curl_setopt ($ch, CURLOPT_URL, $ARG_URL . "/installation/index.php");
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_HTTPHEADER, $POST_HEADERS);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARG_URL . "/installation/index.php");
curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_POST, 1);
$result = curl_exec ($ch);
if ($ARG_DEBUG) var_dump($result);

$DATA = array(
        'task' => '',
        $spoof[1] => '1');
$POST_DATA = array();
foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);

$POST_HEADERS = array(
        'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);

curl_setopt ($ch, CURLOPT_URL, $ARG_URL."/installation/index.php?view=license");
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_HTTPHEADER, $POST_HEADERS);
curl_setopt ($ch, CURLOPT_POST, 1);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARG_URL . "/installation/index.php?view=language");
$result = curl_exec ($ch);
if ($ARG_DEBUG) var_dump($result);


$DATA = array(
        'task' => '',
        $spoof[1] => '1');
$POST_DATA = array();
foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);
$POST_HEADERS = array(
        'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);

curl_setopt ($ch, CURLOPT_URL, $ARG_URL."/installation/index.php?view=database");
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_POST, 1);
curl_setopt ($ch, CURLOPT_HTTPHEADER, $POST_HEADERS);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARG_URL . "/installation/index.php?view=license");
$result = curl_exec ($ch);
if ($ARG_DEBUG) var_dump($result);

$DATA = array(
        'task' => 'setup.database',
	$spoof[1] => '1',
	'jform[db_type]' => 'mysqli',
	'jform[db_host]' => 'localhost',
	'jform[db_user]' => $ARG_DBUSER,
	'jform[db_pass]' => $ARG_DBPASS,
	'jform[db_name]' => $ARG_DB,
	'jform[db_prefix]' => substr(sha1($ARG_DBPASS), 0, 4).'_',
	'jform[db_old]' => 'remove');

$POST_DATA = array();
foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);
$POST_HEADERS = array(
        'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);
curl_setopt ($ch, CURLOPT_URL, $ARG_URL."/installation/index.php?view=database");
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_VERBOSE, 1);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_HTTPHEADER, $POST_HEADERS);
curl_setopt ($ch, CURLOPT_POST, 1);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARG_URL . "/installation/index.php?view=database");
$result = curl_exec ($ch);
if ($ARG_DEBUG) var_dump($result);



$DATA = array(
        'task' => 'setup.filesystem',
        $spoof[1] => '1',
        'jform[ftp_enable]' => '0',
        'jform[ftp_user]' => '',
        'jform[ftp_pass]' => '',
        'jform[ftp_root]' => '',
        'jform[ftp_host]' => '127.0.0.1',
        'jform[ftp_port]' => '21',
        'jform[ftp_save]' => '0');

$POST_DATA = array();
foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);
$POST_HEADERS = array(
        'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);
curl_setopt ($ch, CURLOPT_URL, $ARG_URL."/installation/index.php?view=filesystem");
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_VERBOSE, 1);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_HTTPHEADER, $POST_HEADERS);
curl_setopt ($ch, CURLOPT_POST, 1);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARG_URL . "/installation/index.php?view=filesystem");
$result = curl_exec ($ch);
if ($ARG_DEBUG) var_dump($result);


$DATA = array(
        'task' => 'setup.saveconfig',
        $spoof[1] => '1',
        'jform[site_name]' => $ARG_TITLE,
        'jform[site_metadesc]' => '',
        'jform[site_metakeys]' => '',
        'jform[admin_email]' => $ARG_EMAIL,
        'jform[admin_user]' => $ARG_NAME,
        'jform[admin_password]' => $ARG_PASS,
        'jform[admin_password2]' => $ARG_PASS,
        'jform[sample_installed]' => 0);

$POST_DATA = array();
foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);
$POST_HEADERS = array(
        'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);
curl_setopt ($ch, CURLOPT_URL, $ARG_URL."/installation/index.php?view=site");
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_VERBOSE, 1);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_HTTPHEADER, $POST_HEADERS);
curl_setopt ($ch, CURLOPT_POST, 1);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARG_URL . "/installation/index.php?view=site");
$result = curl_exec ($ch);
if ($ARG_DEBUG) var_dump($result);

curl_close($ch);

?>
