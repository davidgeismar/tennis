module TextMessages
  module Convocations
    class CreateTextMessageService
      def initialize(convocation)
        @convocation  = convocation
        @judge        = convocation.subscription.tournament.user
      end

      def call
        begin
          client  = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN'])
          message = case @convocation.status
          when 'pending'
            "Vous etes convoqué(e) #{@convocation.date.strftime("le %d/%m/%Y")} #{@convocation.hour.strftime(" à %Hh%M")} pour le tournoi #{@convocation.subscription.tournament.name} dans la catégorie #{@convocation.subscription.competition.category}. Num JA: #{@convocation.subscription.tournament.user.telephone} Connectez vous sur www.wetennis.fr (onglet 'Mes Tournois') pour répondre à cette convocation."
          when 'confirmed_by_judge'
            "Le juge-arbitre ne peut pas vous proposer un autre créneau pour votre convocation #{@convocation.date.strftime("le %d/%m/%Y")} #{@convocation.hour.strftime(" à %Hh%M")} pour le tournoi #{@convocation.subscription.tournament.name} dans la catégorie #{@convocation.subscription.competition.category}. Num JA: #{@convocation.subscription.tournament.user.telephone}. Si vous ne pouvez pas participer connectez vous sur www.wetennis.fr (onglet 'Mes Tournois') pour indiquer votre WO."
          end

          # Create and send an SMS message
          client.account.messages.create(
            from: ENV['TWILIO_FROM'],
            to:   @convocation.subscription.user.telephone,
            body: message
          )

          # Judge loses 1 sms
          @judge.sms_quantity -= 1
          @judge.save
        rescue Twilio::REST::RequestError
          # on error, sms won't be sent.. deal
        end
      end

      def new_proposition
        begin
          client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN'])
          # Create and send an SMS message
          client.account.messages.create(
            from: ENV['TWILIO_FROM'],
            to:   @convocation.subscription.user.telephone,
            body: "Le juge-arbitre vous propose une nouvelle convocation #{@convocation.date.strftime("le %d/%m/%Y")} #{@convocation.hour.strftime(" à %Hh%M")} pour le tournoi #{@convocation.subscription.tournament.name} dans la catégorie #{@convocation.subscription.competition.category}. Num JA: #{@convocation.subscription.tournament.user.telephone} Connectez vous sur www.wetennis.fr (onglet 'Mes Tournois') pour répondre à cette convocation. "
          )
          @judge.sms_quantity -= 1
          @judge.save
        rescue Twilio::REST::RequestError
          # on error, sms won't be sent.. deal
        end
      end
    end
  end
end

