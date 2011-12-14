#!/usr/bin/php
<?php


$ARG_DEBUG = false;

$ARGS=array();
$ARGS['title'] = "clodo livestreet preset";
$ARGS['login'] = "admin";
$ARGS['pass'] = "admin";
$ARGS['email'] = "presets@clodo.ru";
$ARGS['domain'] = "http://".gethostbyaddr('127.0.0.1').".clodo.ru";
$ARGS['db_name'] = "livestreet";
$ARGS['db_login'] = "livestreet";
$ARGS['db_pass'] = "livestreet";
$ARGS['db_port'] = "";
$ARGS['db_pref'] = "prefix_";
$ARGS['db_host'] = "localhost";
$ARGS['db_type'] = "mysql";

foreach ($argv as $arg) {
  $parts = explode("=", $arg);
  if (is_array($parts) && isset($parts[0]) && isset($parts[1]) && $parts[1] != NULL && $parts[0] != NULL && preg_match('/администратора/', $parts[1]) == 0) $ARGS[$parts[0]] = $parts[1];
}

var_dump($ARGS);


$ARG_COOKIE = "cookie.txt";

$ch = curl_init();
curl_setopt ($ch, CURLOPT_URL, $ARGS['domain'] . "/install/?lang=russian");
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 60);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "");
$result = curl_exec ($ch);


$POST_DATA=array();
$DATA = array(
        'install_env_params' => 1,
        'install_step_next' => 'дальше');

foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);

$POST_HEADERS = array(
        'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);
curl_setopt ($ch, CURLOPT_URL, $ARGS['domain'] . "/install/?lang=russian");
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 60);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_HTTPHEADER, $POST_HEADERS);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $ARG_COOKIE);
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/install/?lang=russian");
curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_POST, 1);
$result = curl_exec ($ch);


$POST_DATA=array();
$DATA = array(
	'install_db_params' => 1, 'install_db_server' => $ARGS['db_host'],
	'install_db_port' => $ARGS['db_port'], 'install_db_name' => $ARGS['db_name'],
	'install_db_create' => 0, 'install_db_convert' => 0, 
	'install_db_convert_from_05' => 0, 'install_db_user' => $ARGS['db_login'],
	'install_db_password' => $ARGS['db_pass'], 
	'install_db_prefix' => $ARGS['db_pref'], 'install_db_engine' => 'InnoDB',
	'install_step_next' => 'Дальше');

foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);

$POST_HEADERS = array(
	'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);

curl_setopt ($ch, CURLOPT_URL, $ARGS['domain'] . "/install/?lang=russian");
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
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/install/?lang=russian");

curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_POST, 1);
$result = curl_exec ($ch);

$POST_DATA=array();
$DATA = array(
        'install_admin_params' => 1, 'install_admin_login' => $ARGS['login'],
        'install_admin_mail' => $ARGS['email'], 'install_admin_pass' => $ARGS['pass'],
        'install_admin_repass' => $ARGS['pass'],
        'install_step_next' => 'Дальше');

foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);

$POST_HEADERS = array(
        'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);

curl_setopt ($ch, CURLOPT_URL, $ARGS['domain'] . "/install/?lang=russian");
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
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/install/?lang=russian");

curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_POST, 1);
$result = curl_exec ($ch);

/*
$POST_DATA=array();
$DATA = array(
        'install_step_extend' => 'Расширенный режим',
        'install_step_next' => 'Дальше');

foreach($DATA as $KEY => $VALUE) {
  $POST_DATA[] = $KEY."=".urlencode($VALUE);
}
$POST_DATA = implode("&", $POST_DATA);
$POST_LEN = strlen($POST_DATA);

$POST_HEADERS = array(
        'Content-type: application/x-www-form-urlencoded', 'Content-length: '.$POST_LEN);

curl_setopt ($ch, CURLOPT_URL, $ARGS['domain'] . "/install/?lang=russian");
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
curl_setopt ($ch, CURLOPT_REFERER, $ARGS['domain'] . "/install/?lang=russian");

curl_setopt ($ch, CURLOPT_POSTFIELDS, $POST_DATA);
curl_setopt ($ch, CURLOPT_POST, 1);
$result = curl_exec ($ch);

*/

curl_close($ch);



?>

