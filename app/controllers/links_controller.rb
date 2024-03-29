class LinksController < ApplicationController
  before_action :set_current_user
  before_action :set_and_validate_link_from_id, only: %i[show destroy edit update report clear]
  before_action :set_and_validate_link_from_slug, only: %i[redirect_to_large_url redirect_to_large_url_for_private_links]
  before_action :set_visits_to_link, only: %i[report]
  
  # GET /links or /links.json for @current_user
  def index
    @links = Link.where(user_id: @current_user.id)
  end

  # GET /links/1 or /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
  end
 
  # GET /links/1/edit
  def edit
  end

  # POST /links or /links.json
  def create
    # Create the link with form parameters
      # dynamically convert a string into a class name and instantiate an object
    @link = Object.const_get(params[:link_type]).new(link_params)
    
    #The user_id must be obtained from the user who is currently logged in
    @link.assign_attributes(user_id: @current_user.id)  
    
    respond_to do |format|
      if @link.save
        format.html { redirect_to link_url(@link), notice: "Link was successfully created." }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1 or /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to link_url(@link), notice: "Link was successfully updated." }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1 or /links/1.json
  def destroy
    @link.destroy!

    respond_to do |format|
      format.html { redirect_to links_url, notice: "Link was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Has the logic to get original link from :slug and redirect to it, 
    #   if meets the conditions depending on the link type
    def redirect_to_large_url
     
        case (@link_to_redirect.type)
        when 'LinkPrivate'
          # redirect to view to request password to user
          render 'private'
        else
          # check if it meets the condition 
          if @link_to_redirect.meets_condition_for_display?
            @link_to_redirect.update_conditions (request.remote_ip) # pass IP address of the client making the request
            redirect_to @link_to_redirect.large_url, allow_other_host: true
          else
            redirection_on_error
          end
        end
    end

    def redirect_to_large_url_for_private_links
      if @link_to_redirect.meets_condition_for_display? (params[:password_private])
        @link_to_redirect.update_conditions(request.remote_ip) # pass IP address of the client making the request
        redirect_to @link_to_redirect.large_url, allow_other_host: true
      else
        flash[:error] = "Error: Invalid password, please try again."
        redirect_to redirect_to_large_url_for_private_links_path
      end
    end
  
  # GET /links/1/report
  # @visits_search include visits for Report #1 (if no filter was applied, return all visits, otherwise, it returns the subset of visits that match the filters)
  # @visits_count include visits for Report #2 (returns a a hash where keys are dates and values are the counts of visits for each day for the specified link)
  def report

    link_id = params[:id]
    ip_address = params[:ip_address]
    start_date = params[:start_date]
    end_date = params[:end_date]

    # @visits_count include visits for Report #2 
    @visits_count = Visit.byLink(link_id).groupByDate

    # @visits_search include visits for Report #1
    if start_date.present? && end_date.present? && start_date > end_date
      flash[:error] = "End Date must be after Start Date"
      redirect_back fallback_location: root_path
    elsif
      @visits_search = Visit.byLink(link_id).byIpAdress(ip_address).byDateRange(start_date, end_date)
    end  
  end

  def clear
    @visits_search = @visits
    render :report
  end

  # To render Access Denied view when User has no access to that link
  def access_denied
  end

   
  private

    def set_current_user
      @current_user = current_user
    end 

    def set_and_validate_link_from_id
      @link = Link.find_by(id: params[:id])
  
      if @link.nil?
        render plain: 'Not Found', status: :not_found
      elsif @link.user_id != @current_user.id
        redirect_to access_denied_path
      end
    end

    def set_and_validate_link_from_slug
      @link_to_redirect = Link.find_by(slug: params[:slug])

      if @link_to_redirect.nil?
        render plain: 'Not Found', status: :not_found
      elsif @link_to_redirect.user_id != @current_user.id
        redirect_to access_denied_path
      end
    end

    def set_visits_to_link
      @visits = @link.visits.all
    end

    # Only allow a list of trusted parameters through.
    def link_params
      params.require(:link).permit(:name, :large_url, :slug, :type, :expires_at, :visited, :secret)
    end

    def redirection_on_error
      if @link_to_redirect.type == 'LinkTemporal'
        render plain: 'Not Found', status: :not_found
      elsif @link_to_redirect.type == 'LinkEphemeral'
        render plain: 'Forbidden Access', status: :forbidden
      end
    end

end
