#!/usr/bin/php
<?php

$ARG_DEBUG = true;

$ARGS=array();
$ARGS['title'] = "clodo joomla preset";
$ARGS['login'] = "admin";
$ARGS['pass'] = "admin";
$ARGS['email'] = "presets@clodo.ru";
$ARGS['domain'] = "http://".gethostbyaddr('127.0.0.1').".clodo.ru";
$ARGS['db_name'] = "joomla";
$ARGS['db_login'] = "joomla";
$ARGS['db_pass'] = "joomla";
$ARGS['db_port'] = "";
$ARGS['db_pref'] = "";
$ARGS['db_host'] = "localhost";
$ARGS['db_type'] = "mysqli";

foreach ($argv as $arg) {
  $parts = explode("=", $arg);
  if (is_array($parts) && isset($parts[0]) && isset($parts[1]) && $parts[1] != NULL && $parts[0] != NULL && preg_match('/администратора/', $parts[1]) == 0) $ARGS[$parts[0]] = $parts[1];
}

var_dump($ARGS);

$ARG_COOKIE = "cookie.txt";

$ch = curl_init();
curl_setopt ($ch, CURLOPT_URL, $ARGS['domain'] . "/installation/index.php");
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/installation/index.php");
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

curl_setopt ($ch, CURLOPT_URL, $ARGS['domain'] . "/installation/index.php");
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_HTTPHEADER, $POST_HEADERS);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/installation/index.php");
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

curl_setopt ($ch, CURLOPT_URL, $ARGS['domain']."/installation/index.php?view=license");
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
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/installation/index.php?view=language");
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

curl_setopt ($ch, CURLOPT_URL, $ARGS['domain']."/installation/index.php?view=database");
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
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/installation/index.php?view=license");
$result = curl_exec ($ch);
if ($ARG_DEBUG) var_dump($result);

$DATA = array(
        'task' => 'setup.database',
	$spoof[1] => '1',
	'jform[db_type]' => $ARGS['db_type'],
	'jform[db_host]' => $ARGS['db_host'],
	'jform[db_user]' => $ARGS['db_login'],
	'jform[db_pass]' => $ARGS['db_pass'],
	'jform[db_name]' => $ARGS['db_name'],
	'jform[db_prefix]' => substr(sha1($ARGS['db_pass']), 0, 4).'_',
	'jform[db_old]' => 'remove');

$POST_DATA = array();
foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);
$POST_HEADERS = array(
        'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);
curl_setopt ($ch, CURLOPT_URL, $ARGS['domain']."/installation/index.php?view=database");
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
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/installation/index.php?view=database");
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
curl_setopt ($ch, CURLOPT_URL, $ARGS['domain']."/installation/index.php?view=filesystem");
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
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/installation/index.php?view=filesystem");
$result = curl_exec ($ch);
if ($ARG_DEBUG) var_dump($result);


$DATA = array(
        'task' => 'setup.saveconfig',
        $spoof[1] => '1',
        'jform[site_name]' => $ARGS['title'],
        'jform[site_metadesc]' => '',
        'jform[site_metakeys]' => '',
        'jform[admin_email]' => $ARGS['email'],
        'jform[admin_user]' => $ARGS['login'],
        'jform[admin_password]' => $ARGS['pass'],
        'jform[admin_password2]' => $ARGS['pass'],
        'jform[sample_installed]' => 0);

$POST_DATA = array();
foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);
$POST_HEADERS = array(
        'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);
curl_setopt ($ch, CURLOPT_URL, $ARGS['domain']."/installation/index.php?view=site");
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
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/installation/index.php?view=site");
$result = curl_exec ($ch);
if ($ARG_DEBUG) var_dump($result);

curl_close($ch);

?>
