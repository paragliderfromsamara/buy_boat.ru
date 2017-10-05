#@BoatParameterType = React.createClass
#    render: ->

@ErrorsCallout = React.createClass
    render: ->
        if @props.errors.length is 0 then null
        else
            idx = 0
            React.DOM.div
                className: 'row'
                React.DOM.div
                    className: 'small-12 columns'
                    React.DOM.div
                        className: 'callout alert'
                        React.DOM.ul null
                            for err in @props.errors
                                idx++
                                React.DOM.li
                                    type: '1'
                                    key: "err-#{idx}",
                                    err

simpleMenuItem = React.createClass
    handleClick: (e)->
        e.preventDefault()
        @props.clickItemEvent(@props.item)
    render: ->
        React.DOM.li
            style: if @props.isActive then {backgroundColor: '#cee7ff'}
            React.DOM.a
                onClick: @handleClick
                @props.item[@props.nTitle]

@SimpleMenu = React.createClass
    getInitialState: ->
        nTitle: if @props.nTitle is undefined then 'name' else @props.nTitle
    render: ->     
        React.DOM.div 
            className: 'row'
            React.DOM.div
                className: 'small-12 columns'
                React.DOM.ul
                    className: 'menu'
                    for item in @props.items
                        React.createElement simpleMenuItem, key: "item-#{item.id}", item: item, nTitle: @state.nTitle, clickItemEvent: @props.clickItemEvent, isActive: @props.selected is item
                