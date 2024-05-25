class MessagesController < ApplicationController
  before_action :logged_in_user, only: %i[index create destroy]
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    @messages = @conversation.messages
    @conversation.messages.where('user_id != ? AND read = ?', current_user.id, false).update_all(read: true)
    Rails.logger.debug "Marked messages as read in conversation #{@conversation.id}"

    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    end
    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end

    @message = @conversation.messages.new
  end

  def new
    @message = @conversation.messages.new
  end

  def create
    @message = @conversation.messages.new(message_params)
    return unless @message.save

    redirect_to conversation_messages_path(@conversation)
  end

  def destroy
    @message = @conversation.messages.find(params[:id])
    if @message.user == current_user
      @message.destroy
      redirect_to conversation_messages_path(@conversation), notice: 'Message was successfully deleted.'
    else
      redirect_to conversation_messages_path(@conversation), alert: 'You can only delete your own messages.'
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end
