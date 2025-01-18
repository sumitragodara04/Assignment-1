module DATA_HELPER
  def DATA_HELPER.read_test_data
    
    driver_file = '.\data_source\test_data.xls'

    Spreadsheet.open driver_file do |book|
      @test_data_sheet = book.worksheet 0
    end

    headers = Hash.new
    @test_data_sheet.row(0).each_with_index do |header, i|
      headers[i] = header
    end
    @data = Hash.new
	@test_data_sheet.row(1).each_with_index do |row, i|
      @data[headers[i]] = row
    end

    return @data
  end
end