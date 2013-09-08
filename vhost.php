<?php
fwrite(STDOUT, "Please input your domain name(eg. example.com): ");
$domain = trim(fgets(STDIN));

fwrite(STDOUT, "Please input more domain name(a.com b.com): ");
$ext_domain = trim(fgets(STDIN));

fwrite(STDOUT, "Is Phalcon project(Y/N, default is Y): ");
$x = trim(fgets(STDIN));

$isPhalcon = 'Y';
if($x == 'N') $isPhalcon = 'N';

fwrite(STDOUT, "Input rewrite file(supported wordpress,phalcon): ");
$rewrite = trim(fgets(STDIN));

if($rewrite != ''){
    $rewrite = 'include '.$rewrite.'.conf;';
}

$rootfolder = '/home/wwwroot/'.$domain.'/public';

if($isPhalcon != 'Y'){
    $rootfolder = '/home/wwwroot/'.$domain;
}else{
    shell_exec('mkdir /home/wwwroot/'.$domain);        
}

$template = <<<EOT
log_format  $domain  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
             '\$status \$body_bytes_sent "\$http_referer" '
             '"\$http_user_agent" \$http_x_forwarded_for';
server
        {
                listen       80;
                server_name $domain $ext_domain;
                index index.html index.htm index.php default.html default.htm default.php;
                root  $rootfolder;

                $rewrite

                include phpfastcgi.conf;

                include staticfile.conf;

                location ~ /\.ht {
                    deny all;
                }


                access_log  /home/wwwlogs/$domain.log  $domain;
        }
EOT;

$filename = '/etc/nginx/vhost/'.$domain.'.conf';
touch($filename);
file_put_contents($filename,$template);


shell_exec('mkdir '.$rootfolder);
shell_exec('mkdir /home/wwwlog/'.$domain);

shell_exec('chown -R www:www '.$rootfolder);
shell_exec('chown -R www:www /home/wwwlog/'.$domain);

//write test content
$content = <<<EOT
Welcom to $domain. You may delete this file and upload your own files.
EOT;

$cf = $rootfolder.'/index.php';
touch($cf);
file_put_contents($cf,$content);

shell_exec('service nginx restart');

fwrite(STDOUT, "conf file: /etc/nginx/vhost/{$domain}.conf\n");
fwrite(STDOUT, "wwwroot folder:{$rootfolder}\n");
fwrite(STDOUT, "now you can review test site: http://{$domain}/index.php\n");
