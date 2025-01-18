describe "Test News Outlet for Assignment" do
  it "Visit the website and get the article " do
		data = DATA_HELPER.read_test_data
		visit data["Site URL"]
		News.verify_website_in_spanish
		News.open_opinion
		News.get_articals 5
		News.translated_headers 5
  end
end