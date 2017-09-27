#@BoatParameterType = React.createClass
#    render: ->



@BoatTypesTableRow = React.createClass
     tmName: ->
         tm = GetEntityById(@props.control.state.trademarks, @props.boat_type.trademark_id)
         if tm isnt null then tm.name else 'Не выбран'
     bsName: ->
         bs = GetEntityById(@props.control.state.boat_series, @props.boat_type.boat_series_id)
         if bs isnt null then bs.name else 'Вне серии'
     locales: ->
         v = ''
         if @props.boat_type.use_on_ru then v += 'Рус.'
         if @props.boat_type.use_on_com then v += ' Англ.'
         return $.trim v
     render: ->
         React.DOM.tr null,
             React.DOM.td null, @tmName()
             React.DOM.td null, @bsName()
             React.DOM.td null, @props.boat_type.name
             React.DOM.td null, @locales()
             React.DOM.td null,
                 React.DOM.a
                     href: "/boat_types/#{@props.boat_type.id}",
                     React.createElement IconWithText, txt: 'Перейти', fig: 'arrow-right'
             
@BoatTypesTable = React.createClass
    render: ->
        React.DOM.div
            className: 'row'
            React.DOM.div
                className: 'small-12 columns'
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
                            React.createElement BoatTypesTableRow, key: bt.id, boat_type: bt, control: @props.control
                            
                            
            
BTControlMenu = React.createClass
    indexButtons: ->
        React.DOM.div
            className: 'button-group'
            React.DOM.a
                className: 'button success'
                href: '/boat_types/new'
                React.createElement IconWithText, txt: 'Добавить тип лодки', fig: 'plus'
    newButtons: ->
        React.DOM.div
            className: 'button-group'
            React.DOM.a
                className: 'button secondary'
                href: '/manage_boat_types'
                React.createElement IconWithText, txt: 'К списку типов лодок', fig: 'arrow-left'
    showButtons: ->
        React.DOM.div
            className: 'button-group'
            React.DOM.a
                className: 'button secondary'
                href: '/manage_boat_types'
                React.createElement IconWithText, txt: 'К списку типов лодок', fig: 'arrow-left'
    render: ->
        if @props.mode is 'manage_index'
            @indexButtons()
        else if @props.mode is 'show'
            @showButtons()
        else if @props.mode is 'new'
            @newButtons()

NewBoatTypeForm = React.createClass
    getInitialState: ->
        mode: 'manage_index' # index edit show new
    render: ->
        React.DOM.div null, 'form'

@BoatTypesControl = React.createClass
    getInitialState: ->
        form_token: @props.authenticity_token
        boat_types: @props.boat_types
        trademarks: @props.trademarks
        boat_series: @props.boat_series
        boat_type: @props.boat_type
        mode: @props.mode # index edit show new
    setMode: (mode)->
        @setState mode: mode
    pageTitle: ->
        if @state.mode is 'new'
            'Новый тип лодки'
        else
            'Управление типами лодок'
    render: ->
        React.DOM.div null,
            React.DOM.div
                className: 'row'
                React.DOM.div
                    className: 'small-12 columns tb-pad-s'
                    React.DOM.h1 null, @pageTitle()
            React.DOM.div
                className: "row"
                React.DOM.div
                    className: 'small-12 columns'
                    React.createElement BTControlMenu, mode: @state.mode, setMode: @setMode
            React.DOM.div null,
                if @state.mode is 'manage_index'
                    React.createElement BoatTypesTable, boat_types: @state.boat_types, control: @
                else if @state.mode is 'new'
                    React.createElement NewBoatTypeForm, trademarks: @state.trademarks
                else if @state.mode is 'show'
                    React.createElement BoatTypeShow, boat_type: @state.boat_type, control: @, trademarks: @state.trademarks, boat_series: @state.boat_series, form_token: @state.form_token



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

