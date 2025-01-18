module News
extend RSpec::Matchers
$news_opinio_menu_item = "//a[text()='Opinión']"
$news_article_section_header = "(//section[@data-dtm-region='portada_apertura']//article/header/h2/a)[?]"
$news_article_section_content = "(//section[@data-dtm-region='portada_apertura']//article/p[1])[?]"
$news_article_section_cover_img = "(//section[@data-dtm-region='portada_apertura']//article)[?]/figure//img"
$news_site_cookie_accept_button = "//button[@id='didomi-notice-agree-button']"
#$news_site_cookie_accept_button = "//button[@id='didomi-notice-learn-more-button']"

	def self.verify_website_in_spanish
		sleep 5
		#com_wait_for_element $news_site_cookie_accept_button
		if element_present $news_site_cookie_accept_button
			return_element($news_site_cookie_accept_button).click
		end
		#expect(page).to have_text('España')
	end
	
	
	def self.open_opinion 
		return_element($news_opinio_menu_item).click
	end
	
	def self.get_articals no_of_artical
		for i in 1..no_of_artical 
			header = return_element($news_article_section_header.sub('?',i.to_s)).text
			content = return_element($news_article_section_content.sub('?',i.to_s)).text
			p "article header #{header}"
			p "article cover content #{content}"
			if element_present $news_article_section_cover_img.sub('?',i.to_s)
				cover_img = return_element $news_article_section_cover_img.sub('?',i.to_s)
				srcset_value = cover_img[:srcset]
				image_url = srcset_value.split(',').first.strip.split(' ').first
				p "article cover img #{image_url}"
				filename = "cover_img_from_news_#{i.to_s}"
				save_path = "images/#{filename}"
				FileUtils.mkdir_p('images')
				URI.open(image_url) do |image|
					File.open(save_path, 'wb') do |file|
						file.write(image.read)
					end
				end
			end		
		end
	end
	
	def self.translated_headers no_of_artical
		repeated_words = Hash.new
		words_array = Array.new
		for i in 1..no_of_artical 
			header = return_element($news_article_section_header.sub('?',i.to_s)).text
			puts "article Header in Spanish #{header}"
			api_key = 'AIzaSyAuildmLgzp8TwQExHlyHiOD7P-x_SljQQ'
			url = "https://translation.googleapis.com/language/translate/v2"
			payload = {
			  q: header,
			  target: 'en',
			  format: 'text'
			}
			response = RestClient.post(url, payload.merge({ key: api_key }))
			response_body = JSON.parse(response.body)
			translated_text = response_body["data"]["translations"][0]["translatedText"]
			puts "Translated Header in English: #{translated_text}"
			words = translated_text.downcase.gsub(/[^a-z0-9\s]/i, '').split
			words.each do |word|
				words_array.push(word)
			end
		end
		word_counts = words_array.each_with_object(Hash.new(0)) do |word, counts|
			counts[word] += 1
		end
		repeated_words = word_counts.select { |word, count| count > 1 }
		p "Repeated words from headers with count #{repeated_words}"
	end
	
end