class BoatTypesController < ApplicationController
  before_action :check_grants, only: [:new, :create, :edit, :update, :destroy, :manage_index]
  before_action :set_boat_type, only: [:photo, :delete_photo, :photos, :show, :edit, :update, :destroy, :add_configurator_entity]

  def manage_index
    @boat_types = BoatType.admin
    @title = @header = "Управление типами лодок"
  end
  
  # GET /boat_types
  # GET /boat_types.json
  
  def index
    @boat_types = params[:ids].blank? ? BoatType.active : BoatType.where(id: params[:ids])
    if params[:ids].blank? 
      @boat_types = BoatType.active
      #parameter_filter_data = BoatParameterType.filter_data
      #option_filter_data = BoatOptionType.filter_data 
     # @filter_data = parameter_filter_data.merge(option_filter_data)
     # @default_boats = BoatForSale.active.ids 
    else
      @boat_types = BoatType.with_bfs.where(id: params[:ids])
    end
  end

  # GET /boat_types/1
  # GET /boat_types/1.json
  def show
    @title = @boat_type.catalog_name
  end

  def photos
    @photos = @boat_type.photos
    respond_to do |format|
      format.html
      format.json {render json: @photos}
    end
  end
  
  def configurator
    
  end
  
  # GET /boat_types/new
  def new
    @title = @header = "Новый тип лодки"
    @boat_type = BoatType.new
  end

  # GET /boat_types/1/edit
  def edit
    @title = @header = "Редактирование типа лодки"
    @confFileExists = @boat_type.remote_cnf_file_exists?
    @additionScript = @boat_type.cnf_data_file_url if @confFileExists
    @modifications = @boat_type.check_modifications
    @property_values = @boat_type.entity_property_values
  end
  
  #POST /add_configurator_entity - сюда присылаем опции для добавления в бд
  def add_configurator_entity
    ent = []
    if @boat_type.update_attributes(configurator_entities_params)
      render json: {status: :ok}
      @boat_type.create_local_cnf_file
    else
      render json: {status: :failed}
    end
  end

  # POST /boat_types
  # POST /boat_types.json
  def create
    @boat_type = BoatType.new(boat_type_params)
    respond_to do |format|
      if @boat_type.save
        format.html { redirect_to edit_boat_type_path(@boat_type), notice: 'Новый тип лодки успешно добавлен' }
        format.json { render :show, status: :created, location: @boat_type }
      else
        format.html { render :new }
        format.json { render json: @boat_type.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # get /boat_types/:boat_type_id/photos/:id
  def photo
    @photo = @boat_type.photos.find_by(id: params[:photo_id])
  end
  
  # PATCH/PUT /boat_types/1
  # PATCH/PUT /boat_types/1.json
  def update
    respond_to do |format|
      if @boat_type.update(boat_type_params)
        format.html { redirect_to edit_boat_type_path(@boat_type), notice: 'Тип лодки успешно обновлён' }
        format.json { render :show, status: :ok, location: @boat_type }
      else
        format.html { render :edit }
        format.json { render json: @boat_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boat_types/1
  # DELETE /boat_types/1.json
  def destroy
    @boat_type.destroy
    respond_to do |format|
      format.html { redirect_to manage_boat_types_url, notice: 'Тип лодки был успешно удалён' }
      format.json { head :no_content }
    end
  end


  
  private
    def check_grants
      redirect_to "/404" if !could_manage_boat_types?
    end 
    # Use callbacks to share common setup or constraints between actions.
    def set_boat_type
      @boat_type = BoatType.show_page_scope.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def boat_type_params
      params.require(:boat_type).permit(:name, :design_category, :copy_params_table_from_id, :boat_series_id, :body_type, :description, :cnf_data_file_url, :base_cost, :is_deprecated, :is_active, :creator_id, :modifier_id, :trademark_id, entity_property_values_attributes: [:property_type_id, :is_binded, :set_value], photos_attributes:[:link, :uploader_id])
    end
    
    def configurator_entities_params
      params.require(:boat_type).permit(configurator_entities_attributes: [
        :arr_id,
        :rec_type,
        :rec_level,
        :hidden,
        :group_hidden, 
        :rec_fixed_invisibility,
        :param_code,
        :param_name,
        :comment,
        :nom_std_compl,
        :checked,
        :level_checked,
        :enabled,
        :start_enabled,
        :std_comp_sostav,
        :std_comp_option,
        :std_comp_select,
        :std_comp_enable,
        :std_comp_prefer,
        :sel_if_y,
        :sel_if_n, 
        :de_sel_if_y,
        :de_sel_if_n, 
        :en_if_y, 
        :en_if_n, 
        :dis_if_y, 
        :dis_if_n, 
        :price, 
        :amount])
    end
end
