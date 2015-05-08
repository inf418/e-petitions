Then(/^I should see the fieldset called "(.*?)" is (\d+)(?:st|nd|rd|th)$/) do |legend, position|
  expect(page).to have_xpath("//fieldset[#{position}]/legend[contains(., '#{legend}')]", visible: false)
end

Then /^I should (not |)see "([^\"]*)" in the ((?!email\b).*)$/ do |see_or_not, text, section_name|
  if section_name == 'browser page title'
    if see_or_not.blank?
      expect(page).to have_title(text.to_s)
    else
      expect(page).to have_no_title(text.to_s)
    end
  else
    within_section(section_name) do
      if see_or_not.blank?
        expect(page).to have_content(text.to_s)
      else
        expect(page).to have_no_content(text.to_s)
      end
    end
  end
end

### Fields...

Then /^"([^"]*)" should be selected for "([^"]*)"$/ do |value, field|
  expect(field_labeled(field).element.search(".//option[@selected = 'selected']").inner_html).to match(/#{value}/)
end

Then /^I should see an? "([^\"]*)" (\S+) field$/ do |name, type|
  field = find_field(name)
end

Then /^I should not see an? "([^\"]*)" (\S+) field$/ do |name, type|
  expect(page).not_to have_xpath(XPath::HTML.field(name).to_xpath)
end

Then /^I should see an? "([^\"]*)" select field with the following options:$/ do |name, options|
  expected_options = options.raw.flatten
  field = find_field(name)
  expect(field).not_to be_nil
  found_options = field.all('option').map(&:text)
  expect(found_options).to eq expected_options
end

Then /^I should see (\d+) dropdowns in the (.*)$/ do |count, section_name|
  within_section(section_name) do
    expect(page).to have_xpath(".//select", :count => count.to_i)
  end
end

Then /^the "([^\"]*)" select field should have "([^\"]*)" selected$/ do |label, value|
  expect(find_field(label).find('.//option[@selected]').text).to eq value
end

Then /^the "([^\"]*)" radio button should be selected$/ do |label|
  expect(find_field(label)['checked']).to be_truthy
end

Then /^the "([^"]*)" row should display as invalid$/ do |field_label|
  row_node = page.find("//label[.='#{field_label}']/ancestor::*[contains(@class, 'row')] | //*[contains(@class, 'label')][.='#{field_label}']/ancestor::*[contains(@class, 'row')]")
  expect(row_node["class"]).to include("invalid_row")
end

### Tables...

Then /^I should see the following admin index table:$/ do |values_table|
  actual_table = find(:css, 'table').all(:css, 'tr').map { |row| row.all(:css, 'th, td').map { |cell| cell.text.strip } }
  values_table.diff!(actual_table)
end

Then /^I should see the following search results table:$/ do |values_table|
  values_table.raw.each do |row|
    row.each do |column|
      expect(page).to have_content(column)
    end
  end
end

Then /^I should see the creation date of the petition$/ do
  expect(page).to have_css("th", :text => "Created")
end

Then /^I should not see the signature count or the closing date$/ do
  expect(page).to have_no_css("th", :text => "Signatures")
  expect(page).to have_no_css("th", :text => "Closing")
end

Then /^the row with the name "([^\"]*)" is not listed$/ do |name|
  expect(page.body).not_to match(/#{name}/)
end

Then /^I should see (\d+) rows? in the admin index table$/ do |number|
  expect(page).to have_xpath( "//table[@class='admin_index' and count(tr)=#{number.to_i + 1}]" )
end

Then /^I should see (\d+) petitions?$/ do |number|
  expect(page).to have_xpath( "//table/tbody[count(tr)=#{number.to_i}]" )
end

Then /^the "([^"]*)" tab should be active$/ do |tab_text|
  expect(page).to have_css("ul.tab_menu li.active a", :text => tab_text)
end

### Links

Then /^I should see a link called "([^\"]*)" linking to "([^\"]*)"$/ do |link_text, link_target|
  xpath = "//a[@href=\"#{link_target}\"][. = \"#{link_text}\"]"
  expect(page).to have_xpath( xpath )
end

Then /^"([^"]*)" should show as "([^"]*)"$/ do |node_text, node_class_name|
  expect(page).to have_xpath("//*[.='#{node_text}'][contains(@class, '#{node_class_name}')]")
end