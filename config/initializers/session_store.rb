ActionController::Base.session = {
  :key => '_yourflightlog_session',
  :secret      => '22ee4fe1729aaf98e2c040be1429583c0cfa437a6c616fdc3227807acf664f67d4241dc98b9f0b9ae9ff11e9c76b0a624f63bb6a299c6a501a1190e8f1240fa5w'
}

#ActionController::Dispatcher.middleware.insert_before(ActionController::Session::CookieStore, FlashSessionCookieMiddleware, ActionController::Base.session_options[:key])
#ActionController::Dispatcher.middleware.insert_before(ActiveRecord::SessionStore, FlashSessionCookieMiddleware, ActionController::Base.session_options[:key])
#ActionController::Dispatcher.middleware.use(FlashSessionCookieMiddleware, ActionController::Base.session_options[:key])
ActionController::Dispatcher.middleware.insert_before(ActionController::Base.session_store, FlashSessionCookieMiddleware, ActionController::Base.session_options[:key])
