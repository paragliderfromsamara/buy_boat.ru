#@BoatParameterType = React.createClass
#    render: ->

@BoatParameterValueRow = React.createClass
    getInitialState: ->
       isBinded: @props.value.is_binded
       isEditAction: @props.parent.isEditAction
       number: if @props.parent.isEditAction then @props.value.number else @props.number 
    getDefaultProps: ->
       isEditAction: false
       isBinded: false
       number: 0
    
    switchBind: ->
        $.ajax
           method: 'GET'
           url: "/boat_parameter_values/#{@props.value.id}/#{@props.value.boat_type_id}"
           dataType: 'JSON'
           success: (data) =>
             @setState isBinded: !@state.isBinded
             console.log data.status
           error: ->
               alert "Не удалось отвязать атрибут."
    valueCol: ->
        if @state.isBinded
            React.DOM.a
                onClick: @editValue,
                @alter_value()
        else
            React.createElement(FIcon, key: @props.value.id, fig: "minus")        
    
    alter_value: ->
        if @props.value.value_type is "bool"
            React.createElement(FIcon, key: @props.value.id, fig: if @props.value.value then "checked" else "x")
        else
            @props.value.value
            
    editValue: (e)->
        if @props.parent.isEditAction then @props.parent.editRowValue(@props.value)
    
    render: ->
        React.DOM.tr null,
            React.DOM.td null, @state.number
            React.DOM.td null, @props.value.name
            React.DOM.td null, @valueCol()
            if @props.parent.state.isEditAction 
                React.DOM.td null,
                    React.DOM.a
                        title: if @state.isBinded then "Отвязать" else "Привязать"
                        "data-remote":true
                        href: "#"
                        onClick: @switchBind
                        React.createElement(FIcon, key: @props.value.number, fig: if @state.isBinded then "unlink" else "link")

        
@BoatParameterValuesTable = React.createClass
    getInitialState: ->
       vals: @props.data
       isEditAction: @props.is_edit_action
    getDefaultProps: ->
       vals: []
       isEditAction: false
    editRowValue: (value)->
       
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
                            React.DOM.th null, ""

               React.DOM.tbody null,
                     for val in @state.vals
                         if val.is_binded or @state.isEditAction 
                             React.createElement(BoatParameterValueRow, key: numb++, value: val, parent: @, number: numb)             
                       
                   
                   
                   
                            
                    
