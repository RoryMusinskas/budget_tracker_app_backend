class GoalsController < SecuredController
  before_action :set_goal, only: [:show, :update, :destroy]

  # GET /goals
  def index
    @goals = Goal.where(user_sub: @current_user)
    render json: @goals
  end

  # GET /goals/1
  def show
    render json: @goal
  end

  # POST /goals
  def create
    @goal = Goal.new(user_sub: params['user_sub'], goals_data: { goals: params['goals_data']['goals'], columns: params['goals_data']['columns'], columnOrder: params['goals_data']['columnOrder'] })

    if @goal.save
      render json: @goal, status: :created, location: @goal
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /goals/1
  def update
    if @goal.update(user_sub: params['user_sub'], goals_data: { goals: params['goals_data']['goals'], columns: params['goals_data']['columns'], columnOrder: params['goals_data']['columnOrder'] })
      render json: @goal
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /goals/1
  def destroy
    Goal.destroy(params['id'])
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goal
      # set the goal to the current user sub, not an ID. This allows for moving goals on boards without a refresh
      @goal = Goal.where(user_sub: params['user_sub'])
    end

    # Only allow a trusted parameter "white list" through.
    def goal_params
      params.permit!(:user_sub, :goals_data)
    end
end
