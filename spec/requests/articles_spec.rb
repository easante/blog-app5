require 'rails_helper'

RSpec.describe "Articles", type: :request do

  before do
    @john = User.create(email: "john@example.com",
                        password: "password")
    @fred = User.create(email: "fred@example.com",
                        password: "password")
    @article = Article.create!(title: "Title one",
                              body: "Body of article one",
                              user: @john)
  end

  describe 'GET /articles/:id' do
    context 'with existing article' do
      before { get "/articles/#{@article.id}" }

      it "handles existing article" do
        expect(response.status).to eq 200
      end
    end

    context 'with non-existing article' do
      before { get "/articles/xxxxx" }

      it "handles non-existing article" do
        expect(response.status).to eq 302
        flash_message = "The article you are looking for could not be found"
        expect(flash[:alert]).to eq flash_message
      end
    end
  end

  describe 'GET /articles/:id/edit' do
    context 'with non-signed in user' do
      before { get "/articles/#{@article.id}/edit" }

      it "redirects to the signin page" do
        expect(response.status).to eq 302
        flash_message = "You need to sign in or sign up before continuing."
        expect(flash[:alert]).to eq flash_message
      end
    end

    context 'with signed in users who are non-owners' do
      before do
        login_as(@fred)
        get "/articles/#{@article.id}/edit"
      end

      it "redirects to the home page" do
        expect(response.status).to eq 302
        flash_message = "You can only edit your own article."
        expect(flash[:alert]).to eq flash_message
      end
    end

    context 'with signed in user as owner' do
      before do
        login_as(@john)
        get "/articles/#{@article.id}/edit"
      end

      it "successfully edits article" do
        expect(response.status).to eq 200
      end
    end
  end

  describe 'PUT /articles/:id' do
    context 'with non-signed in user' do
      before { put "/articles/#{@article.id}",
              params: { article: {title: "New Title", body: "New body"} } }

      it "redirects to the signin page" do
        expect(response.status).to eq 302
        flash_message = "You need to sign in or sign up before continuing."
        expect(flash[:alert]).to eq flash_message
      end
    end

    context 'with signed in users who are non-owners' do
      before do
        login_as(@fred)
        put "/articles/#{@article.id}",
                params: { article: {title: "New Title", body: "New body"} }
      end

      it "redirects to the home page" do
        expect(response.status).to eq 302
        flash_message = "You can only edit your own article."
        expect(flash[:alert]).to eq flash_message
      end
    end

    context 'with signed in user as owner' do
      before { login_as(@john) }

      it "successfully update article" do
        put "/articles/#{@article.id}",
                params: { article: {title: "New Title", body: "New body"} }

        expect(response.status).to eq 302
      end

      it "unsuccessful update" do
        put "/articles/#{@article.id}",
                params: { article: {title: "New Title", body: ""} }

        expect(flash[:alert]).to eq("Article has not been updated")
        expect(response.status).to eq 200
      end
    end
  end

end
