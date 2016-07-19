require "rails_helper"

RSpec.feature "Showing an Article" do

  before do
    john = User.create(email: "john@example.com",
                       password: "password")

    login_as(john)

    @article = Article.create(title: "The first article",
                body: "Lorem ipsum dolor sit amet.",
                user: john)
  end

  scenario "Clicking on an article title shows article details" do
    visit "/"

    click_link @article.title

    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))
  end
end
