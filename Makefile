default:
	@ruby -r "`pwd`/Automation.rb" -e "Automation.new().perform()"

# See why we need this: https://stackoverflow.com/a/6273809/1418981
%:
	@ruby -r "`pwd`/Automation.rb" -e "Automation.new().perform()" $@