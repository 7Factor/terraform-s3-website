require 'awspec'
require 'hcl/checker'

TFVARS = HCL::Checker.parse(File.open('testing.tfvars').read())

describe s3_bucket(TFVARS['primary_fqdn']) do
  it { should exist }

  its(:acl_grants_count) { should eq 2 }

  its(:acl_owner) {
    should eq 'aws-dev'
  }

  it {
    should have_acl_grant(grantee: 'aws-dev', permission: 'FULL_CONTROL')
  }

  it {
    should have_cors_rule(
        allowed_headers: ['*'],
        allowed_methods: ['GET', 'HEAD'],
        allowed_origins: TFVARS['origins'],
        expose_headers: TFVARS['cors_expose_headers'] || [],
        max_age_seconds: TFVARS['cors_max_age_seconds'] || 3000
    )
  }
  
  it {
    should have_policy <<-POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E2FGOA1GNVRXQH"
                },
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::#{TFVARS['primary_fqdn']}/*"
            },
            {
                "Sid": "",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E2FGOA1GNVRXQH"
                },
                "Action": "s3:ListBucket",
                "Resource": "arn:aws:s3:::#{TFVARS['primary_fqdn']}"
            }
        ]
    }
    POLICY
  }
end
