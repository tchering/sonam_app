class MessagesController < ApplicationController
  before_action :logged_in_user, only: %i[index create destroy]
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  # This is the index action of the MessagesController.
  # It retrieves the messages for a specific conversation and marks them as read if they were unread.
  # If there are more than 10 messages, it only shows the last 10. If the user passes the `m` parameter, it shows all messages.
  # It also creates a new message object for the conversation.
  def index
    # Retrieve the messages for the conversation
    @messages = @conversation.messages

    # Mark messages as read if they were unread
    @conversation.messages.where('user_id != ? AND read = ?', current_user.id, false).update_all(read: true)
    Rails.logger.debug "Marked messages as read in conversation #{@conversation.id}"

    # If there are more than 10 messages, only show the last 10
    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    end

    # If the user passes the `m` parameter, show all messages
    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end

    # Create a new message object for the conversation
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
