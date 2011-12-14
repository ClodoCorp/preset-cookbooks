#!/usr/bin/php
<?php

$ARG_DEBUG = false;

$ARGS=array();
$ARGS['title'] = "clodo drupal preset";
$ARGS['login'] = "admin";
$ARGS['pass'] = "admin";
$ARGS['email'] = "presets@clodo.ru";
$ARGS['domain'] = "http://".gethostbyaddr('127.0.0.1').".clodo.ru";
$ARGS['db_name'] = "drupal";
$ARGS['db_login'] = "drupal";
$ARGS['db_pass'] = "drupal";
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

$DATA = array(
	'db_type' => $ARGS['db_type'], 'db_path' => $ARGS['db_name'],
	'db_user' => $ARGS['db_login'], 'db_pass' => $ARGS['db_pass'],
	'db_host' => $ARGS['db_host'], 'db_port' => $ARGS['db_port'],
	'db_prefix' => $ARGS['db_pref'], 'op' => 'Save and continue',
	'form_id' => 'install_settings_form');

foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);

$POST_HEADERS = array(
	'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);


$ch = curl_init();
curl_setopt ($ch, CURLOPT_URL, $ARGS['domain'] . "/install.php?locale=en&profile=default");
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/install.php?profile=default&locale=en");
$result = curl_exec ($ch);
sleep(2);

curl_setopt ($ch, CURLOPT_URL, $ARGS['domain'] . "/install.php?locale=en&profile=default&op=start&id=1");
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
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/install.php?profile=default&locale=en");
curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_POST, 1);
$result = curl_exec ($ch);
sleep(2);

curl_setopt ($ch, CURLOPT_URL, $ARGS['domain']."/install.php?profile=default&locale=en&op=do_nojs&id=1");
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
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/install.php?profile=default&locale=en");
$result = curl_exec ($ch);
sleep(2);
$result = curl_exec ($ch);
sleep(2);
$result = curl_exec ($ch);
sleep(2);

curl_setopt ($ch, CURLOPT_URL, $ARGS['domain']."/install.php?profile=default&locale=en&op=finished&id=1");
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
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/install.php?profile=default&locale=en");
$result = curl_exec ($ch);
sleep(1);

$DATA = array(
        'site_name' => $ARGS['title'], 'site_mail' => $ARGS['email'],
        'account[name]' => $ARGS['login'], 'account[mail]' => $ARGS['email'],
        'account[pass][pass1]' => $ARGS['pass'], 'account[pass][pass2]' => $ARGS['pass'],
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
curl_setopt ($ch, CURLOPT_URL, $ARGS['domain']."/install.php?locale=en&profile=default");
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
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/install.php?profile=default&locale=en");
curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_POST, 1);
$result = curl_exec ($ch);

curl_close($ch);

?>
