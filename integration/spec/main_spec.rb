require 'awspec'

describe s3_bucket('s3-web-test.7fdev.io') do
  it { should exist }
end
