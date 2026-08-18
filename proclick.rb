class Proclick < Formula
  include Language::Python::Virtualenv

  desc "Configure a Razer Pro Click Mini from macOS - no Synapse needed"
  homepage "https://github.com/Grynn/proclick"
  url "https://files.pythonhosted.org/packages/c1/00/246bcdf0e341dd3b3d191d82cda8dbb7fcbaeec07369cf3d0859c49d5785/proclick-0.1.0.tar.gz"
  sha256 "3e6ff55f43aba10f940d4ec413910bc23927743860b19efc0a56d1523c82279d"
  license "GPL-2.0-or-later"

  depends_on "hidapi"
  depends_on "python@3.13"
  depends_on :macos

  resource "hid" do
    url "https://files.pythonhosted.org/packages/e9/f8/0357a8aa8874a243e96d08a8568efaf7478293e1a3441ddca18039b690c1/hid-1.0.9.tar.gz"
    sha256 "f4471f11f0e176d1b0cb1b243e55498cc90347a3aede735655304395694ac182"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage", shell_output("#{bin}/proclick --help")
  end
end
