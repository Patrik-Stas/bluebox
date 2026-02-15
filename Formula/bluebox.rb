class Bluebox < Formula
  desc "Isolated Docker sandboxes for running Claude Code with skip-permissions"
  homepage "https://github.com/Patrik-Stas/bluebox"
  url "https://github.com/Patrik-Stas/bluebox/archive/refs/tags/v0.1.0.tar.gz"
  sha256 ""
  license "MIT"

  depends_on "docker" => :optional

  def install
    bin.install "bluebox"
    (share/"bluebox").install "Dockerfile.bluebox"
    (share/"bluebox").install "Dockerfile.bluebox-rust"
    (share/"bluebox").install "Dockerfile.bluebox-project"
  end

  def caveats
    <<~EOS
      Docker must be running to use bluebox.

      Quick start:
        bluebox build
        bluebox create my-project --mdboard 9001
        open http://localhost:9001
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/bluebox 2>&1", 1)
  end
end
