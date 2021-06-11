# Ways to Encrypt Files

## Encrypt Files With Editors

For example, `vim -x`.

## Encrypt Files With Passwords

```bash
# Encrypt and Compress
tar -czvf - path/to/files | openssl des3 -salt -out path/to/file.tar.gz
# Extract and Decrypt
openssl des3 -d -salt -in path/to/file.tar.gz | tar xzf -
```

Or more commonly, use `zip`.

```bash
zip -e target.zip files
```

## [Encrypt Files With GPG](wiki/gpg-quick-start)

## Encrypt and Compress Files With GPG

```bash
# Encrypt and Compress
tar -czvf - path/to/files | gpg --encrypt --recipient [ID/name/mail] -o data.csv.gpg
# Extract and Decrypt
gpg --decrypt data.csv.gpg | tar xzf - -C path/to/dir
```
