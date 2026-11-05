class S3mirror < Formula
  include Language::Python::Virtualenv

  desc "Mirror buckets and objects between S3-compatible endpoints"
  homepage "https://github.com/netspeedy/s3mirror"
  url "https://github.com/netspeedy/s3mirror/archive/refs/tags/v1.1.0.tar.gz"
  version "1.1.0"
  sha256 "8dc37d08c4701ac622885d07d092284de2ea9d7c2ee4a21bf5453dd3626848f0"
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
