#!/bin/bash

[[ -n "$DB_USER" ]] || exit 1
[[ -n "$DB_PASS" ]] || exit 1
[[ -n "$DB_HOST" ]] || exit 1
[[ -n "$DB_NAME" ]] || exit 1

case "$DB_TYPE" in
	mysql)
		cat > /etc/pam.d/vsftpd.virtual << EOF
auth required pam_mysql.so user=$DB_USER passwd=$DB_PASS host=$DB_HOST db=$DB_NAME table=ftp_users usercolumn=login passwdcolumn=password crypt=2
account required pam_mysql.so user=$DB_USER passwd=$DB_PASS host=$DB_HOST db=$DB_NAME table=ftp_users usercolumn=login passwdcolumn=password crypt=2
EOF
		chmod 600 /etc/pam.d/vsftpd.virtual
		;;

	pgsql)
		cat > /etc/pam.d/vsftpd.virtual << EOF
auth required pam_pgsql.so
account required pam_pgsql.so
EOF
		cat > /etc/pam_pgsql.conf << EOF
user = $DB_USER
password = $DB_PASS
host = $DB_HOST
database = $DB_NAME
table = ftp_users
user_column = login
pwd_column = password
pw_type = crypt_md5
EOF
		chmod 600 /etc/pam_pgsql.conf
		;;

	*)
		exit 1
		;;
esac

if [[ -n "$FTP_ADMINS" ]]; then
	IFS=':' read -r -a admins <<< "$FTP_ADMINS"
	for user in "${admins[@]}"; do
		echo "local_root=/srv/ftp" > /etc/vsftpd.conf.d/"$user"
	done
fi

chown ftp /srv/ftp
exec /runsvinit
