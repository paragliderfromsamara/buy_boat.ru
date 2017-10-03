#@BoatParameterType = React.createClass
#    render: ->

boatPropertyValuesManageTableRow = React.createClass
    value: (locale)->
        React.DOM.p null,
            if @props.p.is_binded
                if @props.p.value_type is 'bool'
                    React.createElement YesNoIcon, value: @props.p["#{locale}_value"]
                else
                    "#{@props.p["#{locale}_value"]}, #{@props.p["#{locale}_measure"]}"
            else
                React.createElement FIcon, fig: 'minus', title: 'Не используется'
    updValueHandle: (e)->
        attr = e.target.name
        @props.updValListFunc(@props.p.id, attr, e.target.value)
    editCol: (locale)->
        if @props.p.value_type is "bool"
            React.createElement YesNowDropdownList, inputName: "#{locale}_value", value: @props.p["#{locale}_value"], changeEvent: @updValueHandle
        else
            React.DOM.input
                type: if @props.p.value_type is "integer" then "number" else "text"
                name: "#{locale}_value"
                onChange: @updValueHandle
                value: @props.p["#{locale}_value"]
    bindCol: ->
        if @props.editMode
            React.createElement YesNowDropdownList, value: @props.p.is_binded, trueName: 'Используется', falseName: 'Не используется', inputName: 'is_binded', changeEvent: @updValueHandle
        else
            React.createElement YesNoIcon, value: @props.p.is_binded, figs: ['link', 'unlink']
    valCol: (locale)->
        if @props.editMode && @props.p.value_type && @props.p.is_binded && @props.p.value_type isnt 'option'
            @editCol(locale)
        else
            @value(locale)
    render: ->
        React.DOM.tr null,
            React.DOM.td null,
                React.DOM.p null, "#{@props.p.ru_name} #{if @props.p.en_name isnt '' && @props.p.en_name isnt undefined then "{#{@props.p.en_name}}" else ''}"
            React.DOM.td null, @valCol('ru')
            React.DOM.td null, @valCol('en')
            React.DOM.td null, @bindCol()
                
                
@ModificationPropertyValuesManageTable = React.createClass
    getInitialState: ->
        editMode: false
        onlyBinded: true
    emptyList: ->
        React.DOM.p
            className: 'tb-pad-s'
            "У данного типа лодки нет ни одного параметра"
    hasUnbinded: ->
        for p in @props.modification.properties
            if !p.is_binded then return true
        false
    propertyHash: (p)->
        {
            is_binded: p.is_binded
            property_type_id: p.property_type_id
            set_en_value: p.en_value
            set_ru_value: p.ru_value
        }
    makePropertyValuesParams: ->
        val = {}
        i = 0
        for p in @props.modification.properties
            #if !p.is_binded then continue
            val["#{i}"] = @propertyHash(p)
            i++
        {entity_property_values_attributes: val}
    updateList: (id, attr, val)->  
        vals = @props.modification.properties.slice()
        vals = vals.map (e)->
            if id isnt e.id then return e
            e["#{attr}"] = val
            return e
        @props.updateProperties(vals)
        #@setState properties: vals
    updateVals: (e)->
        e.preventDefault()
        $.ajax 
            url: "/boat_types/#{@props.modification.id}/property_values"
            type: 'PUT'
            dataType: 'JSON'
            data: {boat_type: @makePropertyValuesParams()}
            success: (data)=>
                @props.updateProperties(data)
                @setState properties: data
                @switchEditMode()
            error: (jqXHR)->
                XHRErrMsg(jqXHR)
                
    switchEditMode: (e)->
        if e isnt undefined then e.preventDefault()
        @setState editMode: !@state.editMode
    switchOnlyBinded: (e)->
        e.preventDefault()
        @setState onlyBinded: !@state.onlyBinded
    notEmptyList: ->
        React.DOM.div null,
            React.DOM.div 
                className: 'row'
                React.DOM.div 
                    className: 'small-12 columns'
                    React.DOM.div
                        className: 'button-group'
                        React.DOM.a
                            className: 'button'
                            onClick: if !@state.editMode then @switchEditMode else @updateVals
                            React.createElement YesNoIconWithText, txts: ['Изменить', 'Сохранить'], figs: ['pencil', 'save'], value: !@state.editMode 
                        if @hasUnbinded()
                            React.DOM.a
                                className: 'button secondary'
                                onClick: @switchOnlyBinded
                                React.createElement YesNoIconWithText, txts: ['Показать только используемые', 'Показать все'], figs: ['link', 'unlink'], value: !@state.onlyBinded
            React.DOM.table null,
                React.DOM.thead null,
                    React.DOM.tr null,
                        React.DOM.th null, "Параметр"
                        React.DOM.th null, "Значение, мера (рус.)"
                        React.DOM.th null, "Значение, мера (анг.)"
                        React.DOM.th null, "Используется"
                React.DOM.tbody null,
                    for p in @props.modification.properties
                        if !p.is_binded && @state.onlyBinded then continue
                        React.createElement boatPropertyValuesManageTableRow, key: "pv-#{p.id}", p: p, editMode: @state.editMode, updValListFunc: @updateList
                    
    render: ->
        React.DOM.div
            className: 'row'
            React.DOM.div
                className: 'small-12 columns'
                if @props.modification.properties.length is 0 then @emptyList() else @notEmptyList()
                

#------- все что ниже, можно удалить-----------------

@BoatParameterValueRow = React.createClass
    valueCol: ->
        if @props.val.is_binded
            React.DOM.span null, @alter_value()
        else
            React.createElement(FIcon, key: @props.val.id, fig: "minus")
    alter_value: ->
        if @props.val.value_type is "bool"
            React.createElement(FIcon, key: @props.val.id, fig: if @props.val.value then "checked" else "x")
        else
            @props.val.value
    render: ->
        React.DOM.tr null,
            React.DOM.td null, @props.order_number
            React.DOM.td null, @props.val.name
            React.DOM.td null, @valueCol()

@BoatParameterValuesTableShow = React.createClass
    getInitialState: ->
       vals: @props.data
       showUnbinded: @props.showUnbinded #показывать отвязанные параметры
    getDefaultProps: ->
       vals: []
       showUnbinded: false #показывать отвязанные параметры
    render: ->
        numb = 0
        React.DOM.div null,
            React.DOM.table null,
               React.DOM.thead null,
                    React.DOM.tr null,
                        React.DOM.th null,
                            "#"
                        React.DOM.th null,
                            "Наименование"
                        React.DOM.th null,
                            "Значение"                     
               React.DOM.tbody null,
                   if @state.showUnbinded 
                     for val in @state.vals
                        React.createElement(BoatParameterValueRow, key: numb++, val: val, number: numb)
                   else
                       for val in @state.vals
                          if val.is_binded then React.createElement(BoatParameterValueRow, key: numb++, val: val, number: numb)


@BoatParameterValueRowEditable = React.createClass
    getInitialState: ->
       isBinded: @props.value.is_binded
       value: @props.value.value
    getDefaultProps: ->
       isBinded: false
       edit: false
    switchBind: ->
        $.get
           url: "/boat_parameter_values/#{@props.value.id}/#{@props.value.boat_type_id}"
           dataType: 'JSON'
           success: (data) =>
             @setState isBinded: !@state.isBinded
           error: ->
             alert "Не удалось отвязать атрибут."
    updValue: (e)->
        e.preventDefault()
        d =  
            set_value: $("[name=set_value]").val()
        $.ajax
           method: 'PUT'
           url: "/boat_parameter_values/#{@props.value.id}"
           dataType: 'JSON'
           data: 
               boat_parameter_value: d
           success: (data) =>
               if data.status is "ok" then @props.updateHandle(@props.value, data.new_value)   
           error: (e)->
             alert "Не удалось обновить атрибут."
             console.log e
    toggleEdit: (e)->
        e.preventDefault()
        v = if @props.edit then 0 else @props.value.id
        @props.toggleHandle(v) 
    editCol: ->
        if @props.value.value_type is "bool"
            React.DOM.select
                name: "set_value"
                autoFocus: true
                React.DOM.option
                    value: if @props.value.value then true else false
                    if @props.value.value then "Да" else "Нет"
                React.DOM.option
                    value: if @props.value.value then false else true
                    if @props.value.value then "Нет" else "Да"  
        else
            React.DOM.input
                type: if @props.value.value_type is "integer" then "number" else "text"
                name: "set_value"
                defaultValue: @props.value.value    
    valueCol: ->
        if @state.isBinded
            if @props.value.value_type is "bool"
                React.createElement(FIcon, key: @props.value.id, fig: if @props.value.value then "check" else "x")
            else
                @props.value.value
        else
            React.createElement(FIcon, key: @props.value.id, fig: "minus")        
    bindedRow: ->
        React.DOM.tr null, 
            React.DOM.td null, @props.value.number
            React.DOM.td null, @props.value.name
            React.DOM.td null, 
                if @props.edit
                    @editCol()
                else
                    @valueCol()
            React.DOM.td null,
                 if @state.isBinded
                    React.DOM.a
                        onClick: if @props.edit then @updValue else @toggleEdit 
                        title: "Изменить значение"
                        React.createElement(FIcon, key: @props.value.number, fig: if @props.edit then "save" else "pencil")
            React.DOM.td null,
                React.DOM.a
                    title: "Отвязать"
                    onClick: @switchBind
                    React.createElement(FIcon, key: @props.value.number, fig: "link")
    unbindedRow: ->    
        React.DOM.tr 
            className: "bb-undinded"
            React.DOM.td null, @props.value.number
            React.DOM.td null, @props.value.name
            React.DOM.td null, React.createElement(FIcon, key: @props.value.id, fig: "minus")  
            React.DOM.td null, React.createElement(FIcon, key: @props.value.id, fig: "pencil")
            React.DOM.td null,
                React.DOM.a
                    title: "Привязать"
                    onClick: @switchBind
                    React.createElement(FIcon, key: @props.value.number, fig: "unlink")
    
    render: ->
        if @state.isBinded 
            @bindedRow()
        else
            @unbindedRow()    


        
@BoatParameterValuesTable = React.createClass
    getInitialState: ->
       vals: @props.data
       isEditAction: @props.is_edit_action
       editedVal: 0
    getDefaultProps: ->
       vals: []
       isEditAction: false
       editedVal: 0
    editValue: (val_id)->
        @setState editedVal: val_id
        console.log @state.editedVal
    updateValue: (bVal, new_value)->
        @state.vals[@state.vals.indexOf(bVal)].value = new_value
        @setState 
            vals: @state.vals
            editedVal: 0
    render: ->
        numb = 0
        React.DOM.div null,
            React.DOM.table null,
               React.DOM.thead null,
                    React.DOM.tr null,
                        React.DOM.th null,
                            "#"
                        React.DOM.th null,
                            "Наименование"
                        React.DOM.th null,
                            "Значение"
                        if @state.isEditAction 
                            React.DOM.th 
                                colSpan: 2
                                ""
               React.DOM.tbody null,
                     for val in @state.vals
                         React.createElement(BoatParameterValueRowEditable, key: "row_#{numb++}", value: val, toggleHandle: @editValue, updateHandle: @updateValue, number: numb, edit: (@state.editedVal == val.id))          
                       
                   
                   
                   
                            
                    
