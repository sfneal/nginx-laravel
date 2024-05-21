#!/usr/bin/env bash

domain_current=${1}
max_attempts=6
attempts=1

if echo ${domain_current} | grep -q "localhost" ; then
    echo "Skipping cert pull for domain ${domain_current} because it is for a localhost"
else
    echo "Pulling SSL certs for domain ${domain_current}"
    if [[ ${aws_s3} -ne 0 ]] && [[ ${aws_s3_download} -ne 0 ]]; then
        # Pull certs from AWS S3
        # if the certs don't exist, dummy certs should remain?
        awss3 download --bucket ${aws_s3_bucket} \
            --local_path /etc/letsencrypt/archive/${domain_current} \
            --remote_path archive/${domain_current} \
            --recursive

        # Ensure that certs have been pulled and exist
        until [[ -f /etc/letsencrypt/renewal/${domain_current}.conf ]] || [[ ${attempts} -eq ${max_attempts} ]]; do
            echo "Cert download attempt #$(( attempts++ ))..."
            # Pull certs from AWS S3
            # if the certs don't exist, dummy certs should remain?
            awss3 download --bucket ${aws_s3_bucket} \
                --local_path /etc/letsencrypt/archive/${domain_current} \
                --remote_path archive/${domain_current} \
                --recursive
            awss3 download --bucket ${aws_s3_bucket} \
                --local_path /etc/letsencrypt/renewal/${domain_current}.conf \
                --remote_path renewal/${domain_current}.conf
        done

        # Fix symbolic links between 'live' and 'archive' files
        # Find each file ending with '.pem' in the live directory
        # Relink live => archive
        cert_names="cert chain fullchain privkey"
        for pem in ${cert_names}; do
            # Create live and archive file names
            live_file=/etc/letsencrypt/live/${domain_current}/${pem}.pem
            archive_file=/etc/letsencrypt/archive/${domain_current}/${pem}1.pem

            # Delete existing symbolic link file
            if [[ -f ${live_file} ]]; then
                rm -rf ${live_file}
                echo "    Deleted: ${live_file}"
            fi

            # Link archive file to live file
            if [[ -f ${archive_file} ]]; then
                ln -s ${archive_file} ${live_file}
                echo "    Link: ${archive_file} => ${live_file}"
            fi
        done
    else
        echo "AWS disabled... skipping existing SSL certs download"
    fi
fi