#@BoatParameterType = React.createClass
#    render: ->
boatTypeAttrs = ['ru_name', 'en_name', 'boat_series_id', 'trademark_id', 'boat_type_id', 'ru_description', 'en_description', 'ru_slogan', 'en_slogan']

    

@BoatTypesTableRow = React.createClass
     locales: ->
         v = ''
         if @props.boat_type.use_on_ru then v += 'Рус.'
         if @props.boat_type.use_on_en then v += ' Англ.'
         return $.trim v
     componentDidMount: ->
         ShowEl("#bt_row_#{@props.boat_type.id}", 500)
     render: ->
         React.DOM.tr
             id: "bt_row_#{@props.boat_type.id}"
             style: {display: 'none'},
             React.DOM.td null, @props.boat_type.trademark_name
             React.DOM.td null, @props.boat_type.boat_series_name
             React.DOM.td null, @props.boat_type.ru_name
             React.DOM.td null, @locales()
             React.DOM.td null,
                 React.DOM.a
                     href: "/boat_types/#{@props.boat_type.id}",
                     React.createElement IconWithText, txt: 'Перейти', fig: 'arrow-right'


@BoatTypesTables = React.createClass
    activeBoatTypes: ->
        bTypes = []
        for b in @props.boat_types
            if b.is_active && !b.is_deprecated then bTypes.push b
        bTypes
    notActiveBoatTypes: ->
        bTypes = []
        for b in @props.boat_types
            if !b.is_active && !b.is_deprecated then bTypes.push b
        bTypes
    deprecatedBoatTypes: ->
        bTypes = []
        for b in @props.boat_types
            if b.is_deprecated then bTypes.push b
        bTypes
    render: ->
        React.DOM.div
            className: 'row'
            React.DOM.div
                className: 'small-12 columns'
                React.createElement BoatTypesTable, header: "Не активные", showIfEmpty: false, boat_types: @notActiveBoatTypes()
                React.createElement BoatTypesTable, header: "Активные", showIfEmpty: true, boat_types: @activeBoatTypes()
                React.createElement BoatTypesTable, header: "Удалённые", showIfEmpty: true, boat_types: @deprecatedBoatTypes()
                                         
@BoatTypesTable = React.createClass
    empty: ->
        React.DOM.p null, "Список пуст"
    notEmpty: ->
        React.DOM.table
            id: 'boat_types',
            React.DOM.thead null,
                React.DOM.tr null, 
                    React.DOM.th null, "Торговая марка"
                    React.DOM.th null, "Серия"
                    React.DOM.th null, 'Название лодки'
                    React.DOM.th null, 'Локали'
                    React.DOM.th null, null
            React.DOM.tbody null,
                for bt in @props.boat_types
                    React.createElement BoatTypesTableRow, key: bt.id, boat_type: bt    
    render: ->
        if @props.boat_types.length is 0 && !@props.showIfEmpty then return null
        React.DOM.div 
            className: 'tb-pad-xs'
            React.DOM.h5 null, @props.header
            if @props.boat_types.length is 0 then @empty() else @notEmpty()
                
@BoatTypesManageIndex = React.createClass
    getInitialState: ->
        boat_types: @props.boat_types
        curTM: if @props.trademarks.length > 0 then @props.trademarks[0] else null
    addBoatType: (boat_type)->
        console.log boat_type
        boatTypes = @state.boat_types.slice()
        boatTypes.push boat_type
        @setState boat_types: boatTypes
    selectedBoatTypes: ->
        tm = @state.curTM
        bts = []
        if tm is null then return []
        for b in @state.boat_types
            if b.trademark_id is tm.id then bts.push(b)
        return bts
    setTM: (tm)->
        @setState curTM: tm
    tmMenu: ->
        if @props.trademarks.length > 0 then React.createElement SimpleMenu, items: @props.trademarks, selected: @state.curTM, clickItemEvent: @setTM
    render: ->
        React.DOM.div
            id: 'boat_type_manage_index'
            React.createElement BoatTypeNew, boat_series_list: @props.boat_series_list, trademarks: @props.trademarks, addBoatType: @addBoatType
            @tmMenu()
            React.createElement BoatTypesTables, boat_types: @selectedBoatTypes()
            

