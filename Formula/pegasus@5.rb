class PegasusAT5 < Formula
    desc "Pegasus Workflow Management System"
    homepage "https://pegasus.isi.edu"

    stable do
        url "https://download.pegasus.isi.edu/pegasus/5.0.0/pegasus-5.0.0.tar.gz"
        version "5.0.0"
        sha256 "ea2c44472cbe5c464b2787c36618ac2abf9ebc1a5eae8ec3c49d1f33812dd054"
    end

    head do
        url "https://github.com/pegasus-isi/pegasus.git", :using => :git, :branch => '5.0'
        version "5.0.1dev"
    end

    # This check was causing a warning due to the stdlib mismatch with htcondor,
    # but that doesn't matter for pegasus<->htcondor interaction
    cxxstdlib_check :skip

    option "with-docs", "Install documentation"
    option "without-manpages", "Install without manpages"
    option "with-mysql", "Install MySQL support"
    option "with-postgresql", "Install PostgreSQL support"
    option "with-r-api", "Install R DAX API"

    depends_on :openjdk
    depends_on "ant" => :build
    depends_on "openssl"
    if build.with?("manpages") or build.with?("docs")
        depends_on "tox" => :build
    end
    if build.with?("mysql")
        depends_on "mysql"
    end
    if build.with?("postgresql")
        depends_on "postgresql"
    end
    if build.with?("r-api")
        depends_on "r"
    end

    def install
        command = ["ant", "clean"]

        if build.with?("docs")
            command << "dist-release"
        else
            command << "dist-common"
        end
        if build.with?("manpages")
            command << "doc-user-guide"
        end
        if not build.with?("r-api")
            ENV["PEGASUS_BUILD_R_MODULES"] = "0"
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
        <<~EOS
        In order to run workflows you will also need to install HTCondor. You
        can either do this manually, or you can install the htcondor formula.
        EOS
    end

    test do
        system "pegasus-version"
    end
end
