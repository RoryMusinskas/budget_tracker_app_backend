class SharesController < SecuredController
  before_action :set_share, only: [:show, :update, :destroy]

  # GET /shares
  def index
    @shares = Share.where(user_sub: @current_user)
    render json: @shares
  end

  # GET /shares/1
  def show
    render json: @share
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  # POST /shares
  def create
    @share = Share.new(share_params)

    if @share.save
      render json: @share, status: :created, location: @share
    else
      render json: @share.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shares/1
  def update
    if @share.update(share_params)
      render json: @share
    else
      render json: @share.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shares/1
  def destroy
    @share.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_share
      @share = Share.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def share_params
      params.require(:share).permit(:description, :symbol, :user_sub)
    end
end
