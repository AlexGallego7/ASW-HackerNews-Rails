class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @reply = Reply.new
    @like = Like.new
    @likes = Like.new
    if !current_user.nil?
      @likes = Like.where(user_id: current_user.id)
    end
  end

  # GET /comments/new
  def new
    if current_user.nil?
      redirect_to user_google_oauth2_omniauth_authorize_path
    else
      @comment = Comment.new
    end 
  end

  # GET /comments/1/edit
  def edit
    @like = Like.new
    @likes = Like.new
    if !current_user.nil?
      @likes = Like.where(user_id: current_user.id)
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    if current_user.nil?
      redirect_to user_google_oauth2_omniauth_authorize_path
    else
      @comment = Comment.new(create_new_params)
      @comment.user_id = current_user.id
      @contribution = @comment.contribution
      
      respond_to do |format|
        if @comment.save
          format.html { redirect_back(fallback_location: root_path) }
        else
          format.html { redirect_to @contribution, notice: "Comment can't be blank" }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if comment_params[:content].blank?
          format.html { redirect_to edit_comment_url(@comment), notice: "Comment can't be blank" }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
      else @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.json { head :no_content }
    end
  end
  
  def like
    @comment = Comment.find(params[:id])
    @like = Like.where(comment_id: @comment.id, user_id: current_user.id).first
    if @like.nil?
      @like = Like.new
      @like.comment_id = params[:id]
      @like.user_id = current_user.id
      @comment.points += 1
      @comment.save
      @like.save
      @user = User.find(@comment.user_id)
      @user.karma += 1
      @user.save
    end
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.html { notice 'Contribution was successfully liked' }
      format.json { head :no_content }
    end
  end
  
  def dislike
    @comment = Comment.find(params[:id])
    @like = Like.where(comment_id: @comment.id, user_id: current_user.id).first
    if !@like.nil?
      @like.delete
      @comment.points -= 1
      @comment.save
      @user = User.find(@comment.user_id)
      @user.karma -= 1
      @user.save
    end
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.html { notice 'Contribution was successfully disliked' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content)
    end
    
    def create_new_params
      params.require(:comment).permit(:content, :contribution_id)
    end
end
