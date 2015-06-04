class ContactsController < ApplicationController
  skip_after_action :verify_authorized

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to root_path
      flash[:alert] = "Votre message a bien été envoyé à l'équipe TennisMatch, nous vous contacterons dans les plus brefs délais !"
    else
      render 'new'
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :object, :content)
  end

end
