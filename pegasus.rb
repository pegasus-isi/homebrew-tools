class Pegasus < Formula
    desc "Pegasus Workflow Management System"
    homepage "http://pegasus.isi.edu"
    url "http://download.pegasus.isi.edu/pegasus/4.7.2/pegasus-source-4.7.2.tar.gz" 
    version "4.7.2"
    sha256 "99cc528cd093f4bf7dd6833d2d72cac46bf04ea534dce62d7ab02a79ea1c383a"
    head "http://github.com/pegasus-isi/pegasus.git"

    devel do
        url "https://github.com/pegasus-isi/pegasus.git", :using => :git, :branch => '4.7'
        version "4.7.3dev"
    end

    # This check was causing a warning due to the stdlib mismatch with htcondor,
    # but that doesn't matter for pegasus<->htcondor interaction
    cxxstdlib_check :skip

    option "with-docs", "Install documentation"
    option "without-manpages", "Install without manpages"
    option "with-mysql", "Install MySQL support"
    option "with-postgresql", "Install PostgreSQL support"

    depends_on :java
    depends_on "ant" => :build
    depends_on "openssl"
    if build.with?("manpages") or build.with?("docs")
        depends_on "asciidoc" => :build
    end
    if build.with?("docs")
        depends_on "fop" => :build
    end
    if build.with?("mysql")
        depends_on "mysql"
    end
    if build.with?("postgresql")
        depends_on "postgresql"
    end

    def install
        command = ["ant", "clean"]
        if build.with?("docs")
            command << "dist-release"
        else
            command << "dist-common"
        end
        if build.with?("manpages")
            command << "doc-manpages"
        end
        system *command
        ver = `./release-tools/getversion`.strip
        cd "dist/pegasus-#{ver}" do
            bin.install Dir["bin/*"]
            share.install "share/pegasus"
            lib.install "lib/pegasus"
            if build.with?("manpages")
                man1.install Dir["share/man/man1/*.1"]
            end
            if build.with?("docs")
                doc.install Dir["share/doc/pegasus/*"]
            end
        end
    end

    def caveats
        <<-EOS.undent
        In order to run workflows you will also need to install HTCondor. You
        can either do this manually, or you can install the htcondor formula.
        EOS
    end

    test do
        system "pegasus-version"
    end
end
