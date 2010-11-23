Given /^the following (.+) records:$/ do |factory, table|
  table.hashes.each do |hash|
    Factory( factory, hash )
  end
end

Then /^I should see the following text in order:$/ do |table|
  page.body.should match( Regexp.new( table.hashes.collect { |hash| hash["text"] }.join( "(.*)" ), Regexp::MULTILINE ) )
end

