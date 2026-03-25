class Minify < Formula
  desc "Minifier CLI for HTML, CSS, JS, JSON, SVG and XML"
  homepage "https://github.com/tdewolff/minify"
  url "https://github.com/tdewolff/minify/archive/v2.24.11.tar.gz"
  sha256 "f43c2ec205d395483d3e731f13da01cb12003ca583030c349b3b6dcfd75615c9"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/tdewolff/minify").install buildpath.children

    cd "src/github.com/tdewolff/minify/cmd/minify" do
      # Build minify binary
      system "go", "build", "-o", bin/"minify"

      # Build bash completion
      bash_completion.install "bash_completion"
    end
  end

  test do
    (testpath/"test.html").write "<p class='test'> Text </p>"
    system bin/"minify", "-o", "test.min.html", "test.html"
    assert_predicate testpath/"test.min.html", :exist?
    assert_match "<p class=test>Text", (testpath/"test.min.html").read
  end
end
