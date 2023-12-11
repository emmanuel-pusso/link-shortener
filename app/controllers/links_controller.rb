class LinksController < ApplicationController
  before_action :set_link, only: %i[ show edit update destroy ]

  # GET /links or /links.json
  def index
    @links = Link.all
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
   @link = Object.const_get(link_params[:type]).new(link_params)
    
    # Set the slug (automatically generated on the model) to the new link
    @link.generate_slug

    #TO_DO: The user_id must be obtained from the user who is currently logged in.
    @link.user_id = 1  
  
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
      link_to_redirect = Link.all.find_by(slug: params[:slug])
      #if :slug doesn't exist on DB returns 404
      if link_to_redirect.nil?
        render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
      # if link doesn't match the condition  
      elsif !link_to_redirect.meets_condition_for_display?
        render plain: 'Forbidden Access', status: :forbidden
      # all is fine, redirects to link
      else
        link_to_redirect.update_conditions
        redirect_to link_to_redirect.large_url, allow_other_host: true
      end
    end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def link_params
      params.require(:link).permit(:name, :large_url, :slug, :type, :expires_at, :visited, :secret)
    end
end
