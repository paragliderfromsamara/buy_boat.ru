#@BoatParameterType = React.createClass
#    render: ->

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
            React.DOM.td null, @props.number
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
                       
                   
                   
                   
                            
                    
