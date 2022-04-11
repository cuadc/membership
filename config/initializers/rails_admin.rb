RailsAdmin.config do |config|
  config.asset_source = :webpacker
  config.main_app_name = ["CUADC Membership System", "Sysop Interface"]
  config.parent_controller = 'ApplicationController'
  config.current_user_method(&:current_user)
  config.show_gravatar = false

  config.authenticate_with do
    unless current_user.sysop?
      redirect_to main_app.root_path
    end
  end

  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version'
  # excluded_models = []
  # audited_models = []

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
