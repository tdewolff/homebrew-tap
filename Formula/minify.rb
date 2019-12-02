class Minify < Formula
  desc "Minifier CLI for HTML, CSS, JS, JSON, SVG and XML"
  homepage "https://github.com/tdewolff/minify"
  url "https://github.com/tdewolff/minify/archive/v2.6.1.tar.gz"
  sha256 "a8e59212186d2790575de2c91ba718ca0394f19399205ee85df39f2626a2f69d"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/tdewolff/minify").install buildpath.children

    cd "src/github.com/tdewolff/minify/cmd/minify" do
      # Build minify binary
      system "go", "build", "-o", bin/"minify"

      # Build bash completion
      bash_completion.install "minify_bash_tab_completion"
    end
  end

  test do
    (testpath/"test.html").write "<p class='test'> Text </p>"
    system bin/"minify", "-o", "test.min.html", "test.html"
    assert_predicate testpath/"test.min.html", :exist?
    assert_match "<p class=test>Text", (testpath/"test.min.html").read
  end
end
