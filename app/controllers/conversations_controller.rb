class ConversationsController < ApplicationController

  def index
    @user = current_user
    @users = messageable_users
    @conversations = Conversation.joins(:messages)
                                 .where("sender_id = ? OR recipent_id = ?", current_user.id, current_user.id)
                                 .distinct
  end

  def create
    if Conversation.between(params[:sender_id], params[:recipent_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:recipent_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end
    redirect_to conversation_messages_path(@conversation)
  end

  private

  def conversation_params
    params.permit(:sender_id, :recipent_id)
  end

  def messageable_users
    current_user.following
  end
end
