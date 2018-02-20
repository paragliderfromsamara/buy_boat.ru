#@BoatParameterType = React.createClass
#    render: ->

tmTableDataRow = React.createClass
    altText: (t)-> if $.trim(t) is "" then "Не указан" else t
    clickEditBut: (e)->
        e.preventDefault()
        @props.editHandle(@props.tm)
    delHandle: (e)->
        e.preventDefault()
        c = confirm "Удаление торговой марки приведёт к удалению всех типов лодок связанных с ней. Продолжить?"
        if c
            $.ajax(
                    url: "/trademarks/#{@props.tm.id}"
                    type: "DELETE"
                    data: {}
                    dataType: 'json'
                    success: (data)=>
                        @props.removeHandle(@props.tm)
               )
    render: ->
        React.DOM.tr null,
            React.DOM.td null, 
                if @props.tm.logo["url"] is null then "не загружен"
                else
                    React.DOM.img 
                        src: @props.tm.logo["small"]["url"]
            React.DOM.td null, @props.tm.name
            React.DOM.td null, @altText(@props.tm.email)
            React.DOM.td null, @altText(@props.tm.www)
            React.DOM.td null, @altText(@props.tm.phone)
            React.DOM.td null, 
                React.DOM.a
                    onClick: @clickEditBut
                    React.createElement FIcon, fig: "pencil"
            React.DOM.td null, 
                React.DOM.a
                    onClick: @delHandle
                    React.createElement FIcon, fig: "x"
        
@ManageTrademarksTable = React.createClass
    getInitialState: ->
        trademarks: @props.trademarks
        mode: "index"
        cur_tm: undefined
    switchTMMode: (e)->
        if e isnt undefined then e.preventDefault()
        mode = if @state.mode is "index" then "new" else "index"
        @setState mode: mode
    setEditMode: (tm)->
        @setState cur_tm: tm, mode: "edit"
    updHandle: (tm)->
        tms = @state.trademarks.slice()
        tms = tms.map (t)-> if tm.id is t.id then tm else t
        @setState trademarks: tms
    removeTm: (tm)->
        tms = []
        for t in @state.trademarks
            if t.id isnt tm.id then tms.push(t)
        @setState trademarks: tms
    createHandle: (tm)->
        tms = @state.trademarks.slice()
        tms.push(tm)
        @setState trademarks: tms, mode: "index"
    render: ->
        React.DOM.div null,
            switch @state.mode
                when "new"
                    React.createElement TrademarkForm, backHandle: @switchTMMode, form_token: @props.form_token, createHandle: @createHandle
                when "edit"
                    React.createElement TrademarkForm, backHandle: @switchTMMode, trademark: @state.cur_tm, form_token: @props.form_token, updHandle: @updHandle
                when "index"
                    React.DOM.div
                        className: "row"
                        React.DOM.div
                            className: "small-12 columns"
                            React.DOM.div
                                className: "button-group"
                                React.DOM.a
                                    className: 'button'
                                    onClick: @switchTMMode
                                    React.createElement IconWithText, fig: 'plus', txt: "Добавить"
                            React.DOM.table
                                id: "trademarks_table"
                                React.DOM.thead null,
                                    React.DOM.tr null,
                                        React.DOM.th null, "Логотип"
                                        React.DOM.th null, "Название"
                                        React.DOM.th null, "E-Mail"
                                        React.DOM.th null, "Веб сайт"
                                        React.DOM.th null, "Контактный номер"
                                        React.DOM.th null, null
                                        React.DOM.th null, null
                                React.DOM.tbody null,
                                    for tm in @state.trademarks
                                        React.createElement tmTableDataRow, key: "tm-#{tm.id}", tm: tm, editHandle: @setEditMode, removeHandle: @removeTm
                                
                                
                        
tmLogoCell = React.createClass
    handleRemove: (e)->
        e.preventDefault()
        $.ajax(
                url: "/trademarks/#{@props.tm.id}"
                type: "PUT"
                data: {trademark: {delete_logo: @props.view.attr}}
                dataType: 'json'
                success: (data)=>
                    @props.viewUploaded(data)
               )
    hasPhoto: ->
        @props.tm["#{@props.view.attr}"]["url"] isnt '' and @props.tm["#{@props.view.attr}"]["url"] isnt null and @props.tm["#{@props.view.attr}"]["url"] isnt undefined
    showMode: ->
        React.DOM.div
            style: if @props.view.attr is "white_logo" then {backgroundColor: "gray", height: "100%"} else null
            React.DOM.a
                className: 'button expanded'
                onClick: @handleRemove
                'Удалить'
            React.DOM.img
                src: if @hasPhoto() then @props.tm["#{@props.view.attr}"]["url"] else NoPhoto()

    editMode: ->
        React.createElement MiniPhotoUploader, url: "/trademarks/#{@props.tm.id}}", entity: 'trademark', attr: @props.view.attr, form_token: @props.form_token, handleSuccess: @props.viewUploaded
    render: ->
        React.DOM.div
            className: 'column'
            React.DOM.div 
                className: 'tb-pad-s'
                React.DOM.h6 null, @props.view.name
                if not @hasPhoto() then @editMode() else @showMode()

