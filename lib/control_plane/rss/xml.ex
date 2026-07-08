# RSS 2.0 Validation Criteria:
#
# Required structure:
#
# ```xml
#   <rss version="2.0">
#     <channel>
#       <title>Required</title>
#       <link>Required</link>
#       <description>Required</description>
#
#       <item>
#         <title>Optional but recommended</title>
#         <link>Optional but recommended</link>
#         <description>Optional but recommended</description>
#         <pubDate>RFC 822 format</pubDate>
#       </item>
#     </channel>
#   </rss>
# ```
#
# To validate in Elixir:
#
# 1. Check it's valid XML — use SweetXml or Floki
# 2. Check root element — must be <rss version="2.0">
# 3. Check <channel> exists with required fields
# 4. Check <item> elements exist (the actual content)
#
# Content-Type should be: application/rss+xml
defmodule ControlPlane.RSS.XML do
  import SweetXml

  require Logger

  def fetch(url) do
    normalized_url = normalize_url(url)
    Logger.info("[xml] fetching xml")

    case Req.get(normalized_url) do
      {:ok, req: %{status: 200, body: body}} ->
        # TODO: check content type header
        Logger.info("[xml] fetched xml")
        {:ok, body}

      {:ok, req: %{status: 404}} ->
        Logger.info("[xml] not found")
        {:error, :not_found}

      {:error, reason} ->
        Logger.info("[xml] failed to fetch: #{inspect(reason)}")
        {:error, reason}
    end
  end

  def valid_rss?(xml_string) do
    try do
      Logger.info("[xml] parse rss xml")

      doc = SweetXml.parse(xml_string)
      Logger.info("[xml] parsed xml", %{doc: doc})

      has_rss_root? = SweetXml.xpath(doc, ~x"//rss[@version='2.0']") != nil
      has_channel? = SweetXml.xpath(doc, ~x"//channel/title") != nil

      Logger.info("[xml] doc parsed, checking structure", %{
        root: has_rss_root?,
        channel: has_channel?
      })

      has_rss_root? and has_channel?
    catch
      :exit, error ->
        Logger.warning("[xml] failed to use sweet_xml: #{inspect(error)}")
        false
    end
  end

  defp normalize_url(url) do
    case url do
      "http" <> _ -> url
      _ -> "https://#{url}"
    end
  end
end
