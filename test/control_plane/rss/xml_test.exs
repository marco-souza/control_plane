defmodule ControlPlane.RSS.XMLTest do
  use ExUnit.Case, async: true

  alias ControlPlane.RSS.XML

  describe "valid_rss?/1" do
    test "returns true for a valid RSS XML" do
      xml = "<rss version='2.0'><channel><title>title</title></channel></rss>"

      assert XML.valid_rss?(xml) == true
    end

    test "returns false for a invalid RSS XML" do
      invalid_rss_xml = "<html><body>Not RSS</body></html>"
      assert XML.valid_rss?(invalid_rss_xml) == false
    end

    test "returns false for empty string" do
      assert ControlPlane.RSS.XML.valid_rss?("") == false
    end

    test "returns false for malformed RSS" do
      xml = "rss><channel></channel></rss>"
      assert ControlPlane.RSS.XML.valid_rss?(xml) == false
    end
  end
end
