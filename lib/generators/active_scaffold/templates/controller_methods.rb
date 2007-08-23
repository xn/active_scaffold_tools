class <%= controller_class_name %>Controller < ApplicationController
	<%= template_for_inclusion %>

<% for action in unscaffolded_actions -%>
  def <%= action %><%= suffix %>
  end

<% end -%>
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy<%= suffix %>, :create<%= suffix %>, :update<%= suffix %> ],
         :redirect_to => { :action => :list<%= suffix %> }

  protected
  
   def do_add_existing<%= suffix %>
     # Put your code here.
     super
   end

  def do_create<%= suffix %>
    # Put your code here.
    super
  end

  def do_destroy<%= suffix %>
    # Put your code here.
    super
  end

  def do_destroy_existing<%= suffix %>
    # Put your code here.
    super
  end

  def do_edit<%= suffix %>
    # Put your code here.
    super
  end

  def do_nested<%= suffix %>
    # Put your code here.
    super
  end

  def do_new<%= suffix %>
    # Put your code here.
    super
  end

  def do_show<%= suffix %>
    # Put your code here.
    super
  end

  def do_update
    # Put your code here.
    super
  end

end
