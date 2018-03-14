module Admin::BaseHelper
  def navbar_menu(body, url)
    content_tag :li, role: "presentation", class: active_class(url) do
      link_to body, url
    end
  end
end
