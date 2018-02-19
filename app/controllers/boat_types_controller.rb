class BoatTypesController < ApplicationController
  before_action :check_grants, only: [:create, :edit, :update, :destroy, :manage_index, :update_property_values, :create_modification]
  before_action :set_boat_type, only: [:show, :options, :modification_show,:edit, :update, :destroy, :add_configurator_entity, :update_property_values, :property_values, :create_modification, :photos, :modifications, :videos]
  before_action :set_trademarks_and_boat_series, only: [:show, :manage_index]

  def manage_index
    @title = "Управление типами лодок"
    @boat_types = BoatType.base_types.to_a.map{ |bt| bt.hash_view('control')}
    @data = {boat_types: @boat_types, boat_series_list: @boat_series, trademarks: @trademarks}
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
    @title = @header = @boat_type.catalog_name 
    
    #@data = is_control? ? {boat_type: @boat_type.hash_view(current_site, cur_locale.to_s), trademarks: @trademarks, boat_series: @boat_series} : {boat_type: @boat_type}
    respond_to do |format|
      format.html 
      format.json { render json: @data}
    end
  end
  
  def photos
    @title = @boat_type.catalog_name
    photos = @boat_type.entity_photos.map {|ph| ph.hash_view}
    @data = is_control? ? {boat_type: @boat_type.hash_view(current_site, cur_locale.to_s), photos: photos, form_token: form_authenticity_token} : photos
    respond_to do |format|
      format.html {render "show"}
      format.json {render json: @data}
    end
  end
  
  def modifications
    @title = @header = @boat_type.catalog_name + ": Компоновки"
    modifications = @boat_type.modifications.to_a.map{|m| m.hash_view(current_site, cur_locale.to_s)}
    @data = is_control? ? {boat_type: @boat_type.hash_view(current_site, cur_locale.to_s), modifications: modifications, form_token: form_authenticity_token} : modifications
    respond_to do |format|
      format.html
      format.json {render json: @data}
    end
  end
  
  def videos
    @title = @header = @boat_type.catalog_name + ": Видео"
    respond_to do |format|
      format.html
    end
  end
  
  #GET /boat_types/:boat_type_id/modifications/:id
  def modification_show
    @modification = @boat_type.modifications.find_by(id: params[:modification_id])
    if @modification.nil?
      redirect_to '/404' 
    else
      render json: @modification.hash_view(current_site, cur_locale)
    end
  end
  
  def options
    @title = @header = @boat_type.catalog_name + ": Опции"
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
        format.html { redirect_to edit_boat_type_path(@boat_type)}
        format.json { render json: @boat_type.hash_view('control'), status: :created, location: @boat_type }
      else
        format.html { render :new }
        format.json { render json: @boat_type.errors, status: :unprocessable_entity }
      end
    end
  end
  
  #POST /boat_types/1/modifications
  def create_modification
    @modification = @boat_type.modifications.build(modification_params)
    respond_to do |format|
      if @modification.save
        format.json { render json: @modification.hash_view('control'), status: :created}
      else
        format.json { render json: @modification.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /boat_types/1
  # PATCH/PUT /boat_types/1.json
  def update
    prms = @boat_type.is_modification? ? modification_params : boat_type_params
    respond_to do |format|
      if @boat_type.update(prms)
        format.html { redirect_to edit_boat_type_path(@boat_type), notice: 'Тип лодки успешно обновлён' }
        format.json { render json: @boat_type.hash_view('control'), status: :ok}
      else
        format.html { render :edit }
        format.json { render json: @boat_type.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def property_values
      render json: @boat_type.property_values_hash(cur_locale.to_s) if !is_control?
      render json: @boat_type.property_values_hash if is_control?
  end
  
  # PATCH/PUT /boat_types/1/property_values
  def update_property_values
    respond_to do |format|
      if @boat_type.update(boat_properties_params)
        format.json {render json: @boat_type.property_values_hash}
      else
        format.json {render json: {message: 'Не удалось обновить таблицу характеристик'}, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /boat_types/1
  # DELETE /boat_types/1.json
  def destroy
    if !@boat_type.is_modification?
      @boat_type.destroy
      respond_to do |format|
        format.html { redirect_to manage_boat_types_url, notice: 'Тип лодки был успешно удалён' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        if @boat_type.boat_type.modifications.size > 1 
          @boat_type.destroy
          format.json { head :no_content }
        else
          format.json {render json: {message: 'Нельзя удалить компоновку, если она единственная'}, status: :unprocessable_entity }
        end
      end
    end
  end
  
  def get_boat_types_list
    listType = params[:type].blank? ? 'properties' : params[:type]
    mdfs = BoatType.all_modifications
    mdfs = listType == "photos" ? mdfs.map {|m| {id: m.id, name: m.catalog_name} if !m.photos.blank?} : mdfs.map {|m| {id: m.id, name: m.catalog_name}}
    mdfs.compact!
    render json: mdfs.to_json
  end
  
  def copy_photos
    prms = copy_params
    copy_from = BoatType.find_by(id: prms[:copy_from])
    copy_to = BoatType.find_by(id: prms[:copy_to])
    if !copy_from.nil? and !copy_to.nil?
      photos = copy_to.copy_photos_from(copy_from)
      photos = photos.map {|ph| ph.hash_view}
      render json: photos
    else
      render json: []
    end
   
  end
  
  def copy_properties
    prms = copy_params
    copy_from = BoatType.find_by(id: prms[:copy_from])
    copy_to = BoatType.find_by(id: prms[:copy_to])
    if !copy_from.nil? and !copy_to.nil?
      photos = copy_to.copy_properties_from(copy_from)
      photos = photos.map {|ph| ph.hash_view}
      render json: photos
    else
      render json: []
    end
    
  end
  
  private
    def check_grants
      redirect_to "/404" if !could_manage_boat_types? || !is_control?
    end 
    # Use callbacks to share common setup or constraints between actions.
    def set_boat_type
      #boat_type = 
      #redirect_to boat_type.boat_type and return if boat_type.is_modification? 
      @boat_type = BoatType.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def boat_type_params
      params.require(:boat_type).permit(:ru_name, :en_name, :design_category, :copy_params_table_from_id, :boat_series_id, :body_type, :ru_description, :en_description, :ru_slogan, :en_slogan, :cnf_data_file_url, :base_cost, :is_deprecated, :is_active, :trademark_id, :use_on_ru, :use_on_en)
    end
    
    def modification_params
      params.require(:boat_type).permit(:top_view, :aft_view, :bow_view, :accomodation_view_1, :accomodation_view_2, :accomodation_view_3, :delete_view, :ru_name, :en_name, :ru_description, :en_description, :is_deprecated, :is_active, :use_on_ru, :use_on_en)
    end
    
    def boat_properties_params
      params.require(:boat_type).permit(entity_property_values_attributes: [:property_type_id, :is_binded, :set_ru_value, :set_en_value])
    end
    
    def copy_params
      params.require(:copy_entities).permit(:copy_from, :copy_to)
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
    
    def set_trademarks_and_boat_series
      return unless is_control?
      @trademarks = Trademark.all
      @boat_series = BoatSeries.all
    end
end
