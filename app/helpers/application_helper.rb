module ApplicationHelper
  def page_title
    if content_for?(:title)
      "#{content_for(:title)} | Flix  a better IMDB"
    else
      "Flix  a better IMDB"
    end
  end

  def title(title)
    content_for(:title, title)
  end
end
