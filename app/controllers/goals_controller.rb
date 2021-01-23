class GoalsController < SecuredController
  before_action :set_goal, only: [:show, :update, :destroy]

  # GET /goals
  def index
    @goals = Goal.all

    render json: @goals
  end

  # GET /goals/1
  def show
    render json: @goal
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  # POST /goals
  def create
    @goal = Goal.new(goal_params)

    if @goal.save
      render json: @goal, status: :created, location: @goal
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /goals/1
  def update
    if @goal.update(goal_params)
      render json: @goal
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /goals/1
  def destroy
    @goal.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goal
      @goal = Goal.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def goal_params
      params.require(:goal).permit(:description, :due_date)
    end
end
