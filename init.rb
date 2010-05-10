# Make sure that ActiveScaffold has already been included require File.dirname(__FILE__) + '/active_scaffold/config/core'
ActiveScaffold rescue throw "should have included ActiveScaffold plug in first.  Please make sure that this overwrite plugging comes alphabetically after the ActiveScaffold plug in"

require "#{File.dirname __FILE__}/lib/active_scaffold/config/core"
require "#{File.dirname __FILE__}/lib/active_scaffold/config/print_list"
require "#{File.dirname __FILE__}/lib/active_scaffold/config/revision"
require "#{File.dirname __FILE__}/lib/active_scaffold/actions/print_list"
require "#{File.dirname __FILE__}/lib/active_scaffold/actions/revision"




require "#{File.dirname __FILE__}/lib/active_scaffold/helpers/form_column_helpers_override"
require "#{File.dirname __FILE__}/lib/active_scaffold/helpers/view_helpers_override"
require "#{File.dirname(__FILE__)}/lib/active_scaffold/helpers/print_list_helpers.rb"

##
## Run the install script, too, just to make sure
## But at least rescue the action in production
##
begin
  require File.dirname(__FILE__) + '/install'
rescue
  raise $! unless RAILS_ENV == 'production'
end

# Register our helper methods
ActionView::Base.send(:include, ActiveScaffold::Helpers::PrintListHelpers)
