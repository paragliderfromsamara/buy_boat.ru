#@BoatParameterType = React.createClass
#    render: ->

simpleMenuItem = React.createClass
    handleClick: (e)->
        e.preventDefault()
        @props.clickItemEvent(@props.item)
    render: ->
        React.DOM.li
            style: if @props.isActive then {backgroundColor: '#cee7ff'}
            React.DOM.a
                onClick: @handleClick
                @props.item.name

@SimpleMenu = React.createClass
    render: ->     
        React.DOM.div 
            className: 'row'
            React.DOM.div
                className: 'small-12 columns'
                React.DOM.ul
                    className: 'menu'
                    for item in @props.items
                        React.createElement simpleMenuItem, key: "item-#{item.id}", item: item, clickItemEvent: @props.clickItemEvent, isActive: @props.selected is item
                
