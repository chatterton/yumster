module LocationsHelper
  def http_referer_uri
    request.env["HTTP_REFERER"] && URI.parse(request.env["HTTP_REFERER"])
  end

  def refered_from_our_site?
    if uri = http_referer_uri
      uri.host == request.host
    end
  end

  def refered_from_a_search?
    if refered_from_our_site?
      http_referer_uri.path =~ /locations\/near/
    end
  end
end
