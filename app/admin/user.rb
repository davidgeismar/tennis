ActiveAdmin.register User do
  index do
      selectable_column
      column :id
      column :email
      column :telephone
      column :judge
      column :admin
      column :first_name
      column :last_name
      column :created_at
      actions
    end


  form do |f|
    f.inputs "Identity" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :telephone
      f.input :judge
      f.input :accepted
    end
    f.inputs "Admin" do
      f.input :admin
    end
    f.actions
  end

  permit_params :first_name, :last_name, :email, :admin, :telephone, :judge, :accepted
end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # en





