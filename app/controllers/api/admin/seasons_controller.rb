class API::Admin::SeasonsController < API::BaseController
  skip_before_filter :authenticate, only: :index
  before_action :_set_season, only: [:show, :update, :destroy]
  before_action :_verify_admin, except: :index

  # GET /api/admin/seasons
  def index
    @seasons = Season.all
    render json: @seasons
  end

  # GET /api/admin/seasons/:id
  def show
    render json: @season
  end

  # POST /api/admin/seasons
  def create
    @season = Season.new(_season_params)
    if @season.save
      render json: @season, status: :created, location: api_admin_season_path(@season)
    else
      error(WARNING, @season.errors.full_messages.join(', '), :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/admin/seasons/:id
  def update
    if @season.update(_season_params)
      head :no_content
    else
      error(WARNING, @season.errors.full_messages.join(', '), :unprocessable_entity)
    end
  end

  # DELETE /api/admin/seasons/:id
  def destroy
    @season.destroy
    head :no_content
  end

  private

    def _set_season
      @season = Season.find(params[:id])
    end

    def _verify_admin
      forbidden() unless current_user.admin?
    end

    def _season_params
      params.require(:season).permit(:name)
    end

end

