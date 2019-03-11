// skin name: folder from skins/
$config['skin'] = 'larry';
$config['db_dsnw'] = 'mysql://roundcube:roundpasswd@172.17.0.5/roundcubedb';
#$config['default_host'] = '127.0.0.1';
$config['smtp_server'] = 'tls://127.0.0.1';
$config['smtp_user'] = '%u';
$config['smtp_pass'] = '%p';

#$config['default_host'] = 'tls://%n';
#$config['default_host'] = 'tls://127.0.0.1';
$config['default_host'] = 'abetobing.com:9143';

$config['imap_conn_options'] = array(
        'ssl' => array(
                'verify_peer' => false,
                'verfify_peer_name' => false,
        ),
);

$config['smtp_conn_options'] = array(
        'ssl' => array(
                'verify_peer' => false,
                'verify_peer_name' => false,
        ),
);
