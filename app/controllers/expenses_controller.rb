class ExpensesController < SecuredController
  before_action :set_expense, only: [:show, :update, :destroy]
  # GET /expenses
  def index
    # Get all the expenses based on the current user
    @expenses = Expense.where(user_sub: SecuredController.current_user_id)
    p @expenses
    render json: @expenses
  end

  # GET /expenses/1
  def show
    render json: @expense
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  # POST /expenses
  # Once post request has been made, pull in the params and add to new, then add the current user id 
  def create
    # Get the variables passed in from params on create
    description = params['expense']['description']
    amount = params['expense']['amount'] 
    category_id = params['expense']['category_id']
    @expense = Expense.new(description: description, amount: amount, user_sub: SecuredController.current_user_id, category_id: category_id)

    if @expense.save
      render json: @expense, status: :created, location: @expense
    else
      render json: @expense.errors, status: :unprocessable_entity
      puts @expense.errors.messages
    end
  end

  # TODO - USER AUTHENTICATION TO ONLY UPDATE OWN EXPENSES
  # PATCH/PUT /expenses/1
  def update
    if @expense.update(expense_params)
      render json: @expense
    else
      render json: @expense.errors, status: :unprocessable_entity
    end
  end

  # TODO - USER AUTHENTICATION TO ONLY DELETE OWN EXPENSES
  # DELETE /expenses/1
  def destroy
    @expense.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end
    
    # Only allow a trusted parameter "white list" through.
    def expense_params
      params.require(:expense).permit(:description, :amount, :user_sub, :category_id)
    end
end