@BoatTypeNew = React.createClass 
    getInitialState: ->
        maxNameLength: 16
        minNameLength: 3
        boat_series_id: null
        trademark_id: if @props.trademarks.length is 0 then null else @props.trademarks[0].id
        body_type: ''
        copy_params_table_from_id: null
        modifications_number: 1
        design_category: "C"
        ru_name: ''
        isOpen: false
        errors: []
    defaultState: ->
        boat_series_id: null
        trademark_id: if @props.trademarks.length is 0 then null else @props.trademarks[0].id
        body_type: ''
        modifications_number: 1
        design_category: "C"
        ru_name: ''
        errors: []
    onChangeHandle: (e)->
        name = e.target.name
        @setState "#{name}": e.target.value
        console.log @params()
    params: ->
        {
            boat_series_id: @state.boat_series_id
            trademark_id: @state.trademark_id
            ru_name: @state.ru_name
            modifications_number: @state.modifications_number
            body_type: @state.body_type
        }
    handleSubmit: (e)->
        e.preventDefault()
        $.ajax({
          url: "/boat_types"
          type: "POST"
          data: {boat_type: @params()}
          success: (data)=>
              @props.addBoatType(data)
              @setState @defaultState
          error: (jqXHR, textStatus, errorThrown)=>
              
              @fillErrors(jqXHR.responseJSON)
          dataType: 'json'
        })
        #console.log @state
    handleSwitch: (e)->
        e.preventDefault()
        @setState isOpen: !@state.isOpen
    fillErrors: (errors)->
        errs = GetErrorsFromResponse(errors, boatTypeAttrs)
        @setState errors: errs
        #console.log errs
    drawErrors: ->
        React.createElement ErrorsCallout, errors: @state.errors
    render: ->
        React.DOM.div 
            id: "new_boat_type_form",
            React.DOM.div 
                className: 'row'
                React.DOM.div
                    className: 'small-12 columns'
                    React.DOM.div
                        className: 'button-group'
                        React.DOM.a
                            className: 'button primary'
                            onClick: @handleSwitch
                            React.createElement YesNoIconWithText, figs: ['plus', 'minus'], txts: ['Новый тип лодки', 'Скрыть форму'], value: !@state.isOpen
            if @state.isOpen
                React.DOM.form 
                    onSubmit: @handleSubmit
                    if @state.errors.length > 0 then @drawErrors() 
                    React.DOM.div
                        className: 'row'
                        React.DOM.div 
                            className: 'small-12 medium-2 columns'
                            React.createElement DropdownList, inputName: 'trademark_id', items: @props.trademarks, selected: @state.trademark_id, changeEvent: @onChangeHandle, label: 'Марка'
                        React.DOM.div 
                            className: 'small-12 medium-2 columns'
                            React.createElement DropdownList, inputName: 'boat_series_id', items: @props.boat_series_list, selected: @state.boat_series_id, changeEvent: @onChangeHandle, nullValName: 'Вне серии', label: 'Серия'
                        React.DOM.div 
                            className: 'small-12 medium-2 end columns'
                            React.DOM.label null,
                                "Название"
                                React.DOM.input
                                    name: 'ru_name'
                                    type: 'text'
                                    onChange: @onChangeHandle
                                    value: @state.ru_name
                        React.DOM.div 
                            className: 'small-12 medium-2  columns'
                            React.DOM.label null,
                                "Проектная категория"
                                React.DOM.input
                                    name: 'design_category'
                                    type: 'text'
                                    onChange: @onChangeHandle
                                    value: @state.design_category
                        React.DOM.div 
                            className: 'small-12 medium-2 columns'
                            React.DOM.label null,
                                "Тип корпуса"
                                React.DOM.input
                                    name: 'body_type'
                                    type: 'text'
                                    onChange: @onChangeHandle
                                    value: @state.body_type
                        React.DOM.div 
                            className: 'small-12 medium-2 end columns'
                            React.DOM.label null,
                                "Кол-во компоновок"
                                React.DOM.input
                                    name: 'modifications_number'
                                    type: 'number'
                                    max: 5
                                    min: 1
                                    onChange: @onChangeHandle
                                    value: @state.modifications_number
                    React.DOM.div
                        className: 'row'
                        React.DOM.div
                            className: 'small-12 columns'
                            React.DOM.button
                                    className: 'button success expanded'                                 
                                    type: 'submit'
                                    'Создать'
                                    
@BoatPhoto = React.createClass
    render: ->
        React.DOM.div
            className: "column tb-pad-xs"
            React.DOM.a null,
                React.DOM.img
                    src: @props.photo.small
                    className: "kra-ph-box"
                    "data-collection": "boat_photo"
                    "data-image-versions": "[#{@props.photo.small}, small], [#{@props.photo.medium}, medium],[#{@props.photo.large}, large]"  
                    #"data-interchange": "[#{@props.photo.small}, small], [#{@props.photo.medium}, medium],[#{@props.photo.large}, large]"

@BoatTypeShowMenuItem = React.createClass
    handleClick: (e)->
        e.preventDefault()
        history.pushState(@props.item, @props.item.title, e.target.href)
        @props.setPartAct(@props.item)
    render: ->
        React.DOM.li null,
            React.DOM.a
                href: @props.item.url.replace('{0}', @props.bt_id)
                onClick: @handleClick
                @props.item.title

BTSMenuItems = [
                    {
                        name: "main"
                        title: "Основная информация"
                        url: "/boat_types/{0}" 
                    },
                    {
                        name: "modifications"
                        title: "Компоновки"
                        url: "/boat_types/{0}/modifications" 
                    },
                    {
                        name: "videos"
                        title: "Видео"
                        url: "/boat_types/{0}/videos" 
                    }
                ]
                   
