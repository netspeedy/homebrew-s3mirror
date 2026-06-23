class S3mirror < Formula
  include Language::Python::Virtualenv

  desc "Mirror buckets and objects between S3-compatible endpoints"
  homepage "https://github.com/netspeedy/s3mirror"
  url "https://github.com/netspeedy/s3mirror/archive/refs/tags/v1.0.1.tar.gz"
  version "1.0.1"
  sha256 "b0299d640f944c291a3df3efbafd1da9cf7f7f8c9e82d693ad9e6ac25feffa35"
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
