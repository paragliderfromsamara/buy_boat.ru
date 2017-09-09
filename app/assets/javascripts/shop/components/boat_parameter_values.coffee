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
