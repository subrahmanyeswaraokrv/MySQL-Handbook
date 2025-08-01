# MySQL LDAP Authentication Integration

This project documents the process of integrating MySQL with an LDAP directory (such as Microsoft Active Directory or OpenLDAP) to enable LDAP-based user authentication.

## 📌 Requirements

- MySQL Server (Enterprise Edition recommended for native LDAP support)
- Access to an LDAP/Active Directory server
- Administrative access to MySQL
- (Optional) PAM module if using MySQL Community Edition

## 🛠️ Setup Guide

### 1. Enable LDAP Authentication Plugin (Enterprise Edition)
#*********************LDAP**********************
auth=true
setParameter=saslauthdPath=/var/run/saslauthd/mux
setParameter=authenticationMechanisms=PLAIN,SCRAM-SHA-1

```sql
INSTALL PLUGIN authentication_ldap_simple SONAME 'authentication_ldap_simple.so';
2. Configure LDAP Options in my.cnf

[mysqld]
authentication_ldap_simple_server_host = "ldap.example.com"
authentication_ldap_simple_bind_base_dn = "dc=example,dc=com"
authentication_ldap_simple_bind_root_dn = "cn=ldap_bind,dc=example,dc=com"
authentication_ldap_simple_bind_root_pwd = "yourpassword"
authentication_ldap_simple_tls = ON
3. Create MySQL Users with LDAP Authentication

CREATE USER 'john.doe'@'%' IDENTIFIED WITH authentication_ldap_simple AS 'uid=john.doe,ou=People,dc=example,dc=com';
GRANT SELECT, INSERT, UPDATE ON mydb.* TO 'john.doe'@'%';
4. Test Authentication
Try logging in with the LDAP user credentials:

mysql -u john.doe -p -h mysql.example.com
🔄 Alternative: Using PAM (For Community Edition)
Install the PAM plugin:

INSTALL PLUGIN authentication_pam SONAME 'authentication_pam.so';
Configure PAM module (/etc/pam.d/mysqld) to use pam_ldap or sssd.

Create MySQL proxy user:

CREATE USER 'ldap_proxy'@'%' IDENTIFIED WITH mysql_native_password BY 'StrongPassword';
GRANT ALL PRIVILEGES ON *.* TO 'ldap_proxy'@'%' WITH GRANT OPTION;

CREATE USER 'ldap_user'@'%' IDENTIFIED WITH authentication_pam AS 'mysql_ldap';
GRANT PROXY ON 'ldap_proxy'@'%' TO 'ldap_user'@'%';
🔐 Security Considerations
Always use TLS/SSL to protect credentials during LDAP communication.

Limit privileges of MySQL users authenticated via LDAP.

Rotate LDAP bind passwords and use strong authentication methods.

📚 References
MySQL LDAP Plugin Documentation

PAM Authentication Plugin

LDAP Tools: OpenLDAP, sssd, pam_ldap

🧑‍💻 Maintainer
Subrahmanyeswarao Karri
Database Architect | MySQL & MongoDB Expert
