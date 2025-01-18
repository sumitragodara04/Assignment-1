def return_element obj_locator
	begin
		if (obj_locator.start_with?("//") or obj_locator.start_with?("./") or obj_locator.start_with?("(./") or obj_locator.start_with?("(/"))
			elementObj=find(:xpath, obj_locator)
			return elementObj
		elsif !(obj_locator.start_with?("//") or obj_locator.start_with?("./") or obj_locator.start_with?("(./") or obj_locator.start_with?("(/"))
			elementObj=find(obj_locator)
			return elementObj
		end
	rescue Exception => e
		raise e.message
	end
end

def element_present obj_locator
	begin
		return_element(obj_locator)
		return true
	rescue
		return false
	end
end

def com_scroll_till_element obj_locator
		element= return_element(obj_locator)
		execute_script("arguments[0].scrollIntoView(true)", element)
end

def com_wait_for_element obj_locator
		element= find(obj_locator,visible: true)
end