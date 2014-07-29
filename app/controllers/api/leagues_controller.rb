class API::LeaguesController < API::BaseController
  before_action :_set_season
  before_action :_set_league, only: [:show, :update, :open, :close, :message, :contact]
  before_action :_verify_league_management, only: [:update, :open, :close, :message]
  before_action :_verify_start_week, only: [:create, :update]

  # GET /api/seasons/:season_id/leagues/managed
  def managed
    @leagues = current_user.managed_leagues
    @leagues = @leagues.sort_by { |league| [league.start_week.starts_at, league.name] }
    respond_with @leagues
  end

  # GET /api/seasons/:season_id/leagues/public
  def public
    @leagues = @season.leagues.public.not_started
    @leagues = @leagues.sort_by { |league| [league.start_week.starts_at, league.name] }
    respond_with @leagues
  end

  # GET /api/seasons/:season_id/leagues/private
  def private
    @leagues = @season.leagues.private.not_started
    @leagues = @leagues.sort_by { |league| [league.start_week.starts_at, league.name] }
    respond_with @leagues
  end

  # GET /api/seasons/:season_id/leagues
  def index
    @leagues = @season.leagues
    respond_with @leagues
  end

  # GET /api/seasons/:season_id/leagues/1
  def show
    respond_with @league
  end

  # POST /api/seasons/:season_id/leagues
  def create
    @league = @season.leagues.new(_league_params)
    @league.commishes << current_user
    if @league.save
      render json: { league_id: @league.id, message: { type: SUCCESS, content: "#{@league[:name]} league created" } }, status: :ok
    else
      error(@league.errors.full_messages.join(', '), WARNING, :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/seasons/:season_id/leagues/1
  def update
    return forbidden('Cannot update a league that has started') if @league.started?
    if @league.update(_league_params)
      render json: { message: { type: SUCCESS, content: "#{@league[:name]} league updated" } }, status: :ok
    else
      error(@league.errors.full_messages.join(', '), WARNING, :unprocessable_entity)
    end
  end

  # PUT /api/seasons/:season_id/leagues/1/message
  def message
    if @league.update_attributes(message: _league_params[:message])
      render json: { message: { type: SUCCESS, content: "League message has been updated for #{@league[:name]}" } }, status: :ok
    else
      error(@league.errors.full_messages.join(', '), WARNING, :unprocessable_entity)
    end
  end

  # GET /api/seasons/:season_id/leagues/1/open
  def open
    if @league.update_attributes(open: true)
      render json: { message: { type: SUCCESS, content: "League has been opened and new teams can join" } }, status: :ok
    else
      error(@league.errors.full_messages.join(', '), WARNING, :unprocessable_entity)
    end
  end

  # GET /api/seasons/:season_id/leagues/1/close
  def close
    if @league.update_attributes(open: false)
      render json: { message: { type: SUCCESS, content: "League has been closed and new teams cannot join" } }, status: :ok
    else
      error(@league.errors.full_messages.join(', '), WARNING, :unprocessable_entity)
    end
  end

  # PUT /api/seasons/:season_id/leagues/1/contact
  def contact
    return forbidden('Only league members can contact the commish after the league has started') if @league.started? && !_is_commish_of(@league) && !_has_team_in(@league)
    LeagueMailer.contact_commish(@league, current_user, params[:contact]).deliver
    render json: { message: { type: SUCCESS, content: 'Your message has been sent to the commish' } }, status: :ok
  end

  # DELETE /api/seasons/:season_id/leagues/1
  def destroy
    return forbidden('You cannot delete a league')
  end

  private

    def _league_params
      params.require(:league).permit(:name, :public, :start_week_id, :max_teams_per_user, :message)
    end

    def _set_season
      @season = Season.find(params[:season_id])
    end

    def _set_league
      @league = @season.leagues.find(params[:id])
    end

    def _verify_league_management
      forbidden('Only the commish can update a league') unless _is_commish_of(@league)
    end

    def _verify_start_week
      start_week = Week.find(_league_params[:start_week_id])
      forbidden('Start week is invalid') unless start_week.starts_at > Time.zone.now
    end

    def _is_commish_of(league)
      current_user.managed_leagues.include?(league)
    end

    def _has_team_in(league)
      current_user_leagues = current_user.teams.map(&:league)
      current_user_leagues.include?(league)
    end

end
