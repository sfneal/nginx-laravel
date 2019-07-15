import os
from argparse import ArgumentParser

from dirutility import SystemCommand


def main():
    # Declare argparse argument descriptions
    usage = 'AWS S3 command-line-interface wrapper.'
    description = 'Execute AWS S3 commands.'
    helpers = {
        'aws_s3': "Switch to enable/disabled AWS S3 actions.",
        'aws_s3_bucket': "Name of the AWS S3 bucket SSL certs are stored in.",
        'domain': "List of domain names separated by spaces.",
    }

    # construct the argument parse and parse the arguments
    parser = ArgumentParser(usage=usage, description=description)

    # Sync
    # parser.add_argument('--aws_s3', help=helpers['aws_s3'], type=int, default=0)
    # parser.add_argument('--aws_s3_bucket', help=helpers['aws_s3_bucket'], type=str)
    parser.add_argument('--domains', help=helpers['domain'], type=str)

    # Parse Arguments
    args = vars(parser.parse_args())
    args['domains'] = args['domains'].split(' ')

    # Run certify.sh for each domain
    for domain in args['domains']:
        SystemCommand('domain={0} sh /sites-scripts/certify.sh'.format(domain))


if __name__ == '__main__':
    main()
