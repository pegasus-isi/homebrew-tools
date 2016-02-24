class Pegasus < Formula
    desc "Pegasus Workflow Management System"
    homepage "http://pegasus.isi.edu"
    url "http://download.pegasus.isi.edu/pegasus/4.6.0/pegasus-source-4.6.0.tar.gz"
    version "4.6.0"
    sha256 "9fc0cf5bf1cbbd6d5dca8fcb517db6d6770943deddc8ffdbb1bdb6eba038ad24"
    head "http://github.com/pegasus-isi/pegasus.git"

    devel do
        url "https://github.com/pegasus-isi/pegasus.git", :using => :git, :branch => '4.6'
        version "4.6.1dev"
    end

    option "with-docs", "Install documentation"
    option "with-mysql", "Install MySQL support"
    option "with-postgresql", "Install PostgreSQL support"

    depends_on "htcondor"
    depends_on :java
    depends_on "ant" => :build
    depends_on "asciidoc" => :build
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
        if build.with?("docs")
            system "ant", "dist-release"
        else
            system "ant", "dist-common", "doc-manpages"
        end
        ver = `./release-tools/getversion`.strip
        cd "dist/pegasus-#{ver}" do
            bin.install Dir["bin/*"]
            share.install "share/pegasus"
            lib.install "lib/pegasus"
            man1.install Dir["share/man/man1/*.1"]
            if build.with?("docs")
                doc.install Dir["share/doc/pegasus/*"]
            end
        end
    end

    test do
        system "pegasus-version"
    end
end