@BoatTypeTitleBlock = React.createClass
    render: ->
        React.DOM.div null,#className: "tb-pad-s"
            React.DOM.div 
                className: "bb-wide-block"
                "data-interchange": MakeInterchangeData(@props.b.photo, true)
                React.DOM.div
                    className: "rc-fog hard-fog dark-blue-bg"
                    null
                React.DOM.div
                    className: "row tb-pad-s"
                    React.DOM.div
                        className: "small-12 columns text-center"
                        React.DOM.h3 null, @props.b.name
                React.DOM.div
                    className: "row show-for-large"
                    React.DOM.div
                        className: 'medium-12 columns text-center'
                        React.DOM.p
                            title: @props.b.description,
                            TrimText(@props.b.description, 500)
                React.DOM.div
                    className: "row tb-pad-s"
                    for i in [0..@props.prms.length-1]
                        if i > 5 then break
                        React.DOM.div
                            key: "parameter-#{i}"
                            className: "small-2 columns"
                            React.DOM.div
                                 className: "stat text-center rc-param-val-b"
                                 React.DOM.span null, @props.prms[i].value
                            React.DOM.p 
                                 className: "rc-param-name-b text-center"
                                 @props.prms[i].name
                React.DOM.div
                    className: "row"
                    React.DOM.div
                        className: "small-12 columns"
                        React.DOM.img
                            className: "float-center"
                            src: @props.b.trademark.white_logo.small
                    #        className: "button expanded"
                    #        href: "#"
                    #        "ПОДРОБНЕЕ"
                    #React.DOM.div
                    #    className: "small-4 small-offset-4 columns"
                    #    React.DOM.a
                    #        className: "button expanded"
                    #        href: "#"
                    #        "КУПИТЬ"

@BoatModificationRow = React.createClass
    modelViews: ->
        views = []
        if @props.mdf.views.aft isnt null then views.push({title: "Вид спереди", view: @props.mdf.views.aft})
        if @props.mdf.views.bow isnt null then views.push({title: "Вид сзади", view: @props.mdf.views.bow})
        if @props.mdf.views.top isnt null then views.push({title: "Вид сверху", view: @props.mdf.views.top})
        return views
    render: ->
        views = @modelViews()
        React.DOM.div null,
            React.DOM.div
                className: "row"
                React.DOM.div
                    className: "small-12 columns"
                    React.DOM.h4 null, @props.mdf.name
            if views.length > 0
                React.DOM.div
                    className: "row tb-pad-s small-up-2 medium-up-3",
                    for v in views
                        React.DOM.div
                            key: "view-#{v.title}"
                            className: "column"
                            React.DOM.h6 null, v.title
                            React.DOM.img
                                "data-interchange": MakeInterchangeData(v.view)
                
@BoatTypeShow = React.createClass      
    getInitialState: -> 
        boat_type: @props.boat_type
        trademarks: if @props.trademarks is undefined then [] else @props.trademarks
        boat_series: if @props.boat_series is undefined then [] else @props.boat_series
    render: ->
        React.DOM.div null,
            React.createElement BoatMainInfo, boat_type: @state.boat_type, boat_series: @state.boat_series, trademarks: @state.trademarks
            React.createElement BoatTypePhotos, boat_type: @state.boat_type, form_token: @props.form_token
            React.createElement BoatTypeProperties, properties: @state.boat_type.properties, boat_type: @state.boat_type