@BoatTypeShow = React.createClass #     
    getInitialState: ->
        curPart: @setPartByLocation()
        boat_type: @props.boat_type
        trademarks: @props.trademarks
        boat_series: @props.boat_series
        videos: @props.videos
        photos: @props.photos
        form_token: @props.form_token
        modifications: @props.modifications
    updState: (data)->
        boat_type: if data.boat_type is undefined then @state.boat_type else data.boat_type
        trademarks: if data.trademarks is undefined then @state.trademarks else data.trademarks 
        boat_series: if data.trademarks is undefined then @state.boat_series else data.boat_series 
        videos: if data.videos is undefined then @state.videos else data.videos 
        photos: if data.photos is undefined then @state.photos else data.photos 
        form_token: if data.form_token is undefined then @state.form_token else data.form_token 
        modifications: if data.modifications is undefined then @state.modifications else data.modifications 
        curPart: if data.curPart is undefined then @state.curPart else data.curPart
    setDataInState: (data)->
        @setState @updState(data)
    setPartByLocation: ()->
        loc = window.location
        for i in BTSMenuItems
            if loc.toString().indexOf(i.name) > -1
                return i
        BTSMenuItems[0]
    setPartAct: (state)->
        needUpd = false
        switch state.name
            when 'main'
                needUpd = @state.boat_series is undefined or @state.trademarks is undefined
            when 'modifications'
                needUpd = @state.modifications is undefined or @state.form_token is undefined
            when 'videos'
                needUpd = @state.videos is undefined 
            when 'photos'
                needUpd = @state.photos is undefined or @state.form_token is undefined
        if needUpd 
            $.ajax({
              url: state.url.replace('{0}', @state.boat_type.id)
              type: "GET"
              success: (data)=>
                  data.curPart = state
                  @setState @updState(data)
              error: (jqXHR, textStatus, errorThrown)=>
                  errs = GetErrorsFromResponse(jqXHR.responseJSON, boatTypeAttrs)
                  console.log errs
                  @setState errors: errs
              dataType: 'json'
            })    
        else @setState curPart: state
        
    componentDidMount: ->
        window.addEventListener('popstate', 
                                (e)=> @setState curPart: e.state,
                                false)
    handleUpdated: (boat_type)->
        @setState boat_type: boat_type        
    render: ->
        React.DOM.div 
            className: "bt-show",
            React.DOM.div 
                className: 'tb-pad-m'
                React.DOM.div 
                    className: 'row'
                    React.DOM.div
                        className: 'small-12 medium-6 columns'
                        React.createElement HeaderWithSubHeader, h1: "#{@state.boat_type.trademark_name} #{@state.boat_type.ru_name}", h3: "#{@state.curPart.title}"
                    React.DOM.div
                        className: 'small-12 medium-6 columns'
                        React.DOM.ul
                            className: 'menu right-menu'
                            for i in BTSMenuItems
                                React.createElement BoatTypeShowMenuItem, key: "item-#{i.name}", item: i, bt_id: @state.boat_type.id, setPartAct: @setPartAct              
            #switch @state.curPart.name 
            #    when 'main' then React.createElement BoatMainInfo, boat_type: @state.boat_type, boat_series: @state.boat_series, trademarks: @state.trademarks, handleUpdated: @setDataInState
            #    when 'modifications' then React.createElement BoatTypeModifications, modifications: @state.modifications, boat_type: @state.boat_type, form_token: @state.form_token, updHandle: @setDataInState
            #    when 'videos' then React.createElement BoatTypeVideos, videos: @state.videos, boat_type: @state.boat_type, updHandle: @setDataInState


