require_relative "../require/macfuse"

class Ntfs3gMac < Formula
  desc "Read-write NTFS driver for FUSE"
  homepage "https://www.tuxera.com/community/open-source-ntfs-3g/"
  stable do
    url "https://tuxera.com/opensource/ntfs-3g_ntfsprogs-2017.3.23.tgz"
    sha256 "3e5a021d7b761261836dcb305370af299793eedbded731df3d6943802e1262d5"

    # Fails to build on Xcode 9+. Fixed upstream in a0bc659c7ff0205cfa2b2fc3429ee4d944e1bcc3
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/3933b61bbae505fa95a24f8d7681a9c5fa26dbc2/ntfs-3g/lowntfs-3g.c.patch"
      sha256 "749653cfdfe128b9499f02625e893c710e2167eb93e7b117e33cfa468659f697"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/ntfs-3g-mac-2017.3.23"
    sha256 cellar: :any, big_sur:  "ae4e130ad74b8e15f707f7da0412c8b4f9cbfc06273cebeeb2e644612b62312f"
    sha256 cellar: :any, catalina: "31dd08813e3f473a64b53b3a6f209dc28026fe76b9245621cbfab2c818feadbb"
    sha256 cellar: :any, mojave:   "7af07f1515a0be2c53d46e639204c7e6fe04231de6f62e719b830a38a29bbd13"
  end

  head do
    url "https://git.code.sf.net/p/ntfs-3g/ntfs-3g.git", branch: "edge"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libgcrypt" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "coreutils" => :test
  depends_on "gettext"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    ENV.append "LDFLAGS", "-lintl"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --exec-prefix=#{prefix}
      --mandir=#{man}
      --with-fuse=external
      --enable-extras
    ]

    system "./autogen.sh" if build.head?
    # Workaround for hardcoded /sbin in ntfsprogs
    inreplace "ntfsprogs/Makefile.in", "/sbin", sbin
    system "./configure", *args
    system "make"
    system "make", "install"

    # Install a script that can be used to enable automount
    File.open("#{sbin}/mount_ntfs", File::CREAT|File::TRUNC|File::RDWR, 0755) do |f|
      f.puts <<~EOS
        #!/bin/bash

        VOLUME_NAME="${@:$#}"
        VOLUME_NAME=${VOLUME_NAME#/Volumes/}
        USER_ID=#{Process.uid}
        GROUP_ID=#{Process.gid}

        if [ "$(/usr/bin/stat -f %u /dev/console)" -ne 0 ]; then
          USER_ID=$(/usr/bin/stat -f %u /dev/console)
          GROUP_ID=$(/usr/bin/stat -f %g /dev/console)
        fi

        #{opt_bin}/ntfs-3g \\
          -o volname="${VOLUME_NAME}" \\
          -o local \\
          -o negative_vncache \\
          -o auto_xattr \\
          -o auto_cache \\
          -o noatime \\
          -o windows_names \\
          -o streams_interface=openxattr \\
          -o inherit \\
          -o uid="$USER_ID" \\
          -o gid="$GROUP_ID" \\
          -o allow_other \\
          -o big_writes \\
          "$@" >> /var/log/mount-ntfs-3g.log 2>&1

        exit $?;
      EOS
    end
  end

  test do
    # create a small raw image, format and check it
    ntfs_raw = testpath/"ntfs.raw"
    system Formula["coreutils"].libexec/"gnubin/truncate", "--size=10M", ntfs_raw
    ntfs_label_input = "Homebrew"
    system sbin/"mkntfs", "--force", "--fast", "--label", ntfs_label_input, ntfs_raw
    system bin/"ntfsfix", "--no-action", ntfs_raw
    ntfs_label_output = shell_output("#{sbin}/ntfslabel #{ntfs_raw}")
    assert_match ntfs_label_input, ntfs_label_output
  end
end
