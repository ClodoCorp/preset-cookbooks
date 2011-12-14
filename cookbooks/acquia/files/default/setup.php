#!/usr/bin/php
<?php

$ARG_DEBUG = false;

$ARGS=array();
$ARGS['title'] = "clodo acquia preset";
$ARGS['login'] = "admin";
$ARGS['pass'] = "admin";
$ARGS['email'] = "presets@clodo.ru";
$ARGS['domain'] = "http://".gethostbyaddr('127.0.0.1').".clodo.ru";
$ARGS['db_name'] = "acquia";
$ARGS['db_login'] = "acquia";
$ARGS['db_pass'] = "acquia";
$ARGS['db_port'] = "";
$ARGS['db_pref'] = "acquia_";
$ARGS['db_host'] = "localhost";
$ARGS['db_type'] = "mysqli";

foreach ($argv as $arg) {
  $parts = explode("=", $arg);
  if (is_array($parts) && isset($parts[0]) && isset($parts[1]) && $parts[1] != NULL && $parts[0] != NULL && preg_match('/администратора/', $parts[1]) == 0) $ARGS[$parts[0]] = $parts[1];
}

var_dump($ARGS);

$ARG_COOKIE = "cookie.txt";

$POST_DATA=array();
$DATA = array(
	'driver' => 'mysql',
	'mysql[database]' => $ARGS['db_name'],
	'mysql[username]' => $ARGS['db_login'], 'mysql[password]' => $ARGS['db_pass'],
	'mysql[host]' => $ARGS['db_host'], 'mysql[port]' => $ARGS['db_port'],
	'mysql[db_prefix]' => $ARGS['db_pref'], 'op' => 'Save and continue',
	'form_id' => 'install_settings_form');

foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);

$POST_HEADERS = array(
	'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);
$ch = curl_init();
curl_setopt ($ch, CURLOPT_URL, $ARGS['domain'] . "/install.php?profile=acquia&locale=en");
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/install.php?profile=acquia&locale=en");
curl_setopt ($ch, CURLOPT_HTTPHEADER, $POST_HEADERS);
if ($ARG_DEBUG) {
  curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt ($ch, CURLOPT_HEADER, 1);
  curl_setopt ($ch, CURLOPT_VERBOSE, 1);
}
curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_POST, 1);
$result = curl_exec ($ch);
sleep(2);

curl_setopt ($ch, CURLOPT_URL, $ARGS['domain'] . "/install.php?locale=en&profile=acquia&op=start&id=1");
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
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/install.php?profile=acquia&locale=en");
$result = curl_exec ($ch);
sleep(2);
$result = curl_exec ($ch);
sleep(2);

$POST_DATA=array();
$DATA = array(
        'site_name' => $ARGS['title'], 'site_mail' => $ARGS['email'], 'account[name]' => $ARGS['login'],
        'account[mail]' => $ARGS['email'], 'account[pass][pass1]' => $ARGS['pass'],
        'account[pass][pass2]' => $ARGS['pass'], 'site_default_country' => 'RU',
	'date_default_timezone' => 'Europe/Moscow', 'op' => 'Save and continue',
	'update_status_module[1]' => '1', 'update_status_module[2]' => '2',
	'clean_url' => '1', 'form_id' => 'install_configure_form');

foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);

$POST_HEADERS = array(
        'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);
$ch = curl_init();
curl_setopt ($ch, CURLOPT_URL, $ARGS['domain'] . "/install.php?profile=acquia&locale=en");
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 120);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/install.php?profile=acquia&locale=en");
curl_setopt ($ch, CURLOPT_HTTPHEADER, $POST_HEADERS);
if ($ARG_DEBUG) {
  curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt ($ch, CURLOPT_HEADER, 1);
  curl_setopt ($ch, CURLOPT_VERBOSE, 1);
}
curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_POST, 1);

$result = curl_exec ($ch);

var_dump($result);

curl_close($ch);

?>
