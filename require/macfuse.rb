# frozen_string_literal: true

class MacfuseRequirement < Requirement
  fatal true

  satisfy(build_env: false) { self.class.binary_osxfuse_installed? }

  def self.binary_osxfuse_installed?
    File.exist?("/usr/local/include/fuse.h") &&
      !File.symlink?("/usr/local/include")
  end

  env do
    ENV.append_path "PKG_CONFIG_PATH", HOMEBREW_LIBRARY/"Homebrew/os/mac/pkgconfig/fuse"
  end

  def message
    "This formula requires MacFUSE. Please run `brew install --cask macfuse` first."
  end
end

class Formula

  def setup_fuse
    unless HOMEBREW_PREFIX.to_s == "/usr/local"
      odebug "Setting up FUSE temp environment under #{buildpath}/temp"
      mkdir buildpath/"temp/include" do
        Dir["/usr/local/include/fuse*"].each { |f| cp_r f, "." }
      end
      mkdir buildpath/"temp/lib" do
        Dir["/usr/local/lib/*fuse*"].each { |f| cp_r f, "." }
      end
      Dir.glob(buildpath/"temp/**/*.*").each { |f| odebug ">>> #{f}" }
      ENV.append "CFLAGS", "-I#{buildpath}/temp/include"
      ENV.append "CFLAGS", "-I#{buildpath}/temp/include/fuse"
      ENV.append "CPPFLAGS", "-I#{buildpath}/temp/include"
      ENV.append "CPPFLAGS", "-I#{buildpath}/temp/include/fuse"
      ENV.append "LDFLAGS", "-I#{buildpath}/temp/lib"
    end
  end

end
