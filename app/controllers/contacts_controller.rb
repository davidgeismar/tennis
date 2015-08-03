class ContactsController < ApplicationController
  skip_after_action :verify_authorized
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      ContactMailer.send_message_to_wetennis(@contact).deliver
      ContactMailer.confirmation_email(@contact).deliver

      flash[:notice] = "Votre message a bien été envoyé à l'équipe WeTennis, nous vous contacterons dans les plus brefs délais !"

      redirect_to root_path

        # me = Trello::Member.find("david_geismar")

      # # find first board
      # board = me.boards.first
      # puts board.name
      # # puts "Lists: #{board.lists.map {|x| x.name}.join(', ')}"
      # # puts "Members: #{board.members.map {|x| x.full_name}.join(', ')}"
      # board.cards.each do |card|
      #       puts "fu"
            # puts "-- Actions: #{card.actions.nil? ? 0 : card.actions.count}"
            # puts "-- Members: #{card.members.count}"
            # puts "-- Labels: #{card.labels.count}"
      # end
    else
      render 'new'
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :object, :content)
  end

end
