class Pegasus < Formula
    desc "Pegasus Workflow Management System"
    homepage "https://pegasus.isi.edu"
    url "http://download.pegasus.isi.edu/pegasus/4.6.0/pegasus-binary-4.6.0-x86_64_macos_10.tar.gz"
    version "4.6.0"
    sha256 "8fd3cb8e70257ed8185f51f4b2e2c1ac2096d8bd8fcf3b5744478a7395b580c7"

    bottle :unneeded

    def install
        bin.install Dir["bin/*"]
        share.install "share/pegasus"
        lib.install "lib/pegasus"
        man1.install Dir["share/man/man1/*.1"]
        doc.install Dir["share/doc/pegasus/*"]
    end

    test do
        system "#{bin}/pegasus-version"
    end
end
