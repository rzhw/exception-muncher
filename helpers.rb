helpers do
  def logged_in?
    session[:authenticated]
  end

  def current_user
    logged_in? ? session[:authenticated] : nil
  end

  def ensure_logged_in
    redirect '/admin/login' if not logged_in?
  end

  def ensure_valid_exception
    @exception = ExceptionEntry.get params[:id]
    if @exception
      yield if block_given?
    else
      halt 404, 'Doesn\'t exist!'
    end
  end

  def no_users?
    User.count < 1
  end
end
