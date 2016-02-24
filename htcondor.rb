class Htcondor < Formula
    desc "HTCondor workload management system"
    homepage "http://research.cs.wisc.edu/htcondor"
    url "http://download.pegasus.isi.edu/condor/condor-8.4.4-x86_64_MacOSX7-stripped.tar.gz"
    version "8.4.4"
    sha256 "24b992bc569b6ef5674798f70e23b78361c42a60bd42aa292ec002d922c0e113"

    devel do
        url "http://download.pegasus.isi.edu/condor/condor-8.5.2-x86_64_MacOSX-stripped.tar.gz"
        sha256 "60d70cac5463c90762fffc359727bc2671105ba52aec4a55da2b0414e25c67cc"
        version "8.5.2"
    end

    def localdir
        var/"condor"
    end

    def install
        system "./condor_install", "--prefix=#{prefix}", "--make-personal-condor", "--local-dir=#{localdir}"
        (localdir/"config").mkpath
    end

    test do
        system "condor_version"
    end

    def caveats
        s = <<-EOS.undent
        HTCondor is installed with local dir set to #{localdir}. Local configuration
        changes should go in #{localdir}/condor_config.local or #{localdir}/config/.

        EOS
        if File.exist? "/etc/condor_config" or File.exist? "/etc/condor/condor_config"
            s += <<-EOS.undent
            An '/etc/condor_config' or '/etc/condor/condor_config' from another install may
            interfere with a Homebrew-installed HTCondor.

            EOS
        end
        s += <<-EOS.undent
        The easiest way to manage the HTCondor service is to use Homebrew services:

        $ brew tap homebrew/services
        $ brew services list
        $ brew services start htcondor
        $ brew services stop htcondor

        Or you can use the complicated approach below.
        EOS
        s
    end

    def plist; <<-EOS.undent
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
            <dict>
                <key>Label</key>
                <string>#{plist_name}</string>
                <key>ProgramArguments</key>
                <array>
                    <string>#{opt_sbin}/condor_master</string>
                    <string>-f</string>
                    <string>-c</string>
                    <string>#{etc}/condor_config</string>
                </array>
                <key>RunAtLoad</key>
                <true/>
                <key>KeepAlive</key>
                <true/>
                <key>WorkingDirectory</key>
                <string>#{localdir}</string>
            </dict>
        </plist>
        EOS
    end
end
