class Htcondor < Formula
  desc "Workload management system"
  homepage "http://research.cs.wisc.edu/htcondor"

  stable do
    url "http://download.pegasus.isi.edu/condor/condor-8.8.12-x86_64_MacOSX-stripped.tar.gz"
    version "8.8.12"
    sha256 "eab69cf3c19b79cabc53e69f86b68ca02032426b1bad668b219048c3fc434c85"
  end

  head do
    url "http://download.pegasus.isi.edu/condor/condor-8.9.1-x86_64_MacOSX-stripped.tar.gz"
    sha256 "2255387863256149312e0157fffe6919c3296b3a3b6818d000500770cd512976"
    version "8.9.1"
  end

  def localdir
    var/"condor"
  end

  def install
    localdir.mkpath
    system "./condor_install", "--prefix=#{prefix}", "--make-personal-condor", "--local-dir=#{localdir}"
    (localdir/"config").mkpath
    man1.install Dir["man/man1/*"]
  end

  def plist
    <<~EOS
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

  test do
    system "condor_version"
  end

  def caveats
    s = <<~EOS
      HTCondor is installed with local dir set to #{localdir}. Local configuration
      changes should go in #{localdir}/condor_config.local or #{localdir}/config/.

    EOS
    if File.exist?("/etc/condor_config") || File.exist?("/etc/condor/condor_config")
      s += <<~EOS
        An '/etc/condor_config' or '/etc/condor/condor_config' from another install may
        interfere with a Homebrew-installed HTCondor.

      EOS
    end
    s += <<~EOS
      The easiest way to manage the HTCondor service is to use Homebrew services:

      $ brew tap homebrew/services
      $ brew services list
      $ brew services start htcondor
      $ brew services stop htcondor

      Or you can use the complicated approach below.
    EOS
    s
  end
end
