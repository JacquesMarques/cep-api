class ZipAccessPresenter < BasePresenter
  build_with :id, :zipcode, :state, :city, :neighborhood, :street, :user_id,
             :created_at, :updated_at
  related_to :user
  sort_by    :id, :zipcode, :state, :city, :neighborhood, :street,
             :created_at, :updated_at
  filter_by  :id, :zipcode, :state, :city, :neighborhood, :street, :user_id,
             :created_at, :updated_at
end
