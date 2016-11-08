class Pegasus < Formula
    desc "Pegasus Workflow Management System"
    homepage "http://pegasus.isi.edu"
    url "http://download.pegasus.isi.edu/pegasus/4.7.1/pegasus-source-4.7.1.tar.gz" 
    version "4.7.1"
    sha256 "f5468c80765ffc7a9d8b947e64b18f20b62b71282dc1efd66404c3eb85d50c10"
    head "http://github.com/pegasus-isi/pegasus.git"

    devel do
        url "https://github.com/pegasus-isi/pegasus.git", :using => :git, :branch => '4.7'
        version "4.7.2dev"
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
