class S3mirror < Formula
  include Language::Python::Virtualenv

  desc "Mirror buckets and objects between S3-compatible endpoints"
  homepage "https://github.com/netspeedy/s3mirror"
  url "https://github.com/netspeedy/s3mirror/archive/6b251f2e110ac118904956b37b17f73883a9ac2d.tar.gz"
  version "1.0.0"
  sha256 "39324b9129c02d86b23e9e4d0a116091b0e35b979830f9cc2e35d04585081c2f"
  license "MIT"
  head "https://github.com/netspeedy/s3mirror.git", branch: "main"

  depends_on "python@3.14"

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install %w[
      six
      python-dateutil
      jmespath
      urllib3
      botocore
      s3transfer
      boto3
      PyYAML
    ]

    libexec.install "s3mirror.py" => "s3mirror"
    chmod 0755, libexec/"s3mirror"

    (bin/"s3mirror").write <<~SH
      #!/bin/sh
      exec "#{libexec}/bin/python" "#{libexec}/s3mirror" "$@"
    SH
  end

  test do
    assert_match "S3 Mirror v#{version}", shell_output("#{bin}/s3mirror --version")
  end
end