@BoatTypeModifications = React.createClass
    getInitialState: ->
        modifications: if @props.modifications is undefined then [] else @props.modifications
        curModification: if @props.modifications is undefined then null else @props.modifications[0]
        ru_name: ''
        en_name: ''
        ru_description: ''
        en_description: ''
        errors: []
    selModification: (modification)->
        console.log @state.curModification
        @setState curModification: modification
    newModificationFormOpen: (e)->
        e.preventDefault()
        $('#new_modification_form').foundation('open')
        #@setState curModification: null
    prms: ->
        {
            ru_name: @state.ru_name
            en_name: @state.en_name
            ru_description: @state.ru_description
            en_description: @state.en_description
        }
    mdfsPanel: ->
        idx = 0
        React.DOM.div
            className: 'row'
            React.DOM.div
                className: 'small-12 columns'
                React.DOM.div
                    className: 'button-group'
                    React.DOM.button
                        className: 'button primary'
                        onClick: @newModificationFormOpen
                        disabled: @state.curModification is null
                        React.createElement IconWithText, fig: 'plus', txt: 'Добавить компоновку'
                        
    addModificationToState: (mdf)->
        mdfs = @state.modifications.slice()
        mdfs.push(mdf)
        @setState modifications: mdfs, curModification: mdf, errors: [] 
        $('#new_modification_form').foundation('close')
        @props.updHandle({modifications: mdfs})
    updModificationOnList: (mdf)->
        mdfs = @state.modifications.slice()
        mdfs = mdfs.map (m)->
            if m.id is mdf.id then mdf else m
        @setState modifications: mdfs, curModification: mdf 
    deleteModification: (mdf)->
        if confirm("Вы уверены что хотите удалить компоновку #{mdf.ru_name}")
            $.ajax({
                  url: "/boat_types/#{mdf.id}"
                  type: "DELETE"
                  success: (data)=>
                      mdfs = []
                      for m in @state.modifications
                          if mdf isnt m then mdfs.push(m)
                      @setState modifications: mdfs, curModification: mdfs[0]
                      @props.updHandle({modifications: mdfs})
                  error: (jqXHR, textStatus, errorThrown)=>
                      errs = GetErrorsFromResponse(jqXHR.responseJSON, boatTypeAttrs)
                      console.log errs
                      @setState errors: errs
                  dataType: 'json'
                })
    createModification: (e)->
        e.preventDefault()
        $.ajax({
          url: "/boat_types/#{@props.boat_type.id}/modifications"
          type: "POST"
          data: {boat_type: @prms()}
          success: (data)=>
              @addModificationToState(data)
          error: (jqXHR, textStatus, errorThrown)=>
              errs = GetErrorsFromResponse(jqXHR.responseJSON, boatTypeAttrs)
              console.log errs
              @setState errors: errs
          dataType: 'json'
        })
    handleChange: (e)->
        @setState "#{e.target.name}": e.target.value
    drawErrors: ->
        React.createElement ErrorsCallout, errors: @state.errors
    componentDidMount: ->
        $('#new_modification_form').foundation()
    componentWillUnmount: ->
        $('#new_modification_form').remove()
    newModificationForm: ->
        React.DOM.div
            className: 'reveal large'
            id: 'new_modification_form'
            'data-reveal': true,
            React.DOM.h3 null, "Новая компоновка лодки #{@props.boat_type.trademark_name} #{@props.boat_type.ru_name}"
                React.DOM.form
                    onSubmit: @createModification
                    @drawErrors()
                    React.DOM.div 
                        className: 'tb-pad-s'
                        React.DOM.div 
                            className: 'row'
                            React.DOM.div
                                className: 'small-12 medium-6 columns'
                                React.DOM.label null,
                                    "Русское название"
                                    React.DOM.input
                                        type: 'text'
                                        name: 'ru_name'
                                        onChange: @handleChange
                                        value: @state.ru_name
                            React.DOM.div
                                className: 'small-12 medium-6 columns'
                                React.DOM.label null,
                                    "Английское название"
                                    React.DOM.input
                                        type: 'text'
                                        name: 'en_name'
                                        onChange: @handleChange
                                        value: @state.en_name
                        React.DOM.div 
                            className: 'row'
                            React.DOM.div
                                className: 'small-12 medium-6 columns'
                                React.DOM.label null,
                                    "Описание компоновки"
                                    React.DOM.textarea
                                        name: 'ru_description'
                                        onChange: @handleChange
                                        value: @state.ru_description
                            React.DOM.div
                                className: 'small-12 medium-6 columns'
                                React.DOM.label null,
                                    "Описание компоновки для английской версии"
                                    React.DOM.textarea
                                        name: 'en_description'
                                        onChange: @handleChange
                                        value: @state.en_description
                    React.DOM.div
                        className: 'row'
                        React.DOM.div
                            className: 'small-12 columns'
                            React.DOM.div 
                                className: 'expanded button-group'
                                React.DOM.button
                                    className: 'button success  '
                                    type: 'submit'
                                    'Создать компоновку'
                                React.DOM.a
                                    className: 'button'
                                    onClick: @cleanErrors
                                    'data-close': 'new_modification_form'
                                    'Закрыть'
                        
    cleanErrors: ->
        @setState errors: []
    selModification: (modification)->
        @setState curModification: modification                            
    updateProperties: (properties)->
        cMd = @state.curModification
        cMd.properties = properties
        mdfs = @state.modifications.slice()
        mdfs.map (md)=>
            if md.id is cMd.id then cMd else md
        @setState modifications: mdfs, curModification: cMd
        
    propertiesTable: ->
        React.DOM.div null,
            React.DOM.div 
                className: 'row'
                React.DOM.div
                    className: 'small-12 columns'
                    React.DOM.h5 null, "Технические характеристики \"#{@state.curModification.ru_name}\""
            React.createElement ModificationPropertyValuesManageTable, modification: @state.curModification, updateProperties: @updateProperties
    render: ->
        if @state.modifications.length > 0 
            React.DOM.div null,
                @mdfsPanel()
                React.DOM.div
                    className: 'tb-pad-s'
                    React.createElement SimpleMenu, items: @state.modifications, nTitle: 'ru_name', clickItemEvent: @selModification, selected: @state.curModification
                @newModificationForm()
                React.createElement ModificationMainInfo, modification: @state.curModification, updMdfFunc: @updModificationOnList, form_token: @props.form_token, delMdfFunc: @deleteModification, mdfsCount: @state.modifications.length
                @propertiesTable()

        else
            React.DOM.div
                className: 'row'
                React.DOM.div 
                    className: 'small-12 columns'
                    React.DOM.p null, "Нет ни одной компоновки"

@BoatTypeModification = React.createClass
    render: ->
        React.DOM.div null,
            React.createElement ModificationProperties, modification: @props.modification


