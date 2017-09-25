makeDropdownItems = (items, vTitle, nTitle, nullValName, selected)->
    value = []
    nullVal = if nullValName is undefined then {value: '', name: 'Список пуст'} else {value: '', name: nullValName}
    if items.length is 0
        value.push nullVal
    else
        if selected is null || selected is undefined
            if nullValName isnt undefined then value.push nullVal
            for i in items 
                value.push {value: i[vTitle], name: i[nTitle]}
        else
            value.push {value: selected[vTitle], name: selected[nTitle]}
            if nullValName isnt undefined then value.push nullVal
            for i in items 
                if selected[vTitle] isnt i[vTitle] then value.push {value: i[vTitle], name: i[nTitle]}
    return value


@YesNowDropdownList = React.createClass
    getInitialState: ->
        trueItem: {name: (if @props.trueName is undefined then 'Да' else @props.trueName), value: 1}
        falseItem: {name: (if @props.falseName is undefined then 'Нет' else @props.falseName), value: 0}
        value: @props.value
    items: ->
        if @state.value then [@state.trueItem, @state.falseItem] else [@state.falseItem, @state.trueItem]
    changeHandler: (e)->
        el = {target: {name: e.target.name, value: if e.target.value is '1' then true else false}}
        @props.changeEvent(el)
    render: ->
        React.createElement DropdownList, inputName: @props.inputName, changeEvent: @changeHandler, readyItems: @items(), label: @props.label

@DropdownList = React.createClass #{:items, :selected, :inputName, :valTitle, :nameTitle, :changeEvent, :nullValName}
    getInitialState: ->
        items: if @props.readyItems isnt undefined then @props.readyItems else makeDropdownItems(@props.items, @props.valTitle, @props.nameTitle, @props.nullValName, @props.selected)
    changeHandle: (e)->
        @props.changeEvent(e)
    labeled: ->
        React.DOM.label null, 
            @props.label
            @notLabeled()
    notLabeled: ->
        React.DOM.select
            name: @props.inputName
            onChange: @changeHandle
            for i in @state.items
                React.createElement dropdownListItem, key: "#{@props.inputName}-#{i.value}", value: i.value, name: i.name
    render: ->
        if @props.label is undefined then @notLabeled() else @labeled()




dropdownListItem = React.createClass
    render: ->
        React.DOM.option
            value: if @props.value is null or @props.value is undefined then '' else @props.value,
            @props.name

@CheckBox = React.createClass
    getInitialState: ->
        value: @props.value
    onChangeHandle: (e)->
        e.preventDefault()
        @props.changeHandle(e)
    render: ->
        React.DOM.input
            type: "checkbox"
            name: @props.inputName
            checked: @state.value
            onChange: @onChangeHandle
   
    