@TMLogoLoader = React.createClass
    getInitialState: ->
        curEdit: null
        viewsList: [
                        {attr: "logo", name: "Горизонтальный цветной", isEdit: false},
                        {attr: "vertical_logo", name: "Вертикальный цветной", isEdit: false},
                        {attr: 'white_logo', name: 'Белый', isEdit: false}
                    ]
    viewUploaded: (data)->
        @props.updHandle(data)
    render: ->
        React.DOM.div
            className: 'tb-pad-s'
            React.DOM.div
                className: 'row'
                React.DOM.div
                    className: 'small-12 columns'
                    React.DOM.h6 null, "Логотипы торговой марки"
            React.DOM.div
                className: 'small-up-1 medium-up-3 row'
                for i in @state.viewsList 
                    React.createElement tmLogoCell, key: i.attr, view: i, form_token: @props.form_token, tm: @props.tm, viewUploaded: @viewUploaded

@TrademarkForm = React.createClass
    getInitialState: ->
        isNew: @props.trademark is undefined
        trademark: if @props.trademark is undefined then null else @props.trademark
        name: if @props.trademark is undefined then "" else @altText(@props.trademark.name)
        www: if @props.trademark is undefined then "" else @altText(@props.trademark.www)
        email: if @props.trademark is undefined then "" else @altText(@props.trademark.email)
        phone: if @props.trademark is undefined then "" else @altText(@props.trademark.phone)
    altText: (t)-> if $.trim(t) is "" then "" else t
    tmData: ->
        {
            name: @state.name
            www: @state.www
            email: @state.email
            phone: @state.phone
        }
    submitHandle: (e)->
        e.preventDefault()
        if @state.isNew
            $.post(
                    "/trademarks"
                    {trademark: @tmData()}
                    (data)=> @props.createHandle(data)
                    "json"
                  )
        else
            $.ajax(
                    url: "/trademarks/#{@props.trademark.id}"
                    type: "PUT"
                    data: {trademark: @tmData()}
                    dataType: 'json'
                    success: (data)=>
                        @props.updHandle(data)
                        @props.backHandle()
                        alert "Торговая марка #{@state.name} успешно обновлена"
                   )
        
    changeInputHandle: (e)->
        val = e.target.value
        @setState "#{e.target.name}" : val
    updHandle: (tm)->
        @props.updHandle(tm)
    updLogoHandle: (tm)->
        @updHandle(tm)
        @setState trademark: tm
    render: ->
        React.DOM.form
            onSubmit: @submitHandle
            React.DOM.div
                className: "row"
                React.DOM.div
                    className: "small-12 columns"
                    React.DOM.div
                        className: 'button-group'
                        React.DOM.button
                            type: 'submit'
                            className: "button success"
                            if @state.isNew then "Добавить марку" else "Сохранить изменения"
                        if @props.backHandle isnt undefined 
                            React.DOM.a
                                onClick: @props.backHandle
                                className: 'button'
                                "Назад"
                    React.DOM.h5 null, if @state.isNew then "Добавление торговой марки" else "Изменение торговой марки"
            React.DOM.div
                className: "row"
                React.DOM.div
                    className: "small-12 medium-3 columns"
                    React.DOM.label
                        "Название марки"
                        React.DOM.input
                            type: "text"
                            name: "name"
                            placeholder: "Введите название марки"
                            onChange: @changeInputHandle
                            value: @state.name
                React.DOM.div
                    className: "small-12 medium-3 columns"
                    React.DOM.label
                        "Сайт"
                        React.DOM.input
                            type: "text"
                            name: "www"
                            placeholder: "www.salut-boat.ru"
                            onChange: @changeInputHandle
                            value: @state.www
                React.DOM.div
                    className: "small-12 medium-3 columns"
                    React.DOM.label
                        "E-Mail"
                        React.DOM.input
                            type: "text"
                            name: "email"
                            placeholder: "order@salut-boats.ru"
                            onChange: @changeInputHandle
                            value: @state.email
                React.DOM.div
                    className: "small-12 medium-3 columns"
                    React.DOM.label
                        "Номер телефона"
                        React.DOM.input
                            type: "text"
                            name: "phone"
                            placeholder: "Контактный номер"
                            onChange: @changeInputHandle
                            value: @state.phone
            if !@state.isNew then React.createElement TMLogoLoader, tm: @state.trademark, form_token: @props.form_token, updHandle: @updLogoHandle
                        
                    

                   
                            
                    