@ModificationMainInfo = React.createClass
    getInitialState: ->
        editMode: false
        mdfId: @props.modification.id
        ru_name: ''
        en_name: ''
        ru_description: ''
        en_description: ''
        bow_view: ''
        aft_view: ''
        top_view: ''
        accomodation_view_1: ''
        accomodation_view_2: ''
        accomodation_view_3: ''
        errors: []
    btParams: ->
        {
            en_name: @state.en_name
            ru_name: @state.ru_name
            en_description: @state.en_description
            ru_description: @state.ru_description
        }
    delButHandleClick: (e)->
        e.preventDefault()
        @props.delMdfFunc(@props.modification)
    switchEditMode: (e)->
        e.preventDefault()
        if not @state.editMode
            @setState editMode: true, ru_name: @props.modification.ru_name, en_name: @props.modification.en_name, ru_description: @props.modification.ru_description, en_description: @props.modification.en_description
        else
            $.ajax 
                url: "/boat_types/#{@props.modification.id}"
                type: 'PUT'
                dataType: 'json'
                data: {boat_type: @btParams()}
                success: (data)=>
                    @props.updMdfFunc(data)
                    @setState editMode: false
                error: (jqXHR)=>
                    @setState errors: GetErrorsFromResponse(jqXHR.responseJSON, boatTypeAttrs)
                    console.log jqXHR.responseJSON
    showMode: ->
        React.DOM.table null,
            React.DOM.tbody null,
                React.DOM.tr null,
                    React.DOM.td null,
                        React.DOM.p null,  "Название"
                    React.DOM.td null, 
                        React.DOM.h6 null, 'на русском'
                        React.DOM.p null, @props.modification.ru_name
                        React.DOM.h6 null, 'на английском'
                        React.DOM.p null, @props.modification.en_name
                React.DOM.tr null,
                    React.DOM.td null,
                        React.DOM.p null,  "Описание"
                    React.DOM.td null, 
                        React.DOM.h6 null, 'на русском'
                        React.DOM.p null, if $.trim(@props.modification.ru_description) is '' then 'Не указано' else @props.modification.ru_description
                        React.DOM.h6 null, 'на английском'
                        React.DOM.p null, if $.trim(@props.modification.en_description) is '' then 'Не указано' else @props.modification.en_description

    changeInputHandle: (e)->
        name = e.target.name
        val = e.target.value
        val = if name is 'top_view' then File.open(val) else val
        @setState "#{e.target.name}": val
    editMode: ->
        React.DOM.div null,
            React.createElement ErrorsCallout, errors: @state.errors
            React.DOM.table null,
                React.DOM.tbody null,
                    React.DOM.tr null,
                        React.DOM.td null,
                            React.DOM.p null,  "Название"
                        React.DOM.td null, 
                            React.DOM.label 
                                'на русском'
                                React.DOM.input
                                    onChange: @changeInputHandle
                                    type: 'text'
                                    name: 'ru_name'
                                    value: @state.ru_name
                            React.DOM.label 
                                'на английском'
                                React.DOM.input
                                    onChange: @changeInputHandle
                                    type: 'text'
                                    name: 'en_name'
                                    value: @state.en_name
                    React.DOM.tr null,
                        React.DOM.td null,
                            React.DOM.p null,  "Описание"
                        React.DOM.td null,
                            React.DOM.label 
                                'на русском'
                                React.DOM.textarea
                                    onChange: @changeInputHandle
                                    name: 'ru_description'
                                    value: @state.ru_description
                            React.DOM.label 
                                'на английском'
                                React.DOM.textarea
                                    onChange: @changeInputHandle
                                    name: 'en_description'
                                    value: @state.en_description

    checkMdf: ->
        if @state.mdfId isnt @props.modification.id
            @setState editMode: false, mdfId: @props.modification.id
    updPhotos: (phs)->
        @props.modification.photos = phs.photos
        @props.updMdfFunc(@props.modification)
    updVideos: (vds)->
        @props.modification.videos = vds.videos
        @props.updMdfFunc(@props.modification)
    render: ->
        React.DOM.div null,
            React.DOM.div
                className: 'row'
                React.DOM.div
                    className: 'small-8 columns'
                    React.DOM.h5 null, "Основная информация о компоновке \"#{@props.modification.ru_name}\""
                React.DOM.div
                    className: 'small-4 columns'
                    React.DOM.div
                        className: 'button-group'
                        if @props.mdfsCount > 1
                            React.DOM.a 
                                className: 'button float-right alert'
                                onClick: @delButHandleClick
                                React.createElement IconWithText, fig: 'trash', txt: 'Удалить компоновку'
                        React.DOM.a 
                            className: 'button float-right'
                            onClick: @switchEditMode
                            React.createElement YesNoIconWithText, figs: ['save','pencil'], txts: ['Сохранить', 'Редактировать'], value: @state.editMode
            React.DOM.div
                className: 'row'
                React.DOM.div
                    className: 'small-12 columns'
                    if @state.editMode then @editMode() else @showMode()
            React.createElement TechnicalViewsLoader, form_token: @props.form_token, modification: @props.modification, updMdfFunc: @props.updMdfFunc
            React.DOM.div
                className: 'row'
                React.DOM.div 
                    className: 'small-12 columns'
                    React.DOM.h5 null, "Фото"
            React.createElement PhotosControl, key: "phs-boat-type-#{@props.modification.id}", photos: @props.modification.photos, entity: 'boat_type', entity_id: @props.modification.id, form_token: @props.form_token, afterUpdHandle: @updPhotos

            
