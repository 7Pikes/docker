## vsftpd FTP service for Docker with virtual hosts & SQL authentication

### General

Content is served under `/srv/ftp`. Each folder under `/srv/ftp` should be equal to the name of virtual user.
Each virtual user will be chrooted to her folder (except for admins, those root is `/srv/ftp`).

User credentials are searched in `ftp_users` table, `login` and `password` fields. The encryption algorithm is `crypt` for MySQL
and `crypt_md5` for Postgres. Use `PASSWORD()` function for MySQL and `crypt(password, gen_salt('md5'))` for Postgres.

### Environment variables

- **DB_TYPE**: the database type you're using, can be `mysql` or `pgsql`
- **DB_USER**: username vsftpd will use to access your database
- **DB_PASS**: database password
- **DB_HOST**: database host or IP address
- **DB_NAME**: name of the database
- **FTP_ADMINS** (*optional*): colon separated list of admins (users able to see all other users' folders)

### Volumes & ports

Port 21 and Volume `/srv/ftp` are exported. The dir is chowned (not recursively) to ftp user each time the container starts.
This is userful in case you want to map it to host dir.

### Notes

You may want to insert these kernel modules on the host to ensure passive mode working:

- `nf_conntrack_ftp`
- `nf_nat_ftp`
