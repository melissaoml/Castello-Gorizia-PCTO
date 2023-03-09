<!doctype html>
<html>
    <head>
        <title>Test beta importazione</title>
        <link rel="stylesheet" href="style.css">

        <?php
        include "config.php";

        if(isset($_POST['but_import'])){
            $target_dir = "uploads/";
            $target_file = $target_dir . basename($_FILES["importfile"]["name"]);

            $imageFileType = pathinfo($target_file,PATHINFO_EXTENSION);

            $uploadOk = 1;
            if($imageFileType != "csv" ) {
                $uploadOk = 0;
            }

            if ($uploadOk != 0) {
                if (move_uploaded_file($_FILES["importfile"]["tmp_name"], $target_dir.'importfile.csv')) {

                    // Checking file exists or not
                    $target_file = $target_dir . 'importfile.csv';
                    $fileexists = 0;
                    if (file_exists($target_file)) {
                        $fileexists = 1;
                    }
                    if ($fileexists == 1 ) {

                        // Reading file
                        $file = fopen($target_file,"r");
                        $i = 0;

                        $importData_arr = array();
                       

                        while (($data = fgetcsv($file, 1000, ";")) !== FALSE) {
                            $num = count($data);

                            for ($c=0; $c < $num; $c++) {
                                $importData_arr[$i][] = mysqli_real_escape_string($con,$data[$c]);
                            }
                            $i++;
                        }
                        fclose($file);

                        $skip = 0;
                        // insert import data
                        foreach($importData_arr as $data){
                            if($skip != 0){
                                $username = $data[0];
                                $fname = $data[1];
                                $lname = $data[2];
                                $email = $data[3];

                                // Checking duplicate entry
                                $sql = "select count(*) as allcount from user where username='" . $username . "' and fname='" . $fname . "' and  lname='" . $lname . "' and email='" . $email . "' ";
                                
                                

                                //change value data
                                if($sql){
                                    $update = "UPDATE $sql WHERE id=$targetID";
                                }


                                $retrieve_data = mysqli_query($con,$sql);
                                $row = mysqli_fetch_array($retrieve_data);
                                $count = $row['allcount'];

                                if($count == 0){
                                    // Insert record
                                    $insert_query = "insert into user(username,fname,lname,email) values('".$username."','".$fname."','".$lname."','".$email."')";
                                    mysqli_query($con,$insert_query);
                                }
                                
                            }
                            $skip ++;
                        }

                        $newtargetfile = $target_file;
                        if (file_exists($newtargetfile)) {
                            unlink($newtargetfile);
                        }
                    }
                }
            }
        }
        ?>
    </head>
    <body>
        <header>
            <nav>
                <a href="import_example.csv" target="_blank" class="menu-link">Scarica un CSV unico</a>
            </nav>
        </header>
    <div class="popup_import">
        <form method="post" action="" enctype="multipart/form-data" id="import_form" style="border: none;">
        <center>
            <table width="100%" class="tableViewLoader">
                <tr>
                    <td id="tdLoader">
                        <input type='file' name="importfile" id="importfile" multiple="true">
                        <input type="submit" id="but_import" name="but_import" value="Import">    
                    </td>
                </tr>
            </table>
        </center>
        </form>
    </div>
    <center>
        <table id="userTable" class="table">
            <tr>
                <td class="heading">ID visuale</td>
                <td class="heading">Username</td>
                <td class="heading">Nome</td> 
                <td class="heading">Cognome</td>
                <td class="heading">Email</td>
                <td class="heading">ID effettivo</td>
                <td class="heading">Last update</td>
            </tr>

            <?php
                $sql = "select * from user order by id desc limit 10";
                $sno = 1;
                $retrieve_data = mysqli_query($con,$sql);
                while($row = mysqli_fetch_array($retrieve_data)){
                    $id = $row['id'];
                    $username = $row['username'];
                    $fname = $row['fname'];
                    $lname = $row['lname'];
                    $email = $row['email'];
                    $idefettivo = $row['id'];
                    $timestampValue = $row['last_update'];

                    echo "<tr class='tableRow'>
                        <td>".$sno."</td>
                        <td>".$username."</td>
                        <td>".$fname."</td>
                        <td>".$lname."</td>
                        <td>".$email."</td>
                        <td>".$id."</td>
                        <td>".$timestampValue."</td>
                    </tr>";
                    $sno++;
                }
            ?>
            </table>
    </center>
    </body>
</html>