@BoatMainInfo = React.createClass
    getInitialState: ->
        errors: []
        use_on_ru: @props.boat_type.use_on_ru
        use_on_en: @props.boat_type.use_on_en
        is_active: @props.boat_type.is_active
        is_deprecated: @props.boat_type.is_deprecated
        ru_name: AlterText(@props.boat_type.ru_name)
        en_name: AlterText(@props.boat_type.en_name)
        design_category: AlterText @props.boat_type.design_category
        ru_description: AlterText(@props.boat_type.ru_description)
        en_description: AlterText @props.boat_type.en_description
        ru_slogan: AlterText @props.boat_type.ru_slogan
        en_slogan: AlterText @props.boat_type.en_slogan
        trademark_id: @props.boat_type.trademark_id 
        trademarks: @props.trademarks
        boat_type: @props.boat_type
        boat_series_id: @props.boat_type.boat_series_id
        boat_series_list: if @props.boat_series is undefined then [] else @props.boat_series
        isEdit: false
    getTrademark: ->
        GetEntityById(@props.trademarks, @props.boat_type.trademark_id)
    getBoatSeries: ->
        GetEntityById(@props.boat_series, @props.boat_type.boat_series_id)
    btParams: ->
        {
            ru_name: @state.ru_name
            en_name: @state.en_name
            design_category: @state.design_category
            ru_description: @state.ru_description
            en_description: @state.en_description
            ru_slogan: @state.ru_slogan
            en_slogan: @state.en_slogan
            trademark_id: @state.trademark_id
            boat_series_id: @state.boat_series_id
            is_deprecated: @state.is_deprecated
            is_active: @state.is_active
            use_on_ru: @state.use_on_ru
            use_on_en: @state.use_on_en
        }
    tmName: ->
        tm = @getTrademark()
        if tm isnt null then tm.name else ''
    bsName: ->
        bs = @getBoatSeries()
        if bs isnt null then bs.name else '' 
    btName: ->
        if @state.ru_name is undefined then '' else $.trim(@state.ru_name)
    btEnName: ->
        if @state.en_name is undefined then '' else $.trim(@state.en_name)
    resetForm: (e)->
        e.preventDefault()
        @setState @getInitialState()
    saveFormHandle: (e)->
        e.preventDefault()
        $.ajax 
            url: "/boat_types/#{@props.boat_type.id}"
            type: 'PUT'
            dataType: 'json'
            data: {boat_type: @btParams()}
            success: (data)=>
                @setState boat_type: data                
                @switchEditMode()
            error: (jqXHR)=>
                @setState errors: GetErrorsFromResponse(jqXHR.responseJSON, boatTypeAttrs)
                #XHRErrMsg(jqXHR)         
    showMode: ->
        React.DOM.table null,
            React.DOM.tbody null,
                React.DOM.tr
                    key: 'use_on_ru',
                    React.DOM.td width: '30%', 'Использовать для русской версии'
                    React.DOM.td null, React.createElement YesNoIcon, value: @state.use_on_ru
                React.DOM.tr
                    key: 'use_on_en',
                    React.DOM.td null, 'Использовать для английской версии'
                    React.DOM.td null, React.createElement YesNoIcon, value: @state.use_on_en
                React.DOM.tr
                    key: 'is_active_row',
                    React.DOM.td null, 'Активность'
                    React.DOM.td null, if @state.is_active then 'Активен' else 'Не активен'
                React.DOM.tr
                    key: 'is_deprecated_row',
                    React.DOM.td null, 'Актуальность'
                    React.DOM.td null, if @state.is_deprecated then 'Устарел' else "Актуален"
                React.DOM.tr
                    key: 'design_category_row',
                    React.DOM.td null, 'Проектная категория'
                    React.DOM.td null,  if $.trim(@state.design_category) is '' then 'Не указана' else @state.design_category
                React.DOM.tr
                    key: 'trademark_row',
                    React.DOM.td null, 'Торговая марка'
                    React.DOM.td null,  if @tmName().length is 0 then 'Не выбрана' else @tmName()
                React.DOM.tr
                    key: 'boat_series_row'
                    React.DOM.td null, 'Серия'
                    React.DOM.td null,  if @bsName().length is 0 then 'Вне серии'else @bsName()
                React.DOM.tr
                    key: 'name_row'
                    React.DOM.td null, 'Название'
                    React.DOM.td null,
                        React.DOM.h6 null, 'Для русской версии' 
                        React.DOM.p null, if @btName().length is 0 then "Без имени" else @btName()
                        React.DOM.h6 null, 'Для английской версии' 
                        React.DOM.p null, if @btEnName().length is 0 then "Не указано" else @btEnName()
                React.DOM.tr
                    key: 'slogan_row'
                    React.DOM.td null, 'Слоган'
                    React.DOM.td null,
                         
                React.DOM.tr
                    key: 'description_row'
                    React.DOM.td null, 'Описание'
                    React.DOM.td null,
                        React.DOM.h6 null, 'На русском'
                        React.DOM.p null, if $.trim(@state.ru_description) is '' then 'Не указано' else @state.ru_description
                        React.DOM.h6 null, 'На английском'
                        React.DOM.p null, if $.trim(@state.en_description) is '' then 'Не указано' else @state.en_description
    changeInputHandle: (e)->
        name = e.target.name
        value = e.target.value
        @setState "#{ name }": value
    editMode: ->
        React.DOM.form null,
            React.createElement ErrorsCallout, errors: @state.errors
            React.DOM.table null,
                React.DOM.tbody null,
                    React.DOM.tr
                        key: 'use_on_ru',
                        React.DOM.td width: '30%', 'Использовать для русской версии'
                        React.DOM.td null, React.createElement YesNowDropdownList, key: 'use_on_ru_cb', inputName: 'use_on_ru', value: @state.use_on_ru, changeEvent: @changeInputHandle
                    React.DOM.tr
                        key: 'use_on_en',
                        React.DOM.td null, 'Использовать для английской версии'
                        React.DOM.td null, React.createElement YesNowDropdownList, key: 'use_on_en_cb', inputName: 'use_on_en', value: @state.use_on_en, changeEvent: @changeInputHandle
                    React.DOM.tr
                        key: 'is_active_row',
                        React.DOM.td null, 'Активен'
                        React.DOM.td null, React.createElement YesNowDropdownList, key: 'is_active_cb', inputName: 'is_active', value: @state.is_active, changeEvent: @changeInputHandle, trueName: 'Активен', falseName: 'Не активен'
                    React.DOM.tr
                        key: 'is_deprecated_row',
                        React.DOM.td null, 'Актуальность'
                        React.DOM.td null, React.createElement YesNowDropdownList, key: 'is_deprecated_cb', inputName: 'is_deprecated', value: @state.is_deprecated, changeEvent: @changeInputHandle, trueName: 'Устарел', falseName: 'Актуален'
                    React.DOM.tr
                        key: 'design_category_row',
                        React.DOM.td null, 'Проектная категория'
                        React.DOM.td null, 
                            React.DOM.input 
                                type: 'text' 
                                placeholder: 'Проектная категория' 
                                name: 'design_category'
                                onChange: @changeInputHandle
                                value: @state.design_category
                    React.DOM.tr
                        key: 'trademark_row',
                        React.DOM.td null, 'Торговая марка'
                        React.DOM.td null, React.createElement DropdownList, key: 'tm', items: @state.trademarks, selected: @state.trademark_id, valTitle: 'id', nameTitle: 'name', inputName: 'trademark_id', changeEvent: @changeInputHandle
                    React.DOM.tr
                        key: 'boat_series_row'
                        React.DOM.td null, 'Серия'
                        React.DOM.td null, React.createElement DropdownList, key: 'bs', items: @state.boat_series_list, selected: @state.boat_series_id, valTitle: 'id', nameTitle: 'name', inputName: 'boat_series_id', nullValName: 'Вне серии', changeEvent: @changeInputHandle
                    React.DOM.tr
                        key: 'name_row'
                        React.DOM.td null, 'Название'
                        React.DOM.td null,  
                            React.DOM.label null, 
                                'Для русской версии' 
                                React.DOM.input 
                                    type: 'text' 
                                    placeholder: 'Название лодки' 
                                    name: 'ru_name'
                                    onChange: @changeInputHandle
                                    value: @state.ru_name
                            React.DOM.label null, 
                                'Для английской версии' 
                                React.DOM.input 
                                    type: 'text' 
                                    placeholder: 'Название лодки' 
                                    name: 'en_name'
                                    onChange: @changeInputHandle
                                    value: @state.en_name
                    React.DOM.tr
                        key: 'slogan_row'
                        React.DOM.td null, 'Слоган'
                        React.DOM.td null,
                            React.DOM.h6 null, 'На русском'
                            React.DOM.textarea
                                name: 'ru_slogan'
                                onChange: @changeInputHandle
                                rows: 3
                                value: @state.ru_slogan
                            React.DOM.h6 null, 'На английском'
                            React.DOM.textarea
                                name: 'en_slogan'
                                rows: 3
                                onChange: @changeInputHandle
                                value: @state.en_slogan
                    React.DOM.tr
                        key: 'description_row'
                        React.DOM.td null, 'Описание'
                        React.DOM.td null,
                            React.DOM.h6 null, 'На русском'
                            React.DOM.textarea
                                name: 'ru_description'
                                onChange: @changeInputHandle
                                rows: 10
                                value: @state.ru_description
                            React.DOM.h6 null, 'На английском'
                            React.DOM.textarea
                                name: 'en_description'
                                rows: 10
                                onChange: @changeInputHandle
                                value: @state.en_description 
    switchEditMode: (e)->
        if e isnt undefined then e.preventDefault()
        @setState @btParams()
        @setState isEdit: !@state.isEdit
    render: ->
        React.DOM.div null,
            React.DOM.div 
                className: 'row'
                React.DOM.div
                    className: 'small-12 medium-7 columns'
                    React.DOM.h5 null, 'Основная информация'
                React.DOM.div 
                    className: 'small-12 medium-5 columns'
                    React.DOM.div
                        className: 'button-group'
                        if @state.isEdit
                            React.DOM.a
                                className: 'button float-right'
                                onClick: @saveFormHandle
                                React.createElement IconWithText, fig: 'save', txt: "Сохранить"
                        else 
                            React.DOM.a
                                className: 'button float-right'
                                onClick: @switchEditMode
                                React.createElement IconWithText, fig: 'pencil', txt: "Редактировать"
            React.DOM.div
                className: 'row'
                React.DOM.div 
                    className: 'small-12 columns'
                    React.DOM.div null,
                        if @state.isEdit then @editMode() else @showMode()
             





