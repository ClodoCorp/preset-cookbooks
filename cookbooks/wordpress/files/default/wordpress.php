#!/usr/bin/php
<?php


$ARG_DEBUG = false;

$ARGS=array();
$ARGS['title'] = "clodo wordpress preset";
$ARGS['login'] = "admin";
$ARGS['pass'] = "admin";
$ARGS['email'] = "presets@clodo.ru";
$ARGS['domain'] = "http://".gethostbyaddr('127.0.0.1').".clodo.ru";
$ARGS['db_name'] = "wordpress";
$ARGS['db_login'] = "wordpress";
$ARGS['db_pass'] = "wordpress";
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
	'weblog_title' => $ARGS['title'], 'user_name' => $ARGS['login'],
	'admin_password' => $ARGS['pass'], 'admin_password2' => $ARGS['pass'],
	'admin_email' => $ARGS['email'], 'blog_public' => 1, 'Submit' => 'Install WordPress');

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

