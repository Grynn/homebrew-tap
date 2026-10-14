class TuyaAc < Formula
  desc "Control a Daikin200 AC over LAN through a Tuya infrared hub"
  homepage "https://github.com/Grynn/tuya-ac"
  url "https://github.com/Grynn/tuya-ac/releases/download/v0.1.0/tuya-ac-0.1.0.tar.gz"
  sha256 "3d6560b03b186aa5631b7368bc0921a50eb67e34aec64227f9a643718f39bf62"
  license "MIT"

  depends_on :macos
  depends_on "python@3.13"
  depends_on "uv"

  def install
    libexec.install "ac.py", "daikin.py", "setup_keys.py", "daikin200-template.json",
                    "pyproject.toml", "uv.lock"
    ENV["UV_PYTHON_DOWNLOADS"] = "never"
    system "#{formula_opt_bin("uv")}/uv", "sync", "--frozen", "--no-dev",
           "--project", libexec, "--python", "#{formula_opt_bin("python@3.13")}/python3.13"
    (bin/"ac").write <<~SH
      #!/bin/sh
      exec "#{libexec}/.venv/bin/python" "#{libexec}/ac.py" "$@"
    SH
  end

  def caveats
    <<~EOS
      Retrieve your local key with Smart Life QR login, then configure the hub:
        ac login
        ac scan
        ac configure --device-id YOUR_HUB_ID --ip YOUR_LAN_IP
        ac check

      Control: ac on | ac off | ac temp 28
      Supports Daikin200 with Tuya 3.5 IR hubs using DPS 201/202.
      Keys are stored in macOS Keychain; configuration in ~/.config/tuya-ac.
      Setup guide: https://github.com/Grynn/tuya-ac#1-pair-the-hub-in-smart-life
    EOS
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/ac --version")
    ENV["AC_CONFIG_DIR"] = testpath/"config"
    system bin/"ac", "configure", "--device-id", "test-device", "--ip", "192.0.2.1"
    output = shell_output("#{bin}/ac temp 28 --dry-run")
    assert_match '"pulse_count": 408', output
    assert_match '"preset": "cool-28"', output
  end
end
