# AccessTokenPresenter class
class AccessTokenPresenter < BasePresenter
  build_with    :id, :token, :user_id,
                :accessed_at, :created_at, :updated_at
  related_to    :user
  sort_by       :id, :user_id, :accessed_at,
                :created_at, :updated_at
  filter_by     :id, :user_id, :accessed_at,
                :created_at, :updated_at

  def token
    @options[:token]
  end
end
