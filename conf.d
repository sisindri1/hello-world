</IfModule>

<ifmodule mod_expires.c>
ExpiresActive On
ExpiresByType text/css "access plus 1 day"
ExpiresDefault "access plus 0 days"
</ifmodule>

LoadModule jk_module /etc/httpd/modules/mod_jk.so
#LoadModule unique_id_module /etc/httpd/modules/mod_unique_id.so
LoadModule security2_module /etc/httpd/modules/mod_security2.so
JKWorkersFile /etc/httpd/conf/workers.properties


<IfModule security2_module>
        Include /etc/httpd/crs/owasp-modsecurity-crs/crs-setup.conf
        Include /etc/httpd/crs/owasp-modsecurity-crs/rules/*.conf
</IfModule>


Include /etc/httpd/security/content-security-policy.conf
Include /etc/httpd/security/x-xss-protection.conf
Include /etc/httpd/security/x-content-type-option.conf
#Include /etc/httpd/security/x-frame-option.conf
Include /etc/httpd/security/x-powered-by.conf
Include /etc/httpd/security/server_software_information.conf
Include /etc/httpd/security/strict-transport-security.conf
Include /etc/httpd/security/file_access.conf

RewriteEngine On
RewriteCond %{THE_REQUEST} !HTTP/1.1$
RewriteRule .* - [F]

JkLogFile "logs/mod_jk.log"
JkLogLevel emerg
JkLogStampFormat "[%a %b %d %H:%M:%S %Y]"
JkOptions     +ForwardKeySize +ForwardURICompat -ForwardDirectories
JkRequestLogFormat     "%w %V %T"

JkMount /* tenderapp
JkMount /* auctionapp
#Add the status mount point
#JkMount /status stat
#JkMount /status/* jkstatus


<VirtualHost *:80>
        ServerName staging.tender.apeprocurement.gov.in
        ServerAlias www.staging.tender.apeprocurement.gov.in
        UseCanonicalName On
        ErrorLog logs/staging.tender.apeprocurement.gov.in-error_log
        CustomLog logs/staging.tender.apeprocurement.gov.in-access_log common
#       DocumentRoot /var/www/tender
#        Redirect "/" "https://staging.tender.apeprocurement.gov.in/"
##      Redirect "/" "https://10.10.15.15/"
        JkMount /* tenderapp

<Directory />
      Options Indexes FollowSymLinks
      AllowOverride All
      #Order allow,deny
      #Allow from all
      Require all granted
</Directory>
<Location /users/profile/edit/images>
        LimitRequestBody 5242880
</Location>
</VirtualHost>
<VirtualHost *:80>
        ServerName staging.konugolu.ap.gov.in
        ServerAlias www.staging.konugolu.ap.gov.in
        UseCanonicalName On
        ErrorLog logs/staging.konugolu.ap.gov.in-error_log
        CustomLog logs/staging.konugolu.ap.gov.in-access_log common
#       DocumentRoot /var/www/tender
#        Redirect "/" "https://staging.tender.apeprocurement.gov.in/"
##      Redirect "/" "https://10.10.15.15/"
        JkMount /* auctionapp

<Location /users/profile/edit/images>
        LimitRequestBody 5242880
</Location>
<Directory />
      Options Indexes FollowSymLinks
      AllowOverride All
      #Order allow,deny
      #Allow from all
      Require all granted
</Directory>
</VirtualHost>

<VirtualHost 127.0.0.1:80>
        #Add the status mount point
        JkMount /status stat
#       JkMount /status/* jkstatus
        #Enable the JK manager access from localhost only
        <Location /status>
          JkMount stat
          Order deny,allow
          Deny from all
          Allow from 127.0.0.1
        </Location>
</VirtualHost>

************************************************************
Instance 31 Application deployment is started.
Using CATALINA_BASE:   /usr/local/tomcatauc/inst31auc
Using CATALINA_HOME:   /trs/apache-tomcat-auc
Using CATALINA_TMPDIR: /usr/local/tomcatauc/inst31auc/temp
Using JRE_HOME:        /trs/jdk1.8.0_161_auc/
Using CLASSPATH:       /trs/apache-tomcat-auc/bin/bootstrap.jar:/trs/apache-tomcat-auc/bin/tomcat-juli.jar

***********************************************************************************
Worker.properties
----------------------------------------------------------
worker.list=tenderapp,auctionapp,stat

worker.inst1.type=ajp13
worker.inst1.port=8281
worker.inst1.host=10.96.34.31
worker.inst1.lbfactor=1

worker.inst2.type=ajp13
worker.inst2.port=8282
worker.inst2.host=10.96.34.31
worker.inst2.lbfactor=1

worker.inst3.type=ajp13
worker.inst3.port=8283
worker.inst3.host=10.96.34.31
worker.inst3.lbfactor=1

worker.inst4.type=ajp13
worker.inst4.port=8284
worker.inst4.host=10.96.34.31
worker.inst4.lbfactor=1

worker.inst5.type=ajp13
worker.inst5.port=8285
worker.inst5.host=10.96.34.31
worker.inst5.lbfactor=1

worker.inst1auc.type=ajp13
worker.inst1auc.port=7281
worker.inst1auc.host=10.96.34.31
worker.inst1auc.lbfactor=1

worker.inst2auc.type=ajp13
worker.inst2auc.port=7282
worker.inst2auc.host=10.96.34.31
worker.inst2auc.lbfactor=1

worker.inst2auc.type=ajp13
worker.inst2auc.port=7282
worker.inst2auc.host=10.96.34.31
worker.inst2auc.lbfactor=1

worker.inst3auc.type=ajp13
worker.inst3auc.port=7283
worker.inst3auc.host=10.96.34.31
worker.inst3auc.lbfactor=1

worker.inst4auc.type=ajp13
worker.inst4auc.port=7284
worker.inst4auc.host=10.96.34.31
worker.inst4auc.lbfactor=1

worker.inst5auc.type=ajp13
worker.inst5auc.port=7285
worker.inst5auc.host=10.96.34.31
worker.inst5auc.lbfactor=1


worker.tenderapp.type=lb
worker.tenderapp.balance_workers=inst1,inst2,inst3,inst4,inst5
worker.tenderapp.sticky_session=1

worker.auctionapp.type=lb
worker.auctionapp.balance_workers=inst1auc,inst2auc,inst3auc,inst4auc,inst5auc
worker.auctionapp.sticky_session=1

worker.stat.type=status

