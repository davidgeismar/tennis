module TextMessages
  module Convocations
    class CreateTextMessageService
      def initialize(convocation)
        @convocation = convocation
        @judge = convocation.subscription.tournament.user
      end

      def call
        begin
          client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN'])
          # Create and send an SMS message
          if @convocation.status == "pending"
            client.account.messages.create(
              from: ENV['TWILIO_FROM'],
              to:   @convocation.subscription.user.telephone,
              body: "Vous etes convoqué(e) #{@convocation.date.strftime("le %d/%m/%Y")} #{@convocation.hour.strftime(" à %Hh%M")} pour le tournoi #{@convocation.subscription.tournament.name} dans la catégorie #{@convocation.subscription.competition.category}. Num JA: #{@convocation.subscription.tournament.user.telephone} Connectez vous sur www.wetennis.fr pour répondre à cette convocation."
              )
          elsif @convocation.status == "confirmed_by_judge"
            client.account.messages.create(
              from: ENV['TWILIO_FROM'],
              to:   @convocation.subscription.user.telephone,
              body: "Le juge-arbitre ne peut pas vous proposer un autre créneau pour votre convocation #{@convocation.date.strftime("le %d/%m/%Y")} #{@convocation.hour.strftime(" à %Hh%M")} pour le tournoi #{@convocation.subscription.tournament.name} dans la catégorie #{@convocation.competition.category}. Num JA: #{@convocation.subscription.tournament.user.telephone}. Si vous ne pouvez pas participer connectez vous sur www.wetennis.fr pour indiquer votre WO. "
            )
          end
          # judge is loses 1 sms
          sms_credit = @judge.sms_quantity - 1
          @judge.sms_quantity = sms_credit
          @judge.save
        rescue Twilio::REST::RequestError
          # on error, sms won't be sent.. deal
        end
      end
    end
  end
end

