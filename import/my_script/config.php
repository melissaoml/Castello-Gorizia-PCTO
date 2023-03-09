<?php

$host = "localhost";   
$user = "enea";       
$password = "1234";      
$dbname = "import_test_beta";  

$con = mysqli_connect($host, $user, $password,$dbname);
// Check connection
if (!$con) {
 	die("Connection failed: " . mysqli_connect_error());
}