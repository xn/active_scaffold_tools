# Make sure that ActiveScaffold has already been included
ActiveScaffold rescue throw "should have included ActiveScaffold plug in first.  Please make sure that this overwrite plugging comes alphabetically after the ActiveScaffold plug in"

##
## Initialize the environment
##
require File.dirname(__FILE__) + '/environment'

##
## Run the install script, too, just to make sure
##
require File.dirname(__FILE__) + '/install'