technicalViewLoaderCell = React.createClass
    handleRemove: (e)->
        e.preventDefault()
        $.ajax(
                url: "/boat_types/#{@props.modification.id}"
                type: "PUT"
                data: {boat_type: {delete_view: @props.view.attr}}
                dataType: 'json'
                success: (data)=>
                    @props.viewUploaded(data)
               )
    hasPhoto: ->
        @props.modification["#{@props.view.attr}"] isnt '' and @props.modification["#{@props.view.attr}"] isnt null and @props.modification["#{@props.view.attr}"] isnt undefined
    showMode: ->
        React.DOM.div null,
            React.DOM.a
                className: 'button expanded'
                onClick: @handleRemove
                'Удалить'
            React.DOM.img
                src: if @hasPhoto() then @props.modification["#{@props.view.attr}"] else NoPhoto()

    editMode: ->
        React.createElement MiniPhotoUploader, url: "/boat_types/#{@props.modification.id}}", entity: 'boat_type', attr: @props.view.attr, form_token: @props.form_token, handleSuccess: @props.viewUploaded
    render: ->
        React.DOM.div
            className: 'column'
            React.DOM.div 
                className: 'tb-pad-s'
                React.DOM.h6 null, @props.view.name
                if not @hasPhoto() then @editMode() else @showMode()



