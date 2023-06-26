class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.19.2/php-cs-fixer.phar"
  sha256 "3daebb8e4dee758f4795f3a3569f5ff3e00b4efa3b8fc15e9c426e8880be755a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5832cd9420486927342e19d81279754336cac2a51e774a487008a45b6306aa07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5832cd9420486927342e19d81279754336cac2a51e774a487008a45b6306aa07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5832cd9420486927342e19d81279754336cac2a51e774a487008a45b6306aa07"
    sha256 cellar: :any_skip_relocation, ventura:        "5832cd9420486927342e19d81279754336cac2a51e774a487008a45b6306aa07"
    sha256 cellar: :any_skip_relocation, monterey:       "5832cd9420486927342e19d81279754336cac2a51e774a487008a45b6306aa07"
    sha256 cellar: :any_skip_relocation, big_sur:        "5832cd9420486927342e19d81279754336cac2a51e774a487008a45b6306aa07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8dd03d760b2bc0fa6dc662d8d8ffb8a195db0a83a541be395f0f5a638f44d84"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    EOS
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
