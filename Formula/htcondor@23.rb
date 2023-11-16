class HtcondorAT23 < Formula
  desc "Workload management system"
  homepage "http://research.cs.wisc.edu/htcondor"

  stable do
    url "https://download.pegasus.isi.edu/condor/condor-23.1.0-x86_64_macOS13-stripped.tar.gz"
    version "23.1.0"
    sha256 "d66d6567c856bcc7bd7e5ea09754dfefe4632fbc981bce2aaa457362e689e467"
  end

  def install
    Pathname.new(prefix).mkpath

    pwd = Dir.pwd
    system "cp -a ./ #{prefix}"
    Dir.chdir(prefix)
    system "bin/make-personal-from-tarball"
  end

  # Required as brew removes the log, spool, and execute directories created by
  # the make-personal-from-tarball script in the cleanup phase as they are empty
  def post_install
    system "mkdir -p #{prefix}/local/{log,spool,execute}"
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
              <key>WorkingDirectory</key>
              <string>#{prefix}</string>
              <key>EnvironmentVariables</key>
              <dict>
                <key>CONDOR_CONFIG</key>
                <string>#{prefix}/etc/condor_config</string>
              </dict>
              <key>ProgramArguments</key>
              <array>
                  <string>#{opt_sbin}/condor_master</string>
                  <string>-f</string>
              </array>
              <key>RunAtLoad</key>
              <true/>
              <key>KeepAlive</key>
              <true/>
          </dict>
      </plist>
    EOS
  end

  test do
    system "condor_version"
  end

  def caveats
    s = <<~EOS
      HTCondor is installed with local dir set to #{prefix}. Local configuration
      changes should go in #{prefix}/etc/condor_config or #{prefix}/local/config.d/.

    EOS

    if File.exist?("/etc/condor_config") || File.exist?("/etc/condor/condor_config")
      s += <<~EOS
        An '/etc/condor_config' or '/etc/condor/condor_config' from another install may
        interfere with a Homebrew-installed HTCondor.

      EOS
    end

    s += <<~EOS
      To manage the HTCondor service use Homebrew services:

        brew tap homebrew/services
        brew services list
        brew services start #{name}
        brew services stop #{name}

      You’ll need to run the following command now, and every time you log in:

        source #{prefix}/condor.sh
    EOS
    s
  end
end