@TechnicalViewsLoader = React.createClass
    getInitialState: ->
        curEdit: null
        viewsList: [
                        {attr: "top_view", name: "Вид сверху", isEdit: false},
                        {attr: "aft_view", name: "Вид сзади", isEdit: false},
                        {attr: 'bow_view', name: 'Вид спереди', isEdit: false},
                        {attr: "accomodation_view_1", name: "Схема рассадки 1", isEdit: false},
                        {attr: "accomodation_view_2", name: "Схема рассадки 2", isEdit: false},
                        {attr: "accomodation_view_3", name: "Схема рассадки 3", isEdit: false}
                    ]
    viewUploaded: (data)->
        @props.updMdfFunc(data)
    render: ->
        React.DOM.div
            className: 'small-up-1 medium-up-3 row'
            for i in @state.viewsList 
                React.createElement technicalViewLoaderCell, key: i.attr, view: i, form_token: @props.form_token, modification: @props.modification, viewUploaded: @viewUploaded
#https://youtu.be/sy-uMlHFDSQ
#https://youtu.be/DRNAndsH494

#<iframe width="424" height="238" src="https://www.youtube.com/embed/sy-uMlHFDSQ" frameborder="0" gesture="media" allowfullscreen></iframe>

                
@BoatTypeVideos = React.createClass
     getInitialState: ->
         url: ''
         videos: @props.videos
         video: @defaultVideo()
     defaultVideo: ->
         {boat_type_id: @props.boat_type_id, url: undefined}
     addVideo: (v)->
         vds = @state.videos.slice()
         vds.push(v)
         @setState videos: vds, video: @defaultVideo, url: ''
     rmvAction: (rv)->
         $.ajax
             url: "/videos/#{rv.id}"
             type: 'DELETE'
             dataType: 'json'
             success: (data)=> 
                 vds = []
                 for v in @state.videos
                     if v.id isnt rv.id then vds.push(v)
                 @setState videos: vds
     handleSubmit: (e)->
         e.preventDefault()
         $.ajax
             url: '/videos'
             type: 'POST'
             dataType: 'json'
             data: {boat_video: @state.video}
             success: (data)=> 
                 @addVideo(data)
     handleChange: (e)->
         v = @defaultVideo()
         v.url = GetYouTubeUrl(e.target.value)
         @setState "#{e.target.name}": e.target.value, video: v 
     videosList: ->
         if @state.videos is undefined
             console.log "videos list is undefined"
             return null
         if @state.videos.length > 0
             React.DOM.div 
                 className: 'small-up-1 medium-up-2 row'
                 for v in @state.videos
                     React.createElement VideoViewer, key: "video-#{v.id}", video: v, removeAction: @rmvAction
         else null
     render: ->
         React.DOM.div null,
             React.DOM.form
                 onSubmit: @handleSubmit
                 React.DOM.div
                     className: 'row'
                     React.DOM.div
                         className: 'small-12 medium-6 medium columns'
                         React.DOM.div
                             className: 'row'
                             React.DOM.div
                                 className: 'small-5 medium-6 columns end'
                                 if @state.video.url isnt null && @state.video.url isnt undefined 
                                     React.createElement VideoViewer, video: @state.video
                                 else
                                     if @state.video.url isnt undefined then React.DOM.p null, "Не правильный формат ссылки"
                         React.DOM.div
                             className: 'row'
                             React.DOM.div 
                                 className: 'small-8 columns'
                                 React.DOM.input
                                     type: 'text'
                                     name: 'url'
                                     placeholder: 'Копируйте сюда ссылку на видео'
                                     onChange: @handleChange
                                     value: @state.url
                             React.DOM.div 
                                 className: 'small-4 columns'
                                 React.DOM.button
                                     type: 'submit'
                                     className: 'button'
                                     disabled: @state.video.url is undefined or @state.video.url is null
                                     'Добавить'
             @videosList()


