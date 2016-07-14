require "rails_helper"

RSpec.feature "Deleting an Article" do

  before do
    @article = Article.create(title: "The first article",
                body: "Lorem ipsum dolor sit amet, consectetur.")
  end

  scenario "with correct id" do
    visit "/"

    click_link @article.title
    click_link "Delete Article"

    expect(page).to have_content("Article has been deleted")
    expect(current_path).to eq(articles_path)
  end
 
end