@BoatMainInfo = React.createClass
    getInitialState: ->
        use_on_ru: @props.boat_type.use_on_ru
        use_on_com: @props.boat_type.use_on_com
        is_active: @props.boat_type.is_active
        is_deprecated: @props.boat_type.is_deprecated
        name: AlterText(@props.boat_type.name)
        design_category: AlterText @props.boat_type.design_category
        ru_description: AlterText(@props.boat_type.ru_description)
        com_description: AlterText @props.boat_type.com_description
        ru_slogan: AlterText @props.boat_type.ru_slogan
        com_slogan: AlterText @props.boat_type.com_slogan
        trademark_id: @props.boat_type.trademark_id
        trademark: GetEntityById(@props.trademarks, @props.boat_type.trademark_id)
        trademarks: @props.trademarks
        boat_series_id: @props.boat_type.boat_series_id
        boat_series: GetEntityById(@props.boat_series, @props.boat_type.boat_series_id)
        boat_series_list: if @props.boat_series is undefined then [] else @props.boat_series
        isEdit: false
    btParams: ->
        {
            name: @state.name
            design_category: @state.design_category
            ru_description: @state.ru_description
            com_description: @state.com_description
            ru_slogan: @state.ru_slogan
            com_slogan: @state.com_slogan
            trademark_id: @state.trademark_id
            boat_series_id: @state.boat_series_id
            is_deprecated: @state.is_deprecated
            is_active: @state.is_active
            use_on_ru: @state.use_on_ru
            use_on_com: @state.use_on_com
        }
    tmName: ->
        tm = @state.trademark 
        if tm isnt null then tm.name else ''
    bsName: ->
        bs = @state.boat_series
        if bs isnt null then bs.name else '' 
    btName: ->
        if @state.name is undefined then '' else $.trim(@state.name)
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
                console.log data
                @switchEditMode()
            error: (jqXHR)->
                XHRErrMsg(jqXHR)
            
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
                    React.DOM.td null,  if @btName().length is 0 then "Без имени" else @btName()
                React.DOM.tr
                    key: 'slogan_row'
                    React.DOM.td null, 'Слоган'
                    React.DOM.td null,
                        React.DOM.h6 null, 'На русском'
                        React.DOM.p null, if $.trim(@state.ru_slogan) is '' then 'Не указан' else @state.ru_slogan
                        React.DOM.h6 null, 'На английском'
                        React.DOM.p null, if $.trim(@state.en_slogan) is '' then 'Не указан' else @state.en_slogan
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
    changeDropdownList: (e)->
        name = e.target.name
        if name is 'boat_series_id'
            entName = 'boat_series'
            entity = GetEntityById(@state.boat_series_list, e.target.value)
        else if name is 'trademark_id'
            entName = 'trademark'
            entity = GetEntityById(@state.trademarks, e.target.value)
        @setState "#{name}": e.target.value, "#{entName}": entity    
    editMode: ->
        React.DOM.form null,
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
                        React.DOM.td null, 'Устарел'
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
                        React.DOM.td null, React.createElement DropdownList, key: 'tm', items: @state.trademarks, selected: @state.trademark, valTitle: 'id', nameTitle: 'name', inputName: 'trademark_id', changeEvent: @changeDropdownList
                    React.DOM.tr
                        key: 'boat_series_row'
                        React.DOM.td null, 'Серия'
                        React.DOM.td null, React.createElement DropdownList, key: 'bs', items: @state.boat_series_list, selected: @state.boat_series, valTitle: 'id', nameTitle: 'name', inputName: 'boat_series_id', nullValName: 'Вне серии', changeEvent: @changeDropdownList
                    React.DOM.tr
                        key: 'name_row'
                        React.DOM.td null, 'Название'
                        React.DOM.td null,  
                            React.DOM.input 
                                type: 'text' 
                                placeholder: 'Название типа лодки' 
                                name: 'name'
                                onChange: @changeInputHandle
                                value: @state.name
                    React.DOM.tr
                        key: 'slogan_row'
                        React.DOM.td null, 'Слоган'
                        React.DOM.td null,
                            React.DOM.h6 null, 'На русском'
                            React.DOM.textarea
                                name: 'ru_slogan'
                                onChange: @changeInputHandle
                                rows: 2
                                value: @state.en_slogan
                            React.DOM.h6 null, 'На английском'
                            React.DOM.textarea
                                name: 'en_slogan'
                                rows: 2
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
        @setState isEdit: !@state.isEdit
    render: ->
        React.DOM.div null,
            React.DOM.div 
                className: 'row'
                React.DOM.div
                    className: 'small-12 medium-7 columns'
                    React.DOM.h3 null, 'Основная информация'
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


@BoatTypePhotos = React.createClass
    getInitialState: ->
        boatType: @props.boat_type
        photos: if @props.boat_type.photos is undefined then [] else @props.boat_type.photos    
    render: ->
        React.DOM.div null,
            React.DOM.div 
                className: 'row'
                React.DOM.div
                    className: 'small-12 columns'
                    React.DOM.h3 null, 'Фотографии'
            React.createElement PhotosControl, photos: @state.photos, entity: 'boat_type', entity_id: @state.boatType.id, form_token: @props.form_token

@BoatTypeProperties = React.createClass
    getInitialState: ->
        boatType: @props.boat_type
        properties: if @props.properties is undefined then [] else @props.properties    
    render: ->
        React.DOM.div null,
            React.DOM.div 
                className: 'row'
                React.DOM.div
                    className: 'small-12 columns'
                    React.DOM.h3 null, 'Технические характеристики'
            React.createElement BoatPropertyValuesManageTable, properties: @state.properties, boatType: @state.boatType 